package Controller;

import Model.CheckoutService;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CheckoutController")
public class CheckoutController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Create an instance of the CheckoutService to process the request
        CheckoutService checkoutService = new CheckoutService();
        
        // Call the service to process the checkout
        List<HashMap<String, String>> selectedProducts = checkoutService.processCheckout(request);
        
        // If no products were selected, add a message
        if (selectedProducts.isEmpty()) {
            request.setAttribute("message", "No products selected for checkout.");
        } else {
            // Set the selected products to be forwarded to the JSP
            request.setAttribute("selectedProducts", selectedProducts);
        }

        // Forward to the Checkout Confirmation page (JSP)
        request.getRequestDispatcher("/WEB-INF/CheckoutConfirmation.jsp").forward(request, response);
    }
}
