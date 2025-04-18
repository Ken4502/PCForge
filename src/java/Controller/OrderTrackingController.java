package Controller;

import java.io.IOException;
import java.sql.Connection;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import java.sql.SQLException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import Util.DatabaseConnection;
import Model.*;

@WebServlet("/OrderTrackingController")
public class OrderTrackingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");

        if (userIdObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) userIdObj;

        try {
            Connection conn = DatabaseConnection.getConnection();
            OrderDAO orderDAO = new OrderDAO(conn);

            List<Order> userOrders = orderDAO.getOrdersByUserId(userId);

            Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
            for (Order order : userOrders) {
                List<OrderItem> items = orderDAO.getOrderItemsByOrderId(order.getOrderId());
                orderItemsMap.put(order.getOrderId(), items);
            }

            request.setAttribute("orders", userOrders);
            request.setAttribute("orderItemsMap", orderItemsMap);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/OrderTracking.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading order tracking.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}