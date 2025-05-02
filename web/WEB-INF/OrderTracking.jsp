<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.*, Model.Order, Model.OrderItem, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Tracking</title>
        <style>
            .orders-wrapper {
                max-width: 800px;
                margin: auto;
                margin-top: 20px;
                padding: 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            .order-container {
                margin-bottom: 40px;
                padding: 20px;
                background: #fff;
                border-radius: 10px;
                border: 1px solid #ddd;
            }

            .order-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            .order-table th, .order-table td {
                padding: 10px;
                border: 1px solid #ccc;
                text-align: left;
            }

            .order-table th {
                background-color: #eee;
            }

            .order-table tfoot td {
                font-weight: bold;
                background-color: #f1f1f1;
            }
            .order-wrapper {
                width: 80%;
                margin: 20px auto;
            }

            .order-card {
                background-color: #ffffff;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .order-card p {
                margin: 8px 0;
                font-size: 16px;
            }

            h2 {
                text-align: center;
                margin-top: 30px;
                color: #333;
            }

            .no-orders {
                text-align: center;
                font-size: 18px;
                color: #999;
                margin-top: 50px;
            }

            table.order-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            table.order-table th, table.order-table td {
                border: 1px solid #ccc;
                padding: 8px 12px;
                text-align: left;
            }

            table.order-table th {
                background-color: #f2f2f2;
            }

            .grand-total {
                text-align: right;
                font-weight: bold;
                margin-top: 10px;
                color: #333;
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
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    <body class="body">
        <%
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        %>
        <button type="button" class='back-btn' onclick="history.back();" style="width:80px;height:40px;">Back</button>
        <div class="orders-wrapper">
            <h2>Your Orders</h2>

            <div class="order-wrapper">
                <%
                    List<Order> orders = (List<Order>) request.getAttribute("orders");
                    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

                    if (orders == null || orders.isEmpty()) {
                %>
                <p class="no-orders">No orders found.</p>
                <%
                } else {
                    for (Order order : orders) {
                        int orderId = order.getOrderId();
                %>
                <div class="order-card">
                    <p><strong>Order ID:</strong> <%= orderId%></p>
                    <p><strong>Status:</strong> <%= order.getStatus()%></p>
                    <p><strong>Order Date:</strong> <%= sdf.format(order.getOrderDate())%></p>
                    <p><strong>Delivery Address:</strong> <%= order.getDeliveryAddress()%></p>

                    <%
                        List<OrderItem> items = orderItemsMap.get(orderId);
                        if (items != null && !items.isEmpty()) {
                    %>
                    <table class="order-table">
                        <thead>
                            <tr>
                                <th style="background-color: #ffe8e8;">Product Name</th>
                                <th style="background-color: #ffe8e8;">Quantity</th>
                                <th style="background-color: #ffe8e8;">Price (RM)</th>
                                <th style="background-color: #ffe8e8;">Subtotal (RM)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (OrderItem item : items) {
                                    double subtotal = item.getQuantity() * item.getPrice();
                            %>
                            <tr>
                                <td><%= item.getProductName()%></td>
                                <td><%= item.getQuantity()%></td>
                                <td><%= item.getPrice()%></td>
                                <td><%= String.format("%.2f", subtotal)%></td>
                            </tr>

                            <%
                                }
                            %>
                            <tr>
                                <th colspan="3">Grand Total:</th>
                                <th>RM <%= order.getTotalPrice()%></th>
                            </tr>
                        </tbody>
                    </table>
                    <%
                    } else {
                    %>
                    <p>No items found for this order.</p>
                    <%
                        }
                    %>
                </div>
                <%
                        }
                    }
                %>
            </div>


        </div>
    </body>
</html>
