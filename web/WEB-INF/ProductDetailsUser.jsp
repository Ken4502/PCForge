<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../Header.jsp"/>

<%
    // Get product details from the query parameters
    String productId = request.getParameter("product_id");
    String productName = request.getParameter("product_name");
    String productPrice = request.getParameter("product_price");
    String productQuantity = request.getParameter("product_quantity");
    String productImage = request.getParameter("product_image");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Product Details</title>
  <link rel="stylesheet" type="text/css" href="BodyStyle.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #ffcccc;
      margin: 0;
      padding: 0;
    }

    /* Add space at the top to avoid overlap with the header */
    .main-content {
      margin-top:110px; /* Adjust this value based on the header height */
    }

    .product-details-container {
      display: grid;
      grid-template-columns: 1fr 1.5fr; /* 1:1.5 ratio for image and content */
      gap: 30px;
      width: 80%;
      margin: 0 auto;
      padding: 20px;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .product-image-container {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .product-image {
      width: 100%;
      max-width: 300px;
      height: auto;
      border-radius: 8px;
      object-fit: cover;
    }

    .product-details {
      text-align: left;
      font-size: 1.2rem;
      color: #555;
    }

    .product-details h2 {
      font-size: 2rem;
      color: #333;
      margin-bottom: 20px;
    }

    .price {
      font-size: 1.5rem;
      font-weight: bold;
      color: #28a745;
      margin-top: 10px;
    }

    .stock {
      font-size: 1.2rem;
      font-weight: normal;
      color: #dc3545;
      margin-top: 10px;
    }

  </style>
</head>
<body>
  <div class="main-content">
    <div class="product-details-container">
      <!-- Left side: Product Image -->
      <div class="product-image-container">
        <img src="<%= productImage %>" alt="<%= productName %>" class="product-image">
      </div>

      <!-- Right side: Product Details -->
      <div class="product-details">
        <h2><%= productName %></h2>
        <p><strong>Price:</strong> RM <%= productPrice %></p>
        <p class="stock"><strong>Available Stock:</strong> <%= productQuantity %></p>
      </div>
    </div>
  </div>
</body>
</html>
