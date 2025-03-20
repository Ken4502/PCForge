import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProductAddServlet")
public class ProductAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        //Ensure user is logged in
        if (session == null || session.getAttribute("adminname") == null) {
           response.sendRedirect("controller?action=login");
           return;
        }
        
        // Get form data from request
        String productName = request.getParameter("productname");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String imageUrl = request.getParameter("image");
        String categoryIdStr = request.getParameter("category");

        // Validate inputs
        if (productName == null || priceStr == null || quantityStr == null || imageUrl == null || categoryIdStr == null ||
            productName.isEmpty() || priceStr.isEmpty() || quantityStr.isEmpty() || imageUrl.isEmpty() || categoryIdStr.isEmpty()) {
            sendAlertAndRedirect(response, "All fields are required!", "controller?action=productadd");
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            // Insert into database
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO products (product_name, price, quantity, image_url, category_id) VALUES (?, ?, ?, ?, ?)")) {

                stmt.setString(1, productName);
                stmt.setDouble(2, price);
                stmt.setInt(3, quantity);
                stmt.setString(4, imageUrl);
                stmt.setInt(5, categoryId);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    // Show success alert before redirecting to product management page
                    sendAlertAndRedirect(response, "Product added successfully!", "controller?action=productmanage");
                } else {
                    sendAlertAndRedirect(response, "Failed to add product.", "controller?action=productadd");
                }
            }

        } catch (NumberFormatException e) {
            sendAlertAndRedirect(response, "Invalid price or quantity format.", "controller?action=productadd");
        } catch (Exception e) {
            e.printStackTrace();
            sendAlertAndRedirect(response, "Database error: " + e.getMessage(), "controller?action=productadd");
        }
    }

    private void sendAlertAndRedirect(HttpServletResponse response, String message, String redirectURL) throws IOException {
        response.setContentType("text/html");
        response.getWriter().write("<script>alert('" + message + "'); window.location='" + redirectURL + "';</script>");
    }
}
