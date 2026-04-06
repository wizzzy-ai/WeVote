package com.bascode.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/dashboard"})
public class VoterDashboardFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // ✅ First check: no session or no role → back to login
        if (session == null || session.getAttribute("userRole") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = String.valueOf(session.getAttribute("userRole"));

        // ✅ Role-based routing
        if ("VOTER".equals(role) || "CONTESTER".equals(role) ) {
            chain.doFilter(request, response); // allow voter dashboard
        } else if ("ADMIN".equals(role) || "SUPER_ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
        
        
    }
}