<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.AdminAuditLog,com.bascode.model.entity.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Dashboard</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  long totalUsers = request.getAttribute("totalUsers") != null ? (Long) request.getAttribute("totalUsers") : 0L;
  long totalVoters = request.getAttribute("totalVoters") != null ? (Long) request.getAttribute("totalVoters") : 0L;
  long totalAdmins = request.getAttribute("totalAdmins") != null ? (Long) request.getAttribute("totalAdmins") : 0L;
  long totalContesterUsers = request.getAttribute("totalContesterUsers") != null ? (Long) request.getAttribute("totalContesterUsers") : 0L;
  long contesterApps = request.getAttribute("contesterApps") != null ? (Long) request.getAttribute("contesterApps") : 0L;
  long pendingApps = request.getAttribute("pendingApps") != null ? (Long) request.getAttribute("pendingApps") : 0L;
  long approvedApps = request.getAttribute("approvedApps") != null ? (Long) request.getAttribute("approvedApps") : 0L;
  long deniedApps = request.getAttribute("deniedApps") != null ? (Long) request.getAttribute("deniedApps") : 0L;
  long totalVotes = request.getAttribute("totalVotes") != null ? (Long) request.getAttribute("totalVotes") : 0L;

  @SuppressWarnings("unchecked")
  List<AdminAuditLog> recentActivity = (List<AdminAuditLog>) request.getAttribute("recentActivity");
  if (recentActivity == null) recentActivity = Collections.emptyList();
  @SuppressWarnings("unchecked")
  List<com.bascode.model.entity.PositionElection> positions = (List<com.bascode.model.entity.PositionElection>) request.getAttribute("positions");
  if (positions == null) positions = Collections.emptyList();
  @SuppressWarnings("unchecked")
  Map<com.bascode.model.enums.Position, Long> approvedCounts = (Map<com.bascode.model.enums.Position, Long>) request.getAttribute("approvedCounts");
  if (approvedCounts == null) approvedCounts = Collections.emptyMap();

  String msg = request.getParameter("msg");
  String type = request.getParameter("type");

  request.setAttribute("adminPageTitle", "Admin Dashboard");
  request.setAttribute("adminPageSubtitle", "Election health, approvals, and recent admin activity in one place.");
  request.setAttribute("activeAdminPage", "dashboard");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<% if (msg != null && !msg.trim().isEmpty()) { %>
  <div class="admin-toast <%= "success".equalsIgnoreCase(type) ? "success" : "error" %>">
    <div class="font-semibold"><%= msg %></div>
  </div>
<% } %>

<section class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
  <div class="admin-card p-5 rise-in">
    <div class="text-4xl font-black text-slate-900"><%= totalUsers %></div>
    <div class="mt-2 text-sm text-slate-500">Total users</div>
    <div class="mt-4 grid grid-cols-3 gap-2 text-xs">
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-3"><div class="text-slate-500">Voters</div><div class="mt-1 text-lg font-bold text-slate-900"><%= totalVoters %></div></div>
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-3"><div class="text-slate-500">Contesters</div><div class="mt-1 text-lg font-bold text-slate-900"><%= totalContesterUsers %></div></div>
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-3"><div class="text-slate-500">Admins</div><div class="mt-1 text-lg font-bold text-slate-900"><%= totalAdmins %></div></div>
    </div>
  </div>
  <div class="admin-card p-5 rise-in">
    <div class="text-4xl font-black text-slate-900"><%= contesterApps %></div>
    <div class="mt-2 text-sm text-slate-500">Contester applications</div>
    <div class="mt-4 flex flex-wrap gap-2">
      <span class="admin-badge pending">Pending: <%= pendingApps %></span>
      <span class="admin-badge approved">Approved: <%= approvedApps %></span>
      <span class="admin-badge denied">Denied: <%= deniedApps %></span>
    </div>
  </div>
  <div class="admin-card p-5 rise-in">
    <div class="text-4xl font-black text-slate-900"><%= totalVotes %></div>
    <div class="mt-2 text-sm text-slate-500">Votes recorded</div>
  </div>
  <div class="admin-card p-5 rise-in">
    <div class="admin-section-title">Quick Actions</div>
    <div class="mt-4 grid grid-cols-2 gap-2 text-sm">
      <a href="<%=request.getContextPath()%>/admin/contesters" class="admin-button-subtle px-3 py-3">Review contesters</a>
      <a href="<%=request.getContextPath()%>/admin/users" class="admin-button-subtle px-3 py-3">Manage users</a>
      <a href="<%=request.getContextPath()%>/admin/messages" class="admin-button-subtle px-3 py-3">Open inbox</a>
      <a href="<%=request.getContextPath()%>/admin/election" class="admin-button-subtle px-3 py-3">Election settings</a>
    </div>
  </div>
</section>

<section class="admin-card p-0 mt-4 rise-in">
  <div class="admin-section-head px-5 pt-5">
    <div>
      <div class="admin-section-title">Manage Contest Positions</div>
      <div class="admin-section-note">Track election state and approved-candidate capacity for each office.</div>
    </div>
  </div>
  <div class="admin-table-wrap">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Position</th>
          <th>Status</th>
          <th>Approved</th>
          <th>Voting</th>
          <th>Time Remaining</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <% for (com.bascode.model.entity.PositionElection p : positions) {
           String pname = p.getName() != null ? p.getName().name().replace('_', ' ') : "";
           String status = p.getStatus() != null ? p.getStatus().name() : "NOT_STARTED";
           boolean active = "ACTIVE".equalsIgnoreCase(status);
           boolean ended = "ENDED".equalsIgnoreCase(status);
           long approved = approvedCounts.get(p.getName()) != null ? approvedCounts.get(p.getName()) : 0L;
      %>
        <tr>
          <td class="font-semibold text-slate-900"><%= pname %></td>
          <td><span class="admin-badge <%= active ? "approved" : (ended ? "neutral" : "pending") %>"><%= status.replace('_', ' ') %></span></td>
          <td><span class="admin-badge verified"><%= approved %>/3</span></td>
          <td><span class="admin-badge <%= p.isVotingOpen() ? "approved" : (ended ? "neutral" : "denied") %>"><%= p.isVotingOpen() ? "OPEN" : (ended ? "ENDED" : "CLOSED") %></span></td>
          <td>
            <% if (p.getEndTime() != null && active) { 
                 java.time.LocalDateTime now = java.time.LocalDateTime.now();
                 java.time.Duration duration = java.time.Duration.between(now, p.getEndTime());
                 boolean isPast = duration.isNegative();
                 long hours = Math.abs(duration.toHours());
                 long minutes = Math.abs(duration.toMinutes() % 60);
            %>
              <span class="admin-badge <%= isPast ? "denied" : "pending" %> text-xs">
                <%= isPast ? "Ended" : "Ends in: " + hours + "h " + minutes + "m" %>
              </span>
              <div class="text-xs text-slate-500 mt-1"><%= p.getEndTime().toLocalDate() %></div>
            <% } else if (ended) { %>
              <span class="admin-badge neutral text-xs">Completed</span>
            <% } else { %>
              <span class="text-xs text-slate-400">-</span>
            <% } %>
          </td>
          <td>
            <div class="flex flex-wrap gap-2">
              <% if ("NOT_STARTED".equalsIgnoreCase(status)) { %>
                <form method="post" action="<%=request.getContextPath()%>/admin/start-election" onsubmit="return confirm('Start election for <%= pname %>?');" class="inline">
                  <input type="hidden" name="position" value="<%= p.getName() %>">
                  <button type="submit" class="admin-button px-3 py-2">Start</button>
                </form>
              <% } %>
              <% if (ended) { %>
                <form method="post" action="<%=request.getContextPath()%>/admin/start-election" onsubmit="return confirm('Restart election for <%= pname %>? This will clear previous results and require at least 2 approved contesters.');" class="inline">
                  <input type="hidden" name="position" value="<%= p.getName() %>">
                  <button type="submit" class="admin-button px-3 py-2">Restart</button>
                </form>
              <% } %>
              <% if (active) { %>
                <form method="post" action="<%=request.getContextPath()%>/admin/end-election" onsubmit="return confirm('End election for <%= pname %>? This action cannot be undone.');">
                  <input type="hidden" name="position" value="<%= p.getName() %>">
                  <button type="submit" class="admin-button-danger px-3 py-2">End</button>
                </form>
              <% } %>
              <a href="<%=request.getContextPath()%>/admin/position-details?position=<%= p.getName() %>" class="admin-button-subtle px-3 py-2">Inspect</a>
            </div>
          </td>
        </tr>
      <% }
         if (positions.isEmpty()) { %>
        <tr>
          <td colspan="5">
            <div class="admin-empty">
              <div class="admin-empty-illustration">◌</div>
              No contest positions configured yet.
            </div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</section>

<section class="admin-card p-5 mt-4 rise-in">
  <div class="admin-section-head">
    <div>
      <div class="admin-section-title">Recent Activity</div>
      <div class="admin-section-note">Latest admin-side changes with relative timestamps.</div>
    </div>
    <a href="<%=request.getContextPath()%>/admin/audit" class="admin-button-subtle px-4 py-2">View full log</a>
  </div>
  <div class="space-y-3">
    <% for (AdminAuditLog l : recentActivity) {
         User au = l.getAdminUser();
         String actorName = au != null ? (au.getFirstName() + " " + au.getLastName()).trim() : "(unknown)";
         String action = l.getActionType() != null ? l.getActionType().name().replace('_', ' ') : "ACTION";
    %>
      <div class="rounded-lg border border-slate-200 bg-white px-4 py-3">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <div class="text-sm font-bold text-slate-900"><%= action %></div>
            <div class="mt-1 text-sm text-slate-600"><%= actorName %> • <%= l.getMessage() != null ? l.getMessage() : "" %></div>
          </div>
          <div class="shrink-0 text-xs text-slate-500" data-relative-time="<%= l.getCreatedAt() != null ? l.getCreatedAt().toString() : "" %>"><%= l.getCreatedAt() %></div>
        </div>
      </div>
    <% }
       if (recentActivity.isEmpty()) { %>
      <div class="admin-empty">
        <div class="admin-empty-illustration">⏱</div>
        No activity recorded yet.
      </div>
    <% } %>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
