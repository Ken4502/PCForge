package Model;

import Model.Order;
import Model.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import Util.DatabaseConnection;

@WebServlet("/OrderViewAllAdmin")
public class OrderViewAllAdmin extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DatabaseConnection.getConnection()) {
            OrderDAO orderDAO = new OrderDAO(conn); // ✅ pass connection
            List<Order> orders = orderDAO.getAllOrders();

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/OrdersViewAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
