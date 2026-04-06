<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.ContactMessage,com.bascode.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Contact Form Inbox</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
  <style>
    .msg {
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  </style>
</head>
<body class="admin-app">

<%
  @SuppressWarnings("unchecked")
  List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");
  if (messages == null) messages = Collections.emptyList();

  request.setAttribute("adminPageTitle", "Contact Inbox");
  request.setAttribute("adminPageSubtitle", "Legacy one-time contact form submissions.");
  request.setAttribute("activeAdminPage", "messages");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>
<div class="mb-4 flex justify-end">
  <a href="<%=request.getContextPath()%>/admin/messages" class="admin-button-subtle px-4 py-2">Support Chat Inbox</a>
</div>
  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Inbox</h2>
        <p class="text-sm text-gray-600"><%= messages.size() %> message(s) shown (max 300)</p>
      </div>
    </div>
  </section>

  <section class="mt-6 rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.05s;">
    <div class="mt-1 overflow-x-auto">
      <table class="admin-table w-full text-sm">
        <thead>
          <tr class="text-left text-gray-600">
            <th class="py-3 pr-4">Time</th>
            <th class="py-3 pr-4">Name</th>
            <th class="py-3 pr-4">Email</th>
            <th class="py-3 pr-4">Message</th>
          </tr>
        </thead>
        <tbody>
        <%
          int i = 0;
          for (ContactMessage m : messages) {
            i++;
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay:<%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 text-gray-700 whitespace-nowrap"><%= m.getCreatedAt() %></td>
            <td class="py-4 pr-4 font-semibold text-gray-900 whitespace-nowrap"><%= HtmlUtil.escape(m.getName()) %></td>
            <td class="py-4 pr-4 text-gray-700 whitespace-nowrap">
              <a class="text-[var(--purple)] hover:underline" href="mailto:<%= HtmlUtil.escape(m.getEmail()) %>"><%= HtmlUtil.escape(m.getEmail()) %></a>
            </td>
            <td class="py-4 pr-4 text-gray-700">
              <details class="group">
                <summary class="cursor-pointer select-none">
                  <div class="msg"><%= HtmlUtil.escape(m.getMessage()) %></div>
                  <div class="mt-2 text-xs font-semibold text-gray-500 group-open:hidden">Click to expand</div>
                  <div class="mt-2 text-xs font-semibold text-gray-500 hidden group-open:block">Click to collapse</div>
                </summary>
                <div class="mt-3 rounded-2xl bg-white/70 border border-gray-100 p-4 whitespace-pre-wrap"><%= HtmlUtil.escape(m.getMessage()) %></div>
              </details>
            </td>
          </tr>
        <%
          }
          if (messages.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="4" class="py-8 text-center text-gray-600">
              No contact form messages yet.
            </td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
    </div>
  </section>
<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>

</body>
</html>
