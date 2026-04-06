package com.bascode.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
	}


	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
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
            
            // Prevent account enumeration: always respond with the same success message.
            String genericSuccess = "If an account exists for that email, a password reset link has been sent.";
            if (user == null) {
                request.setAttribute("success", genericSuccess);
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }
            // Generate secure reset token
            SecureRandom random = new SecureRandom();
            byte[] tokenBytes = new byte[24];
            random.nextBytes(tokenBytes);
            String resetToken = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
            em.getTransaction().begin();
            // Store reset tokens in the dedicated field to avoid clobbering email verification OTPs.
            user.setResetToken(resetToken);
            em.getTransaction().commit();
            // Send reset email
            try {
                String baseUrl = buildBaseUrl(request);
                String resetLink = baseUrl + "/reset-password?token=" + URLEncoder.encode(resetToken, StandardCharsets.UTF_8);
                EmailUtil.sendPasswordResetEmail(email, resetLink);
            } catch (MessagingException e) {
                // Don't reveal delivery failures to the requester.
            }
            request.setAttribute("success", genericSuccess);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
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

    private static String buildBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        String ctx = request.getContextPath();

        boolean defaultPort = ("http".equalsIgnoreCase(scheme) && port == 80) ||
                ("https".equalsIgnoreCase(scheme) && port == 443);
        String portPart = defaultPort ? "" : (":" + port);
        return scheme + "://" + host + portPart + ctx;
    }
}
