package Model;

import java.sql.*;
import Util.DatabaseConnection;

public class ProductDAO {

    Connection conn = DatabaseConnection.getConnection();

    public ProductDAO() {
    }

    public int getTotalOrders(String id) {
        String sql = "SELECT COUNT(DISTINCT o.user_id) AS total_users_ordered "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "WHERE oi.product_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_users_ordered");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

}
