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
        this.conn = DatabaseConnection.getConnection();
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
                String formattedTime = dateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm:ss a"));
                user.put("time", formattedTime);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public String addUser(String name, String email, String address, String password, String repassword) {
        //Check input String format
        if (!registrationValidator.isValidUsername(name)) {
            return "Invalid username format! Username must have at least 4 characters and an Uppercase letter";
        }
        if (!registrationValidator.isValidEmail(email)) {
            return "Invalid email format! Please use a correct format (e.g., PCforge123@sample.com).";
        }
        if (!registrationValidator.isValidPassword(password)) {
            return "Invalid password format! Password must have at least 8 characters,"
                    + " one alphabetic letter and one numeric letter.";
        }
        if (!registrationValidator.passwordsMatch(password, repassword)) {
            return "Passwords do not match!";
        }

        //Check from database
        String checkSql = "SELECT name, email, password FROM Users WHERE name = ? OR email = ? OR password = ?";
        String hashedPassword = Utils.hashPassword(password); // Use method from Utils

        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, name);
            checkPs.setString(2, email);
            checkPs.setString(3, hashedPassword);

            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) { //validate first
                if (name.equals(rs.getString("name"))) {
                    return "Your Username has already taken!";
                }
                if (email.equals(rs.getString("email"))) {
                    return "Your Email has already taken!";
                }
                return "Duplicate user found !!";
            }

            //Start insert 
            String sql = "INSERT INTO users (name, email, address, password) VALUES (?,?,?,?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql);) {
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, address);
                stmt.setString(4, hashedPassword);
                stmt.executeUpdate();
                return "User inserted successfull !!";
            } catch (SQLException e) {
                e.printStackTrace();
                return "User inserted failed";
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Insert failed !!";
    }

    public String checkSameUser(String name, String email) {

        // Check if username,email,password already exists ; NOTICE
        String checkSql = "SELECT name, email, password FROM Users WHERE name = ? OR email = ?";

        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, name);
            checkPs.setString(2, email);

            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                if (name.equals(rs.getString("name"))) {
                    return "Your Username has already taken!";
                }
                if (email.equals(rs.getString("email"))) {
                    return "Your Email has already taken!";
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return "no error";
    }

    public String editUser(String id, String name, String email, String address) {
        if (!registrationValidator.isValidUsername(name)) {
            return "Invalid username format! Username must have at least 4 characters and an Uppercase letter";
        } else if (!registrationValidator.isValidEmail(email)) {
            return "Invalid email format! Please use a correct format (e.g., PCforge123@sample.com";
        } else {
            String sql = "UPDATE users SET name = ?, email = ?, address = ? WHERE id = ?";
            try {
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, address);
                stmt.setInt(4, Integer.parseInt(id));
                stmt.executeUpdate();
                return "User Edit successfull !!";
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "Edit failed !!";
    }

    public boolean deleteUser(String id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(id));
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String changePassword(int id, String oldPassword, String newPassword) {
        String selectSQL = "SELECT password FROM users WHERE id = ?";
        String changeSQL = "UPDATE users SET password = ? WHERE id = ?";

        if ((oldPassword == null || oldPassword.isEmpty()) && (newPassword == null || newPassword.isEmpty())) {
            return "Please fill in old password and new password !!";
        }
        if (oldPassword == null || oldPassword.isEmpty()) {
            return "Please fill in old password !!";
        }
        if (newPassword == null || newPassword.isEmpty()) {
            return "Please fill in new password !!";
        }

        if (!registrationValidator.isValidPassword(newPassword)) {
            return "New password is invalid password format! Password must have at least 8 characters,"
                    + " one alphabetic letter and one numeric letter.";
        }

        try (PreparedStatement stmt = conn.prepareStatement(selectSQL);) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String old = rs.getString("password");
                String HashedOldPassword = Utils.hashPassword(oldPassword);
                String HashedNewPassword = Utils.hashPassword(newPassword);

                if (!old.equals(HashedOldPassword)) { //check input old password is same with database's stored old  or not
                    return "Incorrect old password";
                }

                if (oldPassword.equals(newPassword)) {
                    return "Old password and New password cannot be same";
                }

                try (PreparedStatement updateStmt = conn.prepareStatement(changeSQL);) {
                    updateStmt.setString(1, HashedNewPassword);
                    updateStmt.setInt(2, id);
                    updateStmt.executeUpdate();
                    return "Password Changed successfull !!";
                } catch (SQLException e) {
                    e.printStackTrace();
                }

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Change failed !!";
    }

    public boolean validateEditPassword(int id, String oldPassword, String newPassword) {
        String validate = "Password Changed successfull !!";
        return validate.equals(changePassword(id, oldPassword, newPassword));
    }
}
