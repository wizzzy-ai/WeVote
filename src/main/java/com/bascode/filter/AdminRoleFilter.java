package com.bascode.filter;

import com.bascode.model.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminRoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String userRole = session != null ? (String) session.getAttribute("userRole") : null;

        // 🔎 Debug logging
        System.out.println("[AdminRoleFilter] userRole=" + userRole
                + ", userId=" + (session != null ? session.getAttribute("userId") : null)
                + ", suspended=" + (session != null ? isMissingOrSuspended(req, session) : "n/a"));

        if (userRole != null &&
            ("ADMIN".equalsIgnoreCase(userRole) || "SUPER_ADMIN".equalsIgnoreCase(userRole)) &&
            !isMissingOrSuspended(req, session)) {
            chain.doFilter(request, response);
            return;
        }

        if (session != null) {
            session.invalidate();
        }
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private static boolean isMissingOrSuspended(HttpServletRequest req, HttpSession session) {
        EntityManagerFactory emf = (EntityManagerFactory) req.getServletContext().getAttribute("emf");
        if (emf == null || session == null) return false;

        Long userId = toLong(session.getAttribute("userId"));
        if (userId == null) return false;

        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            return user == null || user.isSuspended();
        } finally {
            em.close();
        }
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
}
