<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>

<body class="text-slate-800 antialiased min-h-screen bg-[radial-gradient(circle_at_0%_0%,#e2e8f0_0%,#f8fafc_100%)]">

<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>

<main class="pt-20">

    <section id="terms" class="relative overflow-hidden">
        <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full h-96 bg-indigo-400/20 blur-[150px] -z-10"></div>

        <header class="py-20 px-6 text-center">
            <div class="max-w-4xl mx-auto">
                <span class="text-indigo-600 font-bold tracking-[0.2em] uppercase text-sm mb-4 block">Legal Framework</span>

                <h1 class="text-5xl md:text-6xl font-extrabold tracking-tight mb-8 text-slate-900 relative inline-block group">
                    Terms of Service
                    <span class="absolute left-0 -bottom-2 h-1 w-10 rounded bg-gradient-to-r from-indigo-500 to-purple-500 transition-all duration-300 group-hover:w-full"></span>
                </h1>

                <p class="text-slate-600 text-lg md:text-xl font-light max-w-2xl mx-auto leading-relaxed">
                    Rules and regulations governing the secure, transparent, and fair operation of the SecureVote ecosystem.
                </p>

                <div class="mt-8 inline-flex items-center gap-2 bg-white/70 border border-slate-200 px-4 py-2 rounded-full text-xs font-medium text-slate-700 shadow-sm">
                    <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                    Version 2.4 | Last Updated: February 2026
                </div>
            </div>
        </header>

        <div class="max-w-4xl mx-auto pb-20 px-6 space-y-6">

            <div class="scroll-reveal opacity-0 translate-y-8 transition-all duration-700 ease-out bg-white/70 backdrop-blur-xl border border-slate-200 hover:border-indigo-400 hover:shadow-[0_0_30px_rgba(99,102,241,0.15)] p-10 rounded-3xl shadow-sm">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-slate-300">01</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-slate-900">Introduction & Agreement</h2>
                        <p class="text-slate-600 leading-relaxed">
                            By accessing SecureVote, you enter into a legally binding agreement. 
                            Our platform utilizes advanced cryptographic primitives to ensure that 
                            every vote is cast as intended and remains strictly confidential.
                        </p>
                    </div>
                </div>
            </div>

            <div class="scroll-reveal opacity-0 translate-y-8 transition-all duration-700 ease-out bg-white/70 backdrop-blur-xl border border-slate-200 hover:border-indigo-400 hover:shadow-[0_0_30px_rgba(99,102,241,0.15)] p-10 rounded-3xl shadow-sm">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-slate-300">02</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-slate-900">User Eligibility & Conduct</h2>
                        <ul class="space-y-4 text-slate-600">
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Identity must be verified via authorized election credentials.
                            </li>
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Manipulation, injection attacks, or automation is strictly prohibited.
                            </li>
                            <li class="flex items-center gap-3">
                                <span class="h-1.5 w-1.5 rounded-full bg-indigo-500"></span>
                                Users maintain full responsibility for MFA device security.
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <div class="max-w-4xl mx-auto px-6">
        <div class="h-px bg-gradient-to-r from-transparent via-slate-300 to-transparent"></div>
    </div>

    <section id="privacy" class="relative">
        <header class="py-20 px-6 text-center">
            <div class="max-w-4xl mx-auto">

                <h1 class="text-5xl md:text-6xl font-extrabold tracking-tight mb-8 text-slate-900 relative inline-block group">
                    Privacy Policy
                    <span class="absolute left-0 -bottom-2 h-1 w-10 rounded bg-gradient-to-r from-indigo-500 to-purple-500 transition-all duration-300 group-hover:w-full"></span>
                </h1>

                <p class="text-slate-600 text-lg md:text-xl font-light max-w-2xl mx-auto leading-relaxed">
                    Zero-knowledge architecture. Your identity is your own; your ballot is a secret.
                </p>

                <div class="mt-8 flex justify-center gap-4">
                    <span class="px-4 py-1.5 bg-indigo-500/10 border border-indigo-300 rounded text-indigo-700 text-xs font-bold uppercase tracking-widest">GDPR</span>
                    <span class="px-4 py-1.5 bg-purple-500/10 border border-purple-300 rounded text-purple-700 text-xs font-bold uppercase tracking-widest">CCPA</span>
                </div>
            </div>
        </header>

        <div class="max-w-4xl mx-auto pb-32 px-6 space-y-6">

            <div class="scroll-reveal opacity-0 translate-y-8 transition-all duration-700 ease-out bg-white/70 backdrop-blur-xl border border-slate-200 hover:border-indigo-400 hover:shadow-[0_0_30px_rgba(99,102,241,0.15)] p-10 rounded-3xl shadow-sm">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-slate-300">01</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-slate-900">Data Collection & Minimalist Scope</h2>
                        <p class="text-slate-600 leading-relaxed">
                            We adhere to the principle of data minimization. We only collect the necessary 
                            PII required for verification. Once your cryptographic token is generated, 
                            your personal identity is decoupled from your ballot data.
                        </p>
                    </div>
                </div>
            </div>

            <div class="scroll-reveal opacity-0 translate-y-8 transition-all duration-700 ease-out bg-white/70 backdrop-blur-xl border border-slate-200 hover:border-indigo-400 hover:shadow-[0_0_30px_rgba(99,102,241,0.15)] p-10 rounded-3xl shadow-sm">
                <div class="flex items-start gap-6">
                    <span class="text-4xl font-black text-slate-300">02</span>
                    <div>
                        <h2 class="text-2xl font-bold mb-4 text-slate-900">Cryptographic Separation</h2>
                        <p class="text-slate-600 leading-relaxed">
                            SecureVote employs sharded database architecture. Authentication logs and 
                            voting records are stored in logically and physically separate environments, 
                            ensuring that even in a breach, a vote cannot be traced back to a specific individual.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </section>

</main>

<%@ include file="/WEB-INF/views/fragment/footer.jsp" %>

<script>
    const observerOptions = {
        threshold: 0.15,
        rootMargin: "0px 0px -50px 0px"
    };

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.remove('opacity-0', 'translate-y-8');
                entry.target.classList.add('opacity-100', 'translate-y-0');
                obs.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.scroll-reveal').forEach(el => {
        observer.observe(el);
    });
</script>

</body>
</html>