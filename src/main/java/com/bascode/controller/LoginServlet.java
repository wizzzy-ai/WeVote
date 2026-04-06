package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
import com.bascode.util.AgeUtil;
import com.bascode.util.ContesterAccessUtil;
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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();

        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (user == null) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!user.isEmailVerified()) {
                request.setAttribute("error", "Email not verified. Please check your email for the OTP and verify your account.");
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            if (user.isSuspended()) {
                request.setAttribute("error", "Your account has been suspended. Please contact the admin.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!BCrypt.checkpw(password, user.getPasswordHash())) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            boolean hasApprovedContesterProfile = ContesterAccessUtil.hasApprovedContesterProfile(em, user.getId());
            session.setAttribute("userId", user.getId());
            // Preserve admin roles over contester role
            if (user.getRole() == Role.SUPER_ADMIN || user.getRole() == Role.ADMIN) {
                session.setAttribute("userRole", user.getRole().name());
            } else {
                session.setAttribute("userRole", hasApprovedContesterProfile ? Role.CONTESTER.name() : user.getRole().name());
            }
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("firstName", user.getFirstName());
            session.setAttribute("lastName", user.getLastName());
            session.setAttribute("user", user);
            session.setAttribute("underage", AgeUtil.isUnderage(user));

            if (user.getRole() == Role.ADMIN || user.getRole() == Role.SUPER_ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (hasApprovedContesterProfile || user.getRole() == Role.CONTESTER) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "A system error occurred: " + ex.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
