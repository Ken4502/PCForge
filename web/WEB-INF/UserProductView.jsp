<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.List, java.util.Map;" %>
<%@ page import="java.util.HashMap" %>

<%
    HttpSession sessionObj = request.getSession(false);
    String loggedInUser = (sessionObj != null) ? (String) sessionObj.getAttribute("username") : null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="BodyStyle.css">
    <style>
        .product-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .product-item {
            width: 200px;
            height: auto;
            padding: 10px;
            border: 2px solid #ff9999;
            border-radius: 8px;
            text-align: center;
            background-color: white;
        }

        .product-item img {
            width: 100%;
            height: 200px;
            border-radius: 5px;
        }

        .product-item h4 {
            font-size: 1.2em;
            margin-top: 10px;
        }

        .product-item p {
            font-size: 1em;
            color: #555;
        }

        .submitButton {
            background-color: #4CAF50;
            color: white;
            font-size: 20px;
            padding: 15px;
            margin-top: 20px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .submitButton:hover {
            background-color: #45a049;
        }

        .disabledButton {
            background-color: #cccccc;
            color: #666666;
            cursor: not-allowed;
        }

        .disabledButton:hover {
            background-color: #cccccc;
            color: #666666;
        }

        .button-container {
            display: flex;
            justify-content: center;
            width: 100%;
            text-align: center;
        }
    </style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Product View</title>
</head>
<body class="body">
    <h2>Available Products</h2>

    <%
        List<HashMap<String, String>> categoryList = (List<HashMap<String, String>>) request.getAttribute("categoryList");
        HashMap<String, List<HashMap<String, String>>> productsByCategory = 
            (HashMap<String, List<HashMap<String, String>>>) request.getAttribute("productsByCategory");
    %>

    <form action="controller?action=checkout" method="GET">
        <% 
            for (HashMap<String, String> category : categoryList) { 
                String categoryId = category.get("id");
                List<HashMap<String, String>> productsInCategory = productsByCategory.get(categoryId);

                if (productsInCategory != null && !productsInCategory.isEmpty()) { 
        %>
                <h3><%= category.get("name") %></h3>
                
                <div class="product-container">
                    <% for (HashMap<String, String> product : productsInCategory) { %>
                        <div class="product-item">
                            <img src="<%= product.get("image_url") %>" alt="<%= product.get("name") %>" />
                            <h4><%= product.get("name") %></h4>
                            <p>Price: RM <%= product.get("price") %></p>

                            <% if (loggedInUser != null) { %>
                                <label>Quantity:</label>
                                <input type="number" name="quantity_<%= product.get("id") %>" 
                                       value="0" max="<%= product.get("quantity") %>" min="0" 
                                       oninput="validateInput(this)" />
                                <input type="hidden" name="product_id_<%= product.get("id") %>" 
                                       value="<%= product.get("id") %>" />
                            <% } else { %>
                                <p>Available: <%= product.get("quantity") %></p>
                            <% } %>
                        </div>
                    <% } %>
                </div>
        <% 
                } 
            } 
        %>

        <% if (loggedInUser != null) { %>
            <div class="button-container">
                <button type="submit" class="submitButton disabledButton" disabled>Proceed to Checkout</button>
            </div>
        <% } %>
    </form>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const isLoggedIn = <%= (loggedInUser != null) %>;

        if (isLoggedIn) {
            checkQuantities();

            let form = document.querySelector("form");
            let inputs = document.querySelectorAll('input[type="number"]');

            inputs.forEach(input => {
                input.addEventListener("input", checkQuantities);
            });

            form.addEventListener("submit", function (event) {
                event.preventDefault(); // Prevent normal form submission

                let url = new URL(form.action, window.location.origin);

                inputs.forEach(input => {
                    let quantity = parseInt(input.value);
                    let productId = input.name.replace("quantity_", "product_id_");

                    if (quantity > 0) {
                        url.searchParams.append(input.name, quantity);
                        url.searchParams.append(productId, input.nextElementSibling.value);
                    }
                });

                if (url.searchParams.toString() !== "") {
                    window.location.href = url.toString();
                }
            });
        }
    });

    function checkQuantities() {
        let inputs = document.querySelectorAll('input[type="number"]');
        let submitButton = document.querySelector('.submitButton');
        let allZero = true;

        inputs.forEach(input => {
            if (parseInt(input.value) > 0) {
                allZero = false;
            }
        });

        if (allZero) {
            submitButton.classList.add('disabledButton');
            submitButton.disabled = true;
        } else {
            submitButton.classList.remove('disabledButton');
            submitButton.disabled = false;
        }
    }

    function validateInput(input) {
        const min = parseInt(input.min, 10);
        const max = parseInt(input.max, 10);
        const value = parseInt(input.value, 10);

        if (value < min) {
            input.value = min;
        } else if (value > max) {
            input.value = max;
        }
    }
</script>

</body>
</html>
