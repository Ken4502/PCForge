<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
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
            margin-bottom: 15px;
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
        input[type="number"]{
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        input[type="radio"]{
            margin-bottom: 20px;
        }
        
    </style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
</head>
<body class="body">
    <div class="container">
        <div class="form-container">
            <h2>Add Product</h2>
            <form action="ProductAddServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="addproduct">

            <div class="form-group"><label>Product name:</label> <input type="text" name="productname" required></div>
            <div class="form-group"><label>Price:</label> <input type="number" step="0.01" name="price" min="0" required></div>
            <div class="form-group"><label>Quantity:</label> <input type="number" name="quantity" min="0" required></div>
            <div class="form-group"><label>Image URL:</label> <input type="file" name="image" accept=".png, .jpg, .jpeg" required></div>

            <div class="form-group"><label>Category:</label></div>
            <c:forEach var="category" items="${categoryList}">
                <input type="radio" name="category" value="${category.id}"> ${category.name} <br>
            </c:forEach>

            <button type="button" class="btn" onclick="addCategory()">Add New Category</button> <br><br>
            
            <div class="form-group">
            <button type="submit" class="btn">Add Product</button>
            <button type="button" class="btn" onclick="location.href='ProductManageServlet';">Back</button>
            </div>
            </form>
        </div>    
    </div> 
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
                if (data.includes("Invalid")){
                    alert(data); // Show validation error, don't reload
                }else{
                alert(data); // Show success message
                location.reload(); // Refresh the page to show the new category
             }
            })
            .catch(error => console.error('Error:', error));
        }
    }
</script>