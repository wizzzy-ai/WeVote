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
@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                          .setParameter("email", email)
                          .getResultStream()
                          .findFirst()
                          .orElse(null);

            if (user == null) {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            if (!otp.equals(user.getVerificationCode())) {
                request.setAttribute("error", "Invalid OTP code.");
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            em.getTransaction().begin();
            user.setEmailVerified(true);
            user.setVerificationCode(null); // clear OTP
            em.getTransaction().commit();

            // Redirect to login page with success notification
            response.sendRedirect("login.jsp?success=1");

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
