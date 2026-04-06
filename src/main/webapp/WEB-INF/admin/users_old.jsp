<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.User,com.bascode.model.enums.Role" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Users</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  @SuppressWarnings("unchecked")
  List<User> users = (List<User>) request.getAttribute("users");
  if (users == null) users = Collections.emptyList();
  @SuppressWarnings("unchecked")
  Set<Long> approvedContesterUserIds = (Set<Long>) request.getAttribute("approvedContesterUserIds");
  if (approvedContesterUserIds == null) approvedContesterUserIds = Collections.emptySet();

  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  String selectedRole = (String) request.getAttribute("selectedRole");
  String selectedVerified = (String) request.getAttribute("selectedVerified");
  String searchQuery = (String) request.getAttribute("searchQuery");
  Integer pageObj = (Integer) request.getAttribute("page");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Long totalCountObj = (Long) request.getAttribute("totalCount");
  int currentPage = pageObj != null ? pageObj : 1;
  int totalPages = totalPagesObj != null ? totalPagesObj : 1;
  long totalCount = totalCountObj != null ? totalCountObj : 0L;
  if (selectedRole == null) selectedRole = "";
  if (selectedVerified == null) selectedVerified = "";
  if (searchQuery == null) searchQuery = "";

  Long currentUserId = null;
  Object currentUserIdObj = session != null ? session.getAttribute("userId") : null;
  if (currentUserIdObj instanceof Long) currentUserId = (Long) currentUserIdObj;
  else if (currentUserIdObj instanceof Integer) currentUserId = ((Integer) currentUserIdObj).longValue();
  else if (currentUserIdObj instanceof String) {
    try { currentUserId = Long.valueOf((String) currentUserIdObj); } catch (Exception ignored) { }
  }

  StringBuilder pageBase = new StringBuilder(request.getContextPath()).append("/admin/users?");
  if (!selectedRole.isEmpty()) pageBase.append("role=").append(selectedRole).append("&");
  if (!selectedVerified.isEmpty()) pageBase.append("verified=").append(selectedVerified).append("&");
  if (!searchQuery.isEmpty()) pageBase.append("q=").append(java.net.URLEncoder.encode(searchQuery, "UTF-8")).append("&");

  request.setAttribute("adminPageTitle", "Users");
  request.setAttribute("adminPageSubtitle", "Compact account management with verification, role, and account status controls.");
  request.setAttribute("activeAdminPage", "users");
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
      <div class="admin-section-title">Filter Users</div>
      <div class="admin-section-note">Search by name or email, then narrow by role and verification.</div>
    </div>
  </div>
  <form method="get" action="<%=request.getContextPath()%>/admin/users" class="admin-filter-bar">
    <div class="admin-search">
      <span class="text-slate-400">⌕</span>
      <input type="search" name="q" value="<%= searchQuery %>" placeholder="Search users by name or email">
    </div>
    <select name="role" class="admin-select">
      <option value="" <%= selectedRole.isEmpty() ? "selected" : "" %>>All roles</option>
      <% for (Role r : Role.values()) { String v = r.name(); %>
        <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedRole) ? "selected" : "" %>><%= v %></option>
      <% } %>
    </select>
    <select name="verified" class="admin-select">
      <option value="" <%= selectedVerified.isEmpty() ? "selected" : "" %>>Any verification</option>
      <option value="true" <%= "true".equalsIgnoreCase(selectedVerified) ? "selected" : "" %>>Verified</option>
      <option value="false" <%= "false".equalsIgnoreCase(selectedVerified) ? "selected" : "" %>>Not verified</option>
    </select>
    <button type="submit" class="admin-button px-4 py-2">Apply</button>
    <a href="<%=request.getContextPath()%>/admin/users" class="admin-link-muted">Reset</a>
  </form>
  <div class="mt-4 flex flex-wrap gap-2">
    <% if (!selectedRole.isEmpty()) { %><span class="admin-pill"><%= selectedRole %></span><% } %>
    <% if (!selectedVerified.isEmpty()) { %><span class="admin-pill"><%= "true".equalsIgnoreCase(selectedVerified) ? "Verified" : "Not verified" %></span><% } %>
    <% if (!searchQuery.isEmpty()) { %><span class="admin-pill">Search: <%= searchQuery %></span><% } %>
  </div>
</section>

<section class="admin-card p-0 mt-4 rise-in">
  <div class="admin-section-head px-5 pt-5">
    <div>
      <div class="admin-section-title">User Directory</div>
      <div class="admin-section-note"><%= totalCount %> matched account(s), page <%= currentPage %> of <%= totalPages %>.</div>
    </div>
  </div>
  <div class="admin-table-wrap">
    <table class="admin-table" id="usersTable">
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>Verified</th>
          <th>Account</th>
          <th>Location</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        for (User u : users) {
          String fullName = (u.getFirstName() + " " + u.getLastName()).trim();
          String email = u.getEmail() != null ? u.getEmail() : "";
          String storedRole = u.getRole() != null ? u.getRole().name() : "";
          String role = approvedContesterUserIds.contains(u.getId()) ? "CONTESTER" : storedRole;
          boolean verified = u.isEmailVerified();
          boolean suspended = u.isSuspended();
          boolean self = currentUserId != null && currentUserId.equals(u.getId());
          String location = ((u.getState() != null ? u.getState() : "") + (u.getCountry() != null ? ", " + u.getCountry() : "")).replaceAll("^,\\s*", "");
      %>
        <tr data-row-search="<%= (fullName + " " + email + " " + role + " " + location).toLowerCase() %>">
          <td class="font-semibold text-slate-900"><%= fullName.isEmpty() ? "(unnamed)" : fullName %></td>
          <td title="<%= email %>"><span class="inline-block max-w-[18rem] truncate align-bottom"><%= email %></span></td>
          <td><span class="admin-badge <%= "ADMIN".equals(role) ? "verified" : ("CONTESTER".equals(role) ? "approved" : "neutral") %>"><%= role %></span></td>
          <td><span class="admin-badge <%= verified ? "verified" : "denied" %>"><%= verified ? "VERIFIED" : "NOT VERIFIED" %></span></td>
          <td><span class="admin-badge <%= suspended ? "pending" : "approved" %>"><%= suspended ? "SUSPENDED" : "ACTIVE" %></span></td>
          <td><%= location.isEmpty() ? "—" : location %></td>
<td>
  <div class="flex items-center gap-2">
    <% if (self) { %>
      <span class="text-xs text-slate-500">Current session</span>
    <% } else { 
         String userRole = storedRole;
         if ("SUPER_ADMIN".equalsIgnoreCase(userRole)) { %>
           <span class="text-xs text-red-500">Cannot delete SUPER_ADMIN</span>
         <% } else { %>
           <form method="post" action="<%=request.getContextPath()%>/admin/users/action">
             <input type="hidden" name="userId" value="<%= u.getId() %>">
             <input type="hidden" name="action" value="<%= suspended ? "activate" : "suspend" %>">
             <button type="submit" class="admin-icon-button" 
                     title="<%= suspended ? "Reactivate user" : "Suspend user" %>">
               <%= suspended ? "↺" : "⏸" %>
             </button>
           </form>
           <form method="post" action="<%=request.getContextPath()%>/admin/users/action" 
                 onsubmit="return confirm('Delete <%= fullName %>? This removes related votes, contester data, and support records.');">
             <input type="hidden" name="userId" value="<%= u.getId() %>">
             <input type="hidden" name="action" value="delete">
             <button type="submit" class="admin-icon-button danger" title="Delete user">🗑</button>
           </form>
         <% } 
       } %>
  </div>
</td>
        </tr>
      <%
        }
        if (users.isEmpty()) {
      %>
        <tr>
          <td colspan="7">
            <div class="admin-empty">
              <div class="admin-empty-illustration">⌕</div>
              No users found for the selected filters.
            </div>
          </td>
        </tr>
      <%
        }
      %>
      </tbody>
    </table>
  </div>
  <div class="flex items-center justify-between px-5 py-4 border-t border-slate-200">
    <div class="text-sm text-slate-500">Showing <%= users.size() %> row(s) on this page.</div>
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
