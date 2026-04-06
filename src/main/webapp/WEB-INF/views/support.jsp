<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.bascode.model.entity.SupportConversation,com.bascode.model.entity.SupportMessage,com.bascode.model.entity.User,com.bascode.model.enums.SupportSender,com.bascode.util.HtmlUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
  <title>Support - Voting System</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/chat.css">
  <style>
    .chat-h { height: calc(100vh - 240px); }
    @media (max-width: 768px) { .chat-h { height: auto; } }
  </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>

<%
  User me = (User) request.getAttribute("user");
  SupportConversation conversation = (SupportConversation) request.getAttribute("conversation");

  @SuppressWarnings("unchecked")
  List<SupportMessage> messages = (List<SupportMessage>) request.getAttribute("messages");
  if (messages == null) messages = Collections.emptyList();

  SupportMessage last = (SupportMessage) request.getAttribute("lastMessage");

  Map<Long, SupportMessage> messageById = new HashMap<>();
  for (SupportMessage m : messages) {
    if (m != null && m.getId() != null) {
      messageById.put(m.getId(), m);
    }
  }

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a");
  String err = request.getParameter("err");
%>

<section class="max-w-6xl mx-auto pt-28 px-4 pb-10">

  <% if ("empty".equalsIgnoreCase(err)) { %>
    <div class="mb-4 rounded-2xl p-4 border bg-amber-50 border-amber-200 text-amber-900">
      <div class="font-semibold">Type a message before sending.</div>
    </div>
  <% } else if ("system".equalsIgnoreCase(err)) { %>
    <div class="mb-4 rounded-2xl p-4 border bg-red-50 border-red-200 text-red-800">
      <div class="font-semibold">A system error occurred. Please try again.</div>
    </div>
  <% } %>

  <div class="">
    <div class="flex flex-col md:flex-row">

      <!-- Sidebar (user has exactly one thread with admin) -->
      <aside class="md:w-80 w-full border border-black border-[1px] bg-white/40">
        <div class="p-4">
          <div class="text-xs font-bold tracking-widest text-gray-500">SUPPORT</div>
          <div class="text-sm text-gray-600 mt-1">Your conversation with admin.</div>
        </div>

        <div class="px-3 pb-3">
          <div class="rounded-2xl p-3 border bg-white/70 border-gray-100">
            <div class="flex items-start justify-between gap-2">
              <div class="min-w-0">
                <div class="flex items-center gap-2">
                  <img alt="logo" src="${pageContext.request.contextPath}/images/logos/fingerPrint.png" class="justify-center w-8 h-8">
                  <div class="min-w-0">
                    <div class="font-extrabold text-gray-900 truncate">Admin Support</div>
                    <div class="text-xs text-gray-500 truncate">WeReply within business hours</div>
                  </div>
                </div>
                <div class="mt-2 text-sm text-gray-700 truncate">
                  <%
                    String preview = last != null ? HtmlUtil.ellipsize(last.getBody(), 70) : "No messages yet";
                  %>
                  <%= HtmlUtil.escape(preview) %>
                </div>
              </div>
              <div class="text-[11px] text-gray-500 whitespace-nowrap">
                <%
                  String when = last != null && last.getCreatedAt() != null ? fmt.format(last.getCreatedAt()) : "";
                %>
                <%= HtmlUtil.escape(when) %>
              </div>
            </div>
          </div>
        </div>
      </aside>

      <!-- Chat -->
      <section class="flex-1 flex flex-col bg-gradient-to-b from-white/60 via-white/40 to-white/60">
        <div class="p-4 border-b border-gray-100 flex items-center justify-between">
          <div class="flex items-center gap-3 min-w-0">
            <div class="min-w-0">
              <div class="font-extrabold text-gray-900 truncate">Admin Support</div>
              <div class="text-xs text-gray-600 truncate">
                <%
                  String who = me != null ? (me.getFirstName() + " " + me.getLastName()) : "You";
                %>
                Chatting as <%= HtmlUtil.escape(who) %>
              </div>
            </div>
          </div>
          <div class="hidden md:flex items-center gap-2 text-xs text-gray-500">
            <span class="chat-dot"></span>
            Secure thread
          </div>
        </div>

        <div id="chatHistory" class="flex-1 chat-scrollbar overflow-y-auto p-4 space-y-3 chat-h">
          <%
            if (messages.isEmpty()) {
          %>
            <div class="rounded-2xl bg-white/70 border border-gray-100 p-5 text-sm text-gray-700">
              Send a message to start the conversation.
            </div>
          <%
            } else {
              for (SupportMessage m : messages) {
                boolean fromUser = (m.getSender() == SupportSender.USER);
                String body = HtmlUtil.escapeWithBr(m.getBody());
                String ts = m.getCreatedAt() != null ? fmt.format(m.getCreatedAt()) : "";
          %>
            <div class="w-full flex <%= fromUser ? "justify-end" : "justify-start" %>">
              <div id="msg-<%= m.getId() %>" class="chat-bubble rounded-2xl px-4 py-3 <%= fromUser ? "chat-bubble-user" : "chat-bubble-admin" %>">
                <%
                  Long replyId = m.getReplyToMessageId();
                  SupportMessage original = replyId != null ? messageById.get(replyId) : null;
                  String origSender = original != null
                          ? (original.getSender() == SupportSender.USER ? "You" : "Admin")
                          : "Message unavailable";
                  String origText = original != null ? HtmlUtil.ellipsize(original.getBody(), 120) : "";
                %>
                <% if (replyId != null) { %>
                  <div class="mb-2 rounded-xl bg-white/70 border border-gray-100 px-3 py-2 text-xs text-gray-700 cursor-pointer"
                       data-reply-target="msg-<%= replyId %>">
                    <div class="font-bold text-gray-900"><%= HtmlUtil.escape(origSender) %> <span class="text-gray-500">#<%= replyId %></span></div>
                    <div class="text-gray-600"><%= HtmlUtil.escape(origText) %></div>
                  </div>
                <% } %>
                <div class="text-sm text-gray-900 whitespace-pre-wrap"><%= body %></div>
                <div class="mt-2 flex items-center justify-between gap-3 text-[11px] text-gray-500">
                  <button type="button"
                          class="text-[11px] font-semibold text-[var(--purple)] hover:underline"
                          data-reply-btn
                          data-reply-id="<%= m.getId() %>"
                          data-reply-sender="<%= HtmlUtil.escape(fromUser ? "You" : "Admin") %>"
                          data-reply-text="<%= HtmlUtil.escape(m.getBody()) %>">
                    Reply
                  </button>
                  <div><%= HtmlUtil.escape(ts) %></div>
                </div>
              </div>
            </div>
          <%
              }
            }
          %>
        </div>

        <div class="p-4 border-t border-gray-100 bg-white/60">
          <form method="post" action="<%=request.getContextPath()%>/support" class="flex items-end gap-3">
            <input type="hidden" name="replyToMessageId" id="replyToMessageId" value=""/>
            <div class="flex-1">
              <label class="sr-only" for="msg">Message</label>
              <div id="replyPreview" class="hidden mb-2 rounded-2xl border border-gray-100 bg-white/80 px-4 py-3">
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <div class="text-xs font-bold text-gray-700">Replying to <span id="replySender"></span> <span class="text-gray-400">#</span><span id="replyId"></span></div>
                    <div id="replyText" class="text-xs text-gray-600 mt-1 truncate"></div>
                  </div>
                  <button type="button" id="replyCancel"
                          class="text-xs font-semibold text-gray-500 hover:text-gray-800">
                    Cancel
                  </button>
                </div>
              </div>
              <div class="flex items-start justify-between gap-4">
               <div class="flex flex-col flex-1">
              <textarea id="msg" name="message" rows="1"
                        class="w-full resize-none px-4 py-3 rounded-2xl border border-gray-200 bg-white/90 focus:outline-none focus:ring-2 focus:ring-[var(--green)] transition"
                        placeholder="Type your message..."></textarea>
              <p class="text-[11px] text-gray-500 mt-2">Enter to send, Shift+Enter for a new line.</p>
           	 </div>
           	
            <button type="submit"
			class="h-12 px-5 rounded-2xl bg-gradient-to-r from-[var(--purple-light)] cursor-pointer 
			to-[var(--purple)] text-white font-extrabold hover:brightness-95 hover:shadow transition flex items-center gap-2">
              <span>Send</span>
            </button>
             </div>
            </div>
          </form>
        </div>
      </section>
    </div>
  </div>
  <%
    String userRole = session != null ? (String) session.getAttribute("userRole") : null;
      if ("CONTESTER".equalsIgnoreCase(userRole)) {
  %>
    <%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %>
  <%
    } else {
  %>
    <%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp" %>
  <%
    }
  %>
</section>

<script type="text/javascript">
  (function () {
    var history = document.getElementById('chatHistory');
    if (history) history.scrollTop = history.scrollHeight;

    var ta = document.getElementById('msg');
    var replyPreview = document.getElementById('replyPreview');
    var replySender = document.getElementById('replySender');
    var replyText = document.getElementById('replyText');
    var replyId = document.getElementById('replyId');
    var replyInput = document.getElementById('replyToMessageId');
    var replyCancel = document.getElementById('replyCancel');

    function decodeHtml(s) {
      var t = document.createElement('textarea');
      t.innerHTML = s || '';
      return t.value;
    }

    function setReply(id, sender, text) {
      if (!id) return;
      replyInput.value = id;
      replySender.textContent = sender || 'Unknown';
      replyId.textContent = id;
      replyText.textContent = decodeHtml((text || '')).slice(0, 160);
      replyPreview.classList.remove('hidden');
      if (ta) ta.focus();
    }

    function clearReply() {
      replyInput.value = '';
      replyPreview.classList.add('hidden');
      replySender.textContent = '';
      replyText.textContent = '';
      replyId.textContent = '';
    }

    if (replyCancel) replyCancel.addEventListener('click', clearReply);

    document.querySelectorAll('[data-reply-btn]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        setReply(btn.getAttribute('data-reply-id'),
                 btn.getAttribute('data-reply-sender'),
                 btn.getAttribute('data-reply-text'));
      });
    });

    // Long-press (mobile) to reply
    document.querySelectorAll('[data-reply-btn]').forEach(function (btn) {
      var timer = null;
      var parent = btn.closest('.chat-bubble');
      if (!parent) return;
      parent.addEventListener('touchstart', function () {
        timer = setTimeout(function () {
          setReply(btn.getAttribute('data-reply-id'),
                   btn.getAttribute('data-reply-sender'),
                   btn.getAttribute('data-reply-text'));
        }, 550);
      }, {passive: true});
      parent.addEventListener('touchend', function () { if (timer) clearTimeout(timer); });
      parent.addEventListener('touchmove', function () { if (timer) clearTimeout(timer); });
    });

    // Scroll to quoted message
    document.querySelectorAll('[data-reply-target]').forEach(function (el) {
      el.addEventListener('click', function () {
        var targetId = el.getAttribute('data-reply-target');
        var target = document.getElementById(targetId);
        if (!target) return;
        target.scrollIntoView({behavior: 'smooth', block: 'center'});
        target.classList.add('ring-2', 'ring-[var(--green)]');
        setTimeout(function () {
          target.classList.remove('ring-2', 'ring-[var(--green)]');
        }, 1200);
      });
    });
    if (!ta) return;

    function appendMessage(msg) {
      if (!history) return;
      var wrap = document.createElement('div');
      wrap.className = 'w-full flex justify-end';
      wrap.innerHTML =
        '<div id="msg-' + msg.id + '" class="chat-bubble rounded-2xl px-4 py-3 chat-bubble-user">' +
          '<div class="text-sm text-gray-900 whitespace-pre-wrap"></div>' +
          '<div class="mt-2 flex items-center justify-between gap-3 text-[11px] text-gray-500">' +
            '<span></span>' +
            '<div>' + (msg.timestamp || '') + '</div>' +
          '</div>' +
        '</div>';
      wrap.querySelector('.text-sm').textContent = msg.body || '';
      history.appendChild(wrap);
      history.scrollTop = history.scrollHeight;
    }

    function sendMessageAjax(form) {
      var body = ta.value || '';
      if (!body.trim()) return;
      var data = new FormData(form);
      fetch(form.action, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest', 'Accept': 'application/json' },
        body: data
      })
      .then(function (r) {
        if (!r.ok) throw new Error('send failed');
        return r.json();
      })
      .then(function (json) {
        appendMessage(json);
        ta.value = '';
        clearReply();
      })
      .catch(function () {
        // fallback to full submit if ajax fails
        form.submit();
      });
    }

    var form = ta.form;
    if (form) {
      form.addEventListener('submit', function (e) {
        e.preventDefault();
        sendMessageAjax(form);
      });
    }

    ta.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        if (form) sendMessageAjax(form);
      }
    });
  })();
</script>

</body>
</html>
