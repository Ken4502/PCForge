<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <link rel="stylesheet" type="text/css" href="ErrorMessage.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
</head>
<body class="body">
    <h2>Staff Login</h2>
    <form action="AdminLoginServlet" method="post">
        <input type="hidden" name="action" value="login">
        <label>Staff Username:</label> <input type="text" id="username" name="username" required><br>
        <span class="error-message" id="usernameError"></span>
        <br>
        
        <label>Password:</label> <input type="password" id="password" name="password" required><br><br>
        <span class="error-message" id="passwordError"></span>
        <br>
        
        <button type="submit">Log In</button>
        <button type="button" onclick="location.href='index.jsp';">Back</button>
    </form>
    
    <script src="loginValidation.js"></script>
</body>
</html>