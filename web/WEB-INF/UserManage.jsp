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

    </head>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            align-items: flex-start; /* Align content to the left */
            padding-left: 20px; /* Add some left padding for better spacing */
        }

        h1 {
            margin-top: 40px;
            color: #333;
        }

        table {
            width: 80%;
            margin: 20px 0;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: center;
            border: 1px solid #ddd;
            font-size: 14px;
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

        #userForm {
            display: none;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
            align-items:center;
            width: 100%;
            margin-top: 20px;
        }

        input[type="text"],
        input[type="password"],
        textarea{
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            text-align: center;
        }

        textarea{
            text-align: left;
        }

        input[type="submit"],
        input[type="reset"] {
            width: 150px;
            padding: 10px;
            margin: 10px 10px 10px 0;
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

        button {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #e53935;
        }

        .form-container {
            text-align: center;
        }

        .toggle-button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;

        }

        .toggle-button:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            font-size: 14px;
            display: none;
        }
    </style>
    <body>
        <h1>User Manage</h1>
        <button class="toggle-button" onclick="toggleForm()">Add a user</button>

        <div class="form-container">
            <form action="UserManageServlet" method="get" id="userForm">
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
        </div>

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

        <script>
            function toggleForm() {
                var form = document.getElementById("userForm");
                form.style.display = (form.style.display === "none") ? "block" : "none";
            }
        </script>
    </body>
</html>
