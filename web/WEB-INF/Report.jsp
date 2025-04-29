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
    </style>
    <body>
        <div class="container">
            <div class="form-container">        
                <h1>Report</h1>
                <!--<a href="">Top Sales Report</a>
                <a href="">Potential Customer</a>-->
                <form action="ReportServlet" method="GET">
                    From
                    <input type="date" name="from" id="from" value="<%=from != null ? from : ""%>">
                    to
                    <input type="date" name="to" id="to" value="<%=to != null ? to : ""%>">
                    <button type="submit" onclick="return validationDate()">Apply</button>
                </form>
                <div class="chart-container">
                    <canvas id="myChart" style="width:100%;max-width:800px"></canvas>

                    <div class="sales-list">
                        <%if (barChart != null && !barChart.isEmpty()) {%><!--if have record found within the date-->
                        <h3>Sales by Category</h3>
                        <table style="font-size:20px;">
                            <%if (barChart != null) {%>
                            <% for (int i = 0; i < barChart.size(); i++) {
                                    HashMap<String, String> item = barChart.get(i);%>
                            <tr>
                                <td><%=i + 1%>. <%= item.get("category")%></td>
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
                        <th>Total categories</th>
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
        const xValues = [<%
            for (int i = 0; i < barChart.size(); i++) {
                HashMap<String, String> item = barChart.get(i);
                out.println("\"" + item.get("category") + "\"");
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
            if (barChart != null && !barChart.isEmpty()) {
                if (from == null && to == null) {
                    chartTitle = "Bar Chart of Top Sales";
                } else if (from != null && to != null && from.equals(to)) {
                    chartTitle = "Bar Chart of Top Sales at " + from;
                } else if (from != null && to == null) {
                    chartTitle = "Bar Chart of Top Sales after " + from;
                } else if (to != null && from == null) {
                    chartTitle = "Bar Chart of Top Sales before " + to;
                } else {
                    chartTitle = "Bar Chart of Top Sales from (" + from + " to " + to + ")";
                }
            } else {
                chartTitle = "No record";
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
