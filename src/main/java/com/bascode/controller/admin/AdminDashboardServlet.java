package com.bascode.controller.admin;

import com.bascode.model.entity.AdminAuditLog;
import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
import com.bascode.model.entity.Vote;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.model.enums.Role;
import com.bascode.util.PositionElectionUtil;
import com.bascode.util.ElectionAutoEndUtil;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            long totalUsers = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
            long totalVoters = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :r", Long.class)
                    .setParameter("r", Role.VOTER)
                    .getSingleResult();
            long totalAdmins = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :r", Long.class)
                    .setParameter("r", Role.ADMIN)
                    .getSingleResult();
            long totalContesterUsers = em.createQuery("SELECT COUNT(c) FROM Contester c", Long.class)
                    .getSingleResult();

            long contesterApps = em.createQuery("SELECT COUNT(c) FROM Contester c", Long.class).getSingleResult();
            long pendingApps = em.createQuery("SELECT COUNT(c) FROM Contester c WHERE c.status = :s", Long.class)
                    .setParameter("s", ContesterStatus.PENDING)
                    .getSingleResult();
            long approvedApps = em.createQuery("SELECT COUNT(c) FROM Contester c WHERE c.status = :s", Long.class)
                    .setParameter("s", ContesterStatus.APPROVED)
                    .getSingleResult();
            long deniedApps = em.createQuery("SELECT COUNT(c) FROM Contester c WHERE c.status = :s", Long.class)
                    .setParameter("s", ContesterStatus.DENIED)
                    .getSingleResult();

            long totalVotes = em.createQuery("SELECT COUNT(v) FROM Vote v", Long.class).getSingleResult();

            List<AdminAuditLog> recentActivity = em.createQuery(
                            "SELECT l FROM AdminAuditLog l JOIN FETCH l.adminUser u ORDER BY l.createdAt DESC",
                            AdminAuditLog.class
                    )
                    .setMaxResults(8)
                    .getResultList();

            // Auto-end any expired elections before displaying
            ElectionAutoEndUtil.autoEndExpiredElections(em);

            List<PositionElection> positions = PositionElectionUtil.ensureAll(em);
            Map<Position, Long> approvedCounts = new HashMap<>();
            List<Object[]> rows = em.createQuery(
                            "SELECT c.position, COUNT(c.id) FROM Contester c " +
                                    "WHERE c.status = :s GROUP BY c.position",
                            Object[].class
                    )
                    .setParameter("s", ContesterStatus.APPROVED)
                    .getResultList();
            for (Object[] r : rows) {
                Position p = (Position) r[0];
                Long cnt = (Long) r[1];
                if (p != null && cnt != null) approvedCounts.put(p, cnt);
            }

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalVoters", totalVoters);
            request.setAttribute("totalAdmins", totalAdmins);
            request.setAttribute("totalContesterUsers", totalContesterUsers);
            request.setAttribute("contesterApps", contesterApps);
            request.setAttribute("pendingApps", pendingApps);
            request.setAttribute("approvedApps", approvedApps);
            request.setAttribute("deniedApps", deniedApps);
            request.setAttribute("totalVotes", totalVotes);
            request.setAttribute("recentActivity", recentActivity);
            request.setAttribute("positions", positions);
            request.setAttribute("approvedCounts", approvedCounts);

            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
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
