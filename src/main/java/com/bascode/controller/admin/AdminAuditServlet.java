package com.bascode.controller.admin;

import com.bascode.model.entity.AdminAuditLog;
import com.bascode.model.enums.AdminActionType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/audit")
public class AdminAuditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String actionParam = trimToNull(request.getParameter("action"));

        AdminActionType actionType = null;
        if (actionParam != null) {
            try {
                actionType = AdminActionType.valueOf(actionParam.toUpperCase());
            } catch (IllegalArgumentException ignored) {
                // ignore invalid filter
            }
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT l FROM AdminAuditLog l " +
                            "JOIN FETCH l.adminUser u " +
                            "WHERE 1=1"
            );
            Map<String, Object> params = new HashMap<>();

            if (actionType != null) {
                jpql.append(" AND l.actionType = :actionType");
                params.put("actionType", actionType);
            }

            jpql.append(" ORDER BY l.createdAt DESC");

            var q = em.createQuery(jpql.toString(), AdminAuditLog.class).setMaxResults(250);
            for (var e : params.entrySet()) q.setParameter(e.getKey(), e.getValue());

            List<AdminAuditLog> logs = q.getResultList();
            request.setAttribute("logs", logs);
            request.setAttribute("selectedAction", actionParam == null ? "" : actionParam);
            request.getRequestDispatcher("/WEB-INF/admin/audit.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
