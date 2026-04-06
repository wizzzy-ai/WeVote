<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
  String message = (String) request.getAttribute("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>
<title>Create Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

	<!-- Back to dashboard arrow -->
	  <a href="${pageContext.request.contextPath}/admin/dashboard"
     class="fixed top-4 left-4 flex items-center text-[var(--purple)] hover:underline mb-4">
    <!-- Arrow icon -->
    <svg xmlns="http://www.w3.org/2000/svg" 
         class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" 
         stroke="currentColor" stroke-width="2">
      <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
    </svg>
    Back to Dashboard
  </a>

	<div class="bg-white shadow-md rounded-lg p-8 w-full max-w-md">
	
		<h1 class="text-2xl font-bold mb-6 text-center">Create New Admin</h1>

		<form action="${pageContext.request.contextPath}/admin/create-admin"
			method="post" class="space-y-4">

			<!-- First & Lastname -->
			<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
				<div class="relative">
					<label class="block text-sm font-medium">First Name</label>
					<input type="text" name="firstName" required
						class="border rounded w-full p-2">
				</div>

				<div class="relative">
					<label class="block text-sm font-medium">Last Name</label>
					<input type="text" name="lastName" required
						class="border rounded w-full p-2">
				</div>
			</div>

			<div>
				<label class="block text-sm font-medium">Birth Date</label>
				<input type="date" name="birthDate" class="border rounded w-full p-2">
			</div>

			<!-- email -->
			<div>
				<label class="block text-sm font-medium">Email</label>
				<input type="email" name="email" required
					class="border rounded w-full p-2">
			</div>

			<!--Country & State -->
			<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
				<div class="relative">
					<label class="block text-sm font-medium">Country</label>
					<input type="text" name="country" class="border rounded w-full p-2">
				</div>

				<div class="relative">
					<label class="block text-sm font-medium">State</label>
					<input type="text" name="state" class="border rounded w-full p-2">
				</div>
			</div>

			<!-- password -->
			<div class="relative">
				<input type="password" id="password" name="password"
					required placeholder="Password"
					class="border rounded w-full p-2" />
				<button type="button"
					class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
					aria-label="Show or hide password" data-password-toggle data-target="password">
					<!-- Eye icons -->
					<svg data-icon="show" xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24" class="w-5 h-5 hidden" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round">
						<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z" />
						<circle cx="12" cy="12" r="3" />
					</svg>
					<svg data-icon="hide" xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24" class="w-5 h-5" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round">
						<path d="M10.7 10.7a3 3 0 0 0 4.24 4.24" />
						<path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19" />
						<path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82" />
						<line x1="2" y1="2" x2="22" y2="22" />
					</svg>
				</button>
			</div>

			<div>
				<label class="block text-sm font-medium">Role</label>
				<select name="role" class="border rounded w-full p-2">
					<option value="ADMIN">ADMIN</option>
				</select>
			</div>

			<button type="submit"
				class="bg-[var(--green)] text-white px-4 py-2 rounded w-full cursor-pointer">
				Create Admin</button>
		</form>
	</div>

	<!-- Toast container -->
	<div id="toast"
		class="fixed top-5 right-5 bg-green-600 text-white px-4 py-2 rounded shadow-lg hidden">
		<span id="toast-message"></span>
	</div>

	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const message = "<%= message != null ? message : "" %>";
			if (message) {
				const toast = document.getElementById("toast");
				const toastMessage = document.getElementById("toast-message");
				toastMessage.textContent = message;
				toast.classList.remove("hidden");

				// Auto-hide after 3 seconds
				setTimeout(() => {
					toast.classList.add("hidden");
				}, 9000);
			}
		});
	</script>
</body>
</html>
