/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package View;

import java.sql.*;
import Util.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.time.*;
import java.time.format.*;
import java.util.*;

/**
 *
 * @author TANGH
 */
@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {

    String barchartSQL;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fromString = request.getParameter("from");
        String toString = request.getParameter("to");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate from = null;
        LocalDate to = null;

        try {
            if (fromString != null && !fromString.isEmpty()) {
                from = LocalDate.parse(fromString, formatter);
            }
            if (toString != null && !toString.isEmpty()) {
                to = LocalDate.parse(toString, formatter);
            }
        } catch (DateTimeParseException e) {
            e.printStackTrace(); // You could redirect to an error page or show message
        }

        List<HashMap<String, String>> barChart = getBarChart(from, to);
        

        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("barChart", barChart);
        request.getRequestDispatcher("WEB-INF/Report.jsp").forward(request, response);
    }

    public List<HashMap<String, String>> getBarChart(LocalDate from, LocalDate to) {
        List<HashMap<String, String>> result = new ArrayList<>();

        if (from == null && to == null) {
            barchartSQL
                    = "SELECT c.category_name AS category, SUM(oi.price * oi.quantity) AS total_sales "
                    + "FROM order_items oi "
                    + "JOIN products p ON oi.product_id = p.id "
                    + "JOIN category c ON p.category_id = c.id "
                    + "GROUP BY c.category_name "
                    + "ORDER BY total_sales DESC";
        } else if (from == null && to != null) {
            barchartSQL
                    = "SELECT c.category_name AS category, SUM(oi.price * oi.quantity) AS total_sales "
                    + "FROM order_items oi "
                    + "JOIN products p ON oi.product_id = p.id "
                    + "JOIN category c ON p.category_id = c.id "
                    + "JOIN orders o ON oi.order_id = o.order_id "
                    + "WHERE o.timestamp <= '" + to + " 23:59:59.999' "
                    + "GROUP BY c.category_name "
                    + "ORDER BY total_sales DESC";
        } else if (to == null && from != null) {
            barchartSQL
                    = "SELECT c.category_name AS category, SUM(oi.price * oi.quantity) AS total_sales "
                    + "FROM order_items oi "
                    + "JOIN products p ON oi.product_id = p.id "
                    + "JOIN category c ON p.category_id = c.id "
                    + "JOIN orders o ON oi.order_id = o.order_id "
                    + "WHERE o.timestamp >= '" + from + " 00:00:00.000' "
                    + "GROUP BY c.category_name "
                    + "ORDER BY total_sales DESC";
        } else {
            barchartSQL
                    = "SELECT c.category_name AS category, SUM(oi.price * oi.quantity) AS total_sales "
                    + "FROM order_items oi "
                    + "JOIN products p ON oi.product_id = p.id "
                    + "JOIN category c ON p.category_id = c.id "
                    + "JOIN orders o ON oi.order_id = o.order_id "
                    + "WHERE o.timestamp >= '" + from + " 00:00:00.000' AND o.timestamp < '" + to + " 23:59:59.999' "
                    + "GROUP BY c.category_name "
                    + "ORDER BY total_sales DESC";
        }

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(barchartSQL); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HashMap<String, String> resultset = new HashMap<>();
                resultset.put("category", rs.getString("category"));
                resultset.put("totalSales", rs.getString("total_sales"));
                result.add(resultset);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
