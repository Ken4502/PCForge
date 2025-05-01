/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Model;

import Util.Utils;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TANGH
 */
@WebServlet(name = "UserProfileServlet", urlPatterns = {"/UserProfileServlet"})
public class UserProfileServlet extends HttpServlet {

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

        //User want to change password from the profile page
        String stringID = request.getParameter("id");
        int id = Integer.parseInt(stringID);
        String oldPassword = request.getParameter("oldPassword").trim();   //hash back the password for validation purpose
        String newPassword = request.getParameter("newPassword").trim();

        if (oldPassword != null && newPassword != null) {
            if (user.validateEditPassword(id, oldPassword, newPassword)) {
                Utils.showAlert(out, "Password changed successfull !!", request, response, "controller?action=userprofile");

            } else {
                String error = user.changePassword(id,oldPassword,newPassword);
                Utils.remainPage(out, error, request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        //once click on edit button from user profile, function this code
        String editprofile = request.getParameter("editprofile");

        if (editprofile != null && editprofile.equalsIgnoreCase(editprofile)) {
            String id = request.getParameter("id");
            String editname = request.getParameter("name");
            String editemail = request.getParameter("email");
            String editaddress = request.getParameter("address");

            String valid = "User Edit successfull !!";
            if (valid.equals(user.editUser(id,editname,editemail,editaddress))) {
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
                String error = user.editUser(id, editname, editemail, editaddress);
                Utils.remainPage(out, error, request, response);    //if error, remain the page
            }
            request.getRequestDispatcher("WEB-INF/UserProfile.jsp").forward(request, response);
        }

    }   

}
