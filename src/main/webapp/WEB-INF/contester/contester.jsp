<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.bascode.model.entity.User,com.bascode.model.entity.Contester" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Contester Dashboard - Voting System</title>
  <style>
    @keyframes fadeUp { from { opacity: 0; transform: translateY(12px);} to { opacity: 1; transform: translateY(0);} }
    .fade-up { animation: fadeUp .5s ease-out both; }
    .glass {
      background: linear-gradient(135deg, rgba(255,255,255,.92), rgba(255,255,255,.8));
      border: 1px solid rgba(0,0,0,.06);
      backdrop-filter: blur(10px);
    }
    .manifesto-backdrop {
      position: fixed;
      inset: 0;
      background: rgba(15, 23, 42, 0.55);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 40;
      padding: 1.5rem;
    }
    .manifesto-card {
      width: 100%;
      max-width: 640px;
      background: white;
      border-radius: 1.5rem;
      box-shadow: 0 20px 60px rgba(15, 23, 42, 0.25);
    }
    .manifesto-card textarea {
      min-height: 160px;
    }
  </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>

<%
  User user = (User) request.getAttribute("user");
  Contester contester = (Contester) request.getAttribute("contester");
  Long voteCount = (Long) request.getAttribute("voteCount");
  if (voteCount == null) voteCount = 0L;
  boolean votingOpen = request.getAttribute("votingOpen") != null && (Boolean) request.getAttribute("votingOpen");
  boolean hasVoted = request.getAttribute("hasVoted") != null && (Boolean) request.getAttribute("hasVoted");
  String closedReason = (String) request.getAttribute("votingClosedReason");
  boolean needsManifesto = contester != null && (contester.getManifesto() == null || contester.getManifesto().trim().isEmpty());
%>

<section class="max-w-5xl mx-auto pt-6 px-4 pb-20">
  <%
    String msg = request.getParameter("msg");
    String type = request.getParameter("type");
  %>
  <% if (msg != null && !msg.trim().isEmpty()) { %>
    <div class="fade-up mb-4 rounded-2xl p-4 border
      <%= "success".equalsIgnoreCase(type) ? "bg-green-50 border-green-200 text-green-800" : "bg-red-50 border-red-200 text-red-800" %>">
      <div class="font-semibold"><%= msg %></div>
    </div>
  <% } %>
  <div class="fade-up glass rounded-3xl shadow-xl p-6 md:p-8">
    <div class="flex items-start justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Contester Dashboard</h1>
        <p class="text-gray-600 mt-1">
          Welcome <%= user != null ? user.getFirstName() : "" %>. Track your application and votes.
        </p>
      </div>
      <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
    </div>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5">
      <div class="fade-up rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <h2 class="text-sm font-semibold text-gray-600">My Profile</h2>
        <p class="text-lg font-bold text-gray-900 mt-1"><%= user != null ? (user.getFirstName() + " " + user.getLastName()) : "" %></p>
        <a class="inline-flex mt-4 px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition"
           href="<%=request.getContextPath()%>/profile">Manage Profile</a>
      </div>

      <div id="status" class="fade-up rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5" style="animation-delay:.05s;">
        <h2 class="text-sm font-semibold text-gray-600">Apply / Status</h2>
        <% if (contester != null) { %>
          <p class="text-lg font-bold text-gray-900 mt-1"><%= contester.getStatus() %></p>
          <p class="text-sm text-gray-600 mt-1">Position: <span class="font-semibold text-gray-800"><%= contester.getPosition() %></span></p>
        <% } else { %>
          <p class="text-lg font-bold text-gray-900 mt-1">Not Found</p>
          <p class="text-sm text-gray-600 mt-1">No contester application is linked to your account.</p>
        <% } %>
      </div>

      <div class="fade-up rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5" style="animation-delay:.1s;">
        <h2 class="text-sm font-semibold text-gray-600">Amount of Votes</h2>
        <p class="text-3xl font-extrabold text-gray-900 mt-2"><%= voteCount %></p>
        <p class="text-sm text-gray-600 mt-1">Total votes for your candidacy.</p>
      </div>

      <div class="fade-up rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5" style="animation-delay:.15s;">
        <h2 class="text-sm font-semibold text-gray-600">View Candidates</h2>
        <p class="text-sm text-gray-600 mt-1">See the approved contesters list.</p>
        <a class="inline-flex mt-4 px-4 py-2 rounded-xl bg-[var(--green)] text-white font-semibold hover:brightness-95 hover:shadow transition"
           href="<%=request.getContextPath()%>/contester/candidates">Open Candidates</a>
      </div>
    </div>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="fade-up rounded-2xl border border-gray-100 bg-white p-5" style="animation-delay:.2s;">
        <h3 class="text-lg font-bold text-gray-900">Vote for Yourself</h3>
        <p class="mt-2 text-sm text-gray-600">As a contester, you can vote for yourself once.</p>
        <%
          boolean approved = contester != null && contester.getStatus() != null && "APPROVED".equalsIgnoreCase(contester.getStatus().name());
          boolean canSelfVote = approved && votingOpen && !hasVoted;
        %>
        <% if (!votingOpen) { %>
          <div class="mt-3 text-sm text-red-700"><%= closedReason != null ? closedReason : "Voting is closed." %></div>
        <% } %>
        <form method="post" action="<%=request.getContextPath()%>/contester/vote-self" class="mt-4">
          <button type="submit"
                  class="px-4 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 hover:shadow transition disabled:opacity-50"
                  <%= canSelfVote ? "" : "disabled" %>>
            <%= canSelfVote ? "Vote for Yourself" : "Unavailable" %>
          </button>
        </form>
      </div>

      <div class="fade-up rounded-2xl border border-gray-100 bg-white p-5" style="animation-delay:.25s;">
        <h3 class="text-lg font-bold text-gray-900">View Results</h3>
        <p class="mt-2 text-sm text-gray-600">See the current vote counts (read-only).</p>
        <a href="<%=request.getContextPath()%>/results"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition">
          View Results
        </a>
      </div>
    </div>

    <div class="mt-6 rounded-2xl border border-red-200 bg-red-50 p-5">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h3 class="text-lg font-bold text-red-900">Withdraw From Contest</h3>
          <p class="mt-2 text-sm text-red-700">Use this to withdraw from the contest and return to your voter flow.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <form method="post" action="<%=request.getContextPath()%>/contest/withdraw" onsubmit="return confirm('Withdraw from this contest and return to the voter dashboard?');">
            <button type="submit"
                    class="px-4 py-2 rounded-xl bg-white border border-red-200 text-red-700 font-semibold hover:bg-red-100 hover:shadow transition">
              Withdraw
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %>
</section>

<% if (needsManifesto) { %>
  <div id="manifestoModal" class="manifesto-backdrop">
    <div class="manifesto-card p-6 md:p-8">
      <h2 class="text-xl font-extrabold text-gray-900">Enter Your Manifesto</h2>
      <p class="mt-2 text-sm text-gray-600">Tell the admin why you should be approved. This will be visible to admins reviewing your application.</p>
      <form method="post" action="<%=request.getContextPath()%>/contester/manifesto" class="mt-5">
        <label class="text-xs font-semibold text-gray-700">Manifesto (max 1000 characters)</label>
        <textarea name="manifesto" maxlength="1000" required
                  class="mt-2 w-full px-4 py-3 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition"></textarea>
        <div class="mt-4 flex items-center justify-end gap-3">
          <button type="button" id="dismissManifesto"
                  class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition">
            Later
          </button>
          <button type="submit"
                  class="px-4 py-2 rounded-xl bg-[var(--green)] text-white font-semibold hover:brightness-95 hover:shadow transition">
            Submit Manifesto
          </button>
        </div>
      </form>
    </div>
  </div>
  <script>
    (function () {
      var dismiss = document.getElementById('dismissManifesto');
      var modal = document.getElementById('manifestoModal');
      if (dismiss && modal) {
        dismiss.addEventListener('click', function () {
          modal.style.display = 'none';
        });
      }
    })();
  </script>
<% } %>

</body>
</html>
