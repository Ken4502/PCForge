package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import Util.Utils;

@WebServlet("/StaffAccountManageServlet")
public class StaffAccountManageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        //Ensure user is logged in
        if (session == null || session.getAttribute("adminname") == null) {
           response.sendRedirect("controller?action=login");
           return;
        }

        String adminname = (String) session.getAttribute("adminname");
        request.setAttribute("adminname", adminname);

        // Forward to JSP directly
        request.getRequestDispatcher("WEB-INF/StaffAccountManage.jsp").forward(request, response);

    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminname") == null) {
            response.sendRedirect("controller?action=adminlogin");
            return;
        }

        String adminname = (String) session.getAttribute("adminname");
        String newPassword = request.getParameter("newPassword");

        if (newPassword == null || newPassword.isEmpty()) {
            response.getWriter().println("<script>alert('Password cannot be empty'); window.location.href='controller?action=staffaccountmanage';</script>");
            return;
        }

        // Hash password using Utils
        String hashedPassword = Utils.hashPassword(newPassword);

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE STAFF SET password = ? WHERE username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setString(2, adminname);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                // Success: Show alert and redirect to logout
                response.getWriter().println("<script>alert('Password updated successfully. You will be logged out.'); window.location.href='" + request.getContextPath() + "/AdminLogoutServlet';</script>");

            } else {
                // Failure: Show alert and stay on the same page
                response.getWriter().println("<script>alert('Update failed. Please try again.'); window.location.href='controller?action=staffaccountmanage';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Database error. Please try again later.'); window.location.href='controller?action=staffaccountmanage';</script>");
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }

}

