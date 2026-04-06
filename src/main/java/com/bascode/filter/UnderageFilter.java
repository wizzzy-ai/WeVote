package com.bascode.filter;

import com.bascode.model.entity.User;
import com.bascode.util.AgeUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
        "/vote", "/submit-vote", "/contest/apply", "/admin/*", "/admin.jsp", "/contester/*"
})
public class UnderageFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (session == null) {
            chain.doFilter(request, response);
            return;
        }

        Object flag = session.getAttribute("underage");
        Boolean underage = (flag instanceof Boolean) ? (Boolean) flag : null;
        if (underage == null) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                user = loadUser(session, req);
            }
            underage = AgeUtil.isUnderage(user);
            session.setAttribute("underage", underage);
        }

        if (Boolean.TRUE.equals(underage)) {
            String uri = req.getRequestURI();
            String ctx = req.getContextPath();
            boolean votingOrContesting =
                    uri.equals(ctx + "/vote") ||
                    uri.equals(ctx + "/submit-vote") ||
                    uri.equals(ctx + "/contest/apply") ||
                    uri.startsWith(ctx + "/contester/");

            if (votingOrContesting) {
                res.sendRedirect(ctx + "/dashboard?type=error&msg=Underage+users+can+view+the+dashboard+but+cannot+vote+or+contest.");
            } else {
                res.sendRedirect(ctx + "/underage.jsp");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    private static User loadUser(HttpSession session, HttpServletRequest req) {
        EntityManagerFactory emf = (EntityManagerFactory) req.getServletContext().getAttribute("emf");
        if (emf == null) return null;
        EntityManager em = emf.createEntityManager();
        try {
            Object idObj = session.getAttribute("userId");
            Long userId = null;
            if (idObj instanceof Long) userId = (Long) idObj;
            else if (idObj instanceof Integer) userId = ((Integer) idObj).longValue();
            else if (idObj instanceof String) {
                try {
                    userId = Long.valueOf((String) idObj);
                } catch (Exception ignored) {
                    userId = null;
                }
            }
            if (userId == null) return null;
            return em.find(User.class, userId);
        } finally {
            em.close();
        }
    }
}
