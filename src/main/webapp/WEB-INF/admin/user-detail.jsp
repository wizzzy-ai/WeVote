<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.bascode.model.entity.User, com.bascode.model.enums.Role" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - User Details</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  User user = (User) request.getAttribute("user");
  Boolean hasApprovedContesterObj = (Boolean) request.getAttribute("hasApprovedContester");
  boolean hasApprovedContester = hasApprovedContesterObj != null ? hasApprovedContesterObj : false;
  
  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  
  Long currentUserId = null;
  Object currentUserIdObj = session != null ? session.getAttribute("userId") : null;
  if (currentUserIdObj instanceof Long) currentUserId = (Long) currentUserIdObj;
  else if (currentUserIdObj instanceof Integer) currentUserId = ((Integer) currentUserIdObj).longValue();
  else if (currentUserIdObj instanceof String) {
    try { currentUserId = Long.valueOf((String) currentUserIdObj); } catch (Exception ignored) { }
  }
  
  boolean self = currentUserId != null && currentUserId.equals(user.getId());
  
  String fullName = (user.getFirstName() + " " + user.getLastName()).trim();
  String email = user.getEmail() != null ? user.getEmail() : "";
  String role = user.getRole() != null ? user.getRole().name() : "";
  if (hasApprovedContester) role = "CONTESTER";
  
  request.setAttribute("adminPageTitle", "User Details");
  request.setAttribute("adminPageSubtitle", "Detailed information about " + fullName);
  request.setAttribute("activeAdminPage", "users");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf"%>

<div class="admin-section">
  <% if (msg != null && !msg.isEmpty()) { %>
    <div class="admin-toast <%= "error".equals(type) ? "error" : "success" %>">
      <div class="font-semibold"><%= msg %></div>
    </div>
  <% } %>
  
  <!-- User Information Card -->
  <div class="admin-card p-5 rise-in mb-4">
    <div class="admin-section-head mb-4">
      <div>
        <div class="admin-section-title">User Information</div>
        <div class="admin-section-note">Basic account details and status</div>
      </div>
      <a href="<%=request.getContextPath()%>/admin/users" class="admin-button-subtle px-4 py-2">← Back to Users</a>
    </div>
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Basic Information -->
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
        <h4 class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">Basic Information</h4>
        <div class="space-y-2">
        
        <div class="detail-row">
          <span class="detail-label">Full Name</span>
          <span class="detail-value font-medium"><%= fullName.isEmpty() ? "(unnamed)" : fullName %></span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">Email</span>
          <span class="detail-value"><%= email %></span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">Birth Year</span>
          <span class="detail-value"><%= user.getBirthYear() > 0 ? user.getBirthYear() : "(not set)" %></span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">Location</span>
          <span class="detail-value">
            <%= ((user.getState() != null ? user.getState() : "") + (user.getCountry() != null ? ", " + user.getCountry() : "")).replaceAll("^,\\s*", "").isEmpty() ? "—" : ((user.getState() != null ? user.getState() : "") + (user.getCountry() != null ? ", " + user.getCountry() : "")).replaceAll("^,\\s*", "") %>
          </span>
        </div>
        </div>
      </div>
      
      <!-- Account Status -->
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
        <h4 class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">Account Status</h4>
        <div class="space-y-2">
        
        <div class="detail-row">
          <span class="detail-label">Role</span>
          <span class="admin-badge <%= "ADMIN".equals(role) ? "verified" : ("CONTESTER".equals(role) ? "approved" : "neutral") %>"><%= role %></span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">Email Verified</span>
          <span class="admin-badge <%= user.isEmailVerified() ? "verified" : "denied" %>">
            <%= user.isEmailVerified() ? "VERIFIED" : "NOT VERIFIED" %>
          </span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">Account Status</span>
          <span class="admin-badge <%= user.isSuspended() ? "pending" : "approved" %>">
            <%= user.isSuspended() ? "SUSPENDED" : "ACTIVE" %>
          </span>
        </div>
        
        <div class="detail-row">
          <span class="detail-label">User ID</span>
          <span class="detail-value text-slate-500">#<%= user.getId() %></span>
        </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Account Actions Card -->
  <% if (!self) { %>
    <div class="admin-card p-5 rise-in">
      <div class="admin-section-head mb-4">
        <div>
          <div class="admin-section-title">Account Actions</div>
          <div class="admin-section-note">Manage user account status</div>
        </div>
      </div>
      
      <div class="flex flex-wrap gap-3">
        <% 
           String userRole = user.getRole() != null ? user.getRole().name() : "";
           if (!"SUPER_ADMIN".equalsIgnoreCase(userRole)) { 
        %>
          <form method="post" action="<%=request.getContextPath()%>/admin/users/action" class="inline">
            <input type="hidden" name="userId" value="<%= user.getId() %>">
            <input type="hidden" name="action" value="<%= user.isSuspended() ? "activate" : "suspend" %>">
            <button type="submit" class="admin-button <%= user.isSuspended() ? "success" : "warning" %> px-4 py-2"
                    onclick="return confirm('<%= user.isSuspended() ? "Reactivate this user?" : "Suspend this user?" %>')">
              <%= user.isSuspended() ? "↺ Reactivate" : "⏸ Suspend" %>
            </button>
          </form>
          
          <form method="post" action="<%=request.getContextPath()%>/admin/users/action" class="inline"
                onsubmit="return confirm('Delete <%= fullName %>? This removes related votes, contester data, and support records.')">
            <input type="hidden" name="userId" value="<%= user.getId() %>">
            <input type="hidden" name="action" value="delete">
            <button type="submit" class="admin-button danger px-4 py-2">🗑 Delete User</button>
          </form>
        <% } else { %>
          <span class="text-sm text-red-500">Cannot modify SUPER_ADMIN account</span>
        <% } %>
      </div>
    </div>
  <% } else { %>
    <div class="admin-card p-5 rise-in">
      <div class="admin-section-head mb-4">
        <div>
          <div class="admin-section-title">Account Actions</div>
          <div class="admin-section-note">Your current session account</div>
        </div>
      </div>
      <p class="text-sm text-slate-500">This is your current session account. You cannot modify your own account from here.</p>
    </div>
  <% } %>
</div>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf"%>

<style>
.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem 0;
}

.detail-label {
  font-weight: 500;
  color: #64748b;
  font-size: 0.875rem;
}

.detail-value {
  color: #0f172a;
  font-size: 0.875rem;
  text-align: right;
}
</style>
</body>
</html>
