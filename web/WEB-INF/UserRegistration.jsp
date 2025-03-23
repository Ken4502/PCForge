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
    <link rel="stylesheet" type="text/css" href="ErrorMessage.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>

</head>
<body class="body">
    <h2>Become a Member!</h2>
    <form action="RegistrationServlet" method="post" onsubmit="return validateForm();">
        <input type="hidden" name="action" value="add">
        <label for="name">Username:</label> <input type="text" id="name" name="name" value="<%= name != null ? name : "" %>" required><br>
        <span class="error-message" id="usernameError"></span>
        <br>
        
        <label for="email">Email:</label> <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" required><br>
        <span class="error-message" id="emailError"></span><br>
        
        <label for="password">Password:</label> <input type="password" id="password" name="password" required ><br>
        <span class="error-message" id="passwordError"></span><br>
        
        <label for="repass">Confirm Password:</label> <input type="password"  id="repass" name="repass" required ><br>
        <span class="error-message" id="repassError"></span><br>
        
        <label for="address">Enter Address:</label><br>
        <textarea id="address" name="address" rows="4" cols="50" placeholder="Enter your full address here..."><%= address != null ? address : "" %></textarea><br><br>
        
        <button type="submit">Create Account</button>
        <button type="button" onclick="location.href='index.jsp';">Back</button> 

    </form>
        
        <script src="userRegistrationValidation.js"></script>
</body>
</html>