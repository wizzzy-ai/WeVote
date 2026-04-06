package com.bascode.controller.admin;

import java.io.IOException;
import java.time.LocalDate;

import org.mindrot.jbcrypt.BCrypt;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/create-admin")
public class CreateAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        if (!"SUPER_ADMIN".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String currentRole = (session != null) ? (String) session.getAttribute("userRole") : null;
        if (!"SUPER_ADMIN".equals(currentRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        EntityManager em = null;
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String state = request.getParameter("state");
            String country = request.getParameter("country");
            String birthDateStr = request.getParameter("birthDate");
            String roleStr = request.getParameter("role");

            // Basic validation
            if (firstName == null || lastName == null || email == null || password == null || roleStr == null) {
                request.setAttribute("message", "All required fields must be filled.");
                request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);
                return;
            }

            // Password strength check
       
       //String passwordPattern = "^(?=.*[A-Za-z])(?=.*\\\\d)(?=.*[@$!%*?&])[A-Za-z\\\\d@$!%*?&]{8,}$";
        //    if (!password.matches(passwordPattern)) {
          //      request.setAttribute("message", "Password must be at least 8 characters long and include letters, numbers, and one special character.");
             //   request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);
           //     return;
            //} 

            LocalDate birthDate = null;
            int birthYear = 0;
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                try {
                    birthDate = LocalDate.parse(birthDateStr);
                    birthYear = birthDate.getYear();
                } catch (Exception e) {
                    request.setAttribute("message", "Invalid birth date format.");
                    request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);
                    return;
                }
            }

            EntityManagerFactory emf = getEmf();
            em = emf.createEntityManager();

            // Check for duplicate email
            long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            if (count > 0) {
                request.setAttribute("message", "Email already registered.");
                request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);
                return;
            }

            // Hash password
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            // Create User entity
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPasswordHash(passwordHash);
            user.setBirthDate(birthDate);
            user.setBirthYear(birthYear);
            user.setState(state);
            user.setCountry(country);
            user.setRole(Role.ADMIN);
            user.setEmailVerified(false);
            user.setSuspended(false);
            user.setVerificationCode(null);

            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();

            // ✅ No redirect — just show success message on same page
            request.setAttribute("message", "Admin account created successfully!");
            request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);

        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            request.setAttribute("message", "Error creating admin: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/create-admin.jsp").forward(request, response);
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
