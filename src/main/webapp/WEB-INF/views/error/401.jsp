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
    <h1 class="text-5xl font-extrabold mb-6 text-purple-700">401 - Unauthorized</h1>
    <p class="text-lg text-gray-600 mb-8">
        You must login to access this page
    </p>

    <a href="${pageContext.request.contextPath}/"
       class="inline-block bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
       Back to Home
    </a>
</div>

<%@ include file="../fragment/footer.jsp" %>
</body>
</html>