package com.bascode.controller;

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

@WebServlet("/results")
public class ResultsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            List<Object[]> rows = em.createQuery(
                            "SELECT c, COUNT(v.id) " +
                                    "FROM Contester c " +
                                    "JOIN FETCH c.user u " +
                                    "LEFT JOIN Vote v ON v.contester = c " +
                                    "WHERE c.status = :status " +
                                    "GROUP BY c " +
                                    "ORDER BY COUNT(v.id) DESC, c.position ASC, u.lastName ASC, u.firstName ASC",
                            Object[].class
                    )
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getResultList();

            request.setAttribute("rows", rows);
            request.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(request, response);
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
