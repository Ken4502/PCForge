<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<jsp:include page="../Header.jsp"/>
<%
    String adminname = (String) request.getAttribute("adminname");
    String errorMessage = request.getParameter("error");
    String successMessage = request.getParameter("message");
%>

<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <title>Manage My Account</title>
    </head>
    <body class="body">

        <h2>Manage Your Account</h2>

        <% if (errorMessage != null) { %>
            <p style="color: red;"><%= errorMessage %></p>
        <% } %>

        <% if (successMessage != null) { %>
            <p style="color: green;"><%= successMessage %></p>
        <% } %>

        <form action="StaffAccountManageServlet" method="post">
            <label>Username: </label>
            <input type="text" name="username" value="<%= adminname %>" readonly><br><br>

            <label>New Password: </label>
            <input type="password" name="newPassword" required>
            </br>
            </br>
            <button type="submit">Update Password</button>
            <button type="button" onclick="location.href='controller?';">Back</button>
        </form>

    </body>
</html>
