package com.bascode.controller.admin;

import com.bascode.model.entity.SupportConversation;
import com.bascode.model.entity.SupportMessage;
import com.bascode.model.entity.User;
import com.bascode.model.enums.SupportSender;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/messages")
public class AdminMessagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            List<SupportConversation> conversations = em.createQuery(
                            "SELECT sc FROM SupportConversation sc " +
                                    "JOIN FETCH sc.user u " +
                                    "ORDER BY sc.updatedAt DESC",
                            SupportConversation.class
                    )
                    .setMaxResults(300)
                    .getResultList();

            Long requestedCid = toLong(request.getParameter("cid"));
            SupportConversation selected = null;
            if (requestedCid != null) {
                for (SupportConversation sc : conversations) {
                    if (sc.getId() != null && sc.getId().equals(requestedCid)) {
                        selected = sc;
                        break;
                    }
                }
            }
            if (selected == null && !conversations.isEmpty()) {
                selected = conversations.get(0);
            }

            Map<Long, SupportMessage> lastByConversation = new HashMap<>();
            if (!conversations.isEmpty()) {
                List<Long> ids = new ArrayList<>();
                for (SupportConversation sc : conversations) {
                    if (sc.getId() != null) ids.add(sc.getId());
                }
                if (!ids.isEmpty()) {
                    List<SupportMessage> recent = em.createQuery(
                                    "SELECT m FROM SupportMessage m " +
                                            "JOIN FETCH m.senderUser su " +
                                            "WHERE m.conversation.id IN :ids " +
                                            "ORDER BY m.conversation.id ASC, m.createdAt DESC",
                                    SupportMessage.class
                            )
                            .setParameter("ids", ids)
                            .setMaxResults(4000)
                            .getResultList();
                    for (SupportMessage m : recent) {
                        Long cid = (m.getConversation() != null ? m.getConversation().getId() : null);
                        if (cid != null && !lastByConversation.containsKey(cid)) {
                            lastByConversation.put(cid, m);
                        }
                    }
                }
            }

            Map<Long, Long> unreadByConversation = new HashMap<>();
            List<Object[]> unreadRows = em.createQuery(
                            "SELECT m.conversation.id, COUNT(m.id) " +
                                    "FROM SupportMessage m " +
                                    "WHERE m.sender = :sender AND m.adminReadAt IS NULL " +
                                    "GROUP BY m.conversation.id",
                            Object[].class
                    )
                    .setParameter("sender", SupportSender.USER)
                    .setMaxResults(2000)
                    .getResultList();
            for (Object[] r : unreadRows) {
                Long cid = (Long) r[0];
                Long cnt = (Long) r[1];
                if (cid != null && cnt != null) unreadByConversation.put(cid, cnt);
            }

            List<SupportMessage> thread = Collections.emptyList();
            if (selected != null && selected.getId() != null) {
                // Mark user messages as read by admin when opening a thread.
                em.getTransaction().begin();
                em.createQuery(
                                "UPDATE SupportMessage m SET m.adminReadAt = :now " +
                                        "WHERE m.conversation.id = :cid " +
                                        "AND m.sender = :sender AND m.adminReadAt IS NULL"
                        )
                        .setParameter("now", LocalDateTime.now())
                        .setParameter("cid", selected.getId())
                        .setParameter("sender", SupportSender.USER)
                        .executeUpdate();
                em.getTransaction().commit();

                thread = em.createQuery(
                                "SELECT m FROM SupportMessage m " +
                                        "JOIN FETCH m.senderUser su " +
                                        "WHERE m.conversation.id = :cid " +
                                        "ORDER BY m.createdAt ASC",
                                SupportMessage.class
                        )
                        .setParameter("cid", selected.getId())
                        .setMaxResults(2000)
                        .getResultList();
            }

            request.setAttribute("conversations", conversations);
            request.setAttribute("selectedConversation", selected);
            request.setAttribute("messages", thread);
            request.setAttribute("lastByConversation", lastByConversation);
            request.setAttribute("unreadByConversation", unreadByConversation);
            request.getRequestDispatcher("/WEB-INF/admin/messages.jsp").forward(request, response);
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long adminId = session != null ? toLong(session.getAttribute("userId")) : null;
        if (adminId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Long conversationId = toLong(request.getParameter("conversationId"));
        String body = trimToNull(request.getParameter("message"));
        Long replyToId = toLong(request.getParameter("replyToMessageId"));
        if (conversationId == null) {
            response.sendRedirect(request.getContextPath() + "/admin/messages");
            return;
        }
        if (body == null) {
            response.sendRedirect(request.getContextPath() + "/admin/messages?cid=" + conversationId);
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User admin = em.find(User.class, adminId);
            SupportConversation sc = em.find(SupportConversation.class, conversationId);
            if (admin == null || sc == null) {
                response.sendRedirect(request.getContextPath() + "/admin/messages");
                return;
            }

            SupportMessage msg = new SupportMessage();
            msg.setConversation(sc);
            msg.setSenderUser(admin);
            msg.setSender(SupportSender.ADMIN);
            msg.setBody(body);
            if (replyToId != null) {
                SupportMessage original = em.find(SupportMessage.class, replyToId);
                if (original != null && original.getConversation() != null
                        && original.getConversation().getId().equals(sc.getId())) {
                    msg.setReplyToMessageId(replyToId);
                }
            }

            em.getTransaction().begin();
            em.persist(msg);
            sc.setUpdatedAt(LocalDateTime.now());
            em.merge(sc);
            em.getTransaction().commit();

            response.sendRedirect(request.getContextPath() + "/admin/messages?cid=" + conversationId);
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/messages?cid=" + conversationId);
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

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static Long toLong(Object v) {
        if (v == null) return null;
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
