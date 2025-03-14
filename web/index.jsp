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
        %>
        <%  //dyinamically get username from session
            if (loggedInUser != null){
                out.print(loggedInUser);
            }else{
                out.print("Guest");
            }
        %>, <br>Welcome to PC Forge!
    </h2>


        <%
        if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        %>
            <a href="controller?action=login" >Login</a>
            <a href="controller?action=register" >Sign up now!</a>
        <%
        }else{
        %>
            <a href="LogoutServlet">Logout</a>
        <%    
        }
    %>  
    
</body>
</html>