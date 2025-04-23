package Model;

import Util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.Timestamp;


@WebServlet("/StaffManageServlet")
public class StaffManageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        //Ensure user is logged in
        if (session == null || session.getAttribute("adminname") == null) {
           response.sendRedirect("controller?action=login");
           return;
        }
        
        List<HashMap<String, String>> staffList = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT id, username, is_admin, created_at FROM Staff WHERE is_admin = false");
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                HashMap<String, String> staff = new HashMap<>();
                staff.put("id", String.valueOf(rs.getInt("id")));
                staff.put("username", rs.getString("username"));
                staff.put("is_admin", rs.getBoolean("is_admin") ? "Admin" : "Staff"); // Convert boolean to text
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime dateTime = timestamp.toLocalDateTime();
                String formattedTime = dateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
                staff.put("created_at", formattedTime);
                staffList.add(staff);
            }

            System.out.println("Total staff fetched: " + staffList.size()); // Debugging output
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Store the staff list in request scope and forward it to JSP
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("WEB-INF/StaffManage.jsp").forward(request, response);
    }
}
