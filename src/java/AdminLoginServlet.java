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
import utils.Utils; // Import Utils class

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get user input
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = DatabaseConnection.getConnection();
        if (conn == null) {
            Utils.showAlert(out, "Database connection failed!", request, response, "controller?action=adminlogin");
            return;
        }

        // SQL Query to get stored hashed password for the given username
        String sql = "SELECT password FROM Staff WHERE username = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password"); // Retrieve stored hashed password

                // Verify password
                if (Utils.verifyPassword(password, storedHash)) {
                    // Authentication successful, create session
                    HttpSession session = request.getSession();
                    session.setAttribute("adminname", username);
                    session.setMaxInactiveInterval(30 * 60); // Set session timeout (30 minutes)
                    Utils.showAlert(out, "Login successful!", request, response, "controller?");
                    
                } else {
                    Utils.showAlert(out, "Incorrect password!", request, response, "controller?action=adminlogin");
                }
            } else {
                Utils.showAlert(out, "User not found!", request, response, "controller?action=adminlogin");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            Utils.showAlert(out, "Database error occurred!", request, response, "controller?action=adminlogin");
        }
    }
}
