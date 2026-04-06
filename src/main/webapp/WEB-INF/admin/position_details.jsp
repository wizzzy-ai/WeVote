<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User,com.bascode.model.entity.PositionElection,com.bascode.model.enums.ContesterStatus,com.bascode.model.enums.Position" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Position Details</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">

<%
  Position pos = (Position) request.getAttribute("position");
  PositionElection pe = (PositionElection) request.getAttribute("positionElection");
  @SuppressWarnings("unchecked")
  List<Object[]> rows = (List<Object[]>) request.getAttribute("rows");
  if (rows == null) rows = Collections.emptyList();
  long totalVotes = request.getAttribute("totalVotes") != null ? (Long) request.getAttribute("totalVotes") : 0L;

  String pname = pos != null ? pos.name().replace('_',' ') : "Position";
  request.setAttribute("adminPageTitle", "Position Details");
  request.setAttribute("adminPageSubtitle", pname + " status, vote totals, and contesters.");
  request.setAttribute("activeAdminPage", "dashboard");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>
<div class="mb-4 flex justify-end">
  <a href="<%=request.getContextPath()%>/admin/contesters" class="admin-button-subtle px-4 py-2">Back to Contesters</a>
</div>
  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex flex-wrap items-center justify-between gap-4">
      <div>
        <div class="text-xs font-bold tracking-widest text-gray-500">STATUS</div>
        <div class="mt-1 text-lg font-bold text-gray-900"><%= pe != null && pe.getStatus() != null ? pe.getStatus().name() : "NOT_STARTED" %></div>
      </div>
      <div class="flex items-center gap-3">
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= pe != null && pe.isVotingOpen() ? "text-green-800" : "text-red-800" %>"
              style="background-image:<%= pe != null && pe.isVotingOpen() ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))" : "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))" %>;">
          <%= pe != null && pe.isVotingOpen() ? "VOTING OPEN" : "VOTING CLOSED" %>
        </span>
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-gray-800"
              style="background-image:linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9));">
          Total votes: <%= totalVotes %>
        </span>
      </div>
    </div>
  </section>

  <section class="mt-6 rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.05s;">
    <div class="flex items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Contesters</h2>
        <p class="text-sm text-gray-600"><%= rows.size() %> record(s)</p>
      </div>
    </div>
    <div class="mt-5 overflow-x-auto">
      <table class="admin-table w-full text-sm">
        <thead>
          <tr class="text-left text-gray-600">
            <th class="py-3 pr-4">Name</th>
            <th class="py-3 pr-4">Email</th>
            <th class="py-3 pr-4">Status</th>
            <th class="py-3 pr-4">Votes</th>
            <th class="py-3 pr-4">Winner</th>
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
            String fullName = u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)";
            String email = u != null ? u.getEmail() : "";
            ContesterStatus st = c != null ? c.getStatus() : null;
            boolean winner = c != null && c.isWinner();
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay: <%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 font-semibold text-gray-900"><%= fullName %></td>
            <td class="py-4 pr-4 text-gray-700"><%= email %></td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold
                <%= st == ContesterStatus.APPROVED ? "text-green-800" : (st == ContesterStatus.PENDING ? "text-amber-800" : "text-red-800") %>"
                style="background-image:<%= st == ContesterStatus.APPROVED
                    ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                    : (st == ContesterStatus.PENDING
                        ? "linear-gradient(135deg, rgba(253,230,138,.85), rgba(254,215,170,.85))"
                        : "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))") %>;">
                <%= st != null ? st.name() : "" %>
              </span>
            </td>
            <td class="py-4 pr-4">
              <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                    style="background: linear-gradient(135deg, var(--purple), var(--green));">
                <%= votes != null ? votes : 0 %>
              </span>
            </td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold
                <%= winner ? "text-green-800" : "text-gray-600" %>"
                style="background-image:<%= winner
                    ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                    : "linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9))" %>;">
                <%= winner ? "WINNER" : "—" %>
              </span>
            </td>
          </tr>
        <%
          }
          if (rows.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="5" class="py-8 text-center text-gray-600">No contesters found for this position.</td>
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
