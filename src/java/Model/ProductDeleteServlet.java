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

@WebServlet("/ProductDeleteServlet")
public class ProductDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String deleteId = request.getParameter("id");

        // Check if ID is not null and is a valid number
        if (deleteId != null && deleteId.matches("\\d+")) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM products WHERE id = ?")) {

                stmt.setInt(1, Integer.parseInt(deleteId));
                int deleted = stmt.executeUpdate();

                // Display JavaScript alert and redirect
                response.getWriter().write("<script>alert('Product deleted successfully!'); window.location.href='controller?action=productmanage';</script>");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("<script>alert('Delete failed! Check console for errors.'); window.history.back();</script>");
            }
        } else {
            response.getWriter().write("<script>alert('Invalid Product ID!'); window.history.back();</script>");
        }
    }
}
