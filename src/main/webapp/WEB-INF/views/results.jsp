<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User" %>

<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
    <title>Results - Voting System</title>
    <style>
      @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
      .fade-up { animation: fadeUp .5s ease-out both; }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>
<%
  @SuppressWarnings("unchecked")
  List<Object[]> rows = (List<Object[]>) request.getAttribute("rows");
  if (rows == null) rows = Collections.emptyList();

  long totalVotes = 0L;
  for (Object[] r : rows) {
    Long v = (Long) r[1];
    totalVotes += (v != null ? v : 0L);
  }
%>

  <section class="max-w-4xl mx-auto pt-6 px-4 pb-14">
    <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
      <div class="flex items-start justify-between gap-4">
        <div>
          <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Election Results</h1>
          <p class="text-gray-600 mt-1">Read-only vote counts per approved contester.</p>
        </div>
        <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
      </div>

      <div class="mt-6 flex flex-wrap gap-2">
        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
              style="background: linear-gradient(135deg, var(--purple), var(--green));">
          Total votes: <%= totalVotes %>
        </span>
        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-gray-800 bg-gray-100">
          Candidates: <%= rows.size() %>
        </span>
      </div>

      <div class="mt-6 overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="text-left text-gray-600">
              <th class="py-3 pr-4">Candidate</th>
              <th class="py-3 pr-4">Position</th>
              <th class="py-3 pr-4">Votes</th>
            </tr>
          </thead>
          <tbody>
            <%
              int i = 0;
              for (Object[] r : rows) {
                i++;
                Contester c = (Contester) r[0];
                Long votes = (Long) r[1];
                User u = c != null ? c.getUser() : null;
                String fullName = (u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)");
                String pos = (c != null && c.getPosition() != null) ? c.getPosition().name().replace('_',' ') : "";
            %>
              <tr class="fade-up border-t border-gray-100 hover:bg-white/60 transition"
                  style="animation-delay:<%= Math.min(0.6, i * 0.02) %>s;">
                <td class="py-4 pr-4 font-semibold text-gray-900"><%= fullName %></td>
                <td class="py-4 pr-4 text-gray-700"><%= pos %></td>
                <td class="py-4 pr-4">
                  <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                        style="background: linear-gradient(135deg, var(--purple), var(--green));">
                    <%= votes != null ? votes : 0 %>
                  </span>
                </td>
              </tr>
            <%
              }
              if (rows.isEmpty()) {
            %>
              <tr class="border-t border-gray-100">
                <td class="py-8 text-center text-gray-600" colspan="3">
                  No results to display yet.
                </td>
              </tr>
            <%
              }
            %>
          </tbody>
        </table>
      </div>

      <div class="mt-8 flex flex-wrap gap-3">
        <a href="<%=request.getContextPath()%>/dashboard"
           class="px-5 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Back to Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/candidates"
           class="px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
          View Candidates
        </a>
     </div>
    </div>
     <%
       String userRole = session != null ? (String) session.getAttribute("userRole") : null;
       if ("CONTESTER".equalsIgnoreCase(userRole)) {
     %>
       <%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %>
     <%
       } else {
     %>
       <%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp" %>
     <%
       }
     %>
  </section>
</body>
</html>