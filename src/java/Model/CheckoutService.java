package Model;

import Util.DatabaseConnection;  // Import your database connection utility
import java.sql.*;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;

public class CheckoutService {

    public List<HashMap<String, String>> processCheckout(HttpServletRequest request) {
        List<HashMap<String, String>> selectedProducts = new ArrayList<>();
        Enumeration<String> parameterNames = request.getParameterNames();

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();

            // Look for quantity_ parameters
            if (paramName.startsWith("quantity_")) {
                String productId = paramName.substring(9); // Get product ID from parameter name
                String quantityStr = request.getParameter(paramName);

                // If quantity is greater than 0, fetch the product details
                if (Integer.parseInt(quantityStr) > 0) {
                    HashMap<String, String> product = getProductDetails(productId);
                    if (!product.isEmpty()) { // Ensure product exists in DB
                        product.put("quantity", quantityStr); // Add quantity to the product details
                        selectedProducts.add(product);
                    }
                }
            }
        }

        return selectedProducts;
    }

    private HashMap<String, String> getProductDetails(String productId) {
        HashMap<String, String> product = new HashMap<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // 1. Get Connection from DatabaseConnection Utility
            conn = DatabaseConnection.getConnection();

            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            // 2. Prepare SQL Query
            String sql = "SELECT id, product_name, price, image_url FROM products WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, productId);

            // 3. Execute Query
            rs = stmt.executeQuery();

            // 4. Process Result
            if (rs.next()) {
                product.put("id", rs.getString("id"));
                product.put("name", rs.getString("product_name"));
                product.put("price", rs.getString("price"));
                product.put("image_url", rs.getString("image_url"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources properly
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return product;
    }
}
