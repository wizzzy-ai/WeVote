<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
    <title>Contact - Voting System</title>
</head>
<body class="text-gray-900 ">

<section id="contact" class="py-20 px-15 mt-10">
  <div class="container-custom">
    <div class="grid md:grid-cols-2 gap-12 items-start">
      
      <!-- Contact Details -->
      <div>
        <h2 class="text-4xl font-extrabold mb-6">
          Get In <span class="text-green-600">Touch</span>
        </h2>
        <p class="text-lg text-gray-600 mb-8">
          Have questions or ready to book? Reach out anytime.
        </p>

        <div class="space-y-6">
          <!-- Location -->
          <div class="flex items-start">
            <svg class="h-6 w-6 text-purple-600 mt-1 mr-4 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M12 11c1.656 0 3-1.343 3-3s-1.344-3-3-3-3 1.343-3 3 1.344 3 3 3zm0 1c-2.667 0-8 1.333-8 4v2h16v-2c0-2.667-5.333-4-8-4z" />
            </svg>
            <div>
              <h3 class="font-semibold text-lg">Location</h3>
              <p class="text-gray-600">Lagos, Nigeria</p>
            </div>
          </div>

          <!-- Phone -->
          <div class="flex items-start">
            <svg class="h-6 w-6 text-green-600 mt-1 mr-4 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M3 5a2 2 0 012-2h1l2 5-2 1a11 11 0 006 6l1-2 5 2v1a2 2 0 01-2 2h-1c-6.627 0-12-5.373-12-12V5z" />
            </svg>
            <div>
              <h3 class="font-semibold text-lg">Phone</h3>
              <p class="text-gray-600">+91 9876543210</p>
            </div>
          </div>

          <!-- Email -->
          <div class="flex items-start">
            <svg class="h-6 w-6 text-purple-600 mt-1 mr-4 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M16 12l-4-4-4 4m8 0v4a2 2 0 01-2 2H6a2 2 0 01-2-2v-4m0-4a2 2 0 012-2h8a2 2 0 012 2v4z" />
            </svg>
            <div>
              <h3 class="font-semibold text-lg">Email</h3>
              <p class="text-gray-600">aptech@gmail.com</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Contact Form -->
      <div class="bg-gray-100 p-8 rounded-xl shadow-md">
        <h3 class="text-2xl font-bold mb-6 text-purple-700">Send Us a Message</h3>

        <% if (request.getAttribute("error") != null) { %>
          <div class="mb-4 p-3 bg-red-100 text-red-700 rounded"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
          <div class="mb-4 p-3 bg-green-100 text-green-700 rounded"><%= request.getAttribute("success") %></div>
        <% } %>

        <form class="space-y-6" method="post" action="<%=request.getContextPath()%>/contact">
          <div>
            <label for="name" class="block text-sm font-medium mb-1">Your Name</label>
            <input type="text" id="name" name="name" required
                   value='<%= request.getAttribute("name") != null ? String.valueOf(request.getAttribute("name")) : "" %>'
                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500"
                   placeholder="Enter your name" />
          </div>
          <div>
            <label for="email" class="block text-sm font-medium mb-1">Email Address</label>
            <input type="email" id="email" name="email" required
                   value='<%= request.getAttribute("email") != null ? String.valueOf(request.getAttribute("email")) : "" %>'
                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500"
                   placeholder="Enter your email" />
          </div>
          <div>
            <label for="message" class="block text-sm font-medium mb-1">Message</label>
            <textarea id="message" name="message" required rows="5"
                      class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500"
                      placeholder="Your message here..."><%= request.getAttribute("message") != null ? String.valueOf(request.getAttribute("message")) : "" %></textarea>
          </div>
          <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
            Send Message
          </button>
        </form>
      </div>
    </div>
  </div>
  
</section>

<%@ include file="/WEB-INF/views/fragment/backToTop.jsp" %>
<%@ include file="/WEB-INF/views/fragment/newsletter.jsp" %>
<%@ include file="/WEB-INF/views/fragment/footer.jsp" %>

</body>
</html>
