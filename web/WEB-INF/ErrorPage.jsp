<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%
    List<HashMap<String, String>> error = (List<HashMap<String, String>>) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error Page</title>
    </head>
    <body>
        <h1>Error Occur !</h1>
        <%if (error != null) {%>
        <%for (HashMap<String, String> err : error) {%>
        <p><%=err.get("message")%></p><br>
        <%}%>
        <%} else {%>
        <p>No error message found</p>
        <%}%>
    </body>
</html>
