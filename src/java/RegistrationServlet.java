import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import utils.Utils; // Import Utils class

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = DatabaseConnection.getConnection();
        if (conn == null) {
            Utils.showAlert(out, "Database connection failed!", request, response, "controller?action=register");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            Utils.showAlert(out, "No action specified!", request, response, "controller?action=register");
            return;
        }

        if (action.equals("add")) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String repass = request.getParameter("repass");
            String address = request.getParameter("address");
            request.getSession().setAttribute("name", name);
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("address", address);

            // Check if password is entered correctly or username already exists
            String checkUserSql = "SELECT name FROM Users WHERE name = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkUserSql)) {
                checkPs.setString(1, name);
                ResultSet rs = checkPs.executeQuery();
                if (!repass.equals(password)) {
                    Utils.showAlert(out, "Passwords do not match!", request, response, "controller?action=register");
                    return;
                }
                if (rs.next()) { // If a row is returned, username already exists
                    Utils.showAlert(out, "Username is taken!", request, response, "controller?action=register");
                    return; // Stop execution
                }
            } catch (SQLException e) {
                e.printStackTrace();
                Utils.showAlert(out, "Database error occurred!", request, response, "controller?action=register");
                return;
            }

            

            if (address == null) address = "";

            String hashedPassword = Utils.hashPassword(password); // Use method from Utils

            String sql = "INSERT INTO Users (name, email, password, address, created_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, hashedPassword);
                ps.setString(4, address);
                ps.executeUpdate();
                Utils.showAlert(out, "User added successfully!", request, response, "controller?action=login");
            } catch (SQLException e) {
                e.printStackTrace();
                Utils.showAlert(out, "Database error occurred!", request, response, "controller?action=register");
            }
        }
    }
}
