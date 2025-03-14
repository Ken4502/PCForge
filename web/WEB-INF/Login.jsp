<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
</head>
<body class="body">
    <h2>Login and Get Started!</h2>
    <form action="LoginServlet" method="post">
        <input type="hidden" name="action" value="login">
        <label>Username:</label> <input type="text" name="name" required><br>
        <label>Password:</label> <input type="text" name="password" required><br><br>
        <button type="submit">Log In</button>
    </form>
    
</body>
</html>