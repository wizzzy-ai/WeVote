<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-white text-gray-900">

<section id="db-error" class="py-20">
  <div class="container-custom text-center">
    <h1 class="text-5xl font-extrabold mb-6 text-red-500">Database Error</h1>
    <p class="text-lg text-gray-600 mb-8">
      A system error occurred while processing your request.<br>
      Please contact the administrator.
    </p>

    <%
      boolean debug = "1".equals(request.getParameter("debug"));
      String role = session != null ? (String) session.getAttribute("userRole") : null;
      boolean isAdmin = role != null && "ADMIN".equalsIgnoreCase(role);
      if (debug && isAdmin && exception != null) {
    %>
      <div class="max-w-4xl mx-auto mt-10 text-left">
        <div class="rounded-2xl border border-red-200 bg-red-50 p-4 text-red-900 overflow-x-auto">
          <div class="font-bold mb-2">Debug (admin only)</div>
          <div class="font-mono text-xs whitespace-pre-wrap"><%= exception.toString() %></div>
          <%
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            exception.printStackTrace(pw);
            pw.flush();
          %>
          <div class="font-mono text-xs whitespace-pre-wrap mt-3"><%= sw.toString() %></div>
        </div>
      </div>
    <%
      }
    %>

    <!-- Action buttons -->
    <div class="space-x-4">
      <a href="${pageContext.request.contextPath}/"
         class="inline-block bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
        Back to Home
      </a>
      <a href="${pageContext.request.contextPath}/contact"
         class="inline-block bg-purple-600 hover:bg-purple-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
        Contact Support
      </a>
    </div>
  </div>
</section>

</body>
</html>
