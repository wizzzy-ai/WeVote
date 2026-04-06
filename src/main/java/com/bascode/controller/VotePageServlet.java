package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.util.AgeUtil;
import com.bascode.util.ContesterAccessUtil;
import com.bascode.util.ElectionAutoEndUtil;
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
import java.util.Collections;
import java.util.List;

@WebServlet("/vote")
public class VotePageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long userId = toLong(session != null ? session.getAttribute("userId") : null);

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            // Auto-end any elections that have reached their scheduled end time
            ElectionAutoEndUtil.autoEndExpiredElections(em);

            User user = userId != null ? em.find(User.class, userId) : null;
            
            // Determine which position to check for voting status
            Position targetPosition = null;
            if (user != null && ContesterAccessUtil.hasContesterProfile(em, user.getId())) {
                Contester self = ContesterAccessUtil.findContester(em, user.getId());
                if (self != null && self.getPosition() != null) {
                    targetPosition = self.getPosition();
                }
            }
            
            VotingStatus vs = resolveVotingStatus(em, targetPosition);
            request.setAttribute("votingClosed", !vs.open);
            request.setAttribute("votingClosedReason", vs.reason);

            if (!vs.open) {
                request.setAttribute("candidates", Collections.emptyList());
                request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
                return;
            }

            List<Contester> candidates;

            if (user != null && AgeUtil.isUnderage(user)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?type=error&msg=Underage+users+cannot+vote.");
                return;
            }
            if (user != null && ContesterAccessUtil.hasContesterProfile(em, user.getId())) {
                Contester self = ContesterAccessUtil.findContester(em, user.getId());
                if (self != null && self.getPosition() != null) {
                    candidates = em.createQuery(
                                    "SELECT c FROM Contester c JOIN FETCH c.user u " +
                                            "WHERE c.status = :s AND c.position = :p AND c.user.id <> :uid " +
                                            "ORDER BY u.lastName ASC, u.firstName ASC",
                                    Contester.class
                            )
                            .setParameter("s", ContesterStatus.APPROVED)
                            .setParameter("p", self.getPosition())
                            .setParameter("uid", user.getId())
                            .getResultList();
                } else {
                    candidates = Collections.emptyList();
                }
                request.setAttribute("contesterRestricted", true);
            } else {
                candidates = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u WHERE c.status = :s ORDER BY c.position ASC, u.lastName ASC, u.firstName ASC",
                                Contester.class
                        )
                        .setParameter("s", ContesterStatus.APPROVED)
                        .getResultList();
                request.setAttribute("contesterRestricted", false);
            }

            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
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

    private static class VotingStatus {
        final boolean open;
        final String reason;
        VotingStatus(boolean open, String reason) {
            this.open = open;
            this.reason = reason;
        }
    }

    private static VotingStatus resolveVotingStatus(EntityManager em, Position position) {
        // If no specific position (regular voter), check if any elections are active
        if (position == null) {
            List<PositionElection> activeElections = em.createQuery(
                            "SELECT pe FROM PositionElection pe WHERE pe.status = :activeStatus",
                            PositionElection.class)
                    .setParameter("activeStatus", com.bascode.model.enums.ElectionStatus.ACTIVE)
                    .getResultList();
            
            if (activeElections.isEmpty()) {
                return new VotingStatus(false, "No active elections found.");
            }
            
            // Check if any active election is open for voting
            for (PositionElection pe : activeElections) {
                if (pe.isVotingOpen()) {
                    if (pe.getEndTime() == null || LocalDateTime.now().isBefore(pe.getEndTime())) {
                        return new VotingStatus(true, null);
                    }
                }
            }
            return new VotingStatus(false, "Voting deadline reached.");
        }
        
        // For contesters, check their specific position
        PositionElection pe = PositionElectionUtil.getOrCreate(em, position);
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.ENDED) {
            return new VotingStatus(false, "Election has ended.");
        }
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.NOT_STARTED) {
            return new VotingStatus(false, "Election has not started yet.");
        }
        if (!pe.isVotingOpen()) {
            return new VotingStatus(false, "Voting is currently closed.");
        }
        if (pe.getEndTime() != null && !LocalDateTime.now().isBefore(pe.getEndTime())) {
            return new VotingStatus(false, "Voting deadline reached.");
        }
        return new VotingStatus(true, null);
    }
}
