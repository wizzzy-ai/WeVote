package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = null;
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String birthYearStr = request.getParameter("birthYear");
            String state = request.getParameter("state");
            String country = request.getParameter("country");

            // Input validation
            if (firstName == null || lastName == null || email == null || password == null || confirmPassword == null || birthYearStr == null || state == null || country == null) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Password strength validation
            String passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}$";
            if (!password.matches(passwordPattern)) {
                request.setAttribute("error", "Password must be at least 8 characters long and include letters, numbers, and one special character.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            int birthYear;
            LocalDate birthDate;
            try {
                birthDate = LocalDate.parse(birthYearStr);
                birthYear = birthDate.getYear();
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Invalid birth date.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            EntityManagerFactory emf = getEmf();
            em = emf.createEntityManager();

            // Check for duplicate email
            long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            if (count > 0) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Hash password
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            // Generate 6-digit numeric OTP
            String otp = String.format("%06d", new java.util.Random().nextInt(1000000));

            // Create User entity
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPasswordHash(passwordHash);
            user.setBirthYear(birthYear);
            user.setBirthDate(birthDate);
            user.setState(state);
            user.setCountry(country);

            // Always set role to VOTER
            user.setRole(Role.VOTER);

            user.setEmailVerified(false);
            user.setVerificationCode(otp); // Store OTP

            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();

            // Send OTP email
            try {
                EmailUtil.sendVerificationEmail(email, otp);
            } catch (MessagingException e) {
                request.setAttribute("error", "Registration succeeded, but failed to send OTP email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Redirect to OTP verification page
            response.sendRedirect("verify-otp.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));

        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            request.setAttribute("error", "A system error occurred while processing your registration. Please try entering your OTP or contact support.");
            request.setAttribute("email", request.getParameter("email"));
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        } finally {
            if (em != null) em.close();
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