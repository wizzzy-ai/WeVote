<%-- Testimonial Section - Soft Black/Grey Theme --%>
<style>
    .testimonial-slide { display: none; }
    .testimonial-slide.active { display: block; animation: slideFade 0.5s ease-out; }
    .rough-texture {
        background-color: white;
        background-image: url("https://www.transparenttextures.com"); /* Subtle rough grain */
    }
    @keyframes slideFade {
        from { opacity: 0; transform: translateX(10px); }
        to { opacity: 1; transform: translateX(0); }
    }
</style>

<div class="rough-texture py-10 px-3 sm:px-4 lg:px-6 transition-colors duration-500 mt-[-10px] sm:mt-[-10px]">
    <div class="max-w-3xl mx-auto relative">
        
        <!-- Header -->
        <div class="text-center mb-8">
            <h2 class="text-2xl font-extrabold text-black tracking-tight sm:text-3xl">User Feedback</h2>
            <p class="mt-2 text-base text-gray-700">Real stories from verified voters using our platform.</p>
        </div>

        <!-- Slideshow Container -->
        <div class="relative  border rounded-xl p-6 md:p-10 shadow-xl backdrop-blur-sm  text-black">
            
            <!-- Slide 1 -->
            <div class="testimonial-slide active">
                <div class="flex flex-col items-center">
                    <blockquote class="text-center">
                        <p class="text-lg md:text-xl font-medium text-black leading-relaxed italic">
                            "The security protocols gave me total confidence. Finally, a digital voting system that feels as official as the polling station but ten times faster."
                        </p>
                    </blockquote>
                    <div class="mt-6 flex items-center justify-center space-x-3">
                        <div class="h-10 w-10 rounded-full bg-gradient-to-tr from-blue-600 to-zinc-700 flex items-center justify-center font-bold text-white shadow-lg">JD</div>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-black">James D. Miller</p>
                            <p class="text-xs text-gray-500">Election Official</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Slide 2 -->
            <div class="testimonial-slide">
                <div class="flex flex-col items-center">                  
                    <blockquote class="text-center">
                        <p class="text-lg md:text-xl font-medium text-black leading-relaxed italic">
                            "I voted from my phone while waiting for my coffee. The interface is intuitive, and the verification email arrived instantly. Highly recommended!"
                        </p>
                    </blockquote>
                    <div class="mt-6 flex items-center justify-center space-x-3">
                        <div class="h-10 w-10 rounded-full bg-gradient-to-tr from-purple-600 to-zinc-700 flex items-center justify-center font-bold text-white shadow-lg">SC</div>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-blacke">Sarah Chen</p>
                            <p class="text-xs text-gray-500">Student Voter</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Slide 3 -->
            <div class="testimonial-slide">
                <div class="flex flex-col items-center">                  
                    <blockquote class="text-center">
                        <p class="text-lg md:text-xl font-medium text-black leading-relaxed italic">
                            "The audit trail gave us peace of mind. Every vote was accounted for without question."
                        </p>
                    </blockquote>
                    <div class="mt-6 flex items-center justify-center space-x-3">
                        <div class="h-10 w-10 rounded-full bg-gradient-to-tr from-green-600 to-zinc-700 flex items-center justify-center font-bold text-white shadow-lg">AK</div>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-black">Anita Kumar</p>
                            <p class="text-xs text-gray-500">Community Organizer</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Slide 4 -->
            <div class="testimonial-slide">
                <div class="flex flex-col items-center">                  
                    <blockquote class="text-center">
                        <p class="text-lg md:text-xl font-medium text-black leading-relaxed italic">
                            "Fast, secure, and transparent. This platform has changed how our group approaches elections."
                        </p>
                    </blockquote>
                    <div class="mt-6 flex items-center justify-center space-x-3">
                        <div class="h-10 w-10 rounded-full bg-gradient-to-tr from-red-600 to-zinc-700 flex items-center justify-center font-bold text-white shadow-lg">MT</div>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-black">Michael Thompson</p>
                            <p class="text-xs text-gray-500">Tech Lead</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Nav Arrows -->
            <div class="absolute inset-y-0 left-0 flex items-center">
                <button onclick="changeSlide(-1)" class="ml-2 md:-ml-4 bg-zinc-800 hover:bg-zinc-700 text-white p-2 rounded-full transition-all focus:outline-none border border-zinc-700 shadow-lg">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
                </button>
            </div>
            <div class="absolute inset-y-0 right-0 flex items-center">
                <button onclick="changeSlide(1)" class="mr-2 md:-mr-4 bg-zinc-800 hover:bg-zinc-700 text-white p-2 rounded-full transition-all focus:outline-none border border-zinc-700 shadow-lg">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" /></svg>
                </button>
            </div>
        </div>

        <!-- Dot Indicators -->
        <div class="flex justify-center mt-6 space-x-2">
            <button onclick="setSlide(0)" class="dot h-2 w-6 rounded-full bg-zinc-700 transition-all duration-300"></button>
            <button onclick="setSlide(1)" class="dot h-2 w-6 rounded-full bg-zinc-700 transition-all duration-300 hover:bg-zinc-500"></button>
            <button onclick="setSlide(2)" class="dot h-2 w-6 rounded-full bg-zinc-700 transition-all duration-300 hover:bg-zinc-500"></button>
            <button onclick="setSlide(3)" class="dot h-2 w-6 rounded-full bg-zinc-700 transition-all duration-300 hover:bg-zinc-500"></button>
        </div>
    </div>
</div>

<script>
    let slideIndex = 0;
    const slides = document.getElementsByClassName("testimonial-slide");
    const dots = document.getElementsByClassName("dot");

    function showSlides(n) {
        if (n >= slides.length) slideIndex = 0;
        if (n < 0) slideIndex = slides.length - 1;
        
        for (let i = 0; i < slides.length; i++) {
            slides[i].classList.remove("active");
            dots[i].classList.replace("bg-[var(--green)]", "bg-zinc-700");
            dots[i].classList.replace("w-6", "w-4"); // Shrink inactive dots
        }
        
        slides[slideIndex].classList.add("active");
        dots[slideIndex].classList.replace("bg-zinc-700", "bg-[var(--green)]");
        dots[slideIndex].classList.replace("w-4", "w-6"); // Grow active dot
    }

    function changeSlide(n) {
        showSlides(slideIndex += n);
    }

    function setSlide(n) {
        showSlides(slideIndex = n);
    }

    // Auto-rotate every 2 seconds
    let autoPlay = setInterval(() => changeSlide(1), 2000);

    // Pause auto-rotate on hover
    const container = document.querySelector('.rough-texture');
    container.addEventListener('mouseenter', () => clearInterval(autoPlay));
    container.addEventListener('mouseleave', () => autoPlay = setInterval(() => changeSlide(1), 2000));
</script>