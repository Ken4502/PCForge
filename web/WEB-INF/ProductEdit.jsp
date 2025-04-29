<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        h2 {
            font-size: 30px;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        
        .container {
            width: auto;
            max-width: 500px;
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
        
        .form-group {
            margin-bottom: 10px;
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
        
        input[type="text"],
        input[type="number"],
        input[type="file"]{
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        input[type="radio"]{
            margin-bottom: 10px;
            margin-top: 10px;
        }
    </style>
        <title>Edit Product</title>
    </head>
    <body class="body">
        <div class="container">
            <div class="form-container">
                <h2>Edit Product</h2>
                <%
                    HashMap<String, String> product = (HashMap<String, String>) request.getAttribute("product");
                    List<HashMap<String, String>> categoryList = (List<HashMap<String, String>>) request.getAttribute("categoryList");

                    if (product != null) {
                        // Prevent NullPointerException by providing default values
                        String priceStr = product.get("price");
                        double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.00;

                        String quantityStr = product.get("quantity");
                        int quantity = (quantityStr != null && !quantityStr.isEmpty()) ? Integer.parseInt(quantityStr) : 0;

                        String imageUrl = (product.get("image_url") != null) ? product.get("image_url") : "";
                        String categoryStr = product.get("category");
                        int selectedCategoryId = (categoryStr != null && !categoryStr.isEmpty()) ? Integer.parseInt(categoryStr) : -1;
                %>

                <form action="controller?action=productUpdate" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="<%= product.get("id") %>">

                    <div class="form-group"><label>Product Name:</label>
                    <input type="text" name="name" value="<%= product.get("name") %>" required></div>

                    <div class="form-group"><label>Price:</label>
                    <input type="number" step="0.01" name="price" value="<%= price %>" min="0.1" required></div>

                    <div class="form-group"><label>Quantity:</label>
                    <input type="number" name="quantity" value="<%= quantity %>" min="1" required></div>

                    <div class="form-group"><label>Current Image:</label>
                    <img src="<%= imageUrl %>" alt="Product Image" width="150"><br><br>
                    <input type="hidden" name="existingImageUrl" value="<%= imageUrl %>"></div>

                    <div class="form-group"><label>Upload New Image:</label>
                    <input type="file" name="image" accept=".png, .jpg, .jpeg"></div>

                    <div class="form-group"><label>Category:</label><br>
                    <% 
                        for (HashMap<String, String> category : categoryList) { 
                            int categoryId = Integer.parseInt(category.get("id"));
                    %>
                        <input type="radio" name="category" value="<%= categoryId %>" 
                            <%= (categoryId == selectedCategoryId) ? "checked" : "" %> >
                        <%= category.get("name") %><br>
                    <% } %>
                    </div>
                    <div class="form-group">
                    <button type="submit" class="btn">Update</button>
                    <button type="button" class="btn" onclick="location.href='ProductManageServlet';">Back</button>
                    </div>
                </form>

                <%
                    } else {
                %>
                    <p>Product not found.</p>
                <%
                    }
                %>
             </div>
        </div>    
    </body>
</html>
