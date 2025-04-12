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

@WebServlet(name = "ProductSearchServlet", urlPatterns = {"/ProductSearchServlet"})
public class ProductSearchServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String search = request.getParameter("search");
        List<Map<String, String>> products = new ArrayList<>();

        String sql;
        {
            sql = "SELECT p.id, p.product_name, p.price, p.quantity, p.image_url, c.category_name "
                    + "FROM products p "
                    + "JOIN category c ON p.category_id = c.id "
                    + "WHERE LOWER(p.product_name) LIKE LOWER(?)";

            try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "%" + search.toLowerCase() + "%");
                try (ResultSet rs = stmt.executeQuery()) {
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
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("products", products);
        request.getRequestDispatcher("WEB-INF/ProductManage.jsp").forward(request, response);
    }
}