<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-gray-100">
<%@ include file="/WEB-INF/views/fragment/backToHome.jsp" %>

<div class="flex items-center justify-center px-4 min-h-screen bg-gray-100 mt-6">
  <div class="w-full max-w-4xl bg-white shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row">
    
    <!-- Left Image -->
    <div class="md:w-1/2">
      <img alt="login image" src="${pageContext.request.contextPath}/images/login.jpeg" 
           class="w-full h-full object-cover hidden md:block">
    </div>
    
    <!-- Right Form -->
    <div class="md:w-1/2 p-10 sm:p-16 flex flex-col justify-center bg-white">
      <h2 class="text-2xl font-extrabold text-gray-800 mb-8">Sign in to your account</h2>

      <form class="space-y-4" action="login" method="post">
        <c:if test="${not empty error}">
          <p class="mb-4 p-3 bg-red-100 text-red-700 rounded">${error}</p>
        </c:if> 
        <c:if test="${param.success == '1'}">
          <p class="mb-4 p-3 bg-green-100 text-green-700 rounded">
            Email verified successfully. Please log in.
          </p>
        </c:if>

        <!-- Email -->
        <div class="relative">
          <input type="email" id="email" name="email" required placeholder="Email address"
                 class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
          <label for="email"
                 class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
            Email address
          </label>
        </div>

        <!-- Password -->
        <div class="relative">
          <input type="password" id="password" name="password" required placeholder="Password"
                 class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1 pr-10" />
          <label for="password"
                 class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
            Password
          </label>
          <button type="button"
                  class="absolute right-1 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
                  aria-label="Show or hide password"
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

        <!-- Options -->
        <a href="${pageContext.request.contextPath}/forgot-password"
           class="text-blue-600 hover:underline">Forgot password?</a>

        <!-- Submit Button -->
        <button type="submit"
          class="cursor-pointer w-full bg-[var(--green)] hover:bg-green-700 text-white py-3 rounded-xl font-semibold transition duration-300 shadow-lg mt-2">
          Sign In
        </button>
      </form>

      <!-- Sign Up Link -->
      <p class="text-center text-sm text-gray-600 mt-4">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register.jsp" class="text-blue-600 hover:underline">Sign up</a>
      </p>
    </div>
  </div>
</div>
</body>
</html>