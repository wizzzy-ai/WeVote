<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.bascode.model.entity.User" %>

<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
  <title>Profile - Voting System</title>
  <style>
    @keyframes fadeUp { from { opacity: 0; transform: translateY(10px);} to { opacity: 1; transform: translateY(0);} }
    .fade-up { animation: fadeUp .45s ease-out both; }
  </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>

<%
  User u = (User) request.getAttribute("user");
%>

<section class="max-w-3xl mx-auto pt-4 px-4 pb-14">
  <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
    <div class="flex items-start justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Your Profile</h1>
        <p class="text-gray-600 mt-1">Update your details and change your password.</p>
      </div>
      <img alt="logo" src="${pageContext.request.contextPath}/images/logos/fingerPrint.png" class="justify-center w-12 h-12">
    </div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="mt-6 rounded-2xl p-4 border bg-red-50 border-red-200 text-red-800">
        <div class="font-semibold"><%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="mt-6 rounded-2xl p-4 border bg-green-50 border-green-200 text-green-800">
        <div class="font-semibold"><%= request.getAttribute("success") %></div>
      </div>
    <% } %>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <h2 class="text-lg font-bold text-gray-900">Profile Details</h2>
        <p class="text-sm text-gray-600 mt-1">Keep your info up to date.</p>
        <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
          <div class="rounded-2xl border border-gray-100 bg-white px-4 py-3">
            <div class="text-gray-500">Email</div>
            <div class="mt-1 font-semibold text-gray-900 break-all"><%= u != null ? u.getEmail() : "" %></div>
          </div>
          <div class="rounded-2xl border border-gray-100 bg-white px-4 py-3">
            <div class="text-gray-500">Birth Year</div>
            <div class="mt-1 font-semibold text-gray-900"><%= u != null ? u.getBirthYear() : "" %></div>
          </div>
        </div>

        <form class="mt-4 space-y-4" action="<%=request.getContextPath()%>/profile" method="post">
          <input type="hidden" name="action" value="profile" />
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">First Name</label>
            <input name="firstName" value="<%= u != null ? u.getFirstName() : "" %>"
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)]" required />
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">Last Name</label>
            <input name="lastName" value="<%= u != null ? u.getLastName() : "" %>"
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)]" required />
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">State</label>
            <input name="state" value="<%= u != null ? u.getState() : "" %>"
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)]" required />
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">Country</label>
            <input name="country" value="<%= u != null ? u.getCountry() : "" %>"
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)]" required />
          </div>
          <button type="submit"
                  class="w-full px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
            Save Changes
          </button>
        </form>
      </div>

      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <h2 class="text-lg font-bold text-gray-900">Change Password</h2>
        <p class="text-sm text-gray-600 mt-1">Use a strong password you do not reuse elsewhere.</p>

        <form class="mt-4 space-y-4" action="<%=request.getContextPath()%>/profile" method="post">
          <input type="hidden" name="action" value="password" />
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">Current Password</label>
            <div class="relative">
              <input type="password" id="currentPassword" name="currentPassword"
                     class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] pr-10" required />
              <button type="button"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                      aria-label="Show or hide current password"
                      data-password-toggle data-target="currentPassword">
                <svg data-icon="show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <svg data-icon="hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M10.7 10.7a3 3 0 0 0 4.24 4.24"/>
                  <path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19"/>
                  <path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82"/>
                  <line x1="2" y1="2" x2="22" y2="22"/>
                </svg>
              </button>
            </div>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">New Password</label>
            <div class="relative">
              <input type="password" id="newPassword" name="newPassword"
                     class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] pr-10" required />
              <button type="button"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                      aria-label="Show or hide new password"
                      data-password-toggle data-target="newPassword">
                <svg data-icon="show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <svg data-icon="hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M10.7 10.7a3 3 0 0 0 4.24 4.24"/>
                  <path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19"/>
                  <path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82"/>
                  <line x1="2" y1="2" x2="22" y2="22"/>
                </svg>
              </button>
            </div>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">Confirm New Password</label>
            <div class="relative">
              <input type="password" id="confirmNewPassword" name="confirmPassword"
                     class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] pr-10" required />
              <button type="button"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                      aria-label="Show or hide confirm new password"
                      data-password-toggle data-target="confirmNewPassword">
                <svg data-icon="show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <svg data-icon="hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M10.7 10.7a3 3 0 0 0 4.24 4.24"/>
                  <path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19"/>
                  <path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82"/>
                  <line x1="2" y1="2" x2="22" y2="22"/>
                </svg>
              </button>
            </div>
          </div>
          <button type="submit"
                  class="w-full px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
            Update Password
          </button>
        </form>
      </div>
    </div>

    <div class="mt-6 rounded-2xl border border-red-200 bg-red-50 p-5">
      <h2 class="text-lg font-bold text-red-900">Delete Account</h2>
      <p class="mt-1 text-sm text-red-700">This permanently removes your profile, votes, contester records, and support history.</p>
      <form class="mt-4 flex flex-col md:flex-row gap-3 md:items-end" action="<%=request.getContextPath()%>/profile" method="post"
            onsubmit="return confirm('Delete your account permanently? This action cannot be undone.');">
        <input type="hidden" name="action" value="delete" />
        <div class="flex-1">
          <label class="block text-sm font-semibold text-red-900 mb-1">Confirm with current password</label>
          <div class="relative">
            <input type="password" id="deletePassword" name="currentPassword"
                   class="w-full px-4 py-2 rounded-xl border border-red-200 bg-white focus:outline-none focus:ring-2 focus:ring-red-300 pr-10" required />
            <button type="button"
                    class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                    aria-label="Show or hide delete password"
                    data-password-toggle data-target="deletePassword">
              <svg data-icon="show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
              <svg data-icon="hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M10.7 10.7a3 3 0 0 0 4.24 4.24"/>
                <path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19"/>
                <path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82"/>
                <line x1="2" y1="2" x2="22" y2="22"/>
              </svg>
            </button>
          </div>
        </div>
        <button type="submit"
                class="px-5 py-2 rounded-xl bg-red-600 text-white font-semibold hover:bg-red-700 hover:shadow transition duration-200">
          Delete My Account
        </button>
      </form>
    </div>
  </div>
  <%
    String role = session != null ? (String) session.getAttribute("userRole") : null;
    if ("CONTESTER".equalsIgnoreCase(role)) {
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
