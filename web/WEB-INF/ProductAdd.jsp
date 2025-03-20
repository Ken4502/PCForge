<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
</head>
<body class="body">
    <h2>Add Product</h2>
<form action="ProductAddServlet" method="post">
    <input type="hidden" name="action" value="addproduct">

    <label>Product name:</label> <input type="text" name="productname" required><br>
    <label>Price:</label> <input type="number" step="0.01" name="price" required><br>
    <label>Quantity:</label> <input type="number" name="quantity" required><br>
    <label>Image URL:</label> <input type="text" name="image" required><br>

    <label>Category:</label><br>
    <c:forEach var="category" items="${categoryList}">
        <input type="radio" name="category" value="${category.id}"> ${category.name} <br>
    </c:forEach>
    
    <button type="button" onclick="addCategory()">Add New Category</button> <br><br>
        
    <button type="submit">Add Product</button>
</form>
    
</body>
</html>

<script>
    function addCategory() {
        let categoryName = prompt("Enter new category name:");
        if (categoryName) {
            // Send data to servlet using AJAX
            fetch('controller?action=addcategory', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'categoryName=' + encodeURIComponent(categoryName)
            })
            .then(response => response.text())
            .then(data => {
                alert(data); // Show success message
                location.reload(); // Refresh the page to show the new category
            })
            .catch(error => console.error('Error:', error));
        }
    }
</script>