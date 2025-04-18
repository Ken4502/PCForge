<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="Header.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu</title>
</head>
<body class="body">
    <h2>Hello
        <%
        HttpSession sessionObj = request.getSession(false);
        String loggedInUser = (sessionObj != null) ? (String) sessionObj.getAttribute("username") : null;
        String loggedInUserID = (sessionObj != null) ? (String) (String.valueOf(sessionObj.getAttribute("userId"))) : null;
        String loggedInAdmin = (sessionObj != null) ? (String) sessionObj.getAttribute("adminname") : null;
        Object isAdminObj = session.getAttribute("is_admin"); // Get session attribute
        boolean isAdmin = isAdminObj != null && (Boolean) isAdminObj; // Ensure it's a boolean

        if (loggedInUser != null) {
            out.print(loggedInUser);
        } else if (loggedInAdmin != null) {
            out.print(loggedInAdmin);
        } else {
            out.print("Guest");
        }
        %>, <br>Welcome to PC Forge!
    </h2>

    <%
    if (loggedInAdmin != null) { 
        // If admin is logged in, show admin features
        if (isAdmin){
        %>
        <a href="controller?action=staffmanage">Manage Staff</a>
        <%
        }
    %>
        <a href="controller?action=staffaccountmanage">Manage Account</a>
        <a href="controller?action=productmanage">Manage Product</a>
        <a href="AdminLogoutServlet" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
    <%
    } else if (loggedInUser != null) { 
        // If a normal user is logged in, show normal logout
    %>
        <a href="controller?action=orderTracking">Track Orders</a>
        <a href="controller?action=productview">View Product</a>
        <a href="LogoutServlet">Logout</a>
    <%
    } else { 
        // If no one is logged in, show login/register options
    %>
        <a href="controller?action=productview">View Product</a>
        <a href="controller?action=login">Login</a>
        <a href="controller?action=register">Sign up now!</a>
        <a href="controller?action=adminlogin">Staff Portal</a>
    <%
    }
    %>
</body>
</html>
