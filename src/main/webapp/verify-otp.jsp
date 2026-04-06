<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Verify OTP</title>
</head>
<body class="flex min-h-screen items-center justify-center bg-[#f9f9f9] p-4">
    <section class="w-full max-w-md">
        <div class="rounded-none bg-white p-8 shadow-sm">
            <div class="mb-8 text-center">
                <h1 class="mb-2 text-2xl font-bold text-black">Email Verification</h1>
                <p class="text-sm text-gray-600">Enter the OTP code sent to your email to verify your account.</p>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="mb-4 p-3 bg-red-100 text-red-700 rounded"> <%= request.getAttribute("error") %> </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="mb-4 p-3 bg-green-100 text-green-700 rounded"> <%= request.getAttribute("success") %> </div>
            <% } %>
            <form action="verify-otp" method="post" class="space-y-6">
                <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getParameter("email") != null ? request.getParameter("email") : "") %>" />
                <div>
                    <label for="otp" class="mb-2 block text-sm font-medium text-gray-700">OTP Code</label>
                    <input type="text" id="otp" name="otp" maxlength="6" minlength="6" pattern="[0-9]{6}" class="w-full border border-gray-300 bg-white px-4 py-3 text-gray-900 focus:border-transparent focus:ring-2 focus:ring-black focus:outline-none" placeholder="Enter 6-digit OTP code" required />
                </div>
                <button type="submit" class=" cursor-pointer w-full bg-black px-6 py-3 text-sm font-medium text-white transition-colors hover:bg-gray-800">Verify</button>
            </form>

            <div class="mt-6 text-center text-sm text-gray-600">
                Didn’t receive the code?
                <form action="resend-otp" method="post" class="inline">
                    <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getParameter("email") != null ? request.getParameter("email") : "") %>" />
                    <button type="submit" class="font-semibold text-black hover:underline">Resend code</button>
                </form>
            </div>
        </div>
    </section>
</body>
</html>
