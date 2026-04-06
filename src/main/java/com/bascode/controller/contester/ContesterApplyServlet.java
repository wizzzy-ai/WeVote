package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.model.enums.Role;
import com.bascode.util.AgeUtil;
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

@WebServlet("/contest/apply")
public class ContesterApplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long userId = toLong(session != null ? session.getAttribute("userId") : null);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String positionParam = request.getParameter("position");
        Position position;
        try {
            position = Position.valueOf(positionParam);
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/dashboard?type=error&msg=" + encode("Select a valid position."));
            return;
        }

        EntityManager em = getEmf().createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user == null || user.getRole() == Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            if (AgeUtil.isUnderage(user)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?type=error&msg=" + encode("Underage users cannot contest."));
                return;
            }

            Contester existing = em.createQuery(
                            "SELECT c FROM Contester c WHERE c.user.id = :userId",
                            Contester.class
                    )
                    .setParameter("userId", userId)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (existing != null) {
                existing.setPosition(position);
                existing.setStatus(ContesterStatus.PENDING);
                existing.setStatusReason("Awaiting admin approval.");
                existing.setManifesto(null);

                em.getTransaction().begin();
                em.merge(existing);
                em.getTransaction().commit();
            } else {
                long approvedCount = em.createQuery(
                                "SELECT COUNT(c) FROM Contester c WHERE c.position = :position AND c.status = :status",
                                Long.class
                        )
                        .setParameter("position", position)
                        .setParameter("status", ContesterStatus.APPROVED)
                        .getSingleResult();

                Contester contester = new Contester();
                contester.setUser(user);
                contester.setPosition(position);
                contester.setStatus(approvedCount >= 3 ? ContesterStatus.DENIED : ContesterStatus.PENDING);
                contester.setStatusReason(approvedCount >= 3
                        ? "Position is already filled with the maximum approved contesters."
                        : "Awaiting admin approval.");

                em.getTransaction().begin();
                em.persist(contester);
                em.getTransaction().commit();
            }

            session.setAttribute("userRole", Role.CONTESTER.name());
            response.sendRedirect(request.getContextPath() + "/contester/dashboard");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/dashboard?type=error&msg=" + encode("Could not submit contester application."));
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
