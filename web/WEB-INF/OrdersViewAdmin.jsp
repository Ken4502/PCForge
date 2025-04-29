<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Order, java.text.SimpleDateFormat" %>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" type="text/css" href="BodyStyle.css">
  <meta charset="UTF-8">
  <title>Order Details</title>
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
        select[name="newStatus"]{
            width: auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
        }    
        select[id="searchBy"]{
            width: auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
        }    
        input[type="text"]{
            width: auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
        }    
  </style>
</head>
<body class="body">
    <div class="container">
        <div class="form-container">
            <%
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            %>
          <h2>All Orders</h2>

          <div id="searchControls">
            <label for="searchBy" style="font-size:18px;">Search by:</label>
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
                <td><%= sdf.format(order.getOrderDate()) %></td>
                <td>RM<%= order.getTotalPrice() %></td>
                <td><%= order.getStatus() %></td>
                <td><%= order.getDeliveryAddress() %></td>
                <td>
                  <form method="post" action="UpdateOrderStatusServlet" onsubmit="return confirmStatusChange(this);">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <select name="newStatus" required>
                      <option value="">--</option>
                      <option value="Packaging" <%= "Packaging".equals(order.getStatus()) ? "selected" : "" %>>Packaging</option>
                      <option value="Shipping"  <%= "Shipping".equals(order.getStatus())  ? "selected" : "" %>>Shipping</option>
                      <option value="Delivery"  <%= "Delivery".equals(order.getStatus())  ? "selected" : "" %>>Delivery</option>
                    </select>
                    <button type="submit" class="btn">Update</button>
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
        </div>
    </div>        
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
