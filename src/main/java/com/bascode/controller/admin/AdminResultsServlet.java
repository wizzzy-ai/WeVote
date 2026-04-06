package com.bascode.controller.admin;

import com.bascode.model.entity.Contester;
import com.bascode.model.enums.ContesterStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/results")
public class AdminResultsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            // One row per contester with vote count (0 if none).
            List<Object[]> rows = em.createQuery(
                            "SELECT c, COUNT(v.id) " +
                                    "FROM Contester c " +
                                    "JOIN FETCH c.user u " +
                                    "LEFT JOIN Vote v ON v.contester = c " +
                                    "WHERE c.status = :status " +
                                    "GROUP BY c " +
                                    "ORDER BY c.position ASC, COUNT(v.id) DESC, u.lastName ASC, u.firstName ASC",
                            Object[].class
                    )
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getResultList();

            long totalVotes = em.createQuery("SELECT COUNT(v) FROM Vote v", Long.class).getSingleResult();
            long approvedCandidates = em.createQuery(
                            "SELECT COUNT(c) FROM Contester c WHERE c.status = :s",
                            Long.class
                    )
                    .setParameter("s", ContesterStatus.APPROVED)
                    .getSingleResult();

            request.setAttribute("rows", rows);
            request.setAttribute("totalVotes", totalVotes);
            request.setAttribute("approvedCandidates", approvedCandidates);
            request.getRequestDispatcher("/WEB-INF/admin/results.jsp").forward(request, response);
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
