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

@WebFilter(urlPatterns = {"/dashboard", "/vote", "/submit-vote", "/results", "/profile", "/support"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (isMissingOrSuspended(req, session)) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/login.jsp?suspended=1");
            return;
        }
        chain.doFilter(request, response);
    }

    private static boolean isMissingOrSuspended(HttpServletRequest req, HttpSession session) {
        EntityManagerFactory emf = (EntityManagerFactory) req.getServletContext().getAttribute("emf");
        if (emf == null) return false;

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
