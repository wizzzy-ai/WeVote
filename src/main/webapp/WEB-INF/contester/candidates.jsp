<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User,com.bascode.model.enums.Position" %>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
  <title>Contesters - Voting System</title>
  <style>
    @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
    .fade-up { animation: fadeUp .5s ease-out both; }
  </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>
<%
  @SuppressWarnings("unchecked")
  Map<Position, List<Contester>> grouped = (Map<Position, List<Contester>>) request.getAttribute("grouped");
  if (grouped == null) grouped = new LinkedHashMap<>();
  @SuppressWarnings("unchecked")
  Map<Position, Long> positionCounts = (Map<Position, Long>) request.getAttribute("positionCounts");
  if (positionCounts == null) positionCounts = new LinkedHashMap<>();
%>
  <section class="max-w-3xl mx-auto pt-28 px-4 pb-14">
    <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
      <div class="flex items-start justify-between gap-4">
        <div>
          <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Approved Contesters</h1>
          <p class="text-gray-600 mt-1">Grouped by position with availability.</p>
        </div>
        <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
      </div>

      <div class="mt-6 space-y-6">
        <%
          int i = 0;
          boolean any = false;
          for (Position p : Position.values()) {
            List<Contester> list = grouped.getOrDefault(p, Collections.emptyList());
            long count = positionCounts.getOrDefault(p, 0L);
            String pname = p.name().replace('_',' ');
            if (!list.isEmpty()) any = true;
        %>
          <div class="fade-up rounded-2xl border border-gray-100 bg-white/80 p-5" style="animation-delay:<%= Math.min(0.7, i * 0.04) %>s;">
            <div class="flex items-center justify-between gap-3">
              <div class="text-lg font-extrabold text-gray-900"><%= pname %></div>
              <div class="flex items-center gap-2">
                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-gray-800 bg-gray-100">
                  <%= count %> of 3 spots filled
                </span>
                <% if (count >= 3) { %>
                  <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-red-800 bg-red-100">Position Full</span>
                <% } %>
              </div>
            </div>
            <div class="mt-4 space-y-3">
              <% if (list.isEmpty()) { %>
                <div class="text-sm text-gray-500">No approved contesters for this position yet.</div>
              <% } else { %>
                <%
                  for (Contester c : list) {
                    i++;
                    User u = c.getUser();
                    String fullName = (u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)");
                %>
                  <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-4 hover:shadow-md transition duration-200">
                    <div class="flex items-start justify-between gap-4">
                      <div>
                        <div class="text-base font-bold text-gray-900"><%= fullName %></div>
                        <div class="text-sm text-gray-600 mt-1">Position: <span class="font-semibold text-gray-800"><%= pname %></span></div>
                      </div>
                      <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                            style="background: linear-gradient(135deg, var(--purple), var(--green));">
                        Contester
                      </span>
                    </div>
                  </div>
                <%
                  }
                %>
              <% } %>
            </div>
          </div>
        <%
          }
          if (!any) {
        %>
          <div class="fade-up rounded-2xl border border-gray-100 bg-gray-50 p-6 text-center text-gray-700">
            No approved contesters yet.
          </div>
        <%
          }
        %>
      </div>
    </div>
  </section>
<%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %>
</body>
</html>
