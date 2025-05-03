<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../Header.jsp"/>
<%@page import="Model.User" %>
<jsp:useBean id="user" class="Model.User" scope="session"></jsp:useBean>
<jsp:setProperty name="user" property="*" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Edit</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                background-color: #ffcccc; /* Updated background color */
            }

            .container {
                width: 100%;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .form-container {
                background-color: #ffe8e8;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 500px;
                margin-top: 80px;
            }

            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }

            input[type="text"],
            textarea {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
            }

            textarea {
                text-align: left;
            }

            input[type="submit"] {
                width: 100%;
                padding: 10px;
                margin-top: 10px;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                background-color: #ff9999;
                color: black;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            input[type="submit"]:hover {
                background-color: #e47575;
            }

            .error-message {
                color: red;
                font-size: 13px;
                display: block;
                margin-bottom: 5px;
                text-align: left;
                padding-left: 5px;
            }

            .backbutton {
                background-color: #f44336;
                color: white;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="form-container">
                <button onclick="history.back()" class="backbutton">Back</button>
                <h1>Edit User</h1>
                <form action="UserManageServlet" method="post" id="userForm">
                    <label>ID:</label>
                    <input type="hidden" name="edituser" value="edituser">
                    <input type="text" value="<%= user.getId()%>" disabled>
                    <input type="hidden" name="userid" value="<%= user.getId()%>">

                    <label>Username:</label>
                    <input type="text" name="name" placeholder="Username" value="<%= user.getName()%>" required>
                    <span class="error-message" id="usernameError"></span>

                    <label>Email:</label>
                    <input type="text" name="email" placeholder="Email Address" value="<%= user.getEmail()%>" required>
                    <span class="error-message" id="emailError"></span>

                    <label>Address:</label>
                    <textarea name="address" placeholder="Home Address"><%= user.getAddress()%></textarea>

                    <input type="submit" value="Submit">
                </form>
            </div>
        </div>
    </body> 
</html>