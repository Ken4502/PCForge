/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Model;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.*;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/ProductDetailServlet"})
public class ProductDetailServlet extends HttpServlet {
    
    ProductDAO productDA = new ProductDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get product details from the query parameters
        String productId = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String productPrice = request.getParameter("product_price");
        String productQuantity = request.getParameter("product_quantity");
        String productImage = request.getParameter("product_image");
        
        
        HashMap<String, String> product = new HashMap<>();
        product.put("id", productId);
        product.put("name", productName);
        product.put("price", productPrice);
        product.put("quantity", productQuantity);
        product.put("image", productImage);
        
        int totaluser = productDA.getTotalOrders(productId);
        
        request.setAttribute("totalOrdered", totaluser);
        request.setAttribute("product",product);
        
        request.getRequestDispatcher("WEB-INF/UserProductDetails.jsp").forward(request, response);
    }
}
