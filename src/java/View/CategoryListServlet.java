package View;

import Model.Category;
import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CategoryListServlet")
public class CategoryListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categoryList = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id, category_name FROM category");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                categoryList.add(new Category(rs.getInt("id"), rs.getString("category_name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass the category list to the JSP
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("WEB-INF/ProductAdd.jsp").forward(request, response);
    }
}
