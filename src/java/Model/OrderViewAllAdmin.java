package Model;

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

        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        try (Connection conn = DatabaseConnection.getConnection()) {
            OrderDAO orderDAO = new OrderDAO(conn);

            List<Order> orders;

            orders = orderDAO.getAllOrdersSorted(sortBy, sortOrder);

            request.setAttribute("orders", orders);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher("/WEB-INF/OrdersViewAdmin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
