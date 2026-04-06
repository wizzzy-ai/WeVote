<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body>
<!-- Hero Section-->
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<%@ include file="/WEB-INF/views/fragment/backToTop.jsp" %>

<section class="relative h-[80vh] 
				bg-[url('${pageContext.request.contextPath}/images/votingPic.png')]
				md:bg-[url('${pageContext.request.contextPath}/images/votingPic.png')]		 
				bg-cover bg-center flex flex-col items-center justify-center text-center 
				px-4 mt-18 md:mt-0 ">

	<!-- Quote block -->
	<div class="flex flex-row items-center justify-center space-x-2 sm:space-x-4 relative z-10 mt-12">

	 	<h2 class="font-bold text-6xl md:text-7xl text-white text-center [-webkit-text-stroke:1px_black]">
	 	we decide, we rise, <span class="green">WeVote</span>
	 	</h2>
	 
	   </div>
	 
	 
	
	<!-- CTA buttons -->
	 <div class="mt-24 flex space-x-14 relative z-10">
	 
	 	<a href="${pageContext.request.contextPath}/register.jsp" class="block font-bold cursor-pointer
           py-6 px-4 md:px-6 md:py-4 rounded-sm
           mb-2 md:mb-0
           bg-[var(--purple)] text-white
           transition-transform duration-300
           hover:scale-105 hover:y-110">
            Get Started
         </a>
	 	<a href="#how-it-works" class="block font-bold cursor-pointer
           py-3 px-4 md:px-6 md:py-4 rounded-sm
           mb-2 md:mb-0
           bg-[var(--purple)] text-white
           transition-transform duration-300
           hover:scale-105 hover:y-110">
               		  How It Works
         </a>
	 </div>
	 
</section>

<main>
<h3 class="text-center mt-4 lg:mt-10 text-lg md:text-2xl lg:text-2xl leading-relaxed">
  <img alt="company logo, WeVote"
       src="${pageContext.request.contextPath}/images/logos/logoShort.png"
       class="inline-block align-middle h-[20px] w-[120px] lg:h-[30px] lg:w-[150px] mr-2">
  is a full-service, web-based voting platform <br> designed
  to make your elections seamless, secure, & stress-free.
  <br/>
  <span class="font-semibold">Trusted results, made simple.</span>
</h3>


<!-- steps -->
<section class="px-6 py-12" id="how-it-works">
  <h2 class="text-center text-3xl md:text-4xl font-bold mb-10 text-[var(--purple)]">
    How Does It Work
  </h2>

  <div class="grid grid-cols-2 gap-8 md:grid-cols-4 text-center">
    <!-- Step 1 -->
    <div class="p-6 rounded-lg bg-white">
      <!-- Icon -->
      <div class="flex justify-center mb-4">
		<svg class="w-[200px] h-[70px]" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 392.545 392.545" 
		xml:space="preserve" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" 
		stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path style="fill:#FFFFFF;" d="M175.788,190.061c-2.844-7.176,4.396-16.873,13.77-13.834l87.467,29.091h82.747 c6.012,0,10.925-4.848,10.925-10.796V32.711c0-5.947-4.848-10.796-10.925-10.796H32.725c-6.012,0-10.925,4.848-10.925,10.796 v161.875c0,5.947,4.848,10.796,10.925,10.796H180.83L175.788,190.061z"></path> <path style="fill:#FFC10D;" d="M203.392,203.83l10.15,30.319h41.438c6.012,0,10.925,4.848,10.925,10.925 c0,6.077-4.848,10.925-10.925,10.925h-34.133l4.784,14.545h18.489c6.012,0,10.925,4.849,10.925,10.925 c0,6.012-4.848,10.925-10.925,10.925h-11.184l19.653,58.699l16.679-38.723c4.267-9.374,15.321-7.564,17.713-3.426l49.455,49.39 l21.721-21.721l-49.455-49.325c-4.719-4.396-4.849-13.834,3.426-17.778l38.788-16.614L203.392,203.83z"></path> <rect x="43.65" y="43.572" style="fill:#56ACE0;" width="305.196" height="139.96"></rect> <g> <path style="fill:#194F82;" d="M79.852,108.541c-5.042-1.228-8.21-2.327-9.568-3.232c-1.422-0.905-2.069-2.069-2.069-3.62 s0.776-5.042,6.335-5.107c4.848-0.065,9.568,1.681,14.222,5.172l5.947-8.598c-7.564-6.206-16.226-6.982-19.782-6.982 c-5.43,0-18.877,2.133-18.877,15.709c0,5.042,1.422,8.663,4.267,11.055c2.844,2.327,7.37,4.267,13.446,5.689 c3.879,0.905,6.465,1.939,7.822,2.844c1.293,0.905,1.939,2.133,1.939,3.814c0,1.681-0.646,4.848-6.982,5.172 c-4.784,0.259-10.149-2.457-15.774-7.499l-7.046,8.663c6.723,6.206,14.222,9.568,22.562,9.244 c16.937-0.646,19.329-11.184,19.329-15.903c0-4.719-1.422-8.339-4.202-10.796C88.709,111.644,84.83,109.77,79.852,108.541z"></path> <rect x="105.258" y="87.919" style="fill:#194F82;" width="11.572" height="51.911"></rect> <path style="fill:#194F82;" d="M163.569,127.677h-0.065c-2.715,1.552-6.012,2.327-10.02,2.327 c-11.636,0-14.739-11.313-14.739-16.226c0-4.848,3.491-16.291,15.709-16.291c2.327,0,10.537,3.297,12.8,5.301l6.012-8.663 c-5.495-4.848-11.96-7.37-19.459-7.37c-9.568,0-27.022,6.465-27.022,26.958c0,19.135,16.162,27.152,27.022,26.764 c9.115-0.388,16.291-2.844,21.463-8.598v-18.36h-11.636v14.158H163.569z"></path> <polygon style="fill:#194F82;" points="221.945,121.341 196.41,87.919 185.549,87.919 185.549,139.83 197.121,139.83 197.121,107.313 221.945,139.83 233.517,139.83 233.517,87.919 221.945,87.919 "></polygon> <rect x="266.034" y="87.919" style="fill:#194F82;" width="11.572" height="51.911"></rect> <polygon style="fill:#194F82;" points="302.042,107.313 326.866,139.83 338.438,139.83 338.438,87.919 326.866,87.919 326.866,121.341 301.266,87.919 290.47,87.919 290.47,139.83 302.042,139.83 "></polygon> <path style="fill:#194F82;" d="M385.048,241.261l-42.408-14.093h17.131c18.036,0,32.711-14.675,32.711-32.582V32.711 C392.483,14.675,377.808,0,359.771,0H32.725C14.689,0,0.014,14.675,0.014,32.711v161.875c0,17.907,14.675,32.582,32.711,32.582 h155.41l52.752,157.867c4.396,11.055,17.261,8.663,20.299,0.84l21.657-50.23l45.834,45.64c4.267,4.267,11.119,4.267,15.386,0 l37.172-37.107c4.008-3.491,4.848-10.667,0-15.451l-45.77-45.64l50.295-21.527C394.422,259.103,395.392,244.234,385.048,241.261z M175.788,190.19l5.107,15.321H32.725c-5.947-0.129-10.925-5.042-10.925-10.99V32.711c0-5.947,4.848-10.796,10.925-10.796h327.111 c6.012,0,10.925,4.848,10.925,10.796v161.875c0,5.947-4.848,10.796-10.925,10.796h-82.747l-87.467-29.026 C180.119,173.317,172.943,182.885,175.788,190.19z M312.127,269.446c-8.275,3.943-8.145,13.382-3.426,17.778l49.455,49.325 l-21.721,21.721l-49.455-49.39c-2.392-4.073-13.446-5.947-17.713,3.426l-16.679,38.723l-19.653-58.699h11.184 c6.012,0,10.925-4.848,10.925-10.925s-4.848-10.925-10.925-10.925h-18.554l-4.848-14.545h34.069 c6.012,0,10.925-4.848,10.925-10.925c0-6.012-4.849-10.925-10.925-10.925h-41.438l-10.15-30.319l147.523,49.067L312.127,269.446z"></path> </g> </g></svg>
      </div>
      <div class="text-4xl mb-4 text-[var(--green)] font-bold">Step 1</div>

      <p class="text-gray-600">
        Sign up easily as a <strong>contestant</strong> or a <strong>voter</strong>. Quick, secure, and stress‑free.
      </p>
    </div>

    <!-- Step 2 -->
    <div class="p-6 rounded-lg bg-white">
      <div class="flex justify-center mb-4">
        <svg height="70px" width="200px" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 473.931 473.931" xml:space="preserve" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0">
        </g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <circle style="fill:#4ABC96;" cx="236.966" cy="236.966" r="236.966"></circle> <path style="fill:#DFDFDF;" d="M397.835,204.169l-24.509-24.509l-0.041-36.916c-0.565-11.723-5.86-23.135-14.398-31.158 c-8.4-8.108-20.303-12.771-31.734-12.718h-34.66l-26.129-26.076c-8.688-7.888-20.501-12.217-32.213-11.854 c-11.671,0.206-23.382,5.321-31.431,13.444l-24.516,24.512l-36.912,0.037c-11.723,0.565-23.135,5.86-31.158,14.398 c-8.108,8.46-12.767,20.157-12.718,31.876v34.518l-26.073,26.129c-7.888,8.688-12.221,20.501-11.858,32.209 c0.21,11.674,5.325,23.386,13.448,31.435l24.509,24.527l0.041,36.901c0.565,11.723,5.86,23.135,14.398,31.161 c8.464,8.108,20.161,12.771,31.88,12.718l36.22,0.011c8.808,7.861,17.71,15.652,26.739,23.491 c8.494,6.806,19.349,10.065,29.762,9.369c10.425-0.606,20.475-5.104,27.7-12.46c7.199-7.199,14.533-14.264,21.975-21.216 c14.327-0.745,28.639-1.691,43.139-2.717c10.825-1.194,20.8-6.567,27.674-14.421c6.941-7.802,10.866-18.088,10.776-28.4 c0-9.803,0.183-19.603,0.505-29.403l31.176-31.244c7.891-8.688,12.221-20.501,11.858-32.213 C411.07,223.933,405.955,212.221,397.835,204.169z"></path> <path style="fill:#49A0AE;" d="M381.143,210.328l-23.955-23.951v-33.87c0-20.703-16.778-37.485-37.477-37.485h-33.874L261.89,91.074 c-14.645-14.642-38.375-14.642-53.013,0l-23.947,23.947h-33.874c-20.703,0-37.485,16.778-37.485,37.485v33.87l-23.955,23.951 c-14.63,14.642-14.63,38.368,0,53.01l23.955,23.951v33.874c0,20.696,16.778,37.481,37.485,37.481h33.874l23.947,23.951 c14.638,14.634,38.368,14.638,53.013,0l23.947-23.951h33.874c20.696,0,37.477-16.782,37.477-37.481v-33.874l23.955-23.951 C395.781,248.696,395.773,224.966,381.143,210.328z"></path> <g> <path style="fill:#F6EBD3;" d="M132.731,208.85l13.953,41.309l13.987-41.601c0.73-2.185,1.28-3.704,1.643-4.561 c0.359-0.857,0.965-1.624,1.804-2.309s1.987-1.029,3.442-1.029c1.066,0,2.054,0.266,2.967,0.797 c0.906,0.535,1.624,1.242,2.14,2.125c0.52,0.876,0.775,1.77,0.775,2.668c0,0.614-0.079,1.28-0.247,1.994 c-0.168,0.715-0.382,1.414-0.629,2.099c-0.254,0.688-0.505,1.396-0.76,2.125l-14.915,40.254c-0.535,1.542-1.066,3.005-1.601,4.393 c-0.535,1.388-1.149,2.608-1.848,3.656c-0.703,1.051-1.631,1.916-2.791,2.586c-1.16,0.67-2.586,1.01-4.269,1.01 c-1.684,0-3.098-0.329-4.262-0.988c-1.164-0.659-2.107-1.527-2.821-2.608c-0.707-1.074-1.336-2.301-1.863-3.674 c-0.535-1.369-1.066-2.829-1.601-4.37l-14.668-39.917c-0.247-0.73-0.513-1.448-0.775-2.144c-0.269-0.7-0.49-1.459-0.674-2.268 c-0.183-0.808-0.269-1.497-0.269-2.062c0-1.426,0.569-2.728,1.717-3.906c1.149-1.179,2.593-1.766,4.333-1.766 c2.125,0,3.633,0.651,4.516,1.949C130.898,203.918,131.804,205.995,132.731,208.85z"></path> <path style="fill:#F6EBD3;" d="M206.639,200.659c6.387,0,11.869,1.295,16.449,3.888c4.584,2.589,8.045,6.275,10.398,11.049 c2.354,4.778,3.528,10.383,3.528,16.83c0,4.763-0.644,9.092-1.931,12.988c-1.295,3.891-3.222,7.266-5.803,10.125 c-2.574,2.859-5.744,5.044-9.493,6.556c-3.757,1.512-8.052,2.268-12.898,2.268c-4.823,0-9.134-0.775-12.943-2.331 c-3.817-1.557-6.993-3.749-9.545-6.578c-2.552-2.829-4.471-6.234-5.774-10.211c-1.31-3.978-1.957-8.281-1.957-12.902 c0-4.733,0.681-9.078,2.039-13.025c1.358-3.948,3.326-7.311,5.904-10.084c2.578-2.773,5.714-4.898,9.414-6.365 C197.73,201.4,201.935,200.659,206.639,200.659z M224.378,232.345c0-4.513-0.73-8.419-2.185-11.727 c-1.463-3.304-3.536-5.803-6.241-7.498s-5.811-2.544-9.309-2.544c-2.492,0-4.793,0.468-6.915,1.411 c-2.11,0.935-3.933,2.301-5.459,4.093s-2.731,4.086-3.618,6.87c-0.883,2.791-1.325,5.919-1.325,9.396 c0,3.506,0.438,6.668,1.325,9.497s2.125,5.175,3.742,7.038c1.609,1.863,3.457,3.259,5.545,4.18c2.084,0.928,4.378,1.388,6.87,1.388 c3.195,0,6.133-0.797,8.808-2.398c2.675-1.594,4.801-4.06,6.387-7.397C223.581,241.321,224.378,237.216,224.378,232.345z"></path> <path style="fill:#F6EBD3;" d="M282.271,212.004h-13.613v44.751c0,2.578-0.576,4.49-1.725,5.736 c-1.149,1.25-2.63,1.871-4.449,1.871c-1.848,0-3.36-0.629-4.524-1.893c-1.164-1.257-1.74-3.166-1.74-5.714v-44.751h-13.616 c-2.133,0-3.712-0.471-4.752-1.407c-1.036-0.939-1.557-2.178-1.557-3.719c0-1.598,0.543-2.859,1.624-3.783 c1.074-0.924,2.638-1.384,4.685-1.384h39.67c2.155,0,3.757,0.475,4.808,1.426c1.051,0.954,1.579,2.2,1.579,3.742 s-0.535,2.78-1.601,3.719C285.998,211.533,284.4,212.004,282.271,212.004z"></path> <path style="fill:#F6EBD3;" d="M334.495,211.331h-28.108v15.128h25.885c1.901,0,3.326,0.427,4.262,1.283 c0.943,0.857,1.411,1.979,1.411,3.383c0,1.399-0.46,2.544-1.388,3.42c-0.92,0.883-2.354,1.325-4.284,1.325h-25.885v17.523h29.077 c1.957,0,3.435,0.456,4.43,1.366c0.995,0.913,1.489,2.122,1.489,3.637c0,1.459-0.498,2.642-1.489,3.547 c-0.995,0.913-2.47,1.366-4.43,1.366h-33.915c-2.72,0-4.67-0.599-5.86-1.804c-1.19-1.205-1.785-3.151-1.785-5.841v-46.308 c0-1.792,0.262-3.252,0.797-4.393c0.535-1.134,1.366-1.957,2.5-2.477c1.134-0.52,2.586-0.775,4.348-0.775h32.946 c1.987,0,3.472,0.438,4.438,1.325s1.448,2.039,1.448,3.465c0,1.459-0.483,2.63-1.448,3.51 C337.967,210.889,336.485,211.331,334.495,211.331z"></path> </g> </g></svg>
      </div>
      <div class="text-4xl mb-4 text-[var(--green)] font-bold">Step 2</div>

      <p class="text-gray-600">
        Cast your ballot online with just a click. Your vote is encrypted and protected.
      </p>
    </div>

    <!-- Step 3 -->
    <div class="p-6 rounded-lg bg-white">
      <div class="flex justify-center mb-4">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 200" width="200" height="70">
  <rect width="100%" height="100%" fill="white"/>
  <rect x="40" y="120" width="40" height="60" fill="#FF6F0F" rx="4"/>
  <rect x="100" y="90" width="40" height="90" fill="#FDCB02" rx="4"/>
  <rect x="160" y="60" width="40" height="120" fill="#3B82F6" rx="4"/>
  <rect x="220" y="30" width="40" height="150" fill="#10B981" rx="4"/>
  <polyline 
    points="60,120 120,90 180,60 240,30" 
    fill="none" 
    stroke="#6A0DAD" 
    stroke-width="4" 
    stroke-linecap="round" 
    stroke-linejoin="round"
  />
  <circle cx="60" cy="120" r="6" fill="#6A0DAD"/>
  <circle cx="120" cy="90" r="6" fill="#6A0DAD"/>
  <circle cx="180" cy="60" r="6" fill="#6A0DAD"/>
  <circle cx="240" cy="30" r="6" fill="#6A0DAD"/>

  <!-- TRACK text -->
  <text x="270" y="160" font-size="36" font-weight="bold" fill="#6A0DAD">TRACK</text>
</svg>
      </div>
      <div class="text-4xl mb-4 text-[var(--green)] font-bold">Step 3</div>
      <p class="text-gray-600">
        Follow your vote through the system with a unique tracking ID. Stay informed at every stage.
      </p>
    </div>

    <!-- Step 4 -->
    <div class="p-6 rounded-lg bg-white">
      <div class="flex justify-center mb-4">
<svg class="w-[200px] h-[100px]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="200" height="90">
  <rect width="100%" height="100%" fill="white"/>
  <circle cx="100" cy="80" r="50" fill="url(#grad)" />
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#10B981; stop-opacity:1" />
      <stop offset="50%" style="stop-color:#3B82F6; stop-opacity:1" />
      <stop offset="100%" style="stop-color:#F43F5E; stop-opacity:1" />
    </linearGradient>
  </defs>
  <polyline 
    points="80,80 95,95 120,65" 
    fill="none" 
    stroke="white" 
    stroke-width="8" 
    stroke-linecap="round" 
    stroke-linejoin="round"
  />
  <text x="100" y="160" text-anchor="middle" font-size="28" font-weight="bold" fill="#374151">
    VERIFY
  </text>
</svg>
      </div>
      <div class="text-4xl mb-4 text-[var(--green)] font-bold mt-[-25px]">Step 4</div>
      <p class="text-gray-600">
        Confirm that your vote was counted correctly. Transparent verification tools ensure complete trust in the process.
      </p>
    </div>
  </div>
</section>

<!-- info cards -->
<%@ include file="/WEB-INF/views/fragment/info.jsp" %>

<p class="text-3xl md:text-4xl text-center font-bold mb-6">Secure online voting <br/> <span class="text-[var(--green)] pop-text">you can trust!</span></p>
 </main>

<section class="bg-gray-50 py-16">
  <div class="max-w-7xl mx-auto px-6 grid gap-12 grid-cols-2 lg:grid-cols-4 text-center">
    
    <!-- Stat 1 -->
    <div>
      <!-- Icon -->
      <div class="flex justify-center mb-3">
        <svg class="w-10 h-10 text-indigo-600" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 17v-6h13V7H9V1L1 11l8 10v-4h13v-4H9z"/>
        </svg>
      </div>
      <div class="text-5xl font-extrabold text-gray-900">12+</div>
      <p class="mt-2 text-lg text-gray-600">Elections held weekly</p>
    </div>

    <!-- Stat 2 -->
    <div>
      <div class="flex justify-center mb-3">
        <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M16 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
          <circle cx="8.5" cy="7" r="4"/>
          <path d="M20 8v6M23 11h-6"/>
        </svg>
      </div>
      <div class="text-5xl font-extrabold text-gray-900">50K+</div>
      <p class="mt-2 text-lg text-gray-600">Active voters</p>
    </div>

    <!-- Stat 3 -->
    <div>
      <div class="flex justify-center mb-3">
        <svg class="w-10 h-10 text-blue-600" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <polyline points="12 6 12 12 16 14"/>
        </svg>
      </div>
      <div class="text-5xl font-extrabold text-gray-900">99.9%</div>
      <p class="mt-2 text-lg text-gray-600">System uptime</p>
    </div>

    <!-- Stat 4 -->
    <div>
      <div class="flex justify-center mb-3">
        <svg class="w-10 h-10 text-pink-600" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <path d="M12 6v6l4 2"/>
        </svg>
      </div>
      <div class="text-5xl font-extrabold text-gray-900">24/7</div>
      <p class="mt-2 text-lg text-gray-600">Support available</p>
    </div>

  </div>
</section>

<!-- wavy line -->
<!-- Wavy divider -->
<svg xmlns="http://www.w3.org/2000/svg" 
     viewBox="0 0 1440 100" 
     class="w-full h-24 animate-fadeUp">
  <path fill="#6A0DAD80" d="M0,64 C 360,20 1080,120 1440,64 L1440,100 L0,100Z"></path>
</svg>

<%@ include file="/WEB-INF/views/fragment/testimonial.jsp" %>


<%@ include file="/WEB-INF/views/fragment/footer.jsp" %>
</body>
</html>
