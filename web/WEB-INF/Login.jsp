<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
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
        
        .links {
            margin-top: 20px;
            text-align: left;
        }

        .links a {   
            margin-top: 10px;
            color: #0d47e4;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
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
        input[type="password"] {
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
            <h2>Login and Get Started!</h2>
            <form action="LoginServlet" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-group"><label>Username:</label> <input type="text" id="username" name="username" required></div>
                <span class="error-message" id="usernameError"></span>
                <br>

                <div class="form-group"><label>Password:</label> <input type="password" id="password" name="password" required></div>
                <span class="error-message" id="passwordError"></span>
                <br>

                <div class="form-group">
                <button type="submit" class="btn">Log In</button>
                <button type="button" class="btn" onclick="location.href='index.jsp';">Back</button>
                </div>
            </form>

            <div class="links">
            <a href="controller?action=adminlogin">Admin Login</a>
            </div>
            <script src="loginValidation.js"></script>
        </div>
    </div>
</body>
</html>