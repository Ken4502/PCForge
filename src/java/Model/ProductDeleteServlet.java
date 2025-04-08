package Model;

import Util.DatabaseConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

        if (deleteId != null && deleteId.matches("\\d+")) {
            try (Connection conn = DatabaseConnection.getConnection()) {

                // Retrieve the image URL for the product
                String imageUrl = null;
                try (PreparedStatement selectStmt = conn.prepareStatement("SELECT image_url FROM products WHERE id = ?")) {
                    selectStmt.setInt(1, Integer.parseInt(deleteId));
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            imageUrl = rs.getString("image_url");
                        }
                    }
                }

                //Delete the image file from the server
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    String fullPath = getServletContext().getRealPath("/") + imageUrl;
                    File imageFile = new File(fullPath);
                    if (imageFile.exists()) {
                        if (imageFile.delete()) {
                            System.out.println("Image deleted: " + imageUrl);
                        } else {
                            System.out.println("Failed to delete image: " + imageUrl);
                        }
                    }
                }

                // Delete the product record from the database
                try (PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM products WHERE id = ?")) {
                    deleteStmt.setInt(1, Integer.parseInt(deleteId));
                    deleteStmt.executeUpdate();
                }

                
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
