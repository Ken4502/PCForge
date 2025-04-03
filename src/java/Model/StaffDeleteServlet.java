package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@WebServlet("/StaffDeleteServlet")
public class StaffDeleteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String id = request.getParameter("id");
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            if (id != null && !id.isEmpty()) {
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM staff WHERE id = ?")) {

                    stmt.setInt(1, Integer.parseInt(id));
                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
                        out.println("<script>alert('Staff member deleted successfully.'); window.location.href='controller?action=staffmanage';</script>");
                    } else {
                        out.println("<script>alert('No staff found with this ID.'); window.location.href='controller?action=staffmanage';</script>");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<script>alert('Database error. Please try again.'); window.location.href='controller?action=staffmanage';</script>");
                }
            } else {
                out.println("<script>alert('Invalid staff ID.'); window.location.href='controller?action=staffmanage';</script>");
            }
        }
    }
}


