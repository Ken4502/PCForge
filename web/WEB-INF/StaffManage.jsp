<%@ page import="java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../Header.jsp"/>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <title>Manage Staff</title>
</head>
<body class="body">
    <h2>Staff Management</h2>
    <form action="StaffAddServlet" method="post">
        <button type="submit">Add New Staff</button>
    </form>
    <h3>Staff List</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Created At</th>
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
                                <button>Edit Account</button>
                             </a>
                            <a href="StaffDeleteServlet?id=<%= staff.get("id") %>" 
                               onclick="return confirm('Are you sure you want to delete this staff member?');">
                                <button>Delete Account</button>
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
