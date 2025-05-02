<%@ page import="java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../Header.jsp"/>
<%                    String sortBy = (String) request.getAttribute("sortBy");
                    String sortOrder = (String) request.getAttribute("sortOrder");

                    if (sortBy == null) {
                        sortBy = "id";  // Default sort by product name
                    }
                    if (sortOrder == null) {
                        sortOrder = "ASC";  // Default order is ascending
                    }%>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <style>
        .sort-arrow {
                cursor: pointer;
                font-size: 14px;
            }
            .asc:before {
                content: "▲";
            }
            .desc:before {
                content: "▼";
            }
        body {
            display: flex;
            align-items: top;
            justify-content: center;
        }
        
        h2 {
            font-size: 30px;
            text-align: left;
            margin-bottom: 20px;
            color: #333;
        }
        
        h3 {
            font-size: 25px;
            text-align: left;
            margin-bottom: 20px;
            color: #333;
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
    </style>
    <title>Manage Staff</title>
</head>
<body class="body">
    <div class="container">
        <div class="form-container">
            <h2>Staff Management</h2>
            <form action="StaffAddServlet" method="post">
                <button type="submit" class="btn">Add New Staff</button>
                <button type="button" class="btn" onclick="location.href='controller?';">Back</button>
            </form>
            <h3>Staff List</h3>
            <table style="margin-bottom:10px;">
                <tr>
                    <th>ID
                        <a href="StaffManageServlet?sortBy=id&sortOrder=<%= "id".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                            <span class="sort-arrow <%= "id".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                        </a>
                    </th>
                    <th>Username
                        <a href="StaffManageServlet?sortBy=username&sortOrder=<%= "username".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                            <span class="sort-arrow <%= "username".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                        </a>
                    </th>
                    <th>Created At
                        <a href="StaffManageServlet?sortBy=created_at&sortOrder=<%= "created_at".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                            <span class="sort-arrow <%= "created_at".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                        </a>
                    </th>
                    <th>Actions</th> <!-- New column for actions -->
                </tr>
                <%
                    List<HashMap<String, String>> staffList = (List<HashMap<String, String>>) request.getAttribute("staffList");                    
                    if (staffList != null && !staffList.isEmpty()) {
                        for (HashMap<String, String> staff : staffList) {
                %>
                            <tr>
                                <td><%= staff.get("id") %></td>
                                <td><%= staff.get("username") %></td>
                                <td><%= staff.get("created_at") %></td>
                                <td>
                                    <!-- Edit/Delete Button with confirmation -->
                                    <a href="#" 
                                        onclick="editStaff('<%= staff.get("id") %>'); return false;">
                                        <button class="btn">Edit Account</button>
                                     </a>
                                    <a href="StaffDeleteServlet?id=<%= staff.get("id") %>" 
                                       onclick="return confirm('Are you sure you want to delete this staff member?');">
                                        <button class="btn">Delete Account</button>
                                    </a>
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr><td colspan="5">No staff found.</td></tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>                
</body>
</html>

<script>
function editStaff(staffId) {
    let newPassword = prompt("Enter new password:");

    if (newPassword !== null && newPassword !== "") {
        let encodedPassword = encodeURIComponent(newPassword); // Encode to avoid URL issues
        window.location.href = "StaffEditServlet?id=" + staffId + "&newpass=" + encodedPassword;
    } else {
        alert("Password cannot be empty!");
    }
}
</script>
