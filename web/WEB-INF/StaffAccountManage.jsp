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
            input[type="password"]{
                width: 100%;
                padding: 5px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
            }
        </style>
        <title>Manage My Account</title>
    </head>
    <body class="body">
        <div class="container">
            <div class="form-container">
        
                <h2>Manage Your Account</h2>

                <% if (errorMessage != null) { %>
                    <p style="color: red;"><%= errorMessage %></p>
                <% } %>

                <% if (successMessage != null) { %>
                    <p style="color: green;"><%= successMessage %></p>
                <% } %>

                <form action="StaffAccountManageServlet" method="post">
                    <div class="form-group">
                    <label>Username: </label>
                    <input type="text" name="username" value="<%= adminname %>" disabled><br><br>
                    </div>
                    <div class="form-group">
                    <label>New Password: </label>
                    <input type="password" name="newPassword" required>
                    </div>
                    <div class="form-group">
                    <button type="submit" class="btn">Update Password</button>
                    <button type="button" class="btn" onclick="location.href='controller?';">Back</button>
                    </div>
                </form>
            </div>
        </div>         
                    
    </body>
</html>
