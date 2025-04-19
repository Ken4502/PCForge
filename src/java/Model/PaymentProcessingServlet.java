package Model;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Util.DatabaseConnection;
import Util.Utils;
import java.io.PrintWriter;

@WebServlet("/processPayment")
public class PaymentProcessingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();
        // === Extracting parameters ===
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        String totalStr = request.getParameter("grandTotal");

        System.out.println("Received Payment Details:");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Address: " + address);
        System.out.println("Payment Method: " + paymentMethod);
        System.out.println("Grand Total: " + totalStr);

        // === Extracting products ===
        @SuppressWarnings("unchecked")
        List<HashMap<String, String>> selectedProducts =
            (List<HashMap<String, String>>) session.getAttribute("selectedProducts");

        System.out.println("Selected Products:");
        if (selectedProducts != null) {
            for (HashMap<String, String> item : selectedProducts) {
                System.out.println("Product: " + item.get("name"));
                System.out.println("  Product ID: " + item.get("id"));
                System.out.println("  Price: " + item.get("price"));
                System.out.println("  Quantity: " + item.get("quantity"));
            }
        } else {
            System.out.println("No selected products found!");
        }

        if (selectedProducts == null || selectedProducts.isEmpty()) {
            request.setAttribute("error", "No items found in cart.");
            request.getRequestDispatcher("/WEB-INF/checkoutUpdate.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            int userId = (int) session.getAttribute("userId");
            System.out.println("User ID from session: " + userId);

            // === Insert into Orders ===
            String insertOrder = "INSERT INTO Orders (total_price, order_status, delivery_address, payment_method, user_id) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setBigDecimal(1, new BigDecimal(totalStr));
                ps.setString(2, "Packaging");
                ps.setString(3, address);
                ps.setString(4, paymentMethod);
                ps.setInt(5, userId);

                int rowsAffected = ps.executeUpdate();
                System.out.println("Rows inserted into Orders: " + rowsAffected);

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    System.out.println("Generated Order ID: " + orderId);

                    // === Insert into Order Items ===
                    String insertItem = "INSERT INTO order_items (order_id, product_id, product_name, price, quantity) VALUES (?, ?, ?, ?, ?)";
                    String updateProductQty = "UPDATE products SET quantity = quantity - ? WHERE id = ?";
                    try (PreparedStatement itemPS = conn.prepareStatement(insertItem);
                            PreparedStatement updateQtyPS = conn.prepareStatement(updateProductQty)
                            ) {
                        for (HashMap<String, String> item : selectedProducts) {
                            int productId = Integer.parseInt(item.get("id"));
                            int qtyPurchased = Integer.parseInt(item.get("quantity"));
                            
                            itemPS.setInt(1, orderId);
                            itemPS.setInt(2, Integer.parseInt(item.get("id")));
                            itemPS.setString(3, item.get("name"));
                            itemPS.setBigDecimal(4, new BigDecimal(item.get("price")));
                            itemPS.setInt(5, Integer.parseInt(item.get("quantity")));
                            itemPS.addBatch();
                            
                            // Update product quantity
                            updateQtyPS.setInt(1, qtyPurchased);
                            updateQtyPS.setInt(2, productId);
                            updateQtyPS.addBatch();
                        }
                        int[] batchResults = itemPS.executeBatch();
                        int[] updateResults = updateQtyPS.executeBatch();
                        System.out.println("Inserted " + batchResults.length + " order items.");
                        System.out.println("Updated " + updateResults.length + " product quantities.");
                    }

                    conn.commit();
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("grandTotal", totalStr);
                    session.removeAttribute("selectedProducts");

                    System.out.println("Payment processing complete. Forwarding to success page...");
                    Utils.showAlert(out, "Payment successful! Thank you for your purchase.", request, response, "controller?action=orderTracking");

                } else {
                    throw new SQLException("Order ID not generated.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Payment processing failed.");
            request.getRequestDispatcher("/WEB-INF/addressConfirmation.jsp").forward(request, response);
        }
    }
}
