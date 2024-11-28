package com.fisica.servlets;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the current session
        HttpSession session = request.getSession(false); // Fetch session if exists
        if (session != null) {
            session.invalidate();
        }

        // Redirect to index.jsp with a logout message
        response.sendRedirect("index.jsp?message=Logged out successfully");
    }
}
