package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contester/status")
public class ContesterStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, toLong(session.getAttribute("userId")));
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            Contester contester = em.createQuery(
                            "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :uid",
                            Contester.class
                    )
                    .setParameter("uid", user.getId())
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            long approvedCount = 0L;
            if (contester != null && contester.getPosition() != null) {
                approvedCount = em.createQuery(
                                "SELECT COUNT(c) FROM Contester c WHERE c.status = :s AND c.position = :p",
                                Long.class
                        )
                        .setParameter("s", ContesterStatus.APPROVED)
                        .setParameter("p", contester.getPosition())
                        .getSingleResult();
            }

            request.setAttribute("user", user);
            request.setAttribute("contester", contester);
            request.setAttribute("approvedCount", approvedCount);
            request.getRequestDispatcher("/WEB-INF/contester/status.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
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

