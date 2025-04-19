<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<jsp:include page="../Header.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout Confirmation</title>
  <link rel="stylesheet" href="BodyStyle.css">
  <style>
    .confirmation-container {
      width: 80%; margin: 50px auto; padding: 20px;
      border: 2px solid #ff9999; border-radius: 8px;
      background-color: white; text-align: center;
      overflow-x: auto; position: relative;
    }
    .confirmButton {
      background-color: #4CAF50; color: white;
      font-size: 18px; padding: 10px; border: none;
      cursor: pointer; border-radius: 5px;
      margin-top: 20px; width: 100%;
    }
    .confirmButton:hover { background-color: #45a049; }
    table {
      width: 100%; border-collapse: collapse;
      table-layout: auto; max-width: 100%;
    }
    th, td {
      border: 1px solid #ddd; padding: 10px;
      text-align: left; white-space: nowrap;
    }
    th { background-color: #f2f2f2; }
  </style>
</head>
<body class="body">
  <div class="confirmation-container">
    <%
      List<HashMap<String,String>> cart = 
        (List<HashMap<String,String>>) request.getAttribute("selectedProducts");
      if (cart == null) {
        cart = (List<HashMap<String,String>>) session.getAttribute("selectedProducts");
      }
      if (cart == null || cart.isEmpty()) {
    %>
      <h3>No products selected for checkout.</h3>
      <a href="controller?action=productview">Back to View Product</a>
    <%
      } else {
        double grandTotal = 0;
        for (HashMap<String,String> item : cart) {
          double price = Double.parseDouble(item.get("price"));
          int qty = Integer.parseInt(item.get("quantity"));
          grandTotal += price * qty;
        }
        double deliveryFee = (double)70.00;
        if (grandTotal >= 10000){ 
            deliveryFee = (double)0.00;
        }
        double serviceTax = (double)(grandTotal * 0.10);
        double finalTotal = grandTotal + deliveryFee + serviceTax;
    %>
      <h2>Checkout Confirmation</h2>
      <form id="cartForm" action="controller?action=updateCart" method="POST">
        <table>
          <thead>
            <tr>
              <th>#</th><th>Product</th>
              <th>Price (RM)</th><th>Quantity</th>
              <th>Total (RM)</th><th>Remove</th>
            </tr>
          </thead>
          <tbody>
            <%
              int idx = 0, count = 1;
              for (HashMap<String,String> item : cart) {
                String idStr = item.get("id");
                int id = 0; // fallback default
                if (idStr != null && !idStr.isEmpty() && !idStr.equals("null")) {
                    id = Integer.parseInt(idStr);
                }
                String name = item.get("name");
                double price = Double.parseDouble(item.get("price"));
                int qty = Integer.parseInt(item.get("quantity"));
                double total = price * qty;
            %>
            <tr>
              <td><%= count++ %></td>
              <td><%= name %></td>
              <td><%= String.format("%.2f", price) %></td>
              <td>
                <input type="number"
                       name="quantity_<%= idx %>"
                       value="<%= qty %>"
                       min="1"
                       onchange="checkCartChanges(<%= idx %>)"
                       data-orig="<%= qty %>">
                <input type="hidden" name="product_id_<%= idx %>" value="<%= id %>">
                <input type="hidden" name="name_<%= idx %>" value="<%= name %>">
                <input type="hidden" name="price_<%= idx %>" value="<%= price %>">
              </td>
              <td><%= String.format("%.2f", total) %></td>
              <td>
                <input type="checkbox"
                       name="remove_<%= idx %>"
                       onchange="checkCartChanges(<%= idx %>)"
                       data-orig="false">
              </td>
            </tr>
            <%
                idx++;
              }
            %>
            <input type="hidden" name="totalItems" value="<%= cart.size() %>">
            <tr>
              <td colspan="4" style="text-align:right;"><b>Subtotal</b></td>
              <td><b>RM <%= String.format("%.2f", grandTotal) %></b></td>
              <td></td>
            </tr>
            <tr>
              <td colspan="4" style="text-align:right;"><b>Service Tax (10%)</b></td>
              <td>RM <%= String.format("%.2f", serviceTax) %></td>
              <td></td>
            </tr>
            <tr>
              <td colspan="4" style="text-align:right;"><b>Delivery Fee</b></td>
              <td>RM <%= String.format("%.2f", deliveryFee) %></td>
              <td></td>
            </tr>
            <tr>
              <td colspan="4" style="text-align:right;"><b><u>Final Grand Total</u></b></td>
              <td><b><u>RM <%= String.format("%.2f", finalTotal) %></u></b></td>
              <td></td>
            </tr>
          </tbody>
        </table>
        <button type="submit"
                id="updateBtn"
                class="confirmButton"
                style="display:none;margin-top: 36px;">
          Update Cart
        </button>
      </form>

      <!-- Order Confirmation Form -->
      <form action="controller?action=checkout" method="POST">
        <%
          int idxCheckout = 0;
          for (HashMap<String,String> item : cart) {
            String nameCheckout = item.get("name");
            String productId = item.get("id");
            if (productId == null){
                productId = "0";
            }
            double priceCheckout = Double.parseDouble(item.get("price"));
            int qtyCheckout = Integer.parseInt(item.get("quantity"));
        %>  
            <input type="hidden" name="id_<%= idx %>" value="<%= productId %>">

            <input type="hidden" name="quantity_<%=idxCheckout%>" value="<%= qtyCheckout %>">
            <input type="hidden" name="product_id_<%=idxCheckout%>" value="<%= productId %>">
            <input type="hidden" name="price_<%=idxCheckout%>" value="<%= priceCheckout %>">
            <input type="hidden" name="name_<%=idxCheckout%>" value="<%= nameCheckout %>">
        <%
            idxCheckout++;
          }
        %>
        <input type="hidden" name="deliveryFee" value="<%= String.format("%.2f", deliveryFee) %>">
        <input type="hidden" name="serviceTax" value="<%= String.format("%.2f", serviceTax) %>">
        <input type="hidden" name="grandTotal" value="<%= String.format("%.2f", finalTotal) %>">
        <button type="submit" id="confirmBtn" class="confirmButton">Confirm Order</button>
      </form>
    <%
      }
    %>
  </div>

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      const updateBtn  = document.getElementById("updateBtn");
      const confirmBtn = document.getElementById("confirmBtn");
      const qtyInputs  = document.querySelectorAll('input[type="number"][name^="quantity_"]');
      const removeCbs  = document.querySelectorAll('input[type="checkbox"][name^="remove_"]');

      qtyInputs.forEach(inp => inp.addEventListener("input", () => checkCartChanges(inp)));
      removeCbs.forEach(cb => cb.addEventListener("change", () => checkCartChanges(cb)));

      function checkCartChanges(el) {
        let changed = false;

        qtyInputs.forEach(inp => {
          if (inp.value !== inp.dataset.orig) changed = true;
        });
        removeCbs.forEach(cb => {
          if ((cb.checked && cb.dataset.orig==="false") ||
              (!cb.checked && cb.dataset.orig==="true")) {
            changed = true;
          }
        });

        if (changed) {
          updateBtn.style.display = "inline-block";
          confirmBtn.style.display = "none";
        } else {
          updateBtn.style.display = "none";
          confirmBtn.style.display = "inline-block";
        }
      }

      checkCartChanges();
    });
  </script>
</body>
</html>
