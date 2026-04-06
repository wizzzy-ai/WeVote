<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.AdminAuditLog,com.bascode.model.entity.User,com.bascode.model.enums.AdminActionType" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Activity Log</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  @SuppressWarnings("unchecked")
  List<AdminAuditLog> logs = (List<AdminAuditLog>) request.getAttribute("logs");
  if (logs == null) logs = Collections.emptyList();
  String selectedAction = (String) request.getAttribute("selectedAction");
  if (selectedAction == null) selectedAction = "";

  request.setAttribute("adminPageTitle", "Activity Log");
  request.setAttribute("adminPageSubtitle", "Audit trail of account actions, election changes, and moderation activity.");
  request.setAttribute("activeAdminPage", "activity");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<section class="admin-card p-5 rise-in">
  <div class="admin-section-head">
    <div>
      <div class="admin-section-title">Filter Activity</div>
      <div class="admin-section-note">Quickly narrow the log by action type.</div>
    </div>
  </div>
  <form method="get" action="<%=request.getContextPath()%>/admin/audit" class="admin-filter-bar">
    <select name="action" class="admin-select">
      <option value="" <%= selectedAction.isEmpty() ? "selected" : "" %>>All actions</option>
      <% for (AdminActionType t : AdminActionType.values()) { String v = t.name(); %>
        <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedAction) ? "selected" : "" %>><%= v.replace('_', ' ') %></option>
      <% } %>
    </select>
    <button type="submit" class="admin-button px-4 py-2">Apply</button>
    <a href="<%=request.getContextPath()%>/admin/audit" class="admin-link-muted">Reset</a>
  </form>
</section>

<section class="admin-card p-5 mt-4 rise-in">
  <div class="admin-section-head">
    <div>
      <div class="admin-section-title">Recent Actions</div>
      <div class="admin-section-note"><%= logs.size() %> event(s) loaded.</div>
    </div>
  </div>
  <div class="space-y-3">
    <%
      for (AdminAuditLog l : logs) {
        User au = l.getAdminUser();
        String actorName = au != null ? (au.getFirstName() + " " + au.getLastName()).trim() : "(unknown)";
        String action = l.getActionType() != null ? l.getActionType().name().replace('_', ' ') : "ACTION";
        String icon = action.contains("USER") ? "👤" : (action.contains("ELECTION") ? "🗳" : "📝");
        String target = (l.getTargetType() != null ? l.getTargetType() : "Target") + "#" + (l.getTargetId() != null ? l.getTargetId() : "");
    %>
      <div class="rounded-lg border border-slate-200 bg-white px-4 py-3">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <div class="text-sm font-bold text-slate-900"><span class="mr-2"><%= icon %></span><%= action %></div>
            <div class="mt-1 text-sm text-slate-600"><%= actorName %> • <%= target %></div>
            <% if (l.getMessage() != null && !l.getMessage().trim().isEmpty()) { %>
              <div class="mt-2 text-sm text-slate-500"><%= l.getMessage() %></div>
            <% } %>
            <% if (l.getIpAddress() != null && !l.getIpAddress().trim().isEmpty()) { %>
              <div class="mt-2 text-xs text-slate-400">IP: <%= l.getIpAddress() %></div>
            <% } %>
          </div>
          <div class="shrink-0 text-xs text-slate-500" data-relative-time="<%= l.getCreatedAt() != null ? l.getCreatedAt().toString() : "" %>"><%= l.getCreatedAt() %></div>
        </div>
      </div>
    <% }
       if (logs.isEmpty()) { %>
      <div class="admin-empty">
        <div class="admin-empty-illustration">⏱</div>
        No activity has been recorded yet.
      </div>
    <% } %>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
