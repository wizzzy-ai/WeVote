<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
  <title>Reset Password</title>
</head>
<body class="bg-gray-100">
  <%@ include file="/WEB-INF/views/fragment/backToHome.jsp" %>

  <div class="flex items-center justify-center px-4 min-h-screen bg-gray-100 mt-6">
    <div class="w-full max-w-4xl bg-white shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row">
      <div class="md:w-1/2">
        <img alt="reset password image" src="${pageContext.request.contextPath}/images/login.jpeg"
             class="w-full h-full object-cover hidden md:block">
      </div>

      <div class="md:w-1/2 p-10 sm:p-16 flex flex-col justify-center bg-white">
        <h2 class="text-2xl font-extrabold text-gray-800 mb-3">Reset your password</h2>
        <p class="text-sm text-gray-600 mb-8">Choose a new password (minimum 8 characters).</p>

        <% if (request.getAttribute("error") != null) { %>
          <p class="mb-4 p-3 bg-red-100 text-red-700 rounded"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
          <p class="mb-4 p-3 bg-green-100 text-green-700 rounded"><%= request.getAttribute("success") %></p>
        <% } %>

        <form class="space-y-4" action="${pageContext.request.contextPath}/reset-password" method="post">
          <input type="hidden" name="token" value="<%= request.getParameter("token") != null ? request.getParameter("token") : "" %>">

          <div class="relative">
            <input type="password" id="password" name="password" required placeholder="New password"
                   class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1 pr-10" />
            <label for="password"
                   class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
              New password
            </label>
            <button type="button"
                    class="absolute right-1 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                    aria-label="Show or hide new password"
                    data-password-toggle data-target="password">
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

          <div class="relative">
            <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirm password"
                   class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1 pr-10" />
            <label for="confirmPassword"
                   class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
              Confirm password
            </label>
            <button type="button"
                    class="absolute right-1 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                    aria-label="Show or hide confirm password"
                    data-password-toggle data-target="confirmPassword">
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

          <button type="submit"
                  class="cursor-pointer w-full bg-[var(--green)] hover:bg-green-700 text-white py-3 rounded-xl font-semibold transition duration-300 shadow-lg mt-2">
            Reset Password
          </button>
        </form>

        <p class="text-center text-sm text-gray-600 mt-6">
          Back to
          <a href="${pageContext.request.contextPath}/login.jsp" class="text-blue-600 hover:underline">login</a>
        </p>
      </div>
    </div>
  </div>
</body>
</html>

