<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Results</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  @SuppressWarnings("unchecked")
  List<Object[]> rows = (List<Object[]>) request.getAttribute("rows");
  if (rows == null) rows = Collections.emptyList();
  long totalVotes = request.getAttribute("totalVotes") != null ? (Long) request.getAttribute("totalVotes") : 0L;
  long approvedCandidates = request.getAttribute("approvedCandidates") != null ? (Long) request.getAttribute("approvedCandidates") : 0L;

  request.setAttribute("adminPageTitle", "Results");
  request.setAttribute("adminPageSubtitle", "Live approved-candidate vote totals across positions.");
  request.setAttribute("activeAdminPage", "results");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<section class="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
  <div class="admin-card p-5 rise-in">
    <div class="text-4xl font-black text-slate-900"><%= totalVotes %></div>
    <div class="mt-2 text-sm text-slate-500">Total votes recorded</div>
  </div>
  <div class="admin-card p-5 rise-in">
    <div class="text-4xl font-black text-slate-900"><%= approvedCandidates %></div>
    <div class="mt-2 text-sm text-slate-500">Approved candidates</div>
  </div>
</section>

<section class="admin-card p-0 mt-4 rise-in">
  <div class="admin-section-head px-5 pt-5">
    <div>
      <div class="admin-section-title">Vote Counts</div>
      <div class="admin-section-note">Sorted by position and current count.</div>
    </div>
    <a href="<%=request.getContextPath()%>/admin/results" class="admin-button-subtle px-4 py-2">Refresh</a>
  </div>
  <div class="admin-table-wrap">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Candidate</th>
          <th>Position</th>
          <th>Votes</th>
        </tr>
      </thead>
      <tbody>
      <% for (Object[] r : rows) {
           Contester c = (Contester) r[0];
           Long votes = (Long) r[1];
           User u = c != null ? c.getUser() : null;
           String fullName = u != null ? (u.getFirstName() + " " + u.getLastName()).trim() : "(no user)";
           String pos = c != null && c.getPosition() != null ? c.getPosition().name().replace('_', ' ') : "—";
      %>
        <tr>
          <td class="font-semibold text-slate-900"><%= fullName %></td>
          <td><%= pos %></td>
          <td><span class="admin-badge verified"><%= votes != null ? votes : 0 %></span></td>
        </tr>
      <% }
         if (rows.isEmpty()) { %>
        <tr>
          <td colspan="3">
            <div class="admin-empty">
              <div class="admin-empty-illustration">▤</div>
              No approved candidates are available yet.
            </div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
