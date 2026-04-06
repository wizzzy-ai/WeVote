package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/contester/candidates")
public class ContesterCandidatesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            List<Contester> contesters = em.createQuery(
                            "SELECT c FROM Contester c JOIN FETCH c.user u WHERE c.status = :status ORDER BY c.position ASC, u.lastName ASC, u.firstName ASC",
                            Contester.class
                    )
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getResultList();

            Map<Position, Long> counts = new LinkedHashMap<>();
            List<Object[]> countRows = em.createQuery(
                            "SELECT c.position, COUNT(c) FROM Contester c WHERE c.status = :status GROUP BY c.position",
                            Object[].class
                    )
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getResultList();
            for (Object[] r : countRows) {
                counts.put((Position) r[0], (Long) r[1]);
            }

            Map<Position, List<Contester>> grouped = new LinkedHashMap<>();
            for (Position p : Position.values()) {
                grouped.put(p, contesters.stream().filter(c -> c.getPosition() == p).toList());
            }

            request.setAttribute("grouped", grouped);
            request.setAttribute("positionCounts", counts);
            request.getRequestDispatcher("/WEB-INF/contester/candidates.jsp").forward(request, response);
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
}

