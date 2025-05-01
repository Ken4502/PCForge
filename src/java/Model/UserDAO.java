package Model;

import Util.*;
import java.time.*;
import java.sql.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class UserDAO {

    private Connection conn = DatabaseConnection.getConnection();

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public UserDAO() {

    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        }
        return null;
    }

    public List<HashMap<String, String>> getUsers(String sql) {
        List<HashMap<String, String>> users = new ArrayList<>();

        try (
                Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HashMap<String, String> user = new HashMap<>();
                user.put("id", String.valueOf(rs.getString("id")));
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("password", rs.getString("password"));
                user.put("address", rs.getString("address"));
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime dateTime = timestamp.toLocalDateTime();
                String formattedTime = dateTime.format(DateTimeFormatter.ofPattern("dd/MM/YYYY"));
                user.put("time", formattedTime);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean addUser(String name, String email, String address, String password) {
        String hashedPassword = Utils.hashPassword(password);   // Use method from Utils
        String sql = "INSERT INTO users (name, email, address, password) VALUES (?,?,?,?)";
        try(PreparedStatement stmt = conn.prepareStatement(sql);){
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, address);
            stmt.setString(4, hashedPassword);
            stmt.executeUpdate();
            return true;
        }
        catch(SQLException e){
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean editUser(String id, String name, String email, String address){
        String sql = "UPDATE users SET name = ?, email = ?, address = ? WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, address);
            stmt.setInt(4, Integer.parseInt(id));
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(String id) {
        String sql = "DELETE FROM users WHERE id = " + id;
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
