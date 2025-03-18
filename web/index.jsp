<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="Header.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Gadget & Accessories</title>
</head>
<body class="body">
    <h2>Hello
        <%
        HttpSession sessionObj = request.getSession(false);
        String loggedInUser = (sessionObj != null) ? (String) sessionObj.getAttribute("username") : null;
        String loggedInAdmin = (sessionObj != null) ? (String) sessionObj.getAttribute("adminname") : null;

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
    %>
        <a href="controller?action=productmanage">Manage Product</a>
        <a href="AdminLogoutServlet">Logout</a>
    <%
    } else if (loggedInUser != null) { 
        // If a normal user is logged in, show normal logout
    %>
        <a href="LogoutServlet">Logout</a>
    <%
    } else { 
        // If no one is logged in, show login/register options
    %>
        <a href="controller?action=login">Login</a>
        <a href="controller?action=register">Sign up now!</a>
        <a href="controller?action=adminlogin">Staff Portal</a>
    <%
    }
    %>
</body>
</html>
