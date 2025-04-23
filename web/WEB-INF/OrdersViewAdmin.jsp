<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Order" %>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" type="text/css" href="BodyStyle.css">
  <meta charset="UTF-8">
  <title>Product Details</title>
  <style>
    #searchControls {
      margin-bottom: 1em;
      display: flex;
      gap: 0.5em;
      align-items: center;
    }
    #searchInput {
      flex: 1;
      padding: 0.5em;
      font-size: 1em;
    }
    #searchBy {
      padding: 0.5em;
    }
    #ordersTable {
      width: 100%;
      border-collapse: collapse;
    }
    #ordersTable th, #ordersTable td {
      border: 1px solid #black;
      padding: 8px;
      text-align: left;
      white-space: nowrap;
    }
    #ordersTable th {
      background: #ff9999;
    }
    form {
      margin: 0;
    }
  </style>
</head>
<body class="body">
  <h2>All Orders</h2>

  <div id="searchControls">
    <label for="searchBy">Search by:</label>
    <select id="searchBy">
      <option value="all">All</option>
      <option value="orderId">Order ID</option>
      <option value="userId">User ID</option>
      <option value="deliveryAddress">Delivery Address</option>
    </select>
    <input
      type="text"
      id="searchInput"
      onkeyup="searchOrders()"
      placeholder="Enter search term…"
      title="Type to search"
    />
  </div>

  <table id="ordersTable">
    <thead>
      <tr>
        <th>Order ID</th>
        <th>User ID</th>
        <th>Order Date</th>
        <th>Total Price</th>
        <th>Status</th>
        <th>Delivery Address</th>
        <th>Update Status</th>
      </tr>
    </thead>
    <tbody>
      <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders != null && !orders.isEmpty()) {
          for (Order order : orders) {
      %>
      <tr>
        <td><%= order.getOrderId() %></td>
        <td><%= order.getUserId() %></td>
        <td><%= order.getOrderDate() %></td>
        <td>RM<%= order.getTotalPrice() %></td>
        <td><%= order.getDeliveryAddress() %></td>
        <td><%= order.getStatus() %></td>
        <td>
          <form method="post" action="UpdateOrderStatusServlet" onsubmit="return confirmStatusChange(this);">
            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
            <select name="newStatus" required>
              <option value="">--</option>
              <option value="packaging" <%= "packaging".equals(order.getStatus()) ? "selected" : "" %>>Packaging</option>
              <option value="shipping"  <%= "shipping".equals(order.getStatus())  ? "selected" : "" %>>Shipping</option>
              <option value="delivery"  <%= "delivery".equals(order.getStatus())  ? "selected" : "" %>>Delivery</option>
            </select>
            <button type="submit">Update</button>
          </form>
        </td>
      </tr>
      <%
          }
        } else {
      %>
      <tr>
        <td colspan="7">No orders found.</td>
      </tr>
      <%
        }
      %>
    </tbody>
  </table>

  <script>
    function searchOrders() {
      const input = document.getElementById("searchInput").value.toUpperCase();
      const filterCol = document.getElementById("searchBy").value;
      const table = document.getElementById("ordersTable");
      const trs = table.tBodies[0].getElementsByTagName("tr");

      // Column indices: orderId=0, userId=1, deliveryAddress=5
      const colMap = { orderId: 0, userId: 1, deliveryAddress: 5 };

      for (const tr of trs) {
        let txt = "";
        if (filterCol === "all") {
          // concat all cells
          const tds = tr.getElementsByTagName("td");
          for (let i=0; i<tds.length; i++) {
            txt += tds[i].textContent + " ";
          }
        } else {
          const idx = colMap[filterCol];
          txt = tr.getElementsByTagName("td")[idx].textContent;
        }
        tr.style.display = txt.toUpperCase().includes(input) ? "" : "none";
      }
    }

    function confirmStatusChange(form) {
      const status = form.newStatus.value;
      return confirm(`Are you sure you want to mark this order as "${status}"?`);
    }
  </script>
</body>
</html>
