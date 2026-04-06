package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.User;
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

@WebServlet("/contester/manifesto")
public class ContesterManifestoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object roleObj = session.getAttribute("userRole");
        if (roleObj == null || !Role.CONTESTER.name().equalsIgnoreCase(roleObj.toString())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = requireUser(session, em);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            Contester contester = em.createQuery(
                            "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :userId",
                            Contester.class
                    )
                    .setParameter("userId", user.getId())
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (contester == null) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=No%20contester%20record%20found.");
                return;
            }

            String manifesto = request.getParameter("manifesto");
            if (manifesto == null || manifesto.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=Manifesto%20is%20required.");
                return;
            }

            if (contester.getManifesto() != null && !contester.getManifesto().trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=Manifesto%20already%20submitted.");
                return;
            }

            String trimmed = manifesto.trim();
            if (trimmed.length() > 1000) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=Manifesto%20must%20be%201000%20characters%20or%20less.");
                return;
            }

            String sanitized = escapeHtml(trimmed);

            em.getTransaction().begin();
            contester.setManifesto(sanitized);
            em.merge(contester);
            em.getTransaction().commit();

            response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=success&msg=Manifesto%20submitted%20successfully.");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=Failed%20to%20submit%20manifesto.");
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

    private static User requireUser(HttpSession session, EntityManager em) {
        Object idObj = session.getAttribute("userId");
        if (idObj == null) return null;
        Long id = toLong(idObj);
        if (id == null) return null;
        return em.find(User.class, id);
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

    private static String escapeHtml(String input) {
        StringBuilder out = new StringBuilder(input.length());
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '&':
                    out.append("&amp;");
                    break;
                case '<':
                    out.append("&lt;");
                    break;
                case '>':
                    out.append("&gt;");
                    break;
                case '"':
                    out.append("&quot;");
                    break;
                case '\'':
                    out.append("&#39;");
                    break;
                default:
                    out.append(c);
            }
        }
        return out.toString();
    }
}
