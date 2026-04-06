package com.bascode.util;

import jakarta.persistence.EntityManager;

public final class UserCleanupUtil {

    private UserCleanupUtil() {
    }

    public static Long findContesterId(EntityManager em, Long userId) {
        return em.createQuery(
                        "SELECT c.id FROM Contester c WHERE c.user.id = :userId",
                        Long.class
                )
                .setParameter("userId", userId)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    public static Long findConversationId(EntityManager em, Long userId) {
        return em.createQuery(
                        "SELECT sc.id FROM SupportConversation sc WHERE sc.user.id = :userId",
                        Long.class
                )
                .setParameter("userId", userId)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }

    public static void deleteUserAndRelations(EntityManager em, Long userId) {
        Long contesterId = findContesterId(em, userId);
        if (contesterId != null) {
            em.createQuery("DELETE FROM Vote v WHERE v.contester.id = :contesterId")
                    .setParameter("contesterId", contesterId)
                    .executeUpdate();
            em.createQuery("DELETE FROM Contester c WHERE c.id = :contesterId")
                    .setParameter("contesterId", contesterId)
                    .executeUpdate();
        }

        em.createQuery("DELETE FROM Vote v WHERE v.voter.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();

        em.createQuery("DELETE FROM SupportMessage sm WHERE sm.senderUser.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();

        Long conversationId = findConversationId(em, userId);
        if (conversationId != null) {
            em.createQuery("DELETE FROM SupportMessage sm WHERE sm.conversation.id = :conversationId")
                    .setParameter("conversationId", conversationId)
                    .executeUpdate();
            em.createQuery("DELETE FROM SupportConversation sc WHERE sc.id = :conversationId")
                    .setParameter("conversationId", conversationId)
                    .executeUpdate();
        }

        em.createQuery("DELETE FROM AdminAuditLog l WHERE l.adminUser.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();

        em.createQuery("UPDATE ElectionSettings s SET s.updatedBy = null WHERE s.updatedBy.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();

        em.createQuery("DELETE FROM User u WHERE u.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}
