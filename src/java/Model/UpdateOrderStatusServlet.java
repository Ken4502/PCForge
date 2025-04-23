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

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        try (Connection conn = DatabaseConnection.getConnection()) {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO(conn);
            orderDAO.updateOrderStatus(orderId, newStatus);
            response.sendRedirect("controller?action=viewOrders");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
