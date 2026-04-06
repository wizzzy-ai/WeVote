<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-slate-50 text-slate-900 antialiased">
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
    

    <header class="relative overflow-hidden bg-gradient-to-br from-purple-600 to-indigo-700 py-24 px-6 text-white text-center">
        <div class="absolute inset-0 opacity-10">
            <svg class="h-full w-full" fill="currentColor" viewBox="0 0 100 100" preserveAspectRatio="none">
                <path d="M0 100 C 20 0 50 0 100 100 Z"></path>
            </svg>
        </div>
        <div class="relative z-10 max-w-4xl mx-auto">
            <h1 class="text-4xl md:text-6xl font-extrabold tracking-tight mb-6">
                Redefining Democracy for the Digital Age
            </h1>
            <p class="text-lg md:text-xl text-purple-100 max-w-2xl mx-auto leading-relaxed">
                WeVote is a next-generation platform designed to make voting accessible, transparent, and unhackable. We bridge the gap between technology and civic duty.
            </p>
        </div>
    </header>

    <section class="max-w-6xl mx-auto py-20 px-6">
        <div class="grid md:grid-cols-2 gap-16 items-center">
            <div>
                <h2 class="text-3xl font-bold text-slate-900 mb-6">Our Mission & Vision</h2>
                <p class="text-slate-600 mb-6 leading-relaxed">
                    We believe that every voice deserves to be heard without fear of manipulation or exclusion. Our mission is to provide a secure, decentralized voting infrastructure that empowers organizations—from local clubs to national bodies—to conduct fair elections.
                </p>
                <div class="space-y-4">
                    <div class="flex items-start">
                        <div class="flex-shrink-0 mt-1">
                            <div class="p-1 bg-purple-100 rounded-full text-purple-600">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                            </div>
                        </div>
                        <p class="ml-4 text-slate-700 font-medium">Empowerment through accessibility</p>
                    </div>
                    <div class="flex items-start">
                        <div class="flex-shrink-0 mt-1">
                            <div class="p-1 bg-purple-100 rounded-full text-purple-600">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                            </div>
                        </div>
                        <p class="ml-4 text-slate-700 font-medium">Uncompromising data integrity</p>
                    </div>
                </div>
            </div>
            <div class="bg-white p-8 rounded-2xl shadow-xl border border-slate-100 relative">
                <div class="absolute -top-4 -right-4 bg-indigo-500 text-white px-4 py-2 rounded-lg text-sm font-bold shadow-lg">
                    Since 2024
                </div>
                <h3 class="text-xl font-bold mb-4 text-indigo-600 italic">"The ballot is stronger than the bullet."</h3>
                <p class="text-slate-500 leading-relaxed">
                    Our platform utilizes cryptographic proofs to ensure that once a vote is cast, it remains immutable and verifiable by the voter, maintaining total anonymity.
                </p>
            </div>
        </div>
    </section>

    <!-- COMPANY HISTORY (Replaced How It Works) -->
    <section class="bg-white py-20 px-6">
        <div class="max-w-6xl mx-auto">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-slate-900">Company History</h2>
                <div class="w-20 h-1.5 bg-purple-600 mx-auto mt-4 rounded-full"></div>
            </div>

            <div class="grid md:grid-cols-3 gap-8">

                <div class="group p-8 bg-slate-50 rounded-2xl border border-transparent 
                            hover:border-purple-200 hover:shadow-xl 
                            transition-all duration-300 transform hover:-translate-y-2">
                    <div class="text-4xl font-black text-purple-200 
                                group-hover:text-purple-500 transition-colors mb-4">
                        2024
                    </div>
                    <h3 class="text-xl font-bold mb-3">Foundation</h3>
                    <p class="text-slate-600">
                        WeVote was founded with a mission to modernize democratic participation 
                        through secure digital infrastructure.
                    </p>
                </div>

                <div class="group p-8 bg-slate-50 rounded-2xl border border-transparent 
                            hover:border-purple-200 hover:shadow-xl 
                            transition-all duration-300 transform hover:-translate-y-2">
                    <div class="text-4xl font-black text-purple-200 
                                group-hover:text-purple-500 transition-colors mb-4">
                        2025
                    </div>
                    <h3 class="text-xl font-bold mb-3">Platform Expansion</h3>
                    <p class="text-slate-600">
                        We introduced end-to-end encryption, distributed ledger integration, 
                        and real-time vote verification capabilities.
                    </p>
                </div>

                <div class="group p-8 bg-slate-50 rounded-2xl border border-transparent 
                            hover:border-purple-200 hover:shadow-xl 
                            transition-all duration-300 transform hover:-translate-y-2">
                    <div class="text-4xl font-black text-purple-200 
                                group-hover:text-purple-500 transition-colors mb-4">
                        2026
                    </div>
                    <h3 class="text-xl font-bold mb-3">Global Reach</h3>
                    <p class="text-slate-600">
                        WeVote expanded internationally, supporting institutions 
                        and organizations seeking transparent and tamper-proof elections.
                    </p>
                </div>

            </div>
        </div>
    </section>
    
    <section class="max-w-6xl mx-auto py-20 px-6">
    <div class="text-center mb-16">
        <h2 class="text-3xl font-bold text-slate-900">Meet Our Team</h2>
        <p class="text-slate-500 mt-4">The innovators behind the platform</p>
    </div>

    <!-- First Row (3 Members) -->
    <div class="grid md:grid-cols-3 gap-8 mb-12">

        <!-- Member 1 -->
        <div class="group text-center">
            <div class="relative mb-6 inline-block">
                <div class="w-32 h-32 rounded-full overflow-hidden mx-auto
                            transform transition duration-300 
                            group-hover:scale-110 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/team/man1.jpg"
                         alt="Jane Doe"
                         class="w-full h-full object-cover">
                </div>
            </div>
            <h3 class="text-xl font-bold">Jane Doe</h3>
            <p class="text-purple-600 font-medium text-sm mb-2">CEO & Founder</p>
            <p class="text-slate-500 text-sm">
                Security expert with 10+ years in cryptographic research.
            </p>
        </div>

        <!-- Member 2 -->
        <div class="group text-center">
            <div class="relative mb-6 inline-block">
                <div class="w-32 h-32 rounded-full overflow-hidden mx-auto
                            transform transition duration-300 
                            group-hover:scale-110 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/team/man2.jpg"
                         alt="Alex Smith"
                         class="w-full h-full object-cover">
                </div>
            </div>
            <h3 class="text-xl font-bold">Alex Smith</h3>
            <p class="text-purple-600 font-medium text-sm mb-2">CTO</p>
            <p class="text-slate-500 text-sm">
                Full-stack architect specializing in distributed systems.
            </p>
        </div>

        <!-- Member 3 -->
        <div class="group text-center">
            <div class="relative mb-6 inline-block">
                <div class="w-32 h-32 rounded-full overflow-hidden mx-auto
                            transform transition duration-300 
                            group-hover:scale-110 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/team/woman.jpg"
                         alt="Maria Lopez"
                         class="w-full h-full object-cover">
                </div>
            </div>
            <h3 class="text-xl font-bold">Maria Lopez</h3>
            <p class="text-purple-600 font-medium text-sm mb-2">Product Designer</p>
            <p class="text-slate-500 text-sm">
                Dedicated to creating intuitive and accessible user experiences.
            </p>
        </div>

    </div>

    <!-- Second Row (2 Members Centered) -->
    <div class="grid md:grid-cols-2 gap-8 max-w-3xl mx-auto">

        <!-- Member 4 -->
        <div class="group text-center">
            <div class="relative mb-6 inline-block">
                <div class="w-32 h-32 rounded-full overflow-hidden mx-auto
                            transform transition duration-300 
                            group-hover:scale-110 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/team/man3.jpg"
                         alt="David Kim"
                         class="w-full h-full object-cover">
                </div>
            </div>
            <h3 class="text-xl font-bold">David Kim</h3>
            <p class="text-purple-600 font-medium text-sm mb-2">Backend Engineer</p>
            <p class="text-slate-500 text-sm">
                Specialist in secure database architecture and API development.
            </p>
        </div>

        <!-- Member 5 -->
        <div class="group text-center">
            <div class="relative mb-6 inline-block">
                <div class="w-32 h-32 rounded-full overflow-hidden mx-auto
                            transform transition duration-300 
                            group-hover:scale-110 shadow-lg">
                    <img src="${pageContext.request.contextPath}/images/team/man4.jpg"
                         alt="Sarah Johnson"
                         class="w-full h-full object-cover">
                </div>
            </div>
            <h3 class="text-xl font-bold">Sarah Johnson</h3>
            <p class="text-purple-600 font-medium text-sm mb-2">UI/UX Designer</p>
            <p class="text-slate-500 text-sm">
                Focused on accessible and intuitive digital experiences.
            </p>
        </div>

    </div>
</section>

    <%@ include file="/WEB-INF/views/fragment/footer.jsp" %>

</body>
</html>