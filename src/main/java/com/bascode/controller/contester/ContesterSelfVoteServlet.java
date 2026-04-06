package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
import com.bascode.model.entity.Vote;
import com.bascode.model.enums.ContesterStatus;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@WebServlet("/contester/vote-self")
public class ContesterSelfVoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

            Contester self = em.createQuery(
                            "SELECT c FROM Contester c WHERE c.user.id = :uid",
                            Contester.class
                    )
                    .setParameter("uid", user.getId())
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
            if (self == null || self.getStatus() != ContesterStatus.APPROVED) {
                redirectWithMessage(response, request, "You are not approved to self-vote.", "error");
                return;
            }

            // Check voting status for contester's specific position
            VotingStatus vs = resolveVotingStatus(em, self.getPosition());
            if (!vs.open) {
                redirectWithMessage(response, request, vs.reason != null ? vs.reason : "Voting is closed.", "error");
                return;
            }

            long alreadyVoted = em.createQuery(
                            "SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :uid",
                            Long.class
                    )
                    .setParameter("uid", user.getId())
                    .getSingleResult();
            if (alreadyVoted > 0) {
                redirectWithMessage(response, request, "You have already voted.", "error");
                return;
            }

            Vote vote = new Vote();
            vote.setVoter(user);
            vote.setContester(self);
            em.getTransaction().begin();
            em.persist(vote);
            em.getTransaction().commit();

            redirectWithMessage(response, request, "Self-vote recorded.", "success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            redirectWithMessage(response, request, "A system error occurred.", "error");
        } finally {
            em.close();
        }
    }

    private static void redirectWithMessage(HttpServletResponse response, HttpServletRequest request, String msg, String type) throws IOException {
        String qs = "?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8) +
                "&type=" + URLEncoder.encode(type, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/contester/dashboard" + qs);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }

    private static class VotingStatus {
        final boolean open;
        final String reason;
        VotingStatus(boolean open, String reason) {
            this.open = open;
            this.reason = reason;
        }
    }

    private static VotingStatus resolveVotingStatus(EntityManager em, com.bascode.model.enums.Position position) {
        if (position == null) {
            return new VotingStatus(false, "No position found.");
        }
        
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
