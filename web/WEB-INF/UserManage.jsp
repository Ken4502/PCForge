<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.*"%>

<%
    List<HashMap<String, String>> users = (List<HashMap<String, String>>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Manage</title>

        <link rel="stylesheet" type="text/css" href="ErrorMessage.css">
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    </head>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            font-size: 15px;
            display: flex;
            align-items: top;
            justify-content: center;
            background-color: #ffcccc;
        }

        .container {
            width: 100%;
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

        h1 {
            font-size: 30px;
            color: #333;
            margin-bottom: 20px;
            text-align: left;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
            font-size: 15px;
            color: #333;
        }

        th {
            background-color: #f4f7fa;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        input[type="text"],
        input[type="password"],
        textarea {
            width: auto;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 15px;
        }

        textarea {
            text-align: left;
            width: 100%;
        }

        input[type="submit"],
        input[type="reset"],
        button {
            padding: 10px 20px;
            background-color: #ff9999;
            color: black;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover,
        button:hover {
            background-color: #e47575;
        }

        .toggle-button {
            margin-bottom: 20px;
            background-color: #ff9999;
            color: black;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            transition: background-color 0.3s ease;
        }

        .toggle-button:hover {
            background-color: #e47575;
        }

        #userForm {
            display: none;
            margin-top: 20px;
        }
    </style>
    <body>
        <div class="container">
        <div class="form-container">
        <h1>User Manage</h1>
        <button class="toggle-button" onclick="toggleForm()">Add a user</button>

        
            <form action="UserManageServlet" method="get" id="userForm" onsubmit="return validateForm();">
                <input type="text" name="name" placeholder="Username" required><br>
                <span class="error-message" id="usernameError"></span>
                <input type="text" name="email" placeholder="Email Address" required><br>        
                <span class="error-message" id="emailError"></span><br>
                <input type="password" name="password" placeholder="Password" required><br>
                <span class="error-message" id="passwordError"></span><br>
                <input type="password" name="confirmpassword" placeholder="Confirm Password" required><br>
                <span class="error-message" id="repassError"></span><br>
                <textarea name="address" placeholder="Home Address" required></textarea><br>
                <input type="submit" value="Submit">
                <input type="reset" value="Reset">
            </form>
        

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Address</th>
                <th>Register Time</th>
                <th colspan="2">Action</th>
            </tr>
            <% if (users != null && !users.isEmpty()) { %>
            <% for (HashMap<String, String> user : users) {%>
            <tr>
                <td><%= user.get("id")%></td>
                <td><%= user.get("name")%></td>
                <td><%= user.get("email")%></td>
                <td><%= user.get("address")%></td>
                <td><%= user.get("time")%></td>
                <td>
                    <form action="UserManageServlet" method="get">
                        <input type="hidden" name="edit" value="edit">
                        <input type="hidden" name="id" value="<%= user.get("id")%>">
                        <input type="hidden" name="name" value="<%= user.get("name")%>">
                        <input type="hidden" name="email" value="<%= user.get("email")%>">
                        <input type="hidden" name="address" value="<%= user.get("address")%>">
                        <button type="submit">Edit</button>
                    </form>
                </td>
                <td>
                    <form action="UserManageServlet" method="get">
                        <input type="hidden" name="delete" value="<%= user.get("id")%>">
                        <button onclick="return confirm('Are you sure you want to delete <%= user.get("name")%>?')">Delete</button>
                    </form>
                </td>    
            </tr>
            <% } %>
            <% } else { %>
            <tr>
                <td colspan="7">No user found</td>
            </tr>
            <% }%>
        </table>
        </div>
        </div>
        <script>
            function toggleForm() {
                var form = document.getElementById("userForm");
                form.style.display = (form.style.display === "none") ? "block" : "none";
            }
        </script>
    </body>
</html>
