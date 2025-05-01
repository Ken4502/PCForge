<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<jsp:useBean id="user" class="Model.User" scope="session"></jsp:useBean> <!--Using javabean-->
<jsp:setProperty name="user" property="*" />
<%
    HttpSession sessionObj = request.getSession(false);
    String href = "HeaderStyle.css"; // Default stylesheet
    if (sessionObj != null && sessionObj.getAttribute("adminname") != null) {
        href = "AdminHeaderStyle.css"; // Admin stylesheet
    }

%>
<link rel="stylesheet" type="text/css" href="<%= href%>">
<header class="header">
    <a href="controller"><img src="https://pcforgeph.com/wp-content/uploads/2022/11/transparent-woocommerce.png" alt="Logo" width="150"></a>
        <% if (user.getUserLoginName() != null && !user.getUserLoginName().isEmpty()) { %>
    <a href="controller?action=userprofile"><img src="UserIcon.png" alt="" width="50" height="50"
                 style="background-color: white; border-radius: 50%; padding: 5px; box-shadow: 0 0 5px rgba(0,0,0,0.2);" /></a>
        <% }%>

</header>
