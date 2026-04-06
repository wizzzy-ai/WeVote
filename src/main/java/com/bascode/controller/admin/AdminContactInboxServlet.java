package com.bascode.controller.admin;

import com.bascode.model.entity.ContactMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/admin/contact-inbox")
public class AdminContactInboxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            List<ContactMessage> messages = em.createQuery(
                            "SELECT m FROM ContactMessage m ORDER BY m.createdAt DESC",
                            ContactMessage.class
                    )
                    .setMaxResults(300)
                    .getResultList();

            request.setAttribute("messages", messages != null ? messages : Collections.emptyList());
            request.getRequestDispatcher("/WEB-INF/admin/contact_inbox.jsp").forward(request, response);
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

