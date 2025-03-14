import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/controller") // This URL will handle requests for the user registration page
public class PageControl extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null){
            action = "home";
        }
        
        switch (action){
            
            case "home":
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;
            case "register":
                request.getRequestDispatcher("/WEB-INF/UserRegistration.jsp").forward(request, response);
                break;
            case "login":
                request.getRequestDispatcher("WEB-INF/Login.jsp").forward(request, response);
                
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
        }
        
        
    }
}

