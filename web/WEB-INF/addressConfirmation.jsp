<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
    <style>
        .form-container {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
            width: 100%;
        }
        .user-info, .payment-method {
            margin-bottom: 20px;
        }
        label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .submit-btn {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #0056b3;
        }
        .payment-container {
            width: 60%; margin: 50px auto; padding: 20px;
            border: 2px solid #ccc; border-radius: 10px;
            background-color: #fff;
        }
        h2 { text-align: center; }
        table {
            width: 100%; border-collapse: collapse; margin-top: 30px;
        }
        th, td {
            border: 1px solid #ddd; padding: 12px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tfoot td {
            font-weight: bold;
            font-size: 18px;
        }
        .payment-method {
            text-align: center; margin: 30px 0;
        }
        .payment-method label {
            margin-right: 20px; font-size: 18px;
        }
        .submit-btn {
            display: block; width: 100%;
            padding: 12px; font-size: 18px;
            background-color: #4CAF50; color: white;
            border: none; border-radius: 5px;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #45a049;
        }
        .card-fields {
            margin-top: 20px;
        }
        
            .back-btn {
                background-color: #ff9999;
                color: black;
                border: none;
                display: block;
                position:absolute;
                top:130px;
                left:30px;
                padding: 10px;
                background-color: #ff9999;
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
    </style>
</head>
<body class="body">
    <button type="button" class='back-btn' onclick="history.back();" style="width:80px;height:40px;">Back</button>
<div class="payment-container">
    <h2>Review Your Order</h2>

    <%
        List<HashMap<String, String>> selectedProducts = 
            (List<HashMap<String, String>>) request.getAttribute("selectedProducts");
        if (selectedProducts != null) {
    %>
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>ID</th>
                    <th>Price (RM)</th>
                    <th>Quantity</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (HashMap<String, String> item : selectedProducts) {
                    String name = item.get("name");
                    String id = item.get("id");
                    String price = item.get("price");
                    String quantity = item.get("quantity");
            %>
                <tr>
                    <td><%= name %></td>
                    <td><%= id %></td>
                    <td><%= price %></td>
                    <td><%= quantity %></td>
                </tr>
            <%
                }
            %>
            </tbody>
    <%
        }

        String feeStr   = (String) request.getAttribute("deliveryFee");
        if (feeStr == null || feeStr.isEmpty()) {
            feeStr   = (String) session.getAttribute("deliveryFee");
        } else {
            session.setAttribute("deliveryFee", feeStr);
        }

        String taxStr   = (String) session.getAttribute("serviceTax");
        if (taxStr == null || taxStr.isEmpty()) {
            taxStr = (String) session.getAttribute("serviceTax");
        } else {
            session.setAttribute("serviceTax", taxStr);
        }

        String totalStr = request.getParameter("grandTotal");
        if (totalStr == null || totalStr.isEmpty()) {
            totalStr = (String) session.getAttribute("grandTotal");
        } else {
            session.setAttribute("grandTotal", totalStr);
        }

        DecimalFormat df = new DecimalFormat("0.00");
        double fee = (feeStr != null && !feeStr.isEmpty())
                            ? Double.parseDouble(feeStr)
                            : 0.00;
        double tax = (taxStr != null && !taxStr.isEmpty())
                            ? Double.parseDouble(taxStr)
                            : 0.00;
        double finalTotal = (totalStr != null && !totalStr.isEmpty())
                            ? Double.parseDouble(totalStr)
                            : 0.00;
    %>
            <tfoot>
                <tr><td colspan="3">Subtotal</td><td>RM <%= df.format(finalTotal - fee - tax) %></td></tr>
                <tr><td colspan="3">Service Tax (10%)</td><td>RM <%= df.format(tax) %></td></tr>
                <tr><td colspan="3">Delivery Fee</td><td>RM <%= df.format(fee) %></td></tr>
                <tr>
                    <td colspan="3">Grand Total</td>
                    <td>RM <%= df.format(finalTotal) %></td>
                </tr>
            </tfoot>
        </table>

<%
    Model.User user = (Model.User) request.getAttribute("user");
%>

<div class="form-container">
    <form action="controller?action=processPayment" method="POST">
        <div class="user-info">
            <h2>Delivery Details</h2>
            <label>Name:</label>
            <input type="text" name="name" value="<%= user != null ? user.getName() : "" %>" required><br>

            <label>Email:</label>
            <input type="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" required><br>

            <label>Address:</label>
            <textarea name="address" rows="3" required><%= user != null ? user.getAddress() : "" %></textarea>
        </div>

        <div class="payment-method">
            <input type="radio" name="paymentMethod" value="card" required onclick="document.getElementById('cardDetails').style.display='block';">
            <label>Credit/Debit Card</label>
            <input type="radio" name="paymentMethod" value="cod" required onclick="document.getElementById('cardDetails').style.display='none';">
            <label>Cash on Delivery</label>
        </div>

        <div class="card-fields" id="cardDetails" style="display: none;">
            <label>Card Number:</label>
            <input type="text" name="cardNumber" id="cardNumber" maxlength="19" placeholder="1234-5678-9012-3456"><br>

            <label>Expiry Date (MM/YY):</label>
            <input type="text" name="expiryDate" id="expiryDate" maxlength="5" placeholder="MM/YY"><br>

            <label>CVV:</label>
            <input type="text" name="ccv" id="ccv" maxlength="3" placeholder="123"><br>
        </div>

        <input type="hidden" name="grandTotal" value="<%= df.format(finalTotal) %>">

        <button type="submit" class="submit-btn">Confirm Payment</button>
    </form>
</div>
</div>

<script src="cardValidation.js"></script>
</body>
</html>
