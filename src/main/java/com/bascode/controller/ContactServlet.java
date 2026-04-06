package com.bascode.controller;

import com.bascode.model.entity.ContactMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Logged-in users use the persistent support chat instead of the one-time contact form.
        if (request.getSession(false) != null && request.getSession(false).getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }
        String name = trimToNull(request.getParameter("name"));
        String email = trimToNull(request.getParameter("email"));
        String message = trimToNull(request.getParameter("message"));

        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("message", message);

        if (name == null || email == null || message == null) {
            request.setAttribute("error", "Please fill in your name, email, and message.");
            request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
            return;
        }

        if (!email.contains("@") || email.length() < 5) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            ContactMessage cm = new ContactMessage();
            cm.setName(name);
            cm.setEmail(email);
            cm.setMessage(message);

            em.getTransaction().begin();
            em.persist(cm);
            em.getTransaction().commit();

            // Clear fields on success.
            request.setAttribute("name", "");
            request.setAttribute("email", "");
            request.setAttribute("message", "");
            request.setAttribute("success", "Thanks, your message has been sent. We will get back to you soon.");
            request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            request.setAttribute("error", "A system error occurred while sending your message. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
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
