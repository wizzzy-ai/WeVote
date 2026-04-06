<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>
</head>
<body class="bg-gray-100">
    <%@ include file="/WEB-INF/views/fragment/backToHome.jsp"%>

    <div class="min-h-screen flex items-center justify-center px-4">
        <div class="w-full max-w-xl bg-white shadow-xl rounded-2xl p-8 text-center">
            <h1 class="text-2xl font-extrabold text-gray-900">Account Limited</h1>
            <p class="mt-3 text-gray-600">
                Your account was created successfully, but access is limited until you turn 18.
            </p>
            <p class="mt-2 text-sm text-gray-500">
                If you believe this is an error, please contact support.
            </p>
            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/contact"
                   class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-[var(--green)] text-white font-semibold hover:bg-green-400 transition">
                    Contact Support
                </a>
            </div>
        </div>
    </div>
</body>
</html>
