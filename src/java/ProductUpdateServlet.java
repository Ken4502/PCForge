import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProductUpdateServlet")
public class ProductUpdateServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        System.out.println("ProductUpdateServlet triggered!");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String quantity = request.getParameter("quantity");
        String category = request.getParameter("category");
        String image_url = request.getParameter("image_url"); 

        System.out.println("Received data - ID: " + id + ", Name: " + name + 
                           ", Price: " + price + ", Quantity: " + quantity + 
                           ", Category: " + category + ", Image URL: " + image_url);

        if (id == null || name == null || price == null || quantity == null || category == null || image_url == null) {
            System.out.println("Error: Missing form data!");
            response.sendRedirect("controller?action=productmanage&message=Missing required fields");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "UPDATE products SET product_name = ?, price = ?, quantity = ?, category_id = ?, image_url = ? WHERE id = ?")) {

            stmt.setString(1, name);
            stmt.setDouble(2, Double.parseDouble(price));
            stmt.setInt(3, Integer.parseInt(quantity));
            stmt.setInt(4, Integer.parseInt(category));
            stmt.setString(5, image_url); 
            stmt.setInt(6, Integer.parseInt(id));

            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Executing SQL: UPDATE products SET product_name = " + name + ", price = " + price + ", quantity = " + quantity + ", category_id = " + category + ", image_url = " + image_url + " WHERE id = " + id);
            if (rowsUpdated > 0) {
                System.out.println("Update successful!");
                response.getWriter().write("<script>alert('Product updated successfully!'); window.location.href='controller?action=productmanage';</script>");
            } else {
                System.out.println("Update failed.");
                response.getWriter().write("<script>alert('Update failed!'); window.history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<script>alert('Update failed!'); window.history.back();</script>");
        }
    }
}
