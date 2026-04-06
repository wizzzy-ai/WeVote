package com.bascode.util;

import com.bascode.model.entity.PositionElection;
import com.bascode.model.enums.ElectionStatus;
import com.bascode.model.enums.Position;
import jakarta.persistence.EntityManager;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

public final class PositionElectionUtil {
    private PositionElectionUtil() {}

    public static List<PositionElection> ensureAll(EntityManager em) {
        List<PositionElection> existing = em.createQuery(
                        "SELECT p FROM PositionElection p",
                        PositionElection.class
                )
                .getResultList();

        Map<Position, PositionElection> byName = new EnumMap<>(Position.class);
        for (PositionElection p : existing) {
            if (p.getName() != null) byName.put(p.getName(), p);
        }

        List<PositionElection> created = new ArrayList<>();
        for (Position pos : Position.values()) {
            if (!byName.containsKey(pos)) {
                PositionElection pe = new PositionElection();
                pe.setName(pos);
                pe.setStatus(ElectionStatus.NOT_STARTED);
                pe.setVotingOpen(false);
                created.add(pe);
                byName.put(pos, pe);
            }
        }

        if (!created.isEmpty()) {
            em.getTransaction().begin();
            for (PositionElection pe : created) em.persist(pe);
            em.getTransaction().commit();
        }

        return em.createQuery(
                        "SELECT p FROM PositionElection p ORDER BY p.name ASC",
                        PositionElection.class
                )
                .getResultList();
    }

    public static PositionElection getOrCreate(EntityManager em, Position pos) {
        PositionElection pe = em.createQuery(
                        "SELECT p FROM PositionElection p WHERE p.name = :n",
                        PositionElection.class
                )
                .setParameter("n", pos)
                .getResultStream()
                .findFirst()
                .orElse(null);
        if (pe != null) return pe;

        PositionElection created = new PositionElection();
        created.setName(pos);
        created.setStatus(ElectionStatus.NOT_STARTED);
        created.setVotingOpen(false);

        em.getTransaction().begin();
        em.persist(created);
        em.getTransaction().commit();
        return created;
    }
}

