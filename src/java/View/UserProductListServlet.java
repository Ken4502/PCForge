package View;

import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserProductListServlet")
public class UserProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Step 1: Retrieve the list of categories from the database
        List<HashMap<String, String>> categoryList = getCategoryList();

        // Step 2: Retrieve the list of products from the database
        List<HashMap<String, String>> productList = getProductList();

        // Step 3: Group products by category
        Map<String, List<HashMap<String, String>>> productsByCategory = new HashMap<>();
        for (HashMap<String, String> product : productList) {
            String categoryId = product.get("category_id"); // Assuming this key stores the category ID
            productsByCategory.computeIfAbsent(categoryId, k -> new ArrayList<>()).add(product);
        }

        // Step 4: Filter out categories with no products
        List<HashMap<String, String>> filteredCategoryList = new ArrayList<>();
        for (HashMap<String, String> category : categoryList) {
            String categoryId = category.get("id");
            if (productsByCategory.containsKey(categoryId) && !productsByCategory.get(categoryId).isEmpty()) {
                filteredCategoryList.add(category);
            }
        }

        // Step 5: Pass both filtered category list and grouped products to the JSP
        request.setAttribute("categoryList", filteredCategoryList);
        request.setAttribute("productsByCategory", productsByCategory);

        // Forward to the JSP page to display products
        request.getRequestDispatcher("WEB-INF/UserProductView.jsp").forward(request, response);
    }

    // Method to get the list of categories from the database
    private List<HashMap<String, String>> getCategoryList() {
        List<HashMap<String, String>> categoryList = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM category");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                HashMap<String, String> category = new HashMap<>();
                category.put("id", rs.getString("id"));
                category.put("name", rs.getString("category_name"));
                categoryList.add(category);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return categoryList;
    }

    // Method to get the list of products from the database
    private List<HashMap<String, String>> getProductList() {
        List<HashMap<String, String>> productList = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                HashMap<String, String> product = new HashMap<>();
                product.put("id", rs.getString("id"));
                product.put("name", rs.getString("product_name"));
                product.put("price", rs.getString("price"));
                product.put("quantity", rs.getString("quantity"));
                product.put("image_url", rs.getString("image_url"));
                product.put("category_id", rs.getString("category_id"));
                productList.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return productList;
    }
}
