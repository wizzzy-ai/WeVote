<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter,com.bascode.model.entity.Contester,com.bascode.model.entity.User" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>

<html lang="en">
<head>
  <title>Application Status - Voting System</title>
  <style>
    @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
    .fade-up { animation: fadeUp .5s ease-out both; }
  </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%
  User user = (User) request.getAttribute("user");
  Contester contester = (Contester) request.getAttribute("contester");
  long approvedCount = request.getAttribute("approvedCount") != null ? (Long) request.getAttribute("approvedCount") : 0L;
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a");
%>

  <section class="max-w-4xl mx-auto pt-6 px-4 pb-14">
    <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
      <div class="flex items-start justify-between gap-4">
        <div>
          <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Application Status</h1>
          <p class="text-gray-600 mt-1">Track your contester application timeline.</p>
        </div>
        <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
      </div>

      <% if (contester == null) { %>
        <div class="mt-6 rounded-2xl border border-gray-100 bg-gray-50 p-6 text-center text-gray-700">
          No contester application is linked to your account.
        </div>
      <% } else { %>
        <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="rounded-2xl border border-gray-100 bg-white p-5">
            <div class="text-xs font-bold tracking-widest text-gray-500">POSITION</div>
            <div class="mt-2 text-lg font-bold text-gray-900"><%= contester.getPosition() != null ? contester.getPosition().name().replace('_',' ') : "—" %></div>
            <div class="mt-2 text-sm text-gray-600">
              <%= approvedCount %> of 3 spots filled
              <% if (approvedCount >= 3) { %>
                <span class="ml-2 inline-flex items-center px-2 py-1 rounded-full text-xs font-bold text-red-800 bg-red-100">Position Full</span>
              <% } %>
            </div>
          </div>
          <div class="rounded-2xl border border-gray-100 bg-white p-5">
            <div class="text-xs font-bold tracking-widest text-gray-500">STATUS</div>
            <div class="mt-2 text-lg font-bold text-gray-900"><%= contester.getStatus() != null ? contester.getStatus().name() : "PENDING" %></div>
            <% if (contester.getStatusReason() != null && !contester.getStatusReason().trim().isEmpty()) { %>
              <div class="mt-2 text-sm text-gray-600">Reason: <%= contester.getStatusReason() %></div>
            <% } %>
          </div>
        </div>

        <div class="mt-8 rounded-2xl border border-gray-100 bg-white p-5">
          <div class="text-sm font-semibold text-gray-700">Timeline</div>
          <ol class="mt-4 space-y-4">
            <li class="flex items-start gap-3">
              <div class="w-3 h-3 rounded-full bg-[var(--green)] mt-2"></div>
              <div>
                <div class="font-semibold text-gray-900">Application Submitted</div>
                <div class="text-sm text-gray-600">
                  <%= contester.getCreatedAt() != null ? fmt.format(contester.getCreatedAt()) : "Date unavailable" %>
                </div>
              </div>
            </li>
            <li class="flex items-start gap-3">
              <div class="w-3 h-3 rounded-full bg-amber-400 mt-2"></div>
              <div>
                <div class="font-semibold text-gray-900">Under Review</div>
                <div class="text-sm text-gray-600">Pending admin approval</div>
              </div>
            </li>
            <li class="flex items-start gap-3">
              <div class="w-3 h-3 rounded-full <%= "APPROVED".equalsIgnoreCase(contester.getStatus().name()) ? "bg-[var(--green)]" : ("DENIED".equalsIgnoreCase(contester.getStatus().name()) ? "bg-red-500" : "bg-gray-300") %> mt-2"></div>
              <div>
                <div class="font-semibold text-gray-900">
                  <%= contester.getStatus() != null ? contester.getStatus().name() : "PENDING" %>
                </div>
                <div class="text-sm text-gray-600">
                  <%= contester.getStatusUpdatedAt() != null ? fmt.format(contester.getStatusUpdatedAt()) : "Date unavailable" %>
                </div>
              </div>
            </li>
          </ol>
        </div>
      <% } %>
    </div>
    <%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %>
  </section>
</body>
</html>

