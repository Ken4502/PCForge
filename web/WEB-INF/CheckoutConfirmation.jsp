<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<jsp:include page="../Header.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Confirmation</title>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <style>
        .confirmation-container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            border: 2px solid #ff9999;
            border-radius: 8px;
            background-color: white;
            text-align: center;
            overflow-x: auto;
            position: relative;
        }

        /* Back Button */
        .back-button-container {
            position: absolute;
            top: 10px;
            left: 10px;
        }

        .back-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            margin: 30px 15px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .product-list {
            text-align: left;
            margin-top: 20px;
        }

        .confirmButton {
            background-color: #4CAF50;
            color: white;
            font-size: 18px;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 20px;
            width: 100%;
        }

        .confirmButton:hover {
            background-color: #45a049;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
            max-width: 100%;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            white-space: nowrap;
        }

        th {
            background-color: #f2f2f2;
        }
        
        /* Make it scrollable on smaller screens */
        @media (max-width: 768px) {
            .confirmation-container {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body class="body">
    <div class="confirmation-container">
        <!-- Back Button -->
        <div class="back-button-container">
            <button class="back-button" onclick="goBack()">← Back to Selection</button>
        </div>

        <%
        // Retrieve the list of selected products from the request
        List<HashMap<String, String>> selectedProducts = (List<HashMap<String, String>>) request.getAttribute("selectedProducts");

        // If there are no selected products, display a message
        if (selectedProducts == null || selectedProducts.isEmpty()) {
        %>
            <h3>No products selected for checkout.</h3>
        <%
        } else {
        %>
            <h2>Checkout Confirmation</h2>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Product Name</th>
                        <th>Price (RM)</th>
                        <th>Quantity</th>
                        <th>Total Price (RM)</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        double grandTotal = 0.0;
                        int count = 1; // Counter for numbering
                        for (HashMap<String, String> product : selectedProducts) { 
                            String productName = product.get("name");
                            String priceStr = product.get("price");
                            String quantityStr = product.get("quantity");
                            double price = Double.parseDouble(priceStr);
                            int quantity = Integer.parseInt(quantityStr);
                            double totalPrice = price * quantity;
                            grandTotal += totalPrice;
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <!-- Add product-name class to prevent wrapping -->
                            <td style="white-space: pre-wrap;"><%= productName %></td>
                            <td><%= String.format("%.2f", price) %></td>
                            <td><%= quantity %></td>
                            <td><%= String.format("%.2f", totalPrice) %></td>
                        </tr>
                    <% 
                        } 
                    %>
                    <tr>
                        <td colspan="4" style="text-align: right;"><b>Grand Total</b></td>
                        <td><b>RM <%= String.format("%.2f", grandTotal) %></b></td>
                    </tr>
                </tbody>
            </table>
            <form action="controller?action=checkout" method="POST">
                <input type="hidden" name="grandTotal" value="<%= grandTotal %>" />
                <button type="submit" class="confirmButton">Confirm Order</button>
            </form>
        <%
        }
        %>
    </div>

    <script>
        function goBack() {
            window.history.back();
        }
    </script>
</body>
</html>
