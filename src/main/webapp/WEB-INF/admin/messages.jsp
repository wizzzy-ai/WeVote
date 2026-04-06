<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.bascode.model.entity.SupportConversation,com.bascode.model.entity.SupportMessage,com.bascode.model.entity.User,com.bascode.model.enums.SupportSender,com.bascode.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Support Messages</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/chat.css">
  <style>
    /* Keep the chat panel height stable under the sticky header. */
    .chat-h { height: calc(100vh - 190px); }
    @media (max-width: 768px) { .chat-h { height: auto; } }
  </style>
</head>
<body class="admin-app">

<%
  @SuppressWarnings("unchecked")
  List<SupportConversation> conversations = (List<SupportConversation>) request.getAttribute("conversations");
  if (conversations == null) conversations = Collections.emptyList();

  SupportConversation selected = (SupportConversation) request.getAttribute("selectedConversation");

  @SuppressWarnings("unchecked")
  List<SupportMessage> messages = (List<SupportMessage>) request.getAttribute("messages");
  if (messages == null) messages = Collections.emptyList();

  @SuppressWarnings("unchecked")
  Map<Long, SupportMessage> lastByConversation = (Map<Long, SupportMessage>) request.getAttribute("lastByConversation");
  if (lastByConversation == null) lastByConversation = Collections.emptyMap();

  @SuppressWarnings("unchecked")
  Map<Long, Long> unreadByConversation = (Map<Long, Long>) request.getAttribute("unreadByConversation");
  if (unreadByConversation == null) unreadByConversation = Collections.emptyMap();

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a");

  Map<Long, SupportMessage> messageById = new HashMap<>();
  for (SupportMessage m : messages) {
    if (m != null && m.getId() != null) {
      messageById.put(m.getId(), m);
    }
  }

  request.setAttribute("adminPageTitle", "Messages");
  request.setAttribute("adminPageSubtitle", "Split-pane support inbox with unread status and threaded replies.");
  request.setAttribute("activeAdminPage", "messages");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>
<div class="mb-4 flex justify-end">
  <a href="<%=request.getContextPath()%>/admin/contact-inbox" class="admin-button-subtle px-4 py-2">Contact Form Inbox</a>
</div>
  <section class="chat-glass chat-soft-glow rounded-3xl overflow-hidden border border-gray-100">
    <div class="flex flex-col md:flex-row">
      <!-- Sidebar -->
      <aside class="md:w-80 w-full border-b md:border-b-0 md:border-r border-gray-100 bg-white/40">
        <div class="p-4">
          <div class="flex items-center justify-between">
            <div>
              <div class="text-xs font-bold tracking-widest text-gray-500">CONVERSATIONS</div>
              <div class="text-sm text-gray-600 mt-1"><%= conversations.size() %> thread(s)</div>
            </div>
          </div>
        </div>
        <div class="px-3 pb-3">
          <div class="chat-scrollbar overflow-y-auto md:chat-h md:pr-1">
            <%
              for (SupportConversation sc : conversations) {
                User u = sc.getUser();
                String name = u != null ? (u.getFirstName() + " " + u.getLastName()) : "(unknown user)";
                String email = u != null ? u.getEmail() : "";
                SupportMessage last = lastByConversation.get(sc.getId());
                String preview = last != null ? HtmlUtil.ellipsize(last.getBody(), 70) : "No messages yet";
                String when = last != null && last.getCreatedAt() != null ? fmt.format(last.getCreatedAt()) : "";
                long unread = unreadByConversation.get(sc.getId()) != null ? unreadByConversation.get(sc.getId()) : 0L;
                boolean isSelected = (selected != null && selected.getId() != null && selected.getId().equals(sc.getId()));
            %>
              <a href="<%=request.getContextPath()%>/admin/messages?cid=<%= sc.getId() %>"
                 class="block rounded-2xl p-3 mb-2 border transition duration-200
                        <%= isSelected ? "bg-white/80 border-gray-200 shadow-sm" : "bg-white/50 border-transparent hover:bg-white/70 hover:border-gray-100" %>">
                <div class="flex items-start justify-between gap-2">
                  <div class="min-w-0">
                    <div class="flex items-center gap-2">
                      <div class="w-9 h-9 rounded-2xl bg-gradient-to-br from-[var(--purple-light)] to-[var(--purple)] flex items-center justify-center text-white font-extrabold">
                        <%= name.length() > 0 ? String.valueOf(Character.toUpperCase(name.charAt(0))) : "U" %>
                      </div>
                      <div class="min-w-0">
                        <div class="font-bold text-gray-900 truncate"><%= HtmlUtil.escape(name) %></div>
                        <div class="text-xs text-gray-500 truncate"><%= HtmlUtil.escape(email) %></div>
                      </div>
                    </div>
                    <div class="mt-2 text-sm text-gray-700 truncate"><%= HtmlUtil.escape(preview) %></div>
                  </div>
                  <div class="flex flex-col items-end gap-2">
                    <div class="text-[11px] text-gray-500 whitespace-nowrap"><%= HtmlUtil.escape(when) %></div>
                    <% if (unread > 0) { %>
                      <div class="inline-flex items-center justify-center min-w-6 h-6 px-2 rounded-full text-xs font-extrabold text-white"
                           style="background: linear-gradient(135deg, var(--green), rgba(16,185,129,.75));">
                        <%= unread %>
                      </div>
                    <% } %>
                  </div>
                </div>
              </a>
            <%
              }
              if (conversations.isEmpty()) {
            %>
              <div class="rounded-2xl bg-white/60 border border-gray-100 p-4 text-sm text-gray-600">
                No support conversations yet.
              </div>
            <%
              }
            %>
          </div>
        </div>
      </aside>

      <!-- Chat Window -->
      <section class="flex-1 flex flex-col bg-gradient-to-b from-white/60 via-white/40 to-white/60">
        <div class="p-4 border-b border-gray-100 flex items-center justify-between">
          <div class="flex items-center gap-3 min-w-0">
            <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
            <div class="min-w-0">
              <div class="font-extrabold text-gray-900 truncate">
                <%
                  String title = "Select a conversation";
                  String subtitle = "Choose a user on the left to view and reply.";
                  if (selected != null && selected.getUser() != null) {
                    title = selected.getUser().getFirstName() + " " + selected.getUser().getLastName();
                    subtitle = selected.getUser().getEmail();
                  }
                %>
                <%= HtmlUtil.escape(title) %>
              </div>
              <div class="text-xs text-gray-600 truncate"><%= HtmlUtil.escape(subtitle) %></div>
            </div>
          </div>
          <div class="hidden md:flex items-center gap-2 text-xs text-gray-500">
            <span class="chat-dot"></span>
            Admin Support
          </div>
        </div>

        <div id="chatHistory" class="flex-1 chat-scrollbar overflow-y-auto p-4 space-y-3 chat-h">
          <%
            if (selected == null) {
          %>
            <div class="rounded-2xl bg-white/70 border border-gray-100 p-5 text-sm text-gray-700">
              No conversation selected.
            </div>
          <%
            } else if (messages.isEmpty()) {
          %>
            <div class="rounded-2xl bg-white/70 border border-gray-100 p-5 text-sm text-gray-700">
              No messages in this thread yet.
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
                          ? (original.getSender() == SupportSender.USER ? "User" : "Admin")
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
                          data-reply-sender="<%= HtmlUtil.escape(fromUser ? "User" : "Admin") %>"
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
          <form method="post" action="<%=request.getContextPath()%>/admin/messages" class="flex items-end gap-3">
            <input type="hidden" name="conversationId" value="<%= selected != null ? selected.getId() : "" %>"/>
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
              <textarea id="msg" name="message" rows="1"
                        <%= selected == null ? "disabled" : "" %>
                        class="w-full resize-none px-4 py-3 rounded-2xl border border-gray-200 bg-white/90 focus:outline-none focus:ring-2 focus:ring-[var(--green)] transition disabled:opacity-50"
                        placeholder="<%= selected == null ? "Select a conversation to reply..." : "Type a reply..." %>"></textarea>
              <div class="text-[11px] text-gray-500 mt-2">Enter to send, Shift+Enter for a new line.</div>
            </div>
            <button type="submit"
                    <%= selected == null ? "disabled" : "" %>
                    class="h-12 px-5 rounded-2xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-extrabold hover:brightness-95 hover:shadow transition disabled:opacity-50 flex items-center gap-2">
              <span>Send</span>
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10l9-7 9 7-9 11-9-11z"/>
              </svg>
            </button>
          </form>
        </div>
      </section>
    </div>
  </section>
<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>

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

    ta.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        var form = ta.form;
        if (!form) return;
        if (ta.disabled) return;
        if (!ta.value || !ta.value.trim()) return;
        form.submit();
      }
    });
  })();
</script>

</body>
</html>
