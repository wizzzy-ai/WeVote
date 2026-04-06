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

@WebServlet("/admin/start-election")
public class AdminStartElectionServlet extends HttpServlet {

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
            long approvedCount = em.createQuery(
                            "SELECT COUNT(c) FROM Contester c WHERE c.position = :p AND c.status = :s",
                            Long.class
                    )
                    .setParameter("p", pos)
                    .setParameter("s", ContesterStatus.APPROVED)
                    .getSingleResult();
            if (approvedCount < 2) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Need%20at%20least%202%20approved%20contesters&type=error");
                return;
            }

            PositionElection pe = PositionElectionUtil.getOrCreate(em, pos);
            if (pe.getStatus() == ElectionStatus.ACTIVE) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20already%20active&type=error");
                return;
            }

            // Capture original status before modifying
            ElectionStatus originalStatus = pe.getStatus();

            em.getTransaction().begin();
            
            // If restarting an ended election, clear previous state
            if (originalStatus == ElectionStatus.ENDED) {
                // Clear all winners for this position
                List<Contester> contesters = em.createQuery(
                                "SELECT c FROM Contester c WHERE c.position = :p",
                                Contester.class)
                        .setParameter("p", pos)
                        .getResultList();
                for (Contester c : contesters) {
                    c.setWinner(false);
                    em.merge(c);
                }
                // Clear the end time so it doesn't auto-end immediately
                pe.setEndTime(null);
            }
            
            pe.setStatus(ElectionStatus.ACTIVE);
            pe.setVotingOpen(true);
            pe.setStartTime(LocalDateTime.now());
            // End time is now managed in Election Settings page
            em.merge(pe);
            em.getTransaction().commit();

            String message = originalStatus == ElectionStatus.ENDED 
                ? "Election%20restarted%20successfully" 
                : "Election%20started%20successfully";
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=" + message + "&type=success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Failed%20to%20start%20election&type=error");
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

