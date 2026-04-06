<%@ page contentType="text/html;charset=UTF-8" %>


<meta name="viewport" content="width=device-width, initial-scale=1">

<title>WeVote - Online voting platform</title>

<!-- Favicon for browser tab -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/images/logos/fingerPrint.png" type="image/png" />
 
 <!-- TailWind css config -->
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

<!-- Custom CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/index.css">

<script type="text/javascript">
  // Enables "show/hide password" eye toggles for any button with:
  // data-password-toggle and data-target="<inputId>".
  document.addEventListener('DOMContentLoaded', function () {
    var btns = document.querySelectorAll('[data-password-toggle][data-target]');
    btns.forEach(function (btn) {
      btn.addEventListener('click', function () {
        var targetId = btn.getAttribute('data-target');
        if (!targetId) return;
        var input = document.getElementById(targetId);
        if (!input) return;

        var isHidden = input.type === 'password';
        input.type = isHidden ? 'text' : 'password';

        // Optional icon swap if present.
        var iconShow = btn.querySelector('[data-icon="show"]');
        var iconHide = btn.querySelector('[data-icon="hide"]');
        if (iconShow && iconHide) {
          iconShow.classList.toggle('hidden', !isHidden);
          iconHide.classList.toggle('hidden', isHidden);
        }
      });
    });
  });
</script>
