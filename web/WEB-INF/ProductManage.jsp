<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    // Retrieve the product list from request attribute
    List<Map<String, String>> products = (List<Map<String, String>>) request.getAttribute("products");
    
    Object isAdminObj = session.getAttribute("is_admin"); // Get session attribute
    boolean isAdmin = isAdminObj != null && (Boolean) isAdminObj; // Ensure it's a boolean


%>

<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Product</title>
    <style>
        .img {
            max-width: 50px;
            max-height: 50px;
        }
    </style>
</head>
<body class="body">
    <%
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null) {
    %>
        <div class="<%= messageType %>">
            <%= message %>
        </div>
    <%
        session.removeAttribute("message"); // Remove message after displaying
        session.removeAttribute("messageType");
        }
    %>

    <h2>Product Management</h2>
    <a href="controller?action=productadd">Add Product</a>
    <h3>Product List</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Category</th>
                <th>Image</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if (products != null && !products.isEmpty()) { %>
                <% for (Map<String, String> product : products) { %>
                    <tr>
                        <td><%= product.get("id") %></td>
                        <td><%= product.get("name") %></td>
                        <td>RM<%= String.format("%.2f", Double.parseDouble(product.get("price"))) %></td>
                        <td><%= product.get("quantity") %></td>
                        <td><%= product.get("category") %></td>
                        <td><img src="<%= product.get("image") %>" class="img" alt="Product Image"></td>
                        <td>
                            <a href="controller?action=productEdit&id=<%= product.get("id") %>">Edit</a>
                            <% if (isAdmin) { %>|
                            <a href="controller?action=productDelete&id=<%= product.get("id") %>" 
                                onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="7">No products found.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>