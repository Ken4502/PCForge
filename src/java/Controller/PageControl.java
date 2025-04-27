package Controller;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import java.sql.SQLException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import Util.DatabaseConnection;
import Model.*;

@MultipartConfig
@WebServlet("/controller")
public class PageControl extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        //System.out.println("Controller received request: " + request.getQueryString());
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        System.out.println("Controller received request: " + request.getQueryString());
        System.out.println("Request Method: " + request.getMethod()); // Debugging request method

        System.out.println("Action received in doGet: " + action);
        
        if (action == null) {
            action = "home";
        }
        //.out.println("String stored: " + action);
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
            case "staffaccountmanage":
                request.getRequestDispatcher("/StaffAccountManageServlet").forward(request, response);
                break;
            case "staffmanage":
                response.sendRedirect("StaffManageServlet");
                break;    
            case "productmanage":
                response.sendRedirect("ProductManageServlet");
                break;
            case "productadd":
                request.getRequestDispatcher("CategoryListServlet").forward(request, response);
                break;
            case "productEdit":
                request.getRequestDispatcher("ProductEditServlet").forward(request, response);
                break;
            case "productUpdate":
                request.getRequestDispatcher("ProductUpdateServlet").forward(request, response);
                break;
            case "productDelete":
                request.getRequestDispatcher("ProductDeleteServlet").forward(request, response);
                break;
            case "productview":
                request.getRequestDispatcher("/UserProductListServlet").forward(request, response);
                break;
            case "checkout":
                request.getRequestDispatcher("CheckoutController").forward(request, response);
                break;
            case "orderTracking":
                request.getRequestDispatcher("OrderTrackingController").forward(request, response);
                break;
            case "report":
                request.getRequestDispatcher("/ReportServlet").forward(request, response);
                break;
            case "viewProduct":
                request.getRequestDispatcher("WEB-INF/ProductDetailsUser.jsp").forward(request, response);
                break;
            case "viewOrders":
                response.sendRedirect("OrderViewAllAdmin");
                break;
            case "addressConfirmation":
                List<HashMap<String, String>> selectedProductsForPayment = 
                    (List<HashMap<String, String>>) session.getAttribute("selectedProducts");

                if (selectedProductsForPayment == null || selectedProductsForPayment.isEmpty()) {
                    System.out.println("No products available for payment.");
                    response.sendRedirect("controller?action=checkoutUpdate");
                    return;
                }
                
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    UserDAO userDAO = new UserDAO(conn);
                    System.out.println("User ID from session: " + String.valueOf(session.getAttribute("userId")));
                    int userId = (int)(session.getAttribute("userId"));
                    User user = userDAO.getUserById(userId);
                    request.setAttribute("user", user);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                request.setAttribute("selectedProducts", selectedProductsForPayment);
                request.getRequestDispatcher("/WEB-INF/addressConfirmation.jsp").forward(request, response);
                break;
                



            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        System.out.println("Controller received request: " + request.getQueryString());
        System.out.println("Request Method: " + request.getMethod()); // Debugging request method
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        System.out.println("Action received in doPost: " + action);

        if ("addcategory".equals(action)) {
            // Handle category addition
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
        else if ("productUpdate".equals(action)) {
            // 🚀 Forward request to ProductUpdateServlet
            System.out.println("Forwarding to ProductUpdateServlet...");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ProductUpdateServlet");
            dispatcher.forward(request, response);
        } 
        else if ("updateCart".equals(action)) {
            request.getRequestDispatcher("/updateCart").forward(request, response);
        }
        else if ("checkoutUpdate".equals(action)) {
            List<HashMap<String, String>> selectedProducts =
                    (List<HashMap<String, String>>) session.getAttribute("selectedProducts");

                if (selectedProducts == null || selectedProducts.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No products selected.");
                    return;
                }

                request.setAttribute("selectedProducts", selectedProducts);
                System.out.println("Session Cart: " + session.getAttribute("selectedProducts"));
                System.out.println("Request Cart Set: " + selectedProducts);
                request.getRequestDispatcher("/WEB-INF/CheckoutConfirmation.jsp").forward(request, response);
        }
        else if ("checkout".equals(action)) {
            request.getRequestDispatcher("/checkoutUpdate").forward(request, response);
        }
        else if ("processPayment".equals(action)) {
            request.getRequestDispatcher("/processPayment").forward(request, response);
        }
        else {
            response.getWriter().write("Invalid action.");
        }
    }

}
