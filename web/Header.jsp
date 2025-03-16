<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    String href = "HeaderStyle.css"; // Default stylesheet
    if (sessionObj != null && sessionObj.getAttribute("adminname") != null) {
        href = "AdminHeaderStyle.css"; // Admin stylesheet
    }
%>
<link rel="stylesheet" type="text/css" href="<%= href %>">
<header class="header">
    <a href="controller"><img src="https://pcforgeph.com/wp-content/uploads/2022/11/transparent-woocommerce.png" alt="Logo" width="150"></a>
</header>
