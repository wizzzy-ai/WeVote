package com.bascode.controller.admin;

import com.bascode.model.entity.PositionElection;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.util.PositionElectionUtil;
import com.bascode.util.ElectionAutoEndUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/position-details")
public class AdminPositionDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
            return;
        }

        Position pos;
        try {
            pos = Position.valueOf(request.getParameter("position"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Invalid%20position&type=error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            // Auto-end check: close election if end time reached
            PositionElection pe = PositionElectionUtil.getOrCreate(em, pos);
            ElectionAutoEndUtil.checkAndAutoEnd(em, pe);

            List<Object[]> rows = em.createQuery(
                            "SELECT c, COUNT(v.id) " +
                                    "FROM Contester c " +
                                    "JOIN FETCH c.user u " +
                                    "LEFT JOIN Vote v ON v.contester = c " +
                                    "WHERE c.position = :p " +
                                    "GROUP BY c " +
                                    "ORDER BY COUNT(v.id) DESC, u.lastName ASC, u.firstName ASC",
                            Object[].class
                    )
                    .setParameter("p", pos)
                    .getResultList();

            long totalVotes = 0L;
            for (Object[] r : rows) {
                Long cnt = (Long) r[1];
                if (cnt != null) totalVotes += cnt;
            }

            request.setAttribute("position", pos);
            request.setAttribute("positionElection", pe);
            request.setAttribute("rows", rows);
            request.setAttribute("totalVotes", totalVotes);
            request.getRequestDispatcher("/WEB-INF/admin/position_details.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private static boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Object role = session.getAttribute("userRole");
        if (role == null) return false;
        String roleStr = String.valueOf(role);
        return "ADMIN".equalsIgnoreCase(roleStr) || "SUPER_ADMIN".equalsIgnoreCase(roleStr);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}

