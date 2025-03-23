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
            
            //NOTICE: ADD REGEXX for username, email and password
            String usernameRegex = "^(?=.*[A-Z])[A-Za-z0-9 ]{4,}$"; //Least 4 characters; an Uppercase letter
            String emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"; //(sample@email.com)           
            String passwordRegex ="^(?=.*[A-Za-z])(?=.*\\d).{8,}$"; //Least 8 character; one letter and one number
            
            request.getSession().setAttribute("name", name);
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("address", address);
            
            //Check if username format is valid ; NOTICE
                if (!name.matches(usernameRegex)) { 
                    Utils.showAlert(out, "Invalid username format! Username must have at least 4 characters and an Uppercase letter ",
                            request, response, "controller?action=register");
                    return;
                }           

            //Check if email format is valid ; NOTICE
                if (!email.matches(emailRegex)) { 
                    Utils.showAlert(out, "Invalid email format! Please use a correct format (e.g., PCforge123@sample.com).",
                            request, response, "controller?action=register");
                    return;
                }  
                
            //Check if password format is valid ; NOTICE
                if (!password.matches(passwordRegex)) { 
                    Utils.showAlert(out, "Invalid password format! Password must have at least 8 characters,"
                            + " one alphabetic letter and one numeric letter.",
                            request, response, "controller?action=register");
                    return;
                }           


            //Check if password match confirmation
                if (!repass.equals(password)) {
                    Utils.showAlert(out, "Passwords do not match!", request, response, "controller?action=register");
                    return;
                }
                
            // Check if username,email,password already exists ; NOTICE
            String checkSql = "SELECT name, email, password FROM Users WHERE name = ? OR email = ? OR password = ?";
            String hashedPassword = Utils.hashPassword(password); // Use method from Utils
            
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, name);
                checkPs.setString(2, email);
                checkPs.setString(3,hashedPassword);
             
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                if (name.equals(rs.getString("name"))) {
                     Utils.showAlert(out, "Your Username has already taken!", request, response, "controller?action=register");
                   return;
                }
                if (email.equals(rs.getString("email"))) {
                     Utils.showAlert(out, "Your Email has already taken!", request, response, "controller?action=register");
                   return;
                }
                if (hashedPassword.equals(rs.getString("password"))) {
                     Utils.showAlert(out, "Your password has already been used! Please choose a different one.", request, response, "controller?action=register");
                   return;
                }
             }                  
            } catch (SQLException e) {
                e.printStackTrace();
                Utils.showAlert(out, "Database error occurred!", request, response, "controller?action=register");
                return;
            }

            

            if (address == null) address = "";  //Address could be OPTIONAL, blank space

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
