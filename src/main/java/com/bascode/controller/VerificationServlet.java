package com.bascode.controller;

import com.bascode.model.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/verify")
public class VerificationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            request.setAttribute("error", "Invalid verification link.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.verificationCode = :code", User.class)
                .setParameter("code", code)
                .getResultStream()
                .findFirst()
                .orElse(null);
            if (user == null) {
                request.setAttribute("error", "Invalid or expired verification code.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            em.getTransaction().begin();
            user.setEmailVerified(true);
            user.setVerificationCode(null);
            em.getTransaction().commit();
            request.setAttribute("success", "Email verified successfully. You can now log in.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
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
