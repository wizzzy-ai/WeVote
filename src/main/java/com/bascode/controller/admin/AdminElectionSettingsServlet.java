package com.bascode.controller.admin;

import com.bascode.model.entity.ElectionSettings;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
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
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/admin/election")
public class AdminElectionSettingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            ElectionSettings s = getOrCreate(em);
            // Get all position elections for display
            List<PositionElection> positionElections = PositionElectionUtil.ensureAll(em);
            request.setAttribute("settings", s);
            request.setAttribute("positionElections", positionElections);
            request.getRequestDispatcher("/WEB-INF/admin/election.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading election settings: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/election.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Handle position-specific timer updates
        if ("positionTimers".equals(action)) {
            savePositionTimers(request, response);
            return;
        }
        
        // Handle global election settings
        boolean votingOpen = request.getParameter("votingOpen") != null; // checkbox
        String closesAtStr = trimToNull(request.getParameter("votingClosesAt")); // datetime-local or empty

        LocalDateTime closesAt = null;
        if (closesAtStr != null) {
            try {
                closesAt = LocalDateTime.parse(closesAtStr);
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Invalid close date/time.");
                doGet(request, response);
                return;
            }
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            ElectionSettings s = getOrCreate(em);
            HttpSession session = request.getSession(false);
            Long adminId = session != null ? toLong(session.getAttribute("userId")) : null;
            User admin = adminId != null ? em.find(User.class, adminId) : null;

            em.getTransaction().begin();
            s.setVotingOpen(votingOpen);
            s.setVotingClosesAt(closesAt);
            if (admin != null) s.setUpdatedBy(admin);
            em.merge(s);
            em.getTransaction().commit();

            response.sendRedirect(request.getContextPath() + "/admin/election?msg=Global%20settings%20saved&type=success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/election?msg=Failed%20to%20save&type=error");
        } finally {
            em.close();
        }
    }
    
    private void savePositionTimers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            
            // Process each position's end time
            for (Position pos : Position.values()) {
                String endTimeStr = request.getParameter("endTime_" + pos.name());
                if (endTimeStr != null) { // Only process if parameter was submitted
                    PositionElection pe = PositionElectionUtil.getOrCreate(em, pos);
                    
                    if (endTimeStr.trim().isEmpty()) {
                        pe.setEndTime(null); // Clear the end time
                    } else {
                        try {
                            LocalDateTime endTime = LocalDateTime.parse(endTimeStr);
                            pe.setEndTime(endTime);
                        } catch (DateTimeParseException e) {
                            // Skip invalid dates
                        }
                    }
                    em.merge(pe);
                }
            }
            
            em.getTransaction().commit();
            response.sendRedirect(request.getContextPath() + "/admin/election?msg=Position%20deadlines%20saved&type=success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/election?msg=Failed%20to%20save%20position%20timers&type=error");
        } finally {
            em.close();
        }
    }

    private static ElectionSettings getOrCreate(EntityManager em) {
        ElectionSettings s = em.createQuery("SELECT s FROM ElectionSettings s ORDER BY s.id ASC", ElectionSettings.class)
                .setMaxResults(1)
                .getResultStream()
                .findFirst()
                .orElse(null);

        if (s != null) return s;

        // Create default row.
        em.getTransaction().begin();
        ElectionSettings created = new ElectionSettings();
        created.setVotingOpen(true);
        em.persist(created);
        em.getTransaction().commit();
        return created;
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
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

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}

