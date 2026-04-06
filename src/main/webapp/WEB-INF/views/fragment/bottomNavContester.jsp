<div class="fixed bottom-4 left-1/2 transform -translate-x-1/2 z-50 
            w-[calc(100%-16px)] md:w-[calc(100%-64px)] max-w-5xl">
  <div class="flex justify-between items-center bg-white/90 backdrop-blur rounded-2xl shadow-lg px-3 py-2 border border-gray-100">

    <!-- Dashboard -->
    <a href="<%=request.getContextPath()%>/contester/dashboard" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 text-black transition-colors" fill="none" stroke="black" viewBox="0 0 20 20">
        <path d="m19.707 9.293-2-2-7-7a1 1 0 0 0-1.414 0l-7 7-2 2a1 1 0 0 0 1.414 1.414L2 10.414V18a2 2 0 0 0 2 2h3a1 1 0 0 0 1-1v-4a1 1 0 0 1 1-1h2a1 1 0 1 1 1 1v4a1 1 0 0 0 1 1h3a2 2 0 0 0 2-2v-7.586l.293.293a1 1 0 0 0 1.414-1.414Z"/>
      </svg>
      <span class="text-[12px] mt-1 text-black">Home</span>
    </a>

    <!-- Candidates -->
    <a href="<%=request.getContextPath()%>/contester/candidates" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 text-black transition-colors" fill="none" stroke="black" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 7a4 4 0 1 1 8 0 4 4 0 0 1-8 0zm-4 14a6 6 0 0 1 12 0H4zm14-6h2a4 4 0 0 1 4 4v2h-6z"/>
      </svg>
      <span class="text-[12px] mt-1 text-black">Candidates</span>
    </a>

    <!-- Vote -->
    <a href="<%=request.getContextPath()%>/vote" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 text-black transition-colors" fill="none" stroke="black" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M9 12.75 11.25 15 15 9.75M21 12c0 4.97-4.03 9-9 9s-9-4.03-9-9 4.03-9 9-9 9 4.03 9 9Z"/>
      </svg>
      <span class="text-[12px] mt-1 text-black">Vote</span>
    </a>

    <!-- Status -->
    <a href="<%=request.getContextPath()%>/contester/status" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 text-black transition-colors" fill="none" stroke="black" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M9 12l2 2 4-4M12 22A10 10 0 1 1 12 2a10 10 0 0 1 0 20z"/>
      </svg>
      <span class="text-[12px] mt-1 text-black">Status</span>
    </a>

    <!-- Message Admin -->
    <a href="<%=request.getContextPath()%>/support" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 text-black transition-colors" fill="none" stroke="black" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 10h8M8 14h5M7 4h10a3 3 0 0 1 3 3v6a3 3 0 0 1-3 3h-4l-4 4v-4H7a3 3 0 0 1-3-3V7a3 3 0 0 1 3-3Z"/>
      </svg>
      <span class="text-[12px] mt-1 text-black">Contact</span>
    </a>

    <!-- Profile -->
    <a href="<%=request.getContextPath()%>/profile" class="cursor-pointer flex flex-col items-center justify-center p-2 group">
      <svg class="w-7 h-7 transition-colors" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M16 7C16 9.20914 14.2091 11 12 11C9.79086 11 8 9.20914 8 7C8 4.79086 9.79086 3 12 3C14.2091 3 16 4.79086 16 7Z"
              stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
        <path d="M12 14C8.13401 14 5 17.134 5 21H19C19 17.134 15.866 14 12 14Z"
              stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
      </svg>
      <span class="text-[12px] mt-1 text-black">Profile</span>
    </a>

  </div>
</div>

<style>
  .active-nav svg,
  .active-nav span {
    color: var(--green) !important;
    stroke: var(--green) !important;
  }
</style>

<script>
  const currentPath = window.location.pathname.toLowerCase();
  const navLinks = document.querySelectorAll('.fixed a');

  navLinks.forEach(link => {
    const href = link.getAttribute('href').toLowerCase();
    if (href !== '#' && (currentPath === href || currentPath.endsWith(href))) {
      link.classList.add('active-nav');
    } else {
      link.classList.remove('active-nav');
    }
  });
</script>
