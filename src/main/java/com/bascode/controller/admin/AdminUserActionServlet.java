package com.bascode.controller.admin;

import com.bascode.model.entity.AdminAuditLog;
import com.bascode.model.entity.User;
import com.bascode.model.enums.AdminActionType;
import com.bascode.util.UserCleanupUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/users/action")
public class AdminUserActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String action = trimToNull(request.getParameter("action"));

        Long userId = toLong(userIdStr);
        if (userId == null) {
            redirectWithMessage(request, response, "Invalid user selected.", "error");
            return;
        }
        if (action == null) {
            redirectWithMessage(request, response, "No action selected.", "error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User target = em.find(User.class, userId);
            if (target == null) {
                redirectWithMessage(request, response, "User not found.", "error");
                return;
            }

            Long adminId = currentAdminId(request.getSession(false));
            if (adminId != null && adminId.equals(target.getId())) {
                redirectWithMessage(request, response, "You cannot modify your own account from this screen.", "error");
                return;
            }

            switch (action.toLowerCase()) {
                case "suspend":
                    suspendUser(request, response, em, target);
                    return;
                case "activate":
                    activateUser(request, response, em, target);
                    return;
                case "delete":
                    deleteUser(request, response, em, target);
                    return;
                default:
                    redirectWithMessage(request, response, "Unsupported action.", "error");
            }
        } finally {
            em.close();
        }
    }

    private void suspendUser(HttpServletRequest request, HttpServletResponse response, EntityManager em, User target)
            throws IOException {
        if (target.isSuspended()) {
            redirectWithMessage(request, response, "User is already suspended.", "error");
            return;
        }

        em.getTransaction().begin();
        target.setSuspended(true);
        em.merge(target);
        persistAudit(request, em, AdminActionType.USER_SUSPENDED, target, "Suspended user account");
        em.getTransaction().commit();
        redirectWithMessage(request, response, "User suspended.", "success");
    }

    private void activateUser(HttpServletRequest request, HttpServletResponse response, EntityManager em, User target)
            throws IOException {
        if (!target.isSuspended()) {
            redirectWithMessage(request, response, "User is already active.", "error");
            return;
        }

        em.getTransaction().begin();
        target.setSuspended(false);
        em.merge(target);
        persistAudit(request, em, AdminActionType.USER_REACTIVATED, target, "Reactivated user account");
        em.getTransaction().commit();
        redirectWithMessage(request, response, "User reactivated.", "success");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, EntityManager em, User target)
            throws IOException {
        try {
            em.getTransaction().begin();

            Long targetUserId = target.getId();
            String targetEmail = target.getEmail();

            UserCleanupUtil.deleteUserAndRelations(em, targetUserId);

            persistAudit(request, em, AdminActionType.USER_DELETED, targetUserId, targetEmail, "Deleted user account");
            em.getTransaction().commit();
            redirectWithMessage(request, response, "User deleted.", "success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            redirectWithMessage(request, response, "Could not delete user.", "error");
        }
    }

    private static void persistAudit(HttpServletRequest request, EntityManager em, AdminActionType actionType, User target, String message) {
        persistAudit(request, em, actionType, target.getId(), target.getEmail(), message);
    }

    private static void persistAudit(HttpServletRequest request, EntityManager em, AdminActionType actionType,
                                     Long targetId, String targetEmail, String message) {
        Long adminId = currentAdminId(request.getSession(false));
        if (adminId == null) return;

        User admin = em.find(User.class, adminId);
        if (admin == null) return;

        AdminAuditLog log = new AdminAuditLog();
        log.setAdminUser(admin);
        log.setActionType(actionType);
        log.setTargetType("User");
        log.setTargetId(targetId);
        log.setMessage(message + ": " + targetEmail);
        log.setIpAddress(extractIp(request));
        log.setUserAgent(truncate(request.getHeader("User-Agent"), 256));
        em.persist(log);
    }

    private static Long currentAdminId(HttpSession session) {
        if (session == null) return null;
        return toLong(session.getAttribute("userId"));
    }

    private static String extractIp(HttpServletRequest request) {
        String fwd = request.getHeader("X-Forwarded-For");
        if (fwd != null && !fwd.trim().isEmpty()) {
            int comma = fwd.indexOf(',');
            return (comma >= 0 ? fwd.substring(0, comma) : fwd).trim();
        }
        return request.getRemoteAddr();
    }

    private static String truncate(String s, int maxLen) {
        if (s == null || s.length() <= maxLen) return s;
        return s.substring(0, maxLen);
    }

    private static Long toLong(Object v) {
        if (v instanceof Long) return (Long) v;
        if (v instanceof Integer) return ((Integer) v).longValue();
        if (v instanceof String) {
            try {
                return Long.valueOf((String) v);
            } catch (Exception ignored) {
                return null;
            }
        }
        return null;
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static void redirectWithMessage(HttpServletRequest request, HttpServletResponse response, String msg, String type)
            throws IOException {
        String qs = "?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8) +
                "&type=" + URLEncoder.encode(type, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/admin/users" + qs);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
