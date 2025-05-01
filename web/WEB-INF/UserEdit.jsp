<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../Header.jsp"/>
<%@page import="Model.User" %>
<jsp:useBean id="user" class="Model.User" scope="session"></jsp:useBean> <!--Using javabean-->
<jsp:setProperty name="user" property="*" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Edit</title>
    </head>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f4f7fa;
        }

        #userForm {
            background-color: #fff;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
            width: 400px;
            margin-top:100px;
        }

        h1 {
            position: absolute;
            top: 90px;
            left: 50%;
            transform: translateX(-50%);
            color: #333;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            text-align: center;
        }

        textarea {
            text-align: left;
        }

        input[type="submit"],
        input[type="reset"] {
            width: 48%;
            padding: 10px;
            margin: 10px 1% 0 1%;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background-color: #45a049;
        }

        .error-message {
            color: red;
            font-size: 13px;
            display: block;
            margin-bottom: 5px;
            text-align: left;
            padding-left: 5px;
        }
        .backbutton{
            position: absolute;
            top: 100px;
            left: 20px;
            background-color: #f44336;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
    </style>
    <body>
        <button onclick="history.back()" class="backbutton">Back</button>

        <h1>Edit User</h1>
        <form action="UserManageServlet" method="post" id="userForm" onsubmit="return validateForm();">
            <label>ID:</label>
            <input type="text" value="<%= user.getId()%>" disabled>
            <input type="hidden" name="userid" value="<%= user.getId()%>">
            <label>Username:</label>
            <input type="text" name="name" placeholder="Username" value="<%= user.getName()%>" required><br>
            <span class="error-message" id="usernameError"></span>            
            <label>Email:</label>
            <input type="text" name="email" placeholder="Email Address" value="<%= user.getEmail()%>" required><br>        
            <span class="error-message" id="emailError"></span><br>
            <label>Address:</label>
            <textarea name="address" placeholder="Home Address" required><%= user.getAddress()%></textarea><br>
            <input type="submit" value="Submit">
        </form>
    </body>
</html>
