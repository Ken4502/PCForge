<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<% String name = (String) session.getAttribute("name");
   String email = (String) session.getAttribute("email");
   String address = (String) session.getAttribute("address");
   session.removeAttribute("name");
   session.removeAttribute("email");
   session.removeAttribute("address");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
</head>
<body class="body">
    <h2>Become a Member!</h2>
    <form action="RegistrationServlet" method="post">
        <input type="hidden" name="action" value="add">
        <label>Username:</label> <input type="text" name="name" value="<%= name != null ? name : "" %>" required><br>
        <label>Email:</label> <input type="email" name="email" value="<%= email != null ? email : "" %>" required><br>
        <label>Password:</label> <input type="text" name="password" required><br>
        <label>Confirm Password:</label> <input type="text" name="repass" required><br>
        <label for="address">Enter Address:</label><br>
        <textarea id="address" name="address" rows="4" cols="50" placeholder="Enter your full address here..."><%= address != null ? address : "" %></textarea><br><br>
        <button type="submit">Create Account</button>
    </form>
</body>
</html>