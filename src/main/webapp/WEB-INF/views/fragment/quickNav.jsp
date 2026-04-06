<!-- Quick Home + Logout Buttons -->
<div class="fixed z-50 top-4 left-4 flex items-center gap-3">
    <button onclick="quickGoHome()" title="Back to Homepage"
        class="cursor-pointer p-3 sm:p-4 border-0 w-10 h-10 sm:w-14 sm:h-14 rounded-full shadow-md bg-[var(--purple)] hover:bg-[var(--purple-light)] text-white text-lg font-semibold transition-colors duration-300">
        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24" class="w-5 h-5 sm:w-6 sm:h-6">
            <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
        </svg>
        <span class="sr-only">Back to Homepage</span>
    </button>
</div>

<div class="fixed z-50 top-4 right-4 flex items-center gap-3">
    <a href="<%=request.getContextPath()%>/logout" title="Logout"
       class="cursor-pointer p-3 sm:p-4 border-0 w-10 h-10 sm:w-14 sm:h-14 rounded-full shadow-md bg-[var(--green)] hover:bg-emerald-500 text-white text-lg font-semibold transition-colors duration-300">
        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24" class="w-5 h-5 sm:w-6 sm:h-6">
            <path d="M16 17v1a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v1h-2V6H6v12h8v-1h2zm3.59-5-4.3-4.29-1.41 1.41L15.17 11H9v2h6.17l-1.29 1.88 1.41 1.41 4.3-4.29a1 1 0 0 0 0-1.42z"/>
        </svg>
        <span class="sr-only">Logout</span>
    </a>
</div>

<script>
    function quickGoHome() {
        window.location.href = "<%=request.getContextPath()%>/";
    }
</script>

