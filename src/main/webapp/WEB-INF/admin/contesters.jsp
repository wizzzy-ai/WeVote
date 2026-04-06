<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User,com.bascode.model.enums.ContesterStatus,com.bascode.model.enums.Position" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Contesters</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  @SuppressWarnings("unchecked")
  List<Contester> contesters = (List<Contester>) request.getAttribute("contesters");
  if (contesters == null) contesters = Collections.emptyList();

  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  String selectedStatus = (String) request.getAttribute("selectedStatus");
  String selectedPosition = (String) request.getAttribute("selectedPosition");
  String searchQuery = (String) request.getAttribute("searchQuery");
  Integer pageObj = (Integer) request.getAttribute("page");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Long totalCountObj = (Long) request.getAttribute("totalCount");
  int currentPage = pageObj != null ? pageObj : 1;
  int totalPages = totalPagesObj != null ? totalPagesObj : 1;
  long totalCount = totalCountObj != null ? totalCountObj : 0L;
  if (selectedStatus == null) selectedStatus = "";
  if (selectedPosition == null) selectedPosition = "";
  if (searchQuery == null) searchQuery = "";

  StringBuilder pageBase = new StringBuilder(request.getContextPath()).append("/admin/contesters?");
  if (!selectedStatus.isEmpty()) pageBase.append("status=").append(selectedStatus).append("&");
  if (!selectedPosition.isEmpty()) pageBase.append("position=").append(selectedPosition).append("&");
  if (!searchQuery.isEmpty()) pageBase.append("q=").append(java.net.URLEncoder.encode(searchQuery, "UTF-8")).append("&");

  request.setAttribute("adminPageTitle", "Contesters");
  request.setAttribute("adminPageSubtitle", "Approve or deny contesters and monitor position capacity.");
  request.setAttribute("activeAdminPage", "contesters");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<% if (msg != null && !msg.trim().isEmpty()) { %>
  <div class="admin-toast <%= "success".equalsIgnoreCase(type) ? "success" : "error" %>">
    <div class="font-semibold"><%= msg %></div>
  </div>
<% } %>

<section class="admin-card p-5 rise-in">
  <div class="admin-section-head">
    <div>
      <div class="admin-section-title">Filter Contesters</div>
      <div class="admin-section-note">Search by candidate name or email, then narrow by status and position.</div>
    </div>
  </div>
  <form method="get" action="<%=request.getContextPath()%>/admin/contesters" class="admin-filter-bar">
    <div class="admin-search">
      <span class="text-slate-400">⌕</span>
      <input type="search" name="q" value="<%= searchQuery %>" placeholder="Search contesters">
    </div>
    <select name="status" class="admin-select">
      <option value="" <%= selectedStatus.isEmpty() ? "selected" : "" %>>All statuses</option>
      <% for (ContesterStatus s : ContesterStatus.values()) { String v = s.name(); %>
        <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedStatus) ? "selected" : "" %>><%= v %></option>
      <% } %>
    </select>
    <select name="position" class="admin-select">
      <option value="" <%= selectedPosition.isEmpty() ? "selected" : "" %>>All positions</option>
      <% for (Position p : Position.values()) { String v = p.name(); %>
        <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedPosition) ? "selected" : "" %>><%= v.replace('_', ' ') %></option>
      <% } %>
    </select>
    <button type="submit" class="admin-button px-4 py-2">Apply</button>
    <a href="<%=request.getContextPath()%>/admin/contesters" class="admin-link-muted">Reset</a>
  </form>
</section>

<section class="admin-card p-0 mt-4 rise-in">
  <div class="admin-section-head px-5 pt-5">
    <div>
      <div class="admin-section-title">Contester Queue</div>
      <div class="admin-section-note"><%= totalCount %> matched application(s), page <%= currentPage %> of <%= totalPages %>.</div>
    </div>
  </div>
  <div class="admin-table-wrap">
    <table class="admin-table">
      <thead>
        <tr>
          <th>Candidate</th>
          <th>Email</th>
          <th>Position</th>
          <th>Status</th>
          <th>Manifesto</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        for (Contester c : contesters) {
          User u = c.getUser();
          String fullName = u != null ? (u.getFirstName() + " " + u.getLastName()).trim() : "(no user)";
          String email = u != null && u.getEmail() != null ? u.getEmail() : "";
          String pos = c.getPosition() != null ? c.getPosition().name().replace('_', ' ') : "—";
          ContesterStatus st = c.getStatus();
          String manifesto = c.getManifesto();
      %>
        <tr>
          <td class="font-semibold text-slate-900"><%= fullName %></td>
          <td title="<%= email %>"><span class="inline-block max-w-[16rem] truncate align-bottom"><%= email %></span></td>
          <td><%= pos %></td>
          <td><span class="admin-badge <%= st == ContesterStatus.APPROVED ? "approved" : (st == ContesterStatus.DENIED ? "denied" : "pending") %>"><%= st != null ? st.name() : "PENDING" %></span></td>
          <td class="max-w-xs">
            <% if (manifesto != null && !manifesto.trim().isEmpty()) { %>
              <details>
                <summary class="cursor-pointer text-sm font-semibold text-emerald-700">View manifesto</summary>
                <div class="mt-2 whitespace-pre-wrap text-sm text-slate-600"><%= manifesto %></div>
              </details>
            <% } else { %>
              <span class="text-sm text-slate-400">Not submitted</span>
            <% } %>
          </td>
          <td>
            <div class="flex items-center gap-2">
              <form method="post" action="<%=request.getContextPath()%>/admin/contesters/status">
                <input type="hidden" name="contesterId" value="<%= c.getId() %>">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="admin-icon-button" title="Approve contester" <%= st == ContesterStatus.APPROVED ? "disabled" : "" %>>✓</button>
              </form>
              <form method="post" action="<%=request.getContextPath()%>/admin/contesters/status" onsubmit="return confirm('Deny <%= fullName %>?');">
                <input type="hidden" name="contesterId" value="<%= c.getId() %>">
                <input type="hidden" name="action" value="deny">
                <input type="hidden" name="reason" value="Denied by admin review">
                <button type="submit" class="admin-icon-button danger" title="Deny contester" <%= st == ContesterStatus.DENIED ? "disabled" : "" %>>✕</button>
              </form>
            </div>
          </td>
        </tr>
      <%
        }
        if (contesters.isEmpty()) {
      %>
        <tr>
          <td colspan="6">
            <div class="admin-empty">
              <div class="admin-empty-illustration">🗳</div>
              No contester applications found for the selected filters.
            </div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
  </div>
  <div class="flex items-center justify-between px-5 py-4 border-t border-slate-200">
    <div class="text-sm text-slate-500">Showing <%= contesters.size() %> row(s) on this page.</div>
    <div class="flex items-center gap-2">
      <a href="<%= currentPage > 1 ? pageBase.toString() + "page=" + (currentPage - 1) : "#" %>" class="admin-button-subtle px-3 py-2 <%= currentPage <= 1 ? "pointer-events-none opacity-40" : "" %>">Previous</a>
      <span class="text-sm font-semibold text-slate-700"><%= currentPage %> / <%= totalPages %></span>
      <a href="<%= currentPage < totalPages ? pageBase.toString() + "page=" + (currentPage + 1) : "#" %>" class="admin-button-subtle px-3 py-2 <%= currentPage >= totalPages ? "pointer-events-none opacity-40" : "" %>">Next</a>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
