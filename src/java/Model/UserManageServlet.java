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

        String id = request.getParameter("userid");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        System.out.println("Hey !!! I am here id = " + id);
        if (user.editUser(id, name, email, address)) {
            Utils.showAlert(out, "Edit successfull !!", request, response, "controller?action=usermanage");
        } else {
            Utils.showAlert(out, "Edit failed !!", request, response, "controller?action=usermanage");

        }

        response.sendRedirect("UserManageServlet");
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

        if (name != null && email != null && address != null && password != null) { //if want to add user only trigger this function
            //Check if username format is valid ; NOTICE
            if (!registrationValidator.isValidUsername(name)) {
                Utils.showAlert(out, "Invalid username format! Username must have at least 4 characters and an Uppercase letter ",
                        request, response, "controller?action=usermanage");
                return;
            }
            //Check if email format is valid ; NOTICE
            if (!registrationValidator.isValidEmail(email)) {
                Utils.showAlert(out, "Invalid email format! Please use a correct format (e.g., PCforge123@sample.com).",
                        request, response, "controller?action=usermanage");
                return;
            }
            //Check if password format is valid ; NOTICE
            if (!registrationValidator.isValidPassword(password)) {
                Utils.showAlert(out, "Invalid password format! Password must have at least 8 characters,"
                        + " one alphabetic letter and one numeric letter.",
                        request, response, "controller?action=usermanage");
                return;
            }
            //Check if password match confirmation
            if (!registrationValidator.passwordsMatch(password, confirmpassword)) {
                Utils.showAlert(out, "Passwords do not match!", request, response, "controller?action=usermanage");
                return;
            }

            //If all validate success, call the insert function
            if (user.addUser(name, email, address, password)) {
                Utils.showAlert(out, "Insert successfull !!", request, response, "controller?action=usermanage");
            } else {
                Utils.showAlert(out, "Insert failed !!", request, response, "controller?action=usermanage");
            }
        }

        // once click on the edit button will function 
        String edit = request.getParameter("edit");
        if (edit != null && !edit.isEmpty()) {
            User user = new User();
            int editid = Integer.parseInt(request.getParameter("id"));
            String editname = request.getParameter("name");
            String editemail = request.getParameter("email");
            String editaddress = request.getParameter("address");
            user.setId(editid);
            user.setName(editname);
            user.setEmail(editemail);
            user.setAddress(editaddress);

            request.getRequestDispatcher("WEB-INF/UserEdit.jsp").forward(request, response);
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

        //once click on edit button from user profile, function this code
        String editprofile = request.getParameter("editprofile");

        if (editprofile!= null && editprofile.equalsIgnoreCase(editprofile)) {
            String id = request.getParameter("id");
            String editname = request.getParameter("name");
            String editemail = request.getParameter("email");
            String editaddress = request.getParameter("address");
            
            
            

            if (user.editUser(id, editname, editemail, editaddress)) {
                int editID = Integer.parseInt(id);
                edituser.setId(editID);
                edituser.setUserLoginName(editname);
                edituser.setEmail(editemail);
                edituser.setAddress(editaddress);
                
                
                HttpSession session = request.getSession();
                session.setAttribute("user", edituser);
                session.setAttribute("name", editname);
                session.setAttribute("email", editemail);
                session.setAttribute("address", editaddress);                
                Utils.showAlert(out, "Edit successfull !!", request, response, "controller?action=userprofile");
            } else {
                Utils.showAlert(out, "Edit unsuccessfull !!", request, response, "controller?action=userprofile");
            }
            request.getRequestDispatcher("WEB-INF/UserProfile.jsp").forward(request, response);
        }

        String sql = "SELECT * FROM users"; //Display user list
        request.setAttribute("users", user.getUsers(sql));
        request.getRequestDispatcher("WEB-INF/UserManage.jsp").forward(request, response);
    }
}
