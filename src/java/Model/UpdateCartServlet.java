package Model;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalItems = Integer.parseInt(request.getParameter("totalItems"));
        List<HashMap<String, String>> updatedProducts = new ArrayList<>();

        for (int i = 0; i < totalItems; i++) {
            
            String id = request.getParameter("product_id_" + i);
            System.out.println("Id: " + id);
            String name = request.getParameter("name_" + i);
            String price = request.getParameter("price_" + i);
            String quantity = request.getParameter("quantity_" + i);
            String remove = request.getParameter("remove_" + i);

            // Skip item if remove checkbox is checked
            if (remove == null) {
                HashMap<String, String> item = new HashMap<>();
                item.put("id", id);
                item.put("name", name);
                item.put("price", price);
                item.put("quantity", quantity);
                updatedProducts.add(item);
            }
        }

        // Store the updated products in the session
        HttpSession session = request.getSession();
        session.setAttribute("selectedProducts", updatedProducts);

        // Now forward the request to checkoutUpdate to proceed
        request.getRequestDispatcher("/controller?action=checkoutUpdate").forward(request, response);
    }
}
