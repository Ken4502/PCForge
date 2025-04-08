package Model;


import Util.DatabaseConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/ProductManageServlet")
public class ProductManageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Ensure user is logged in
        if (session == null || session.getAttribute("adminname") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }

        // Retrieve sorting parameters from the request
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Default sorting if no parameters are provided
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "id"; // Default sort by id
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "ASC"; // Default to ascending order
        }

        // Validate sortOrder
        if (!"ASC".equals(sortOrder) && !"DESC".equals(sortOrder)) {
            sortOrder = "ASC"; // Default to ascending if the order is invalid
        }

        // Prepare the SQL query with dynamic sorting
        String sql = "SELECT p.id, p.product_name, p.price, p.quantity, p.image_url, c.category_name "
                   + "FROM products p "
                   + "JOIN category c ON p.category_id = c.id "
                   + "ORDER BY " + sortBy + " " + sortOrder;

        List<Map<String, String>> products = new ArrayList<>();

        // Execute the query and retrieve the products
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, String> product = new HashMap<>();
                product.put("id", String.valueOf(rs.getInt("id")));
                product.put("name", rs.getString("product_name"));
                product.put("price", String.valueOf(rs.getDouble("price")));
                product.put("quantity", String.valueOf(rs.getInt("quantity")));
                product.put("image", rs.getString("image_url"));
                product.put("category", rs.getString("category_name"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set the sorting parameters to the request, so they can be used in the JSP
        // Store the product list in request scope and forward it to JSP
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("products", products);
        request.getRequestDispatcher("WEB-INF/ProductManage.jsp").forward(request, response);
    }
}

