<!-- Back to Homepage Button -->
<button id="home-button" onclick="goHome()" title="Back to Homepage"
    class="cursor-pointer fixed z-50 top-4 left-4 p-3 sm:p-4 border-0 w-10 h-10 sm:w-14 sm:h-14 rounded-full shadow-md bg-[var(--purple)] hover:bg-[var(--purple-light)] text-white text-lg font-semibold transition-colors duration-300">
    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24" class="w-5 h-5 sm:w-6 sm:h-6">
        <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
    </svg>
    <span class="sr-only">Back to Homepage</span>
</button>

<script>
    function goHome() {
        // Redirect to homepage (context path root)
        window.location.href = "${pageContext.request.contextPath}/";
    }
</script>