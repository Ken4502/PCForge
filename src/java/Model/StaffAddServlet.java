package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Util.Utils;

@WebServlet("/StaffAddServlet")
public class StaffAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            // Get a database connection
            conn = DatabaseConnection.getConnection();

            if (conn == null) {
                out.println("<script>alert('Database connection failed.'); window.location.href='controller?action=staffmanage';</script>");
                return;
            }

            // Get the last staff username
            String getLastStaffQuery = "SELECT username FROM STAFF WHERE username LIKE 'staff%' ORDER BY id DESC FETCH FIRST 1 ROW ONLY";
            ps = conn.prepareStatement(getLastStaffQuery);
            rs = ps.executeQuery();

            int nextStaffNumber = 1;
            if (rs.next()) {
                String lastStaff = rs.getString("username");
                nextStaffNumber = Integer.parseInt(lastStaff.replace("staff", "")) + 1;
            }

            String newUsername = "staff" + nextStaffNumber;
            String newPassword = newUsername; // Password is the same as username

            // Hash the password before storing it
            String hashedPassword = Utils.hashPassword(newPassword);

            // Insert new staff
            String insertQuery = "INSERT INTO STAFF (username, password) VALUES (?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, newUsername);
            ps.setString(2, hashedPassword);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<script>alert('Staff added successfully. Username: " + newUsername + "'); window.location.href='controller?action=staffmanage';</script>");
            } else {
                out.println("<script>alert('Failed to add staff. Please try again.'); window.location.href='controller?action=staffmanage';</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            try (PrintWriter out = response.getWriter()) {
                out.println("<script>alert('Database error. Please try again.'); window.location.href='controller?action=staffmanage';</script>");
            }
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
