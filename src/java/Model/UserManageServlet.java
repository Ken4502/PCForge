package Model;

import Util.Utils;
import java.io.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserManageServlet", urlPatterns = {"/UserManageServlet"})
public class UserManageServlet extends HttpServlet {

    UserDAO user;
    User edituser;

    @Override
    public void init() throws ServletException {
        user = new UserDAO();
        edituser = new User();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        //Edit user from admin site
        String id = request.getParameter("userid");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        

        String valid = "User Edit successfull !!";
        String result = user.editUser(id, name, email, address);
        if (valid.equals(result)) {
            Utils.showAlert(out, "Edit successfull !!", request, response, "controller?action=usermanage");
        } else {
            edituser.setId(Integer.parseInt(id));
            edituser.setName(name);
            edituser.setEmail(email);
            edituser.setAddress(address);
            
            HttpSession session = request.getSession();
            session.setAttribute("user",edituser);

            Utils.remainPage(out, result, request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        // Retrieve sorting parameters from the request
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Default sorting if no parameters are provided
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "id"; // Default sort by id
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "ASC"; // Default to ascending order
        }

        // Validate sortOrder
        if (!"ASC".equals(sortOrder) && !"DESC".equals(sortOrder)) {
            sortOrder = "ASC"; // Default to ascending if the order is invalid
        }

        String name = request.getParameter("name");     //retrieve input of add user
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmpassword = request.getParameter("confirmpassword");

        String validate = "User inserted successfull !!";
        if (name != null && email != null && password != null) {
            //If all validate success, call the insert function
            if (validate.equals(user.addUser(name, email, address, password, confirmpassword))) {
                Utils.showAlert(out, "Insert successfull !!", request, response, "controller?action=usermanage");
            } else {
                String error = user.addUser(name, email, address, password, confirmpassword);
                Utils.showAlert(out, error, request, response,"controller?action=usermanage");   
            }
        }

        // once click on the edit button will function 
        String edit = request.getParameter("edit");
        if (edit != null && !edit.isEmpty()) {
            int editid = Integer.parseInt(request.getParameter("id"));
            String editname = request.getParameter("name");
            String editemail = request.getParameter("email");
            String editaddress = request.getParameter("address");
            setSession(editid, editname, editemail, editaddress, request, response);

            request.getRequestDispatcher("WEB-INF/UserEdit.jsp").forward(request, response);
            return;
        }

        // if click on delete button, will trigger this function
        String delete = request.getParameter("delete");
        if (delete != null && !delete.isEmpty()) {
            if (user.deleteUser(delete)) {
                Utils.showAlert(out, "Delete successfull !!", request, response, "controller?action=usermanage");
            } else {
                Utils.showAlert(out, "Delete failed !!", request, response, "controller?action=usermanage");

            }
        }


        String sql = "SELECT * FROM users ORDER BY " + sortBy + " " + sortOrder; //Display user list
        request.setAttribute("users", user.getUsers(sql));
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("WEB-INF/UserManage.jsp").forward(request, response);
    }

    public void setSession(int editid, String editname, String editemail, String editaddress, HttpServletRequest request, HttpServletResponse response) {
        User editUser = new User();
        editUser.setId(editid);
        editUser.setName(editname);
        editUser.setEmail(editemail);
        editUser.setAddress(editaddress);

        // Set in session scope
        HttpSession session = request.getSession();
        session.setAttribute("user", editUser);
    }
}
