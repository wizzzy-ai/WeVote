<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>
</head>
<body class="bg-gray-100">
	<%@ include file="/WEB-INF/views/fragment/backToHome.jsp"%>

	<div
		class="flex items-center justify-center px-4 min-h-screen bg-gray-100">
		<div
			class="w-full max-w-4xl bg-white shadow-2xl rounded-2xl overflow-hidden flex flex-col md:flex-row">

			<!-- Side Image -->
			<div class="md:w-1/2 flex items-center justify-center bg-gray-50">
				<img alt="signup image"
					src="${pageContext.request.contextPath}/images/signup.jpeg"
					class="max-h-[350px] w-auto object-contain">
			</div>

			<!-- Signup Form -->
			<div class="md:w-1/2 sm:p-8 flex flex-col justify-center bg-white">
				<h2 class="text-2xl font-extrabold text-gray-800 mb-8">Create
					your account</h2>

				<form class="space-y-4" action="register" method="post">

					<!-- Error check  -->
					<c:if test="${not empty error }">
						<p class="mb-4 p-3 bg-red-100 text-red-700 rounded">${error}</p>
					</c:if>

					<!-- First & Lastname -->
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div class="relative">
							<input type="text" id="firstName" name="firstName" required
								placeholder="First Name"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="firstName"
								class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								First Name </label>
						</div>
						<div class="relative">
							<input type="text" id="lastName" name="lastName" required
								placeholder="Last Name"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="lastName"
								class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								Last Name </label>
						</div>
					</div>

					<!-- Email -->
					<div class="relative">
						<input type="email" id="email" name="email" required
							placeholder="Email"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
						<label for="email"
							class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Email </label>
					</div>

					<!-- Birth Year -->
					<div class="relative">
						<input type="date" id="birthYear" name="birthYear" required
							min="1900" max="2026" placeholder=""
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
						<label for="birthYear"
							class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Date Of Birth </label>
					</div>

					<!-- State & Country  -->
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div class="relative">
							<input type="text" id="state" name="state" required
								placeholder="State"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="state"
								class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								State </label>
						</div>
						<div class="relative">
							<input type="text" id="country" name="country" required
								placeholder="Country"
								class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                          focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1" />
							<label for="country"
								class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                          peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                          peer-focus:top-2 peer-focus:text-sm">
								Country </label>
						</div>
					</div>

					<!-- Password -->
					<div class="relative">
						<input type="password" id="password" name="password"
							pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$"
							title="Must contain at least 8 characters, including letters, numbers, and one special character"
							required placeholder="Password"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
                        focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1 pr-10" />
						<label for="password"
							class="absolute left-1 top-0 text-gray-500 text-sm transition-all
                        peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
                        peer-focus:top-2 peer-focus:text-sm">
							Password </label>
						<button type="button"
							class="absolute right-1 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
							aria-label="Show or hide password" data-password-toggle
							data-target="password">
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
								<path
									d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19" />
								<path
									d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82" />
								<line x1="2" y1="2" x2="22" y2="22" />
							</svg>
						</button>

					</div>

					<!-- Confirm Password -->
					<div class="relative">
						<input type="password" id="confirmPassword" name="confirmPassword"
							required placeholder="Confirm Password"
							class="peer w-full border-b-2 border-gray-300 placeholder-transparent
           focus:outline-none focus:border-blue-500 text-gray-900 py-3 px-1 pr-10" />
						<label for="confirmPassword"
							class="absolute left-1 top-0 text-gray-500 text-sm transition-all
           peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-base
           peer-focus:top-2 peer-focus:text-sm">
							Confirm Password </label>
						<button type="button"
							class="absolute right-1 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-800 transition"
							aria-label="Show or hide confirm password" data-password-toggle
							data-target="confirmPassword">
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
								<path
									d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19" />
								<path
									d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82" />
								<line x1="2" y1="2" x2="22" y2="22" />
							</svg>
						</button>
					</div>



					<!-- Role -->
					<div class="relative">
						<label class="text-sm font-semibold text-gray-700">Role</label> <select
							id="roleSelect" name="role" required
							class="mt-1 w-full px-3 py-3 rounded-xl border border-gray-200 bg-white
							focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
							<option value="VOTER">Voter</option>
							<!--  <option value="ADMIN">Admin</option>-->
						</select>
					</div>

					<!-- Position (only for CONTESTER) -->
					<div id="positionWrapper"
						class="relative overflow-hidden max-h-0 opacity-0 translate-y-[-6px] transition-all duration-300 ease-out">
						<label class="text-sm font-semibold text-gray-700">Position</label>
						<select id="positionSelect" name="position"
							class="mt-1 w-full px-3 py-3 rounded-xl border border-gray-200 bg-white
							focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
							<option value="" selected>Select a position</option>
							<option value="PRESIDENT">President</option>
							<option value="VICE_PRESIDENT">Vice President</option>
							<option value="SECRETARY">Secretary</option>
							<option value="TREASURER">Treasurer</option>
						</select>
						<p class="mt-2 text-xs text-gray-600">Note: If a position
							already has 3 approved contesters, your contester application
							will be declined automatically.</p>
					</div>
					
					<div class="flex items-center justify-center gap-1">
					<input type="checkbox" name="accept" value="yes" required >
						<p class="text-sm text-black">
							I accept the <a
								href="${pageContext.request.contextPath}/legal.jsp"
								class="text-underline text-blue-500">Terms & Conditions</a>

							<p />
					</div>
					
				<!-- Submit Button -->
							<button type="submit"
								class="cursor-pointer w-full bg-[var(--green)] hover:bg-green-400 text-white py-3 rounded-xl font-semibold transition duration-300 shadow-lg mt-2">
								Sign Up</button>
				
						
						</form>

				<!-- Already have account -->
				<p class="text-center text-sm text-gray-600 mt-4">
					Already have an account? <a
						href="${pageContext.request.contextPath}/login.jsp"
						class="text-blue-600 hover:underline">Log in</a>
				</p>
			</div>
		</div>
	</div>

	<script>
		(function() {
			const roleSelect = document.getElementById('roleSelect');
			const positionWrapper = document.getElementById('positionWrapper');
			const positionSelect = document.getElementById('positionSelect');

			function sync() {
				const isContester = roleSelect.value === 'CONTESTER';
				if (isContester) {
					positionWrapper.classList.remove('max-h-0', 'opacity-0',
							'translate-y-[-6px]');
					positionWrapper.classList.add('max-h-40', 'opacity-100',
							'translate-y-0', 'mt-2');
					positionSelect.required = true;
				} else {
					positionWrapper.classList.add('max-h-0', 'opacity-0',
							'translate-y-[-6px]');
					positionWrapper.classList.remove('max-h-40', 'opacity-100',
							'translate-y-0', 'mt-2');
					positionSelect.required = false;
					positionSelect.value = '';
				}
			}

			roleSelect.addEventListener('change', sync);
			sync();
		})();
	</script>

</body>
</html>
