<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../fragment/head.jsp" %>
</head>
<body class="bg-white text-gray-900">

<%@ include file="../fragment/navbar.jsp" %>

<div class="container mt-20 text-center">
    <h1 class="text-5xl font-extrabold mb-6 text-purple-700">403 - Forbidden</h1>
    <p class="text-lg text-gray-600 mb-8">
        You do not have permission to access this resource.
    </p>

        <a href="${pageContext.request.contextPath}/contact" class="text-sm font-semibold text-gray-900">
          Contact support <span aria-hidden="true">&rarr;</span>
        </a>
</div>

<%@ include file="../fragment/footer.jsp" %>
</body>
</html>
