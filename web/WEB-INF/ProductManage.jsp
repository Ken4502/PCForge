<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*"%>
<%
    // Retrieve the product list from request attribute
    List<Map<String, String>> products = (List<Map<String, String>>) request.getAttribute("products");
    List<Map<String, String>> categoryList = (List<Map<String, String>>) request.getAttribute("categoryList");

    Object isAdminObj = session.getAttribute("is_admin"); // Get session attribute
    boolean isAdmin = isAdminObj != null && (Boolean) isAdminObj; // Ensure it's a boolean

    String sortBy = (String) request.getAttribute("sortBy");
    String sortOrder = (String) request.getAttribute("sortOrder");

    if (sortBy == null) {
        sortBy = "product_name";  // Default sort by product name
    }
    if (sortOrder == null) {
        sortOrder = "ASC";  // Default order is ascending
    }


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
                font-size: 15px;
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
                position:relative;
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
            input[type="text"] {
                width: auto;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
            }
            input[type="submit"] {
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
            input[type="submit"]:hover{
                background-color: #e47575;
            }
            select[name="category"]{
                width: auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
            }
            .links {
                font-size: 18px;
                margin: 5px;
                text-align: left;
            }
            .links a {
                width: auto;
                padding: 10px;
                background-color: #ff9999;
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
                transition: background-color 0.3s;
                text-decoration: none;
            }
            .links a:hover {
                background-color: #e47575;
            }
            th{
                font-size: 18px;
            }
            .form-group {
                position: absolute;
                top: 150px;
                right: 30px; /* Pushes it to the right inside .form-container */
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                align-items: center;
            }
        </style>
    </head>
    <body class="body">
        <div class="container">
            <div class="form-container"> 

                <%        String message = (String) session.getAttribute("message");
                    String messageType = (String) session.getAttribute("messageType");
                    if (message != null) {
                %>
                <div class="<%= messageType%>">
                    <%= message%>
                </div>
                <%
                        session.removeAttribute("message"); // Remove message after displaying
                        session.removeAttribute("messageType");
                    }
                %>

                <h2>Product Management</h2>
                <div class="links">            
                    <a href="controller?action=productadd">Add Product</a>&nbsp
                    <button type="button" class="btn" onclick="location.href = 'controller?';">Back</button>
                    <form action="ProductManageServlet" method="GET">
                        <div class="form-group">                   
                            <label for="searchBy" style="font-size:18px;">Search by:</label>

                            <%
                                if (categoryList != null) {
                            %>
                            <select name="category">
                                <option value="">All</option>
                                <% for (Map<String, String> ctgr : categoryList) {%>
                                <option value="<%= ctgr.get("category_ID")%>">
                                    <%= ctgr.get("category_NAME")%>
                                </option>
                                <% } %>
                            </select>
                            <%
                            } else {
                            %>
                            <p>No categories available.</p>
                            <%
                                }
                            %>
                            <input type="text" name="search" placeholder="Enter product name">
                            <input type="submit" value="Search">

                        </div>

                    </form>
                </div>
                <h3>Product List</h3>
                <table>
                    <thead>
                        <tr>
                            <th>ID
                                <a href="ProductManageServlet?sortBy=id&sortOrder=<%= "id".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "id".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                            </th>
                            <th>Product Name
                                <a href="ProductManageServlet?sortBy=product_name&sortOrder=<%= "product_name".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "product_name".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                            </th>
                            <th>Price
                                <a href="ProductManageServlet?sortBy=price&sortOrder=<%= "price".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "price".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                            </th>
                            <th>Quantity
                                <a href="ProductManageServlet?sortBy=quantity&sortOrder=<%= "quantity".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "quantity".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                            </th>
                            <th>Category
                                <a href="ProductManageServlet?sortBy=category_id&sortOrder=<%= "category_id".equals(sortBy) && "ASC".equals(sortOrder) ? "DESC" : "ASC"%>">
                                    <span class="sort-arrow <%= "category_id".equals(sortBy) ? sortOrder.toLowerCase() : "asc"%>"></span>
                                </a>
                            </th>
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null && !products.isEmpty()) { %>
                        <% for (Map<String, String> product : products) {%>
                        <tr>
                            <td><%= product.get("id")%></td>
                            <td><%= product.get("name")%></td>
                            <td>RM<%= String.format("%.2f", Double.parseDouble(product.get("price")))%></td>
                            <td><%= product.get("quantity")%></td>
                            <td><%= product.get("category")%></td>
                            <td><img src="<%= product.get("image")%>" class="img" alt="Product Image"></td>
                            <td>
                                <div class="links">
                                    <a href="controller?action=productEdit&id=<%= product.get("id")%>">Edit</a>
                                    <% if (isAdmin) {%>&nbsp
                                    <a href="controller?action=productDelete&id=<%= product.get("id")%>" 
                                       onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        <% } else { %>
                        <tr>
                            <td colspan="7">No products found.</td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>        
        </div>        

    </body>
</html>
