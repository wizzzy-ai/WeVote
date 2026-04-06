package com.bascode.util;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.ElectionStatus;
import jakarta.persistence.EntityManager;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Utility for automatically ending elections that have reached their scheduled end time.
 */
public final class ElectionAutoEndUtil {
    private ElectionAutoEndUtil() {}

    /**
     * Checks all active position elections and ends any that have reached their scheduled end time.
     * This should be called when viewing the dashboard or performing voting-related actions.
     *
     * @param em EntityManager for database operations
     * @return number of elections that were automatically ended
     */
    public static int autoEndExpiredElections(EntityManager em) {
        LocalDateTime now = LocalDateTime.now();

        // Find all active elections that have reached their end time
        List<PositionElection> expiredElections = em.createQuery(
                        "SELECT pe FROM PositionElection pe " +
                                "WHERE pe.status = :activeStatus " +
                                "AND pe.endTime IS NOT NULL " +
                                "AND pe.endTime <= :now",
                        PositionElection.class)
                .setParameter("activeStatus", ElectionStatus.ACTIVE)
                .setParameter("now", now)
                .getResultList();

        int endedCount = 0;
        if (!expiredElections.isEmpty()) {
            em.getTransaction().begin();
            try {
                for (PositionElection pe : expiredElections) {
                    endElection(em, pe);
                    endedCount++;
                }
                em.getTransaction().commit();
            } catch (Exception e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }

        return endedCount;
    }

    /**
     * Checks if a specific position election should be auto-ended based on its end time.
     *
     * @param em EntityManager for database operations
     * @param positionElection the election to check
     * @return true if the election was ended, false otherwise
     */
    public static boolean checkAndAutoEnd(EntityManager em, PositionElection positionElection) {
        if (positionElection == null) return false;
        if (positionElection.getStatus() != ElectionStatus.ACTIVE) return false;
        if (positionElection.getEndTime() == null) return false;

        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(positionElection.getEndTime())) return false;

        // End the election
        em.getTransaction().begin();
        try {
            endElection(em, positionElection);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    private static void endElection(EntityManager em, PositionElection pe) {
        pe.setStatus(ElectionStatus.ENDED);
        pe.setVotingOpen(false);

        // Clear previous winners
        List<Contester> contesters = em.createQuery(
                        "SELECT c FROM Contester c WHERE c.position = :p",
                        Contester.class)
                .setParameter("p", pe.getName())
                .getResultList();

        for (Contester c : contesters) {
            c.setWinner(false);
            em.merge(c);
        }

        // Pick winner (highest vote count among approved contesters)
        List<Object[]> rows = em.createQuery(
                        "SELECT c, COUNT(v.id) " +
                                "FROM Contester c " +
                                "LEFT JOIN Vote v ON v.contester = c " +
                                "WHERE c.position = :p AND c.status = :s " +
                                "GROUP BY c " +
                                "ORDER BY COUNT(v.id) DESC, c.id ASC",
                        Object[].class)
                .setParameter("p", pe.getName())
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

        em.merge(pe);
    }
}
