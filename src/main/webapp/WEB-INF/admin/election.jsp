<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.bascode.model.entity.ElectionSettings,com.bascode.model.entity.PositionElection,com.bascode.model.enums.Position,java.time.LocalDateTime,java.time.ZoneId,java.time.format.DateTimeFormatter,java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Election Settings</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  ElectionSettings s = (ElectionSettings) request.getAttribute("settings");
  if (s == null) s = new ElectionSettings();
  List<PositionElection> positionElections = (List<PositionElection>) request.getAttribute("positionElections");
  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  String err = (String) request.getAttribute("error");
  LocalDateTime serverNow = LocalDateTime.now();
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

  request.setAttribute("adminPageTitle", "Election Settings");
  request.setAttribute("adminPageSubtitle", "Manage global voting controls and position-specific deadlines.");
  request.setAttribute("activeAdminPage", "election");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<% if (err != null && !err.trim().isEmpty()) { %>
  <div class="admin-toast error"><div class="font-semibold"><%= err %></div></div>
<% } %>
<% if (msg != null && !msg.trim().isEmpty()) { %>
  <div class="admin-toast <%= "success".equalsIgnoreCase(type) ? "success" : "error" %>"><div class="font-semibold"><%= msg %></div></div>
<% } %>

<section class="admin-grid grid gap-4">
  <!-- Global Election Settings -->
  <div class="admin-card p-5 rise-in">
    <div class="admin-section-head">
      <div>
        <div class="admin-section-title">Global Voting Control</div>
        <div class="admin-section-note">Master switch affecting all positions system-wide.</div>
      </div>
      <span class="admin-badge <%= s.isVotingOpen() ? "approved" : "denied" %>"><%= s.isVotingOpen() ? "OPEN" : "CLOSED" %></span>
    </div>
    <form method="post" action="<%=request.getContextPath()%>/admin/election" onsubmit="return confirm('Apply these global settings?');" class="space-y-5">
      <label class="flex items-center justify-between rounded-lg border border-slate-200 bg-slate-50 px-4 py-4">
        <div>
          <div class="font-semibold text-slate-900">Enable voting (Global)</div>
          <div class="mt-1 text-sm text-slate-500">When disabled, no new votes can be submitted across all positions.</div>
        </div>
        <span class="relative inline-flex items-center">
          <input type="checkbox" name="votingOpen" class="peer sr-only" <%= s.isVotingOpen() ? "checked" : "" %>>
          <span class="h-7 w-12 rounded-full bg-slate-300 transition peer-checked:bg-emerald-600"></span>
          <span class="absolute left-1 h-5 w-5 rounded-full bg-white transition peer-checked:translate-x-5"></span>
        </span>
      </label>

      <div class="rounded-lg border border-slate-200 bg-white p-4">
        <label class="block text-sm font-semibold text-slate-700">Global voting deadline</label>
        <input type="datetime-local" name="votingClosesAt"
               value="<%= s.getVotingClosesAt() != null ? dtf.format(s.getVotingClosesAt()) : "" %>"
               class="mt-2 w-full rounded-lg border border-slate-200 px-4 py-3 outline-none focus:border-emerald-500 focus:ring-4 focus:ring-emerald-100">
        <div class="mt-2 text-xs text-slate-500">Server time: <%= dtf.format(serverNow) %> (<%= ZoneId.systemDefault().getId() %>)</div>
        <div class="mt-1 text-xs text-slate-400">This affects all positions. Individual position timers override this.</div>
      </div>

      <div class="flex items-center gap-3">
        <button type="submit" class="admin-button px-5 py-3">Save Global Settings</button>
        <a href="<%=request.getContextPath()%>/admin/election" class="admin-button-subtle px-5 py-3">Refresh</a>
      </div>
    </form>
  </div>

  <!-- Per-Position Election Timers -->
  <div class="admin-card p-5 rise-in">
    <div class="admin-section-head">
      <div>
        <div class="admin-section-title">Position-Specific Deadlines</div>
        <div class="admin-section-note">Set individual end times for each contest position.</div>
      </div>
    </div>
    <form method="post" action="<%=request.getContextPath()%>/admin/election?action=positionTimers" onsubmit="return confirm('Update position deadlines?');" class="space-y-4">
      <div class="space-y-3">
        <% if (positionElections != null) {
           for (PositionElection pe : positionElections) {
             String posName = pe != null && pe.getName() != null ? pe.getName().name().replace('_', ' ') : "Unknown";
             String status = pe != null && pe.getStatus() != null ? pe.getStatus().name() : "NOT_STARTED";
             boolean isActive = "ACTIVE".equalsIgnoreCase(status);
             boolean isEnded = "ENDED".equalsIgnoreCase(status);
        %>
          <div class="flex items-center gap-3 rounded-lg border border-slate-200 bg-slate-50 px-4 py-3 <%= isEnded ? "opacity-60" : "" %>">
            <div class="flex-1">
              <div class="font-semibold text-slate-900"><%= posName %></div>
              <div class="text-xs text-slate-500">
                Status: <span class="admin-badge <%= isActive ? "approved" : (isEnded ? "neutral" : "pending") %> text-xs px-2 py-0.5"><%= status %></span>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <input type="hidden" name="position_<%= pe.getName() %>" value="<%= pe.getName() %>">
              <input type="datetime-local" name="endTime_<%= pe.getName() %>"
                     value="<%= pe.getEndTime() != null ? dtf.format(pe.getEndTime()) : "" %>"
                     <%= isEnded ? "disabled" : "" %>
                     class="rounded-lg border border-slate-200 px-3 py-2 text-sm <%= isEnded ? "bg-slate-200" : "bg-white" %>"
                     title="<%= isEnded ? "Election has ended" : "Set when this election should automatically end" %>">
              <% if (pe.getEndTime() != null && !isEnded) {
                   LocalDateTime now = LocalDateTime.now();
                   boolean isPast = now.isAfter(pe.getEndTime());
                   java.time.Duration duration = java.time.Duration.between(now, pe.getEndTime());
                   long hours = Math.abs(duration.toHours());
                   long minutes = Math.abs(duration.toMinutes() % 60);
              %>
                <span class="text-xs <%= isPast ? "text-red-500" : "text-slate-500" %>">
                  <%= isPast ? "Ended" : "Ends in " + hours + "h " + minutes + "m" %>
                </span>
              <% } %>
            </div>
          </div>
        <%   }
           } else { %>
          <div class="admin-empty">
            <div class="admin-empty-illustration">[ ]</div>
            No positions configured yet.
          </div>
        <% } %>
      </div>
      <div class="flex items-center gap-3 pt-2">
        <button type="submit" class="admin-button px-5 py-3">Save Position Deadlines</button>
        <a href="<%=request.getContextPath()%>/admin/election" class="admin-button-subtle px-5 py-3">Refresh</a>
      </div>
    </form>
  </div>

  <!-- Countdown Summary -->
  <div class="admin-card p-5 rise-in">
    <div class="admin-section-head">
      <div>
        <div class="admin-section-title">Countdown Summary</div>
        <div class="admin-section-note">Quick overview of upcoming deadlines.</div>
      </div>
    </div>
    <div class="space-y-3">
      <% if (s.getVotingClosesAt() != null) { %>
        <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
          <div class="text-sm text-slate-500">Global deadline</div>
          <div class="mt-1 text-lg font-bold text-slate-900"><%= s.getVotingClosesAt() %></div>
        </div>
      <% } %>
      <% if (positionElections != null) {
           int activeCount = 0;
           for (PositionElection pe : positionElections) {
             if (pe != null && pe.getEndTime() != null && pe.getStatus() != null && "ACTIVE".equalsIgnoreCase(pe.getStatus().name())) {
               activeCount++;
             }
           }
           if (activeCount > 0) { %>
        <div class="text-sm font-semibold text-slate-700 mt-4">Active Position Deadlines:</div>
        <% for (PositionElection pe : positionElections) {
             if (pe != null && pe.getEndTime() != null && pe.getStatus() != null && "ACTIVE".equalsIgnoreCase(pe.getStatus().name())) {
               String posName = pe.getName() != null ? pe.getName().name().replace('_', ' ') : "Unknown";
        %>
          <div class="flex justify-between items-center rounded-lg border border-slate-200 bg-slate-50 px-4 py-2">
            <span class="text-sm text-slate-700"><%= posName %></span>
            <span class="text-sm font-semibold text-slate-900"><%= pe.getEndTime() %></span>
          </div>
        <%   } // end inner if
           } // end inner for
         } // end outer if (activeCount > 0)
       } // end outer if (positionElections != null) %>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
