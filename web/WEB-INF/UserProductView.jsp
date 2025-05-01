<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../Header.jsp"/>
<%@ page import="java.util.List,java.util.Map,java.util.HashMap" %>

<%
    HttpSession sessionObj = request.getSession(false);
    String loggedInUser = sessionObj != null
            ? (String) sessionObj.getAttribute("username")
            : null;
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Available Products</title>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <style>
            #searchControls {
                margin: 1em auto;
                display: flex;
                gap: .5em;
                justify-content: center;
                align-items: center;
            }
            #searchInput {
                padding: 0.5em;
                width: 300px;
                font-size: 1em;
            }
            #searchBy {
                padding: 0.5em;
                font-size: 1em;
            }
            .product-container {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 2em;
            }
            .product-item {
                width: 200px;
                padding: 10px;
                border: 2px solid #ff9999;
                border-radius: 8px;
                text-align: center;
                background-color: white;
            }
            .product-item img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 5px;
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
            input[type="text"]{
                width: auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
            }

            button {
                background-color: #ff9999;
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 20px;
                margin-left: 20px;
                font-size: 20px;
            }

        </style>
    </head>
    <body class="body">
        <button type="button" onclick="history.back();" style="width:100px;height:40px;">Back</button>
        <div id="searchControls">
            <label for="searchBy" style="font-size:18px">Search by:</label>
            <select id="searchBy">
                <option value="all">All</option>
                <option value="name">Name</option>
                <option value="category">Category</option>
            </select>
            <input
                type="text"
                id="searchInput"
                placeholder="Enter search term…"
                onkeyup="filterProducts()"
                />
        </div>

        <h2 style="font-size:30px">Available Products</h2>

        <%
            List<HashMap<String, String>> categoryList
                    = (List<HashMap<String, String>>) request.getAttribute("categoryList");
            Map<String, List<HashMap<String, String>>> productsByCategory
                    = (Map<String, List<HashMap<String, String>>>) request.getAttribute("productsByCategory");
        %>

        <form action="controller?action=checkout" method="GET" onsubmit="return filterFormBeforeSubmit(this)">
            <input type="hidden" name="action" value="checkout">
            <%
                for (HashMap<String, String> category : categoryList) {
                    String catId = category.get("id");
                    String catName = category.get("name");
                    List<HashMap<String, String>> prods = productsByCategory.get(catId);
                    if (prods == null || prods.isEmpty())
                        continue;
            %>
            <div class="category-block">
                <h3 class="category-name" style="font-size:22px"><%= catName%></h3>
                <div class="product-container">
                    <%
                        for (HashMap<String, String> product : prods) {
                            int prodQuantity = Integer.parseInt(product.get("quantity"));
                    %>
                    <div class="product-item" data-name="<%=product.get("name").toLowerCase()%>"
                         data-category="<%=catName.toLowerCase()%>">
                        <a href="controller?action=viewProduct&product_id=<%= product.get("id")%>&product_name=<%= product.get("name")%>&product_image=<%= product.get("image_url")%>&product_quantity=<%=product.get("quantity")%>&product_price=<%= product.get("price")%>" target="_blank">
                            <img src="<%= product.get("image_url")%>" alt="<%= product.get("name")%>">
                        </a>
                        <h4><%= product.get("name")%></h4>
                        <p>Price: RM <%= product.get("price")%></p>

                        <% if (loggedInUser != null) {%>
                        <label>Quantity:</label>
                        <input
                            type="number"
                            name="quantity_<%=product.get("id")%>"
                            value="0"
                            min="0"
                            max="<%=product.get("quantity")%>"
                            oninput="validateInput(this); checkQuantities();">
                        <input
                            type="hidden"
                            name="product_id_<%=product.get("id")%>"
                            value="<%=product.get("id")%>">
                        <p>Stock Available: <%= product.get("quantity")%></p>
                        <% } %>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            <%
                }
            %>

            <% if (loggedInUser != null) { %>
            <div style="text-align:center; margin-top:2em;">
                <button type="submit" class="submitButton disabledButton" disabled>
                    Proceed to Checkout
                </button>
            </div>
            <% }%>
        </form>

        <script>
            const searchInput = document.getElementById("searchInput");
            const searchBy = document.getElementById("searchBy");
            const numberInputs = document.querySelectorAll('input[type="number"]');
            const form = document.querySelector('form');
            const submitButton = document.querySelector('.submitButton');

            // --- Product Filter Function ---
            function filterProducts() {
                const term = searchInput.value.trim().toLowerCase();
                const by = searchBy.value;

                document.querySelectorAll(".category-block").forEach(catBlk => {
                    let anyVisible = false;
                    catBlk.querySelectorAll(".product-item").forEach(item => {
                        const name = item.dataset.name;
                        const cat = item.dataset.category;
                        let matches = false;

                        if (!term) {
                            matches = true;
                        } else if (by === "all") {
                            matches = name.includes(term) || cat.includes(term);
                        } else if (by === "name") {
                            matches = name.includes(term);
                        } else if (by === "category") {
                            matches = cat.includes(term);
                        }

                        item.style.display = matches ? "" : "none";
                        if (matches)
                            anyVisible = true;
                    });

                    catBlk.style.display = anyVisible ? "" : "none";
                });
            }

            // --- Quantity Input Validator ---
            function validateInput(input) {
                const min = parseInt(input.min, 10);
                const max = parseInt(input.max, 10);
                let val = parseInt(input.value, 10) || 0;
                if (val < min)
                    val = min;
                if (val > max)
                    val = max;
                input.value = val;
            }

            // --- Enable/Disable Checkout Button Based on Quantities ---
            function checkQuantities() {
                let anySelected = false;
                numberInputs.forEach(input => {
                    if (parseInt(input.value) > 0) {
                        anySelected = true;
                    }
                });

                submitButton.disabled = !anySelected;
                submitButton.classList.toggle("disabledButton", !anySelected);
            }

            // --- Filter out quantity/product_id if quantity is 0 before submit ---
            function filterFormBeforeSubmit(form) {
                const inputs = form.querySelectorAll('input[type="number"]');

                // Loop through the quantity inputs and remove those with a value of 0
                inputs.forEach(input => {
                    const quantity = parseInt(input.value, 10);
                    if (quantity === 0) {
                        // Remove the quantity input from the form
                        //input.remove();

                        // Also remove the corresponding product_id input
                        const idSuffix = input.name.replace("quantity_", "");
                        const productIdInput = form.querySelector(`[name="product_id_${idSuffix}"]`);
                        if (productIdInput) {
                            //productIdInput.remove(); // Remove the corresponding hidden product_id input
                        }
                    }
                });

                return true; // Allow form to submit
            }

            // --- Event Listeners on Load ---
            numberInputs.forEach(input => {
                input.addEventListener("input", checkQuantities);
            });

            document.addEventListener("DOMContentLoaded", checkQuantities);
        </script>

    </body>
</html>
