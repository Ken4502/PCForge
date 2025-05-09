package Util;

import Util.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Util.Utils; // Import Utils class
import Model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        User user = new User();

        // Get user input
        String name = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = DatabaseConnection.getConnection();
        if (conn == null) {
            Utils.showAlert(out, "Database connection failed!", request, response, "controller?action=login");
            return;
        }

        // SQL Query to get stored hashed password for the given username
        String sql = "SELECT * FROM Users WHERE name = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password"); // Retrieve stored hashed password
                int userId = Integer.parseInt(rs.getString("id"));
                String email = rs.getString("email");
                String address = rs.getString("address");
                
                
                    user.setId(userId);//set this for javabean
                    user.setEmail(email); 
                    user.setAddress(address); 

                // Verify password
                if (Utils.verifyPassword(password, storedHash)) {
                    user.setUserLoginName(name); 
                    

                    // Authentication successful, create session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("username", name);
                    session.setAttribute("userId", userId);


                    session.setMaxInactiveInterval(30 * 60); // Set session timeout (30 minutes)
                    Utils.showAlert(out, "Login successful!", request, response, "controller?");

                } else {
                    Utils.showAlert(out, "Incorrect password!", request, response, "controller?action=login");
                }
            } else {
                Utils.showAlert(out, "User not found!", request, response, "controller?action=login");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            Utils.showAlert(out, "Database error occurred!", request, response, "controller?action=login");
        }
    }
}
