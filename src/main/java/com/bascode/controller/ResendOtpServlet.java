package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.util.EmailUtil;
import jakarta.mail.MessagingException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required to resend the OTP.");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            // Avoid leaking whether an account exists for arbitrary emails.
            if (user == null) {
                request.setAttribute("success", "If an account exists for that email, a new OTP has been sent.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            if (user.isEmailVerified()) {
                response.sendRedirect("login.jsp?success=1");
                return;
            }

            String otp = String.format("%06d", new java.util.Random().nextInt(1000000));
            em.getTransaction().begin();
            user.setVerificationCode(otp);
            em.merge(user);
            em.getTransaction().commit();

            try {
                EmailUtil.sendVerificationEmail(email, otp);
            } catch (MessagingException e) {
                request.setAttribute("error", "Failed to send OTP email on this environment. Please try again later.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            request.setAttribute("success", "A new OTP has been sent to your email.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
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

