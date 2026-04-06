package com.bascode.controller;

import com.bascode.model.entity.User;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        // Input sanitization: trim and check length
        if (token == null || password == null || confirmPassword == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters.");
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.resetToken = :token", User.class)
                .setParameter("token", token)
                .getResultStream()
                .findFirst()
                .orElse(null);
            if (user == null) {
                request.setAttribute("error", "Invalid or expired reset token.");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }
            // Prevent password reuse
            if (BCrypt.checkpw(password, user.getPasswordHash())) {
                request.setAttribute("error", "New password must be different from the old password.");
                request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                return;
            }
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
            em.getTransaction().begin();
            user.setPasswordHash(passwordHash);
            user.setResetToken(null);
            em.getTransaction().commit();
            request.setAttribute("success", "Password reset successful. You can now log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
