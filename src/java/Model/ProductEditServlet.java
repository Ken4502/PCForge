package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/ProductEditServlet")
public class ProductEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String editId = request.getParameter("id");
        if (editId == null) {
            response.sendRedirect("controller?action=productmanage&message=Invalid Product ID");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Fetch product
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
            stmt.setInt(1, Integer.parseInt(editId));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HashMap<String, String> product = new HashMap<>();
                product.put("id", rs.getString("id"));
                product.put("name", rs.getString("product_name"));
                product.put("price", rs.getString("price"));
                product.put("quantity", rs.getString("quantity"));
                product.put("image_url", rs.getString("image_url"));
                product.put("category", rs.getString("category_id"));

                request.setAttribute("product", product);
            } else {
                response.sendRedirect("controller?action=productmanage&message=Product not found");
                return;
            }

            // Fetch category list
            List<HashMap<String, String>> categoryList = new ArrayList<>();
            PreparedStatement catStmt = conn.prepareStatement("SELECT * FROM category");
            ResultSet catRs = catStmt.executeQuery();

            while (catRs.next()) {
                HashMap<String, String> category = new HashMap<>();
                category.put("id", catRs.getString("id"));
                category.put("name", catRs.getString("category_name"));
                categoryList.add(category);
            }

            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("WEB-INF/ProductEdit.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("controller?action=productmanage&message=Error fetching product");
        }      
    }  
}


