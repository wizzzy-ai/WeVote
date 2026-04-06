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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/contest/withdraw")
public class ContesterWithdrawServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long userId = toLong(session != null ? session.getAttribute("userId") : null);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        EntityManager em = getEmf().createEntityManager();
        try {
            User user = em.find(User.class, userId);
            Contester contester = em.createQuery(
                            "SELECT c FROM Contester c WHERE c.user.id = :userId",
                            Contester.class
                    )
                    .setParameter("userId", userId)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (contester == null) {
                session.setAttribute("userRole", "VOTER");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            em.getTransaction().begin();
            em.createQuery("DELETE FROM Vote v WHERE v.contester.id = :contesterId")
                    .setParameter("contesterId", contester.getId())
                    .executeUpdate();
            if (user != null) {
                user.setRole(Role.VOTER);
                em.merge(user);
            }
            em.remove(em.contains(contester) ? contester : em.merge(contester));
            em.getTransaction().commit();

            session.setAttribute("userRole", "VOTER");
            response.sendRedirect(request.getContextPath() + "/dashboard?type=success&msg=" + encode("You have withdrawn from the contest."));
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/contester/dashboard?type=error&msg=" + encode("Could not withdraw from the contest."));
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

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
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
