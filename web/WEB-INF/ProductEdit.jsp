<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <title>Edit Product</title>
    </head>
    <body class="body">
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

        <form action="controller?action=productUpdate" method="POST">
            <input type="hidden" name="id" value="<%= product.get("id") %>">

            <label>Product Name:</label>
            <input type="text" name="name" value="<%= product.get("name") %>" required><br>

            <label>Price:</label>
            <input type="number" step="0.01" name="price" value="<%= price %>" required><br>

            <label>Quantity:</label>
            <input type="number" name="quantity" value="<%= quantity %>" required><br>
            
            <label>Image URL:</label>
            <input type="text" name="image_url" value="<%= imageUrl %>" required><br>
            
            <label>Category:</label><br>
            <% 
                for (HashMap<String, String> category : categoryList) { 
                    int categoryId = Integer.parseInt(category.get("id"));
            %>
                <input type="radio" name="category" value="<%= categoryId %>" 
                    <%= (categoryId == selectedCategoryId) ? "checked" : "" %> >
                <%= category.get("name") %><br>
            <% } %>

            <button type="submit">Update</button>
        </form>

        <%
            } else {
        %>
            <p>Product not found.</p>
        <%
            }
        %>
    </body>
</html>
