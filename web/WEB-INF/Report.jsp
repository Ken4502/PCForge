<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*, java.time.* "%>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<%
    List<HashMap<String, String>> barChart = (List<HashMap<String, String>>) request.getAttribute("barChart");
    LocalDate from = (LocalDate) request.getAttribute("from");
    LocalDate to = (LocalDate) request.getAttribute("to");
    double totalsales = 0.00;
    for (int i = 0; i < barChart.size(); i++) {
        HashMap<String, String> item = barChart.get(i);
        totalsales += Double.parseDouble(item.get("totalSales"));
    }
    String product = (String) request.getAttribute("product");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>

        <title>Report</title>
    </head>
    <style>
        * {
            font-family: sans-serif;
            color: black;
        }
        .chart-container {
            display: flex;
            gap: 40px;
            align-items: flex-start;
            margin-bottom: 30px;
        }
        #myChart {
            border: 2px solid black;
        }
        .sales-list {
            flex: 1;
        }
        th {
            text-align: left;
        }
        td {
            padding-left: 10px;
            padding-right:20px;
        }
        table {
            margin-top: 20px;
        }
        h3{
            text-decoration:underline;
            padding-left:20px;
            font-size:20px;
        }
        #error{
            font-size:20px;
        }
        input[type=date]{
            font-size:15px;
            width:140px;
            height:30px;
            margin-left:10px;
            margin-right:10px;
        }
        button[type=submit]{
            font-size:15px;
            width:100px;
            height:30px;
            border:none;
            background-color:yellowgreen;
            color:white;
        }
        button[type=submit]:hover{
            background-color:lightgreen;
            color:black;
        }
        body {
            background-color: #ffcccc;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            width: 90%;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }

        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .btn {
            margin-bottom:20px;
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
        .twobutton {
            background-color: #007BFF; /* A clean blue */
            color: white;
            font-size: 15px;
            padding: 10px 20px;
            margin-right: 10px; /* space between buttons */
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .twobutton:hover {
            background-color: #339AFF; /* lighter on hover */
            transform: translateY(-2px); /* subtle lift on hover */
        }
    </style>
    <body>
        <div class="container">
            <div class="form-container">   
                <% if (product != null && !product.isEmpty()) { %>
                <h1>Top Sales Product Report</h1>
                <% } else { %>
                <h1>Top Sales Category Report</h1>
                <% }%>
                <button type="button" class="btn" onclick="location.href = 'controller?';">Back</button><br>

                <form action="ReportServlet" method="GET">
                    <input type="submit" value="Top Sales Product" class="twobutton">
                    <input type="hidden" name="product" value="product">
                </form>
                <form action="ReportServlet" method="GET">
                    <input type="submit" value="Top Sales Category" class="twobutton">
                </form>

                <form action="ReportServlet" method="GET">
                    From
                    <input type="date" name="from" id="from" value="<%=from != null ? from : ""%>">
                    to
                    <input type="date" name="to" id="to" value="<%=to != null ? to : ""%>">
                    <% if (product != null && !product.isEmpty()) { %>
                    <input type="hidden" name="product" value="product"> <!--act as a session -->
                    <% } %>
                    <button type="submit" onclick="return validationDate()">Apply</button>
                </form>
                <div class="chart-container">
                    <canvas id="myChart" style="width:100%;max-width:800px"></canvas>

                    <div class="sales-list">
                        <%if (barChart != null && !barChart.isEmpty()) {%><!--if have record found within the date-->


                        <% if (product != null && !product.isEmpty()) { %>
                        <h3>Sales by Product</h3>
                        <% } else {%>
                        <h3>Sales by Category</h3>
                        <%}%>
                        <table style="font-size:20px;">
                            <%if (barChart != null) {%>
                            <% for (int i = 0; i < barChart.size(); i++) {
                                    HashMap<String, String> item = barChart.get(i);%>
                            <tr>

                                <% if (product != null && !product.isEmpty()) {%>
                                <td><%=i + 1%>. <%= item.get("product")%></td>
                                <% } else {%>
                                <td><%=i + 1%>. <%= item.get("category")%></td>
                                <% }%>
                                <th>RM</th>
                                <th style="text-align:right;"> <%= item.get("totalSales")%></th>
                            </tr>
                            <% }%>
                            <% }%>
                        </table>
                        <% } else if (barChart != null && barChart.isEmpty()) { %>
                        <% if (from == null && to == null) { %>
                        <h3 style="color:red;">ERROR</h3>
                        <p id="error">No data available.</p>
                        <% } else if (from != null && to != null && from.equals(to)) {%>
                        <h3 style="color:red;">ERROR</h3>
                        <p id="error">No data at <strong><%=from%></strong></p>
                        <% } else if (from == null && to != null) {%>
                        <h3 style="color:red;">ERROR</h3>
                        <p id="error">No data found before <strong><%=to%></strong></p>
                        <% } else if (to == null && from != null) {%>
                        <h3 style="color:red;">ERROR</h3>
                        <p id="error">No data found after <strong><%=from%></strong></p>
                        <% } else {%>
                        <h3 style="color:red;">ERROR</h3>
                        <p id="error">No data from <strong><%=from%></strong> until <strong><%=to%></strong></p>
                        <% } %>
                        <% }%>
                    </div>
                </div>
                <table style="font-size:20px;">
                    <tr>
                        <% if (product != null && !product.isEmpty()) {%>
                        <th>Total products</th>
                            <% } else { %>
                        <th>Total categories</th>
                            <% }%>
                        <td>: <%= (barChart != null ? barChart.size() : 0)%></td>
                    </tr>
                    <tr>
                        <th>Total sales </th>
                        <td>: RM<%= totalsales%></td>
                    </tr>
                </table>
            </div>
        </div>            
    </body>

    <script>
        //Validation of 'from' date can't be over 'to' date
        function validationDate() {
            const fromDate = document.getElementById("from").value;
            const toDate = document.getElementById("to").value;
            if (!fromDate) {
                return true;
            } else if (!toDate) {
                return true;
            } else if (fromDate > toDate) {
                alert("'From' date must be before or equal to 'To' date.");
                return false;
            }

            return true;
        }



        //Bar Chart script
        <%
            boolean isProductMode = product != null && !product.isEmpty();
        %>

        const xValues = [<%
            for (int i = 0; i < barChart.size(); i++) {
                HashMap<String, String> item = barChart.get(i);
                out.println("\"" + item.get(isProductMode ? "product" : "category") + "\"");
                if (i < barChart.size() - 1) {
                    out.println(", ");
                }
            }
        %>];

        const yValues = [<%
            for (int i = 0; i < barChart.size(); i++) {
                HashMap<String, String> item = barChart.get(i);
                out.println(item.get("totalSales"));
                if (i < barChart.size() - 1) {
                    out.println(", ");
                }
            }
        %>];
        // Find the index of the highest value
        const maxVal = Math.max(...yValues);
        const barColors = yValues.map(val => val == maxVal ? "gray" : "lightgray");
        new Chart("myChart", {
            type: "bar",
            data: {
                labels: xValues,
                datasets: [{
                        backgroundColor: barColors,
                        data: yValues
                    }]
            },
            options: {
                legend: {
                    display: false
                },
                scales: {
                    yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                fontSize: 16
                            }
                        }],
                    xAxes: [{
                            ticks: {
                                fontSize: 16
                            }
                        }]
                },
        <%  //The condition of title
            String chartTitle;

            if (product != null && !product.isEmpty()) {
                if (barChart != null && !barChart.isEmpty()) {
                    if (from == null && to == null) {
                        chartTitle = "Bar Chart of Top Sales Product";
                    } else if (from != null && to != null && from.equals(to)) {
                        chartTitle = "Bar Chart of Top Sales Product at " + from;
                    } else if (from != null && to == null) {
                        chartTitle = "Bar Chart of Top Sales Product after " + from;
                    } else if (to != null && from == null) {
                        chartTitle = "Bar Chart of Top Sales Product before " + to;
                    } else {
                        chartTitle = "Bar Chart of Top Sales Product from (" + from + " to " + to + ")";
                    }
                } else {
                    chartTitle = "No record";
                }
            } else {
                if (barChart != null && !barChart.isEmpty()) {
                    if (from == null && to == null) {
                        chartTitle = "Bar Chart of Top Sales Category";
                    } else if (from != null && to != null && from.equals(to)) {
                        chartTitle = "Bar Chart of Top Sales Category at " + from;
                    } else if (from != null && to == null) {
                        chartTitle = "Bar Chart of Top Sales Category after " + from;
                    } else if (to != null && from == null) {
                        chartTitle = "Bar Chart of Top Sales Category before " + to;
                    } else {
                        chartTitle = "Bar Chart of Top Sales Category from (" + from + " to " + to + ")";
                    }
                } else {
                    chartTitle = "No record";
                }
            }
        %>
                title: {
                    display: true,
                    text: "<%=chartTitle%>", //Display the relevant title
                    fontSize: 20
                }
            }
        });

    </script>
</html>
