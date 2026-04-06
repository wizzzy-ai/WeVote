package com.bascode.controller.admin;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.ElectionStatus;
import com.bascode.model.enums.Position;
import com.bascode.util.PositionElectionUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/end-election")
public class AdminEndElectionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
            return;
        }

        Position pos;
        try {
            pos = Position.valueOf(request.getParameter("position"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Invalid%20position&type=error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            PositionElection pe = PositionElectionUtil.getOrCreate(em, pos);
            if (pe.getStatus() != ElectionStatus.ACTIVE) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20is%20not%20active&type=error");
                return;
            }

            em.getTransaction().begin();
            pe.setStatus(ElectionStatus.ENDED);
            pe.setVotingOpen(false);
            pe.setEndTime(LocalDateTime.now());
            em.merge(pe);

            // Clear previous winners for this position.
            List<Contester> contesters = em.createQuery(
                            "SELECT c FROM Contester c WHERE c.position = :p",
                            Contester.class
                    )
                    .setParameter("p", pos)
                    .getResultList();
            for (Contester c : contesters) {
                c.setWinner(false);
                em.merge(c);
            }

            // Pick winner (optional) - highest vote count among approved contesters.
            List<Object[]> rows = em.createQuery(
                            "SELECT c, COUNT(v.id) " +
                                    "FROM Contester c " +
                                    "LEFT JOIN Vote v ON v.contester = c " +
                                    "WHERE c.position = :p AND c.status = :s " +
                                    "GROUP BY c " +
                                    "ORDER BY COUNT(v.id) DESC, c.id ASC",
                            Object[].class
                    )
                    .setParameter("p", pos)
                    .setParameter("s", ContesterStatus.APPROVED)
                    .setMaxResults(1)
                    .getResultList();
            if (!rows.isEmpty()) {
                Contester winner = (Contester) rows.get(0)[0];
                if (winner != null) {
                    winner.setWinner(true);
                    em.merge(winner);
                }
            }

            em.getTransaction().commit();

            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20ended%20successfully&type=success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Failed%20to%20end%20election&type=error");
        } finally {
            em.close();
        }
    }

    private static boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Object role = session.getAttribute("userRole");
        if (role == null) return false;
        String roleStr = String.valueOf(role);
        return "ADMIN".equalsIgnoreCase(roleStr) || "SUPER_ADMIN".equalsIgnoreCase(roleStr);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}

