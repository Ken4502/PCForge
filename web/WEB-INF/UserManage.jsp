<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.*"%>

<%
    List<HashMap<String, String>> users = (List<HashMap<String, String>>) request.getAttribute("users");
    Object isAdminObj = session.getAttribute("is_admin"); // Get session attribute
    boolean isAdmin = isAdminObj != null && (Boolean) isAdminObj; // Ensure it's a boolean
    
    String sortBy = (String) request.getAttribute("sortBy");
    String sortOrder = (String) request.getAttribute("sortOrder");

    if (sortBy == null) {
        sortBy = "id";  // Default sort by user id
    }
    if (sortOrder == null) {
        sortOrder = "ASC";  // Default order is ascending
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Manage</title>
<style>
        .sort-arrow {
                cursor: pointer;
                font-size: 14px;
            }
            .asc:before {
                content: "\25B2"; 
            }
            .desc:before {
                content: "\25BC"; 
            }
           
        body {
            font-family: 'Arial', sans-serif;
            font-size: 15px;
            display: flex;
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
        .error-message {
            color: red;
            font-size: 14px;
            display: none;
        }
        .input-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            gap: 10px; /* space between input and p */
        }

        .input-group p {
            margin: 0;
            font-size: 14px;
            color: #666;
        }

        select[id="searchBy"] {
            width: auto;
            margin-top: 10px;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 15px;
        }

        input[type="text"]#searchInput {
            width: auto;
            margin-top: 10px;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 15px;
        }
        #searchControls {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
            margin-bottom: 10px;

        }


    </style>
    </head>
    
    <body>
        <div class="container">
            <div class="form-container">
                <h1>User Manage</h1>
                <button class="toggle-button" onclick="toggleForm()">Add a user</button>
                <button type="button" class="btn" onclick="location.href = 'controller?';">Back</button>


                <form action="UserManageServlet" method="get" id="userForm">
                    <div class="input-group">                
                        <input type="text" name="name" placeholder="Username" required>
                        <p>Username must be at least 4 characters long and contain a uppercase letter.</p>
                    </div>
                    <div class="input-group"> 
                        <input type="text" name="email" placeholder="Email Address" required>
                        <p>Email must be '(sample@email.com)'.</p><br>    
                    </div>
                    <div class="input-group"> 
                        <input type="password" name="password" placeholder="Password" required>
                        <p>Password must be at least 8 characters long and contain at least one letter and one number.</p><br>
                    </div>
                    <input type="password" name="confirmpassword" placeholder="Confirm Password" required><br>
                    <p>Address is optional</p><br>
                    <textarea name="address" placeholder="Home Address"></textarea>
                    <input type="submit" value="Submit">
                    <input type="reset" value="Reset">
                </form>


                <div id="searchControls">
                    <label for="searchBy" style="font-size:18px;">Search by:</label>

                    <select id="searchBy">
                        <option value="id">ID</option>
                        <option value="name">Name</option>
                        <option value="email">Email</option>
                        <option value="address">Address</option>
                    </select>
                    <input
                        type="text"
                        id="searchInput"
                        onkeyup="searchUsers()"
                        placeholder="Enter search term…"
                        title="Type to search"
                        />
                </div>
                <table>
                    <tr>
                        <th>ID
                        <a href="UserManageServlet?sortBy=id&sortOrder=<%= "id".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "id".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                        </th>
                        <th>Name
                        <a href="UserManageServlet?sortBy=name&sortOrder=<%= "name".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "name".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                        </th>
                        <th>Email
                        <a href="UserManageServlet?sortBy=email&sortOrder=<%= "email".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "email".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                        </th>
                        <th>Address
                        <a href="UserManageServlet?sortBy=address&sortOrder=<%= "address".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "address".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                        </th>
                        <th>Register Time
                        <a href="UserManageServlet?sortBy=created_at&sortOrder=<%= "created_at".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "created_at".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                        </th>
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
                        <%if (isAdmin) {%>
                        <td>
                            <form action="UserManageServlet" method="get">
                                <input type="hidden" name="delete" value="<%= user.get("id")%>">
                                <button onclick="return confirm('Are you sure you want to delete <%= user.get("name")%>?')">Delete</button>
                            </form>
                        </td>
                        <%}%>
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

            function searchUsers() {
                const input = document.getElementById("searchInput").value.toUpperCase();
                const filterCol = document.getElementById("searchBy").value;
                const table = document.querySelector("table");
                const trs = table.tBodies[0].getElementsByTagName("tr");

                // Column indices: id=0, name=1, email=2, address=3
                const colMap = {id: 0, name: 1, email: 2, address: 3};

                for (const tr of trs) {
                    let txt = "";
                    if (tr.getElementsByTagName("td").length === 0)
                        continue; // skip header/footer
                    if (filterCol === "all") {
                        const tds = tr.getElementsByTagName("td");
                        for (let i = 0; i < tds.length; i++) {
                            txt += tds[i].textContent + " ";
                        }
                    } else {
                        const idx = colMap[filterCol];
                        txt = tr.getElementsByTagName("td")[idx].textContent;
                    }
                    tr.style.display = txt.toUpperCase().includes(input) ? "" : "none";
                }
            }

        </script>
    </body>
</html>
