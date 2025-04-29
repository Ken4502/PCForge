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
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        h2 {
            font-size: 30px;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        
        .container {
            width: auto;
            max-width: 500px;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        
        .form-container {
            background-color: #ffe8e8;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 10px;
        }
        
        .btn {
            width: auto;
            padding: 10px;
            background-color: #ff9999;
            color: black;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #e47575;
        }
        
        input[type="text"],
        input[type="password"],
        input[type="email"],
        textarea[name="address"]{
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
    </style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>

</head>
<body class="body">
    <div class="container">
        <div class="form-container">
            <h2>Become a Member!</h2>
            <form action="RegistrationServlet" method="post" onsubmit="return validateForm();">
                <input type="hidden" name="action" value="add">
                <div class="form-group"><label for="name">Username:</label> <input type="text" id="name" name="name" value="<%= name != null ? name : "" %>" required></div>
                <span class="error-message" id="usernameError"></span>
                <br>

                <div class="form-group"><label for="email">Email:</label> <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" required></div>
                <span class="error-message" id="emailError"></span><br>

                <div class="form-group"><label for="password">Password:</label> <input type="password" id="password" name="password" required ></div>
                <span class="error-message" id="passwordError"></span><br>

                <div class="form-group"><label for="repass">Confirm Password:</label> <input type="password"  id="repass" name="repass" required ></div>
                <span class="error-message" id="repassError"></span><br>

                <div class="form-group"><label for="address">Enter Address:</label></div>
                <textarea id="address" name="address" rows="4" cols="50" placeholder="Enter your full address here..."><%= address != null ? address : "" %></textarea><br><br>

                <div class="form-group">
                <button type="submit" class="btn">Create Account</button>&nbsp&nbsp
                <button type="button" class="btn" onclick="location.href='index.jsp';">Back</button> 
                </div>
            </form>
        
        <script src="userRegistrationValidation.js"></script>
        </div>
    </div>             
</body>
</html>