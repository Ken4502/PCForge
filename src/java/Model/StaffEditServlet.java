package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Util.Utils;  
import java.io.PrintWriter;


@WebServlet("/StaffEditServlet")
public class StaffEditServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String newpass = request.getParameter("newpass");

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (id == null || newpass == null || id.isEmpty() || newpass.isEmpty()) {
            out.println("<script>alert('Error: Invalid input!'); window.location.href='controller?action=staffmanage';</script>");
            return;
        }

        String hashedPassword = Utils.hashPassword(newpass);
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE STAFF SET password = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, Integer.parseInt(id));
            
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                out.println("<script>alert('Success: Password updated!'); window.location.href='controller?action=staffmanage';</script>");
            } else {
                out.println("<script>alert('Error: Failed to update password!'); window.location.href='controller?action=staffmanage';</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Error: Database issue!'); window.location.href='controller?action=staffmanage';</script>");
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
