package com.bascode.controller.admin;

import com.bascode.model.entity.AdminAuditLog;
import com.bascode.model.entity.Contester;
import com.bascode.model.entity.User;
import com.bascode.model.enums.AdminActionType;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Role;
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

@WebServlet("/admin/contesters/status")
public class AdminContesterStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("contesterId");
        String action = request.getParameter("action"); // approve | deny
        String reason = request.getParameter("reason");

        Long contesterId;
        try {
            contesterId = Long.valueOf(idStr);
        } catch (Exception e) {
            redirectWithMessage(request, response, "Invalid contester id.", "error");
            return;
        }

        if (action == null || (!"approve".equalsIgnoreCase(action) && !"deny".equalsIgnoreCase(action))) {
            redirectWithMessage(request, response, "Invalid action.", "error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            Contester contester = em.find(Contester.class, contesterId);
            if (contester == null) {
                redirectWithMessage(request, response, "Contester not found.", "error");
                return;
            }

            if ("deny".equalsIgnoreCase(action)) {
                em.getTransaction().begin();
                contester.setStatus(ContesterStatus.DENIED);
                contester.setStatusReason(reason != null && !reason.trim().isEmpty() ? reason.trim() : "Not provided");
                if (contester.getUser() != null) {
                    contester.getUser().setRole(Role.VOTER);
                    em.merge(contester.getUser());
                }
                em.merge(contester);
                persistAudit(request, em, AdminActionType.CONTESTER_DENIED, "Contester", contester.getId(),
                        "Denied contester for position " + contester.getPosition());
                em.getTransaction().commit();
                redirectWithMessage(request, response, "Contester denied.", "success");
                return;
            }

            // approve
            long approvedCount = em.createQuery(
                            "SELECT COUNT(c) FROM Contester c WHERE c.position = :position AND c.status = :status",
                            Long.class
                    )
                    .setParameter("position", contester.getPosition())
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getSingleResult();

            if (approvedCount >= 3) {
                redirectWithMessage(request, response, "Cannot approve: this position already has 3 approved contesters.", "error");
                return;
            }

            em.getTransaction().begin();
            contester.setStatus(ContesterStatus.APPROVED);
            contester.setStatusReason(null);
            if (contester.getUser() != null) {
                contester.getUser().setRole(Role.CONTESTER);
                em.merge(contester.getUser());
            }
            em.merge(contester);
            persistAudit(request, em, AdminActionType.CONTESTER_APPROVED, "Contester", contester.getId(),
                    "Approved contester for position " + contester.getPosition());
            em.getTransaction().commit();
            redirectWithMessage(request, response, "Contester approved.", "success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            redirectWithMessage(request, response, "A system error occurred while updating status.", "error");
        } finally {
            em.close();
        }
    }

    private static void redirectWithMessage(HttpServletRequest request, HttpServletResponse response, String msg, String type) throws IOException {
        String qs = "?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8) +
                "&type=" + URLEncoder.encode(type, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/admin/contesters" + qs);
    }

    private static void persistAudit(HttpServletRequest request, EntityManager em, AdminActionType type,
                                     String targetType, Long targetId, String message) {
        HttpSession session = request.getSession(false);
        Object adminIdObj = session != null ? session.getAttribute("userId") : null;
        Long adminId = toLong(adminIdObj);
        if (adminId == null) return;

        User admin = em.find(User.class, adminId);
        if (admin == null) return;

        AdminAuditLog log = new AdminAuditLog();
        log.setAdminUser(admin);
        log.setActionType(type);
        log.setTargetType(targetType);
        log.setTargetId(targetId);
        log.setMessage(message);
        log.setIpAddress(extractIp(request));
        log.setUserAgent(truncate(request.getHeader("User-Agent"), 256));
        em.persist(log);
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

    private static String extractIp(HttpServletRequest request) {
        String fwd = request.getHeader("X-Forwarded-For");
        if (fwd != null && !fwd.trim().isEmpty()) {
            // Use first IP in XFF.
            int comma = fwd.indexOf(',');
            return (comma >= 0 ? fwd.substring(0, comma) : fwd).trim();
        }
        return request.getRemoteAddr();
    }

    private static String truncate(String s, int maxLen) {
        if (s == null) return null;
        if (s.length() <= maxLen) return s;
        return s.substring(0, maxLen);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
