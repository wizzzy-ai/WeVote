package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
import com.bascode.util.UserCleanupUtil;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = requireUser(request.getSession(false), em);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // profile | password | delete

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = requireUser(request.getSession(false), em);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            if ("password".equalsIgnoreCase(action)) {
                handlePasswordChange(request, response, em, user);
            } else if ("delete".equalsIgnoreCase(action)) {
                handleDeleteAccount(request, response, em, user);
            } else {
                handleProfileUpdate(request, response, em, user);
            }
        } finally {
            em.close();
        }
    }

    private void handleDeleteAccount(HttpServletRequest request, HttpServletResponse response, EntityManager em, User user)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("error", "Enter your current password to delete your account.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            request.setAttribute("error", "Current password is incorrect.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (user.getRole() == Role.ADMIN) {
            request.setAttribute("error", "Admin accounts cannot be deleted from the profile page.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        em.getTransaction().begin();
        UserCleanupUtil.deleteUserAndRelations(em, user.getId());
        em.getTransaction().commit();

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp?deleted=1");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, EntityManager em, User user)
            throws ServletException, IOException {
        String firstName = trimToNull(request.getParameter("firstName"));
        String lastName = trimToNull(request.getParameter("lastName"));
        String state = trimToNull(request.getParameter("state"));
        String country = trimToNull(request.getParameter("country"));

        if (firstName == null || lastName == null || state == null || country == null) {
            request.setAttribute("error", "First name, last name, state, and country are required.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        em.getTransaction().begin();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setState(state);
        user.setCountry(country);
        em.merge(user);
        em.getTransaction().commit();

        request.getSession().setAttribute("user", user);
        request.setAttribute("success", "Profile updated.");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, EntityManager em, User user)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null) {
            request.setAttribute("error", "All password fields are required.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            request.setAttribute("error", "Current password is incorrect.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.trim().length() < 8) {
            request.setAttribute("error", "New password must be at least 8 characters.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (BCrypt.checkpw(newPassword, user.getPasswordHash())) {
            request.setAttribute("error", "New password must be different from the old password.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        em.getTransaction().begin();
        user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        em.merge(user);
        em.getTransaction().commit();

        request.setAttribute("success", "Password updated.");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static User requireUser(HttpSession session, EntityManager em) {
        if (session == null) return null;
        Long id = toLong(session.getAttribute("userId"));
        if (id == null) return null;
        return em.find(User.class, id);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }

    private static Long toLong(Object v) {
        if (v instanceof Long) return (Long) v;
        if (v instanceof Integer) return ((Integer) v).longValue();
        if (v instanceof String) {
            try {
                return Long.valueOf((String) v);
            } catch (Exception ignored) {
                return null;
            }
        }
        return null;
    }
}
