package Model;

import java.util.List;
import java.util.HashMap;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkoutUpdate")
public class CheckoutUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        System.out.println("Action received in doPost: checkout");
            List<HashMap<String, String>> selectedProducts = new ArrayList<>();
            int idx = 0;

            while (request.getParameter("product_id_" + idx) != null) {
                String id = request.getParameter("product_id_" + idx);
                String name = request.getParameter("name_" + idx);
                String price = request.getParameter("price_" + idx);
                String quantity = request.getParameter("quantity_" + idx);

                HashMap<String, String> item = new HashMap<>();
                item.put("id", id);
                item.put("name", name);
                item.put("price", price);
                item.put("quantity", quantity);
                System.out.println(id);
                selectedProducts.add(item);
                idx++;
            }

            if (selectedProducts.isEmpty()) {
                System.out.println("No products found in form submission.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No products selected.");
                return;
            }
            
            
            String deliveryFee = request.getParameter("deliveryFee");
            String serviceTax  = request.getParameter("serviceTax");
            String grandTotal = request.getParameter("grandTotal");

            // Store in session
            session.setAttribute("deliveryFee", deliveryFee);
            session.setAttribute("serviceTax", serviceTax);
            session.setAttribute("grandTotal", grandTotal);
            session.setAttribute("selectedProducts", selectedProducts);
            System.out.println("Selected products stored in session: " + selectedProducts.size());
            
            System.out.println("deliveryFee: " + deliveryFee);
            System.out.println("serviceTax: " + serviceTax);
            System.out.println("grandTotal: " + grandTotal);

            response.sendRedirect("controller?action=addressConfirmation");
    }
}

