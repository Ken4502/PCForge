package Model;

import java.sql.*;
import java.util.*;

public class OrderDAO {
    private Connection conn;

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT order_id, total_price, order_status, delivery_address, timestamp, user_id "
               + "FROM Orders WHERE user_id = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Order order = new Order();
            order.setOrderId(        rs.getInt("order_id"));
            order.setTotalPrice(     rs.getBigDecimal("total_price"));
            order.setStatus(         rs.getString("order_status"));
            order.setDeliveryAddress(rs.getString("delivery_address"));
            // map your timestamp column into a Date (or java.sql.Timestamp) field in Order:
            order.setOrderDate(rs.getTimestamp("timestamp"));
            order.setUserId(         rs.getInt("user_id"));
            orders.add(order);
        }
    }
    return orders;
}

    // Private helper
    private List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setItemId(rs.getInt("item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                items.add(item);
            }
        }
        return items;
    }

    // ✅ This public method allows external classes to call it
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        return getOrderItems(orderId);
    }
}
