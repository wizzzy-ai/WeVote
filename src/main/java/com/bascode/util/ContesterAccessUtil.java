package com.bascode.util;

import com.bascode.model.entity.Contester;
import com.bascode.model.enums.ContesterStatus;
import jakarta.persistence.EntityManager;

public final class ContesterAccessUtil {

    private ContesterAccessUtil() {
    }

    public static boolean hasContesterProfile(EntityManager em, Long userId) {
        if (userId == null) return false;
        Long count = em.createQuery(
                        "SELECT COUNT(c) FROM Contester c WHERE c.user.id = :userId",
                        Long.class
                )
                .setParameter("userId", userId)
                .getSingleResult();
        return count != null && count > 0;
    }

    public static Contester findContester(EntityManager em, Long userId) {
        if (userId == null) return null;
        return em.createQuery(
                        "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :userId",
                        Contester.class
                )
                .setParameter("userId", userId)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    public static boolean hasApprovedContesterProfile(EntityManager em, Long userId) {
        Contester contester = findContester(em, userId);
        return contester != null && contester.getStatus() == ContesterStatus.APPROVED;
    }
}
