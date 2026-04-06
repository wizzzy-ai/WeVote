<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>
<html lang="en">
<head>
    <title>Vote Submission</title>
    <style>
      @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
      .fade-up { animation: fadeUp .5s ease-out both; }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
    <section class="max-w-3xl mx-auto pt-28 px-4 pb-14">
        <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100 text-center">
            <div class="mx-auto w-14 h-14 rounded-2xl flex items-center justify-center text-white"
                 style="background: linear-gradient(135deg, var(--purple), var(--green));">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 6 9 17l-5-5"/>
              </svg>
            </div>
            <h1 class="mt-4 text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Vote Submitted</h1>
            <p class="mt-2 text-gray-700">Your vote has been submitted successfully.</p>

            <div class="mt-8 flex flex-wrap items-center justify-center gap-3">
              <a href="<%=request.getContextPath()%>/dashboard"
                 class="px-6 py-3 rounded-2xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">
                Back to Dashboard
              </a>
              <a href="<%=request.getContextPath()%>/results"
                 class="px-6 py-3 rounded-2xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
                View Results
              </a>
            </div>
        </div>
    </section>
    <%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp" %>
</body>
</html>
