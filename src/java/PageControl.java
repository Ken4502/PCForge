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

@WebServlet("/controller")
public class PageControl extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "home";
        }

        switch (action) {
            case "home":
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;
            case "register":
                request.getRequestDispatcher("/WEB-INF/UserRegistration.jsp").forward(request, response);
                break;
            case "login":
                request.getRequestDispatcher("WEB-INF/Login.jsp").forward(request, response);
                break;
            case "adminlogin":
                request.getRequestDispatcher("WEB-INF/AdminLogin.jsp").forward(request, response);
                break;
            case "productmanage":
                response.sendRedirect("ProductManageServlet");
                break;
            case "productadd":
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

                // Pass category list to JSP
                request.setAttribute("categoryList", categoryList);
                request.getRequestDispatcher("WEB-INF/ProductAdd.jsp").forward(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("addcategory".equals(action)) {
            String categoryName = request.getParameter("categoryName");
            if (categoryName != null && !categoryName.trim().isEmpty()) {
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("INSERT INTO category (category_name) VALUES (?)")) {
                    
                    stmt.setString(1, categoryName);
                    stmt.executeUpdate();
                    response.getWriter().write("Category added successfully!");
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("Error adding category.");
                }
            } else {
                response.getWriter().write("Invalid category name.");
            }
        }
    }
}
