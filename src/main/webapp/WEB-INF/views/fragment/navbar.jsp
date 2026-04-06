<header class="flex flex-wrap items-center py-4 px-4 absolute top-0 left-0 w-full z-20 
               sm:bg-white md:bg-transparent">

  <div class="flex-1 flex justify-between items-center">
    <a href="${pageContext.request.contextPath}/">
      <img alt="Logo"
           class="cursor-pointer lg:h-[40px] lg:w-[210px] h-[45px] w-[140px]"
           src="${pageContext.request.contextPath}/images/logos/logoShort.png">
    </a>

  </div>

  <!-- Hamburger / Close button -->
  <button id="menu-toggle" class="cursor-pointer md:hidden focus:outline-none">
    <!-- Hamburger icon -->
    <svg id="hamburger-icon" class="fill-current text-[var(--purple)] " xmlns="http://www.w3.org/2000/svg"
         width="45px" height="45px" viewBox="0 0 20 20">
      <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"></path>
    </svg>

    <!-- Close icon (hidden by default) -->
    <svg class="hidden fill-current" id="close-icon" width="45px" height="45px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"
         stroke="#6A0DAD"><g id="SVGRepo_bgCarrier" stroke-width="0"></g>
      <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier">
        <path d="M20.7457 3.32851C20.3552 2.93798 19.722 2.93798 19.3315 3.32851L12.0371 10.6229L4.74275 3.32851C4.35223 2.93798 3.71906 2.93798 3.32854 3.32851C2.93801 3.71903 2.93801 4.3522 3.32854 4.74272L10.6229 12.0371L3.32856 19.3314C2.93803 19.722 2.93803 20.3551 3.32856 20.7457C3.71908 21.1362 4.35225 21.1362 4.74277 20.7457L12.0371 13.4513L19.3315 20.7457C19.722 21.1362 20.3552 21.1362 20.7457 20.7457C21.1362 20.3551 21.1362 19.722 20.7457 19.3315L13.4513 12.0371L20.7457 4.74272C21.1362 4.3522 21.1362 3.71903 20.7457 3.32851Z" fill="#0F0F0F">
        </path> </g></svg>
  </button>

  <!-- Desktop menu -->
  <div class="hidden md:flex md:items-center md:w-auto w-full " id="menu-desktop">

    <nav>
      <%
        boolean loggedIn = session != null && session.getAttribute("userId") != null;
        String role = loggedIn ? String.valueOf(session.getAttribute("userRole")) : null;
      %>
      <ul class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0">
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-black " href="${pageContext.request.contextPath}/about.jsp">About us</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-black" href="${pageContext.request.contextPath}/support">Contact</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block 
                      after:content-[''] after:block after:w-0 after:h-[2px] 
                      after:bg-[var(--green)] after:transition-all after:duration-300 
                      hover:after:w-full text-black" href="${pageContext.request.contextPath}/results">Live results</a></li>
        <% if (loggedIn) { %>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px] 
                        after:bg-[var(--green)] after:transition-all after:duration-300 
                        hover:after:w-full text-black" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px]
                        after:bg-[var(--green)] after:transition-all after:duration-300
                        hover:after:w-full text-black" href="${pageContext.request.contextPath}/profile">Profile</a></li>
        <% if ("ADMIN".equalsIgnoreCase(role)) { %>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block
                          after:content-[''] after:block after:w-0 after:h-[2px]
                          after:bg-[var(--green)] after:transition-all after:duration-300
                          hover:after:w-full text-black" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
        <% } %>
        <li><a class="md:p-4 py-3 px-0 block font-bold rounded-sm
                        bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white
                        transition-transform duration-300 hover:scale-105
                        hover:bg-gradient-to-r hover:from-[var(--purple)] hover:to-[var(--purple-light)]" href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <% } else { %>
        <li><a class="md:p-4 py-3 px-0 block font-bold relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px]
                        after:bg-[var(--green)] after:transition-all after:duration-300
                        hover:after:w-full text-black" href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
        <li><a class="md:p-4 py-3 px-0 block font-bold rounded-sm
                        bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white
                        transition-transform duration-300 hover:scale-105
                        hover:bg-gradient-to-r hover:from-[var(--purple)] hover:to-[var(--purple-light)]" href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
        <% } %>
      </ul>

    </nav>
  </div>

  <!-- Mobile drop down menu -->
  <div id="menu-mobile"
       class="hidden h-[400px] md:hidden absolute top-full left-0 w-full bg-white shadow-lg transform scale-y-0 origin-top transition-transform duration-300 ease-in-out">
    <nav>
      <ul class="flex flex-col items-center text-base text-gray-700 py-4">
        <li><a class="py-2 px-4 block relative inline-block
                      after:content-[''] after:block after:w-0 after:h-[2px]
                      after:bg-[var(--green)] after:transition-all after:duration-300
                      hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/about.jsp">About us</a></li>
        <li><a class="py-2 px-4 block relative inline-block
                      after:content-[''] after:block after:w-0 after:h-[2px]
                      after:bg-[var(--green)] after:transition-all after:duration-300
                      hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/support">Contact</a></li>
        <li><a class="py-2 px-4 block relative inline-block
                      after:content-[''] after:block after:w-0 after:h-[2px]
                      after:bg-[var(--green)] after:transition-all after:duration-300
                      hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/results">Live Results</a></li>
        <% if (loggedIn) { %>
        <li><a class="py-2 px-4 block relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px]
                        after:bg-[var(--green)] after:transition-all after:duration-300
                        hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        <li><a class="py-2 px-4 block relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px] 
                        after:bg-[var(--green)] after:transition-all after:duration-300 
                        hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/profile">Profile</a></li>
        <% if ("ADMIN".equalsIgnoreCase(role)) { %>
        <li><a class="py-2 px-4 block relative inline-block
                          after:content-[''] after:block after:w-0 after:h-[2px] 
                          after:bg-[var(--green)] after:transition-all after:duration-300 
                          hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
        <% } %>
        <li><a class="py-2 px-4 block relative inline-block
                        text-[black] mb-4 text-2xl border border-groove rounded-sm" href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <% } else { %>
        <li><a class="py-2 px-4 block relative inline-block
                        after:content-[''] after:block after:w-0 after:h-[2px] 
                        after:bg-[var(--green)] after:transition-all after:duration-300 
                        hover:after:w-full text-[black] mb-4 text-2xl" href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
        <li><a class="py-2 px-4 block relative inline-block
                        text-[black] mb-4 text-2xl border border-groove rounded-sm" href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
        <% } %>
      </ul>
    </nav>
  </div>
</header>

<script type="text/javascript">
  const toggleBtn = document.getElementById('menu-toggle');
  const menuMobile = document.getElementById('menu-mobile');
  const hamburgerIcon = document.getElementById('hamburger-icon');
  const closeIcon = document.getElementById('close-icon');

  toggleBtn.addEventListener('click', () => {
    const isOpen = menuMobile.classList.contains('scale-y-100');
    if (isOpen) {
      // Close menu
      menuMobile.classList.remove('scale-y-100');
      menuMobile.classList.add('scale-y-0');
      hamburgerIcon.classList.remove('hidden');
      closeIcon.classList.add('hidden');
    } else {
      // Open menu
      menuMobile.classList.remove('scale-y-0', 'hidden');
      menuMobile.classList.add('scale-y-100');
      hamburgerIcon.classList.add('hidden');
      closeIcon.classList.remove('hidden');
    }
  });

</script>
