package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.model.enums.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin/add-contester")
public class AddContesterServlet extends HttpServlet {
    private static final String ALLOWED_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
    private static final int TEMP_PASSWORD_LENGTH = 12;

    private EntityManagerFactory emf;
    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("VotingPU");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = null;
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String state = request.getParameter("state");
            String country = request.getParameter("country");
            String birthYearStr = request.getParameter("birthYear");
            String positionStr = request.getParameter("position");

            if (isBlank(firstName) || isBlank(lastName) || isBlank(email) || isBlank(state)
                    || isBlank(country) || isBlank(birthYearStr) || isBlank(positionStr)) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            int birthYear;
            try {
                birthYear = Integer.parseInt(birthYearStr);
            } catch (NumberFormatException ex) {
                request.setAttribute("error", "Invalid birth year.");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            Position position;
            try {
                position = Position.valueOf(positionStr);
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", "Invalid position selected.");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            em = emf.createEntityManager();

            long existingEmail = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();

            if (existingEmail > 0) {
                request.setAttribute("error", "Email already exists.");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            long approvedForPosition = em.createQuery(
                    "SELECT COUNT(c) FROM Contester c WHERE c.position = :position AND c.status = :status", Long.class)
                    .setParameter("position", position)
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getSingleResult();

            if (approvedForPosition >= 3) {
                request.setAttribute("error", "Maximum approved candidates reached for this position.");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            String tempPassword = generateTempPassword();
            String passwordHash = BCrypt.hashpw(tempPassword, BCrypt.gensalt());

            em.getTransaction().begin();

            User contesterUser = new User();
            contesterUser.setFirstName(firstName);
            contesterUser.setLastName(lastName);
            contesterUser.setEmail(email);
            contesterUser.setPasswordHash(passwordHash);
            contesterUser.setBirthYear(birthYear);
            contesterUser.setState(state);
            contesterUser.setCountry(country);
            contesterUser.setRole(Role.CONTESTER);
            contesterUser.setEmailVerified(true);
            em.persist(contesterUser);

            Contester contester = new Contester();
            contester.setUser(contesterUser);
            contester.setPosition(position);
            contester.setStatus(ContesterStatus.APPROVED);
            em.persist(contester);

            em.getTransaction().commit();

            request.setAttribute("success", "Candidate created successfully. Temporary password: " + tempPassword);
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            request.setAttribute("error", "Failed to create candidate. Please try again.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String generateTempPassword() {
        StringBuilder builder = new StringBuilder(TEMP_PASSWORD_LENGTH);
        for (int i = 0; i < TEMP_PASSWORD_LENGTH; i++) {
            int idx = secureRandom.nextInt(ALLOWED_CHARS.length());
            builder.append(ALLOWED_CHARS.charAt(idx));
        }
        return builder.toString();
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}
