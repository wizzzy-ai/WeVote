package com.bascode.controller.admin;

import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/users/view")
public class AdminUserDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        Long userId = toLong(userIdStr);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?msg=Invalid user ID&type=error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?msg=User not found&type=error");
                return;
            }

            // Check if user has approved contester profile
            boolean hasApprovedContester = false;
            try {
                Long contesterCount = em.createQuery(
                        "SELECT COUNT(c) FROM Contester c WHERE c.user.id = :userId AND c.status = :status", 
                        Long.class)
                        .setParameter("userId", userId)
                        .setParameter("status", ContesterStatus.APPROVED)
                        .getSingleResult();
                hasApprovedContester = contesterCount > 0;
            } catch (Exception ignored) {}

            request.setAttribute("user", user);
            request.setAttribute("hasApprovedContester", hasApprovedContester);
            request.getRequestDispatcher("/WEB-INF/admin/user-detail.jsp").forward(request, response);
            
        } finally {
            em.close();
        }
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

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
