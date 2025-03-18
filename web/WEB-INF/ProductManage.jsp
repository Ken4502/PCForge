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
        table {
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        .img {
            max-width: 50px;
            max-height: 50px;
        }
    </style>
</head>
<body class="body">

    <a href="controller?action=productadd">Add Product</a>
    <h2>Product List</h2>
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
                        <td>RM<%= product.get("price") %></td>
                        <td><%= product.get("quantity") %></td>
                        <td><%= product.get("category") %></td>
                        <td><img src="<%= product.get("image") %>" class="img" alt="Product Image"></td>
                        <td>
                            <a href="ProductEditServlet?id=<%= product.get("id") %>">Edit</a> 
                            <% if (isAdmin) { %>|
                            <a href="ProductDeleteServlet?id=<%= product.get("id") %>" onclick="return confirm('Are you sure?')" >Delete</a>
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