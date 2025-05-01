package Model;

import Model.UserDAO;
import Util.Utils;
import Util.registrationValidator;
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

    UserDAO user = new UserDAO();
    User edituser = new User();

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
        if (valid.equals(user.editUser(id, name, email, address))) {
            Utils.showAlert(out, "Edit successfull !!", request, response, "controller?action=usermanage");
        } else {
            edituser.setId(Integer.parseInt(id));
            edituser.setName(name);
            edituser.setEmail(email);
            edituser.setAddress(address);

            String error = user.editUser(id, name, email, address);
            Utils.showAlert(out, error, request, response, "controller?action=usermanage");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

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
                Utils.remainPage(out, error, request, response);    //if error, remain the page
            }
        }

        // once click on the edit button will function 
        String edit = request.getParameter("edit");
        if (edit != null && !edit.isEmpty()) {

            User editUser = new User();
            int editid = Integer.parseInt(request.getParameter("id"));
            String editname = request.getParameter("name");
            String editemail = request.getParameter("email");
            String editaddress = request.getParameter("address");
            editUser.setId(editid);
            editUser.setName(editname);
            editUser.setEmail(editemail);
            editUser.setAddress(editaddress);

            // Set in session scope
            HttpSession session = request.getSession();
            session.setAttribute("user", editUser);

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

        String sql = "SELECT * FROM users"; //Display user list
        request.setAttribute("users", user.getUsers(sql));
        request.getRequestDispatcher("WEB-INF/UserManage.jsp").forward(request, response);
    }
}
