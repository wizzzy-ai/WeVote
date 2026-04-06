<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../fragment/head.jsp" %>
</head>
<body>


<div class="h-screen bg-white">
  <main class="flex flex-1 items-center justify-center px-6 py-24 sm:py-32 lg:px-8">
    <div class="text-center max-w-md">
      <p class="text-base font-semibold text-red-500 text-md">500</p>
      <h1 class="mt-4 text-5xl font-semibold tracking-tight text-balance text-gray-900 sm:text-7xl">
        
      </h1>
      <p class="mt-6 text-lg font-medium text-pretty text-gray-500 sm:text-xl/8">
        Something went wrong on the server.
      </p>
      <p>Please try again later.</p>
      <div class="mt-10 flex items-center justify-center gap-x-6">
        <a
          href="${pageContext.request.contextPath}/"
          class="rounded-md bg-[var(--green)] px-3.5 py-2.5 text-sm font-semibold text-white shadow-xs hover:bg-green-800 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Go back home
        </a>
        <a href="${pageContext.request.contextPath}/support" class="text-sm font-semibold text-gray-900">
          Contact support <span aria-hidden="true">&rarr;</span>
        </a>
      </div>
    </div>
  </main>
  
</div>

</body>
</html>
