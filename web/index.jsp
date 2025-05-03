<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="Header.jsp"/>

<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" type="text/css" href="BodyStyle.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PC Forge - Premium Computer Components</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #ffcccc;
                font-size: 18px;
                display: flex;
                flex-direction: column;
                min-height: 900px;
            }

            .container {
                flex: 1;
                width: 80%;
                margin: 40px auto;
                background-color: #ffe8e8;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .hero {
                display: flex;
                align-items: center;
                margin-bottom: 40px;
                padding-bottom: 40px;
                border-bottom: 1px solid #e5c7c7;
            }

            .hero-content {
                flex: 1;
                padding-right: 40px;
            }

            .hero-content h2 {
                font-size: 38px;
                color: #333;
                margin-bottom: 20px;
            }

            .hero-content p {
                font-size: 20px;
                line-height: 1.6;
                color: #555;
                margin-bottom: 30px;
            }

            .cta-button {
                display: inline-block;
                background-color: #ff9a9a;
                color: #333;
                padding: 12px 25px;
                border-radius: 4px;
                text-decoration: none;
                font-weight: bold;
                font-size: 20px;
                transition: background-color 0.2s;
            }

            .cta-button:hover {
                background-color: #e57272;
            }

            .hero-image {
                flex: 1;
                text-align: center;
            }

            .hero-image img {
                max-width: 60%;
                border-radius: 8px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }

            .welcome-message {
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e5c7c7;
                width: 100%;
                text-align: center;
            }

            .welcome-message h2 {
                font-size: 36px;
                color: #333;
            }

            .featured-products {
                margin-bottom: 40px;
            }

            .section-title {
                font-size: 34px;
                color: #333;
                margin-bottom: 25px;
                text-align: center;
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 25px;
            }

            .product-card {
                background-color: #fff;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
                transition: transform 0.2s;
                text-decoration: none;
                color: inherit;
            }

            .product-card:hover {
                transform: translateY(-5px);
            }

            .product-image {
                height: 200px;
                background-color: #f5f5f5;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }

            .product-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .product-info {
                padding: 15px;
            }

            .product-name {
                font-size: 22px;
                font-weight: bold;
                color: #333;
                margin-bottom: 8px;
            }

            .product-category {
                font-size: 16px;
                color: #777;
                margin-bottom: 12px;
            }

            .product-price {
                font-size: 24px;
                font-weight: bold;
                color: #e57272;
            }

            .about-section {
                display: flex;
                margin-bottom: 40px;
                padding-bottom: 40px;
                border-bottom: 1px solid #e5c7c7;
            }

            .about-content {
                flex: 2;
                padding-right: 40px;
            }

            .about-content h3 {
                font-size: 30px;
                color: #333;
                margin-bottom: 15px;
            }

            .about-content p {
                font-size: 18px;
                line-height: 1.6;
                color: #555;
                margin-bottom: 20px;
            }

            .about-image {
                flex: 1;
                text-align: center;
            }

            .about-image img {
                max-width: 50%;
                border-radius: 8px;
            }

            .services {
                margin-bottom: 40px;
            }

            .services-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 25px;
            }

            .service-card {
                background-color: #fff;
                border-radius: 8px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }

            .service-icon {
                width: 70px;
                height: 70px;
                margin: 0 auto 15px;
                background-color: lightgray;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }

            .service-title {
                font-size: 24px;
                font-weight: bold;
                color: #333;
                margin-bottom: 15px;
            }

            .service-description {
                font-size: 18px;
                line-height: 1.5;
                color: #555;
            }

            .menu-links {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin: 30px 0;
            }

            .menu-links a {
                color: #333;
                text-decoration: none;
                padding: 16px 22px;
                background-color: #ff9a9a;
                border-radius: 4px;
                display: inline-block;
                text-align: center;
                font-size: 26px;
                box-shadow: 0 2px 3px rgba(0,0,0,0.1);
                transition: background-color 0.2s;
            }

            .menu-links a:hover {
                background-color: #e57272;
            }

            .footer {
                background-color: #333;
                color: #fff;
                padding: 30px 0;
                text-align: center;
                margin-top: 40px;
                font-size: 18px;
            }

            .footer-content {
                width: 80%;
                margin: 0 auto;
            }

            .footer-links {
                display: flex;
                justify-content: center;
                margin-bottom: 20px;
            }

            .footer-links a {
                color: #fff;
                text-decoration: none;
                margin: 0 15px;
                transition: color 0.2s;
                font-size: 18px;
            }

            .footer-links a:hover {
                color: #ff9a9a;
            }

            .footer-bottom {
                margin-top: 20px;
                color: #aaa;
                font-size: 16px;
            }

            @media (max-width: 768px) {
                .hero, .about-section {
                    flex-direction: column;
                }

                .hero-content, .about-content {
                    padding-right: 0;
                    margin-bottom: 30px;
                }

                .product-grid, .services-grid {
                    grid-template-columns: 1fr;
                }

                .menu-links a {
                    width: 100%;
                }

                body {
                    font-size: 19px;
                }

                .hero-content h2 {
                    font-size: 32px;
                }

                .section-title {
                    font-size: 30px;
                }
            }

            #small-detail{
                position:absolute;
                margin:auto;
                top:400px;
                font-size:30px;
            }
        </style>
    </head>
    <body class="body">
        <div class="container">
            <div class="welcome-message">    
                <h2>Hello
                    <%
                        HttpSession sessionObj = request.getSession(false);
                        String loggedInUser = (sessionObj != null) ? (String) sessionObj.getAttribute("username") : null;
                        String loggedInUserID = (sessionObj != null) ? (String) (String.valueOf(sessionObj.getAttribute("userId"))) : null;
                        String loggedInAdmin = (sessionObj != null) ? (String) sessionObj.getAttribute("adminname") : null;
                        Object isAdminObj = session.getAttribute("is_admin"); // Get session attribute
                        boolean isAdmin = isAdminObj != null && (Boolean) isAdminObj; // Ensure it's a boolean

                        if (loggedInUser != null) {
                            out.print(loggedInUser);
                        } else if (loggedInAdmin != null) {
                            out.print(loggedInAdmin);
                        } else {
                            out.print("Guest");
                        }
                    %>, <br>Welcome to PC Forge!
                </h2>
            </div>

            <!-- Show link/buttons for guest and user (not admin) -->
            <div class="menu-links">
                <%
                    if (loggedInAdmin != null) {
                        // If admin is logged in, show admin features
                        if (isAdmin) {
                %>
                <a href="controller?action=staffaccountmanage">Manage Your Account</a>
                <a href="controller?action=staffmanage">Manage Staff</a>
                <a href="controller?action=viewOrders">Manage Order Status</a>
                <a href="controller?action=usermanage">Manage User</a>
                <a href="controller?action=productmanage">Manage Product</a>
                <a href="controller?action=report">Report</a>
                <a href="AdminLogoutServlet" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
                <p id="small-detail">Choose one to manage</p>
                <%} else {%>
                <a href="controller?action=staffaccountmanage">Manage Account</a>
                <a href="controller?action=viewOrders">Manage Order Status</a>
                <a href="controller?action=usermanage">Manage User</a>
                <a href="controller?action=productmanage">Manage Product</a>
                <a href="AdminLogoutServlet" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
                <p id="small-detail">Choose one to manage</p>
                <%}%>
                <%} else if (loggedInUser != null) {
                    // If a normal user is logged in, show normal logout
                %>
                <a href="controller?action=orderTracking">Track Orders</a>
                <a href="controller?action=productview">View Product</a>
                <a href="LogoutServlet">Logout</a>
                <%
                } else {
                    // If no one is logged in, show login/register options
                %>
                <a href="controller?action=productview">View Product</a>
                <a href="controller?action=login">Login</a>
                <a href="controller?action=register">Sign up now!</a>
                <a href="controller?action=adminlogin">Staff Portal</a>
                <%
                    }
                %>
            </div>

            <!-- Only display these sections to guest and user, not to admin -->
            <% if (loggedInAdmin == null) { %>
            <div class="hero">
                <div class="hero-content">
                    <h2>Build Your Dream PC with Premium Components</h2>
                    <p>PC Forge specializes in high-quality computer components for gamers, professionals, and enthusiasts. From powerful graphics cards to lightning-fast storage solutions, we offer everything you need to forge the perfect PC.</p>
                    <a href="controller?action=productview" class="cta-button">Explore Products</a>
                </div>
                <div class="hero-image">
                    <img src="Custom-PC.png" alt="Custom PC Build">
                </div>
            </div>

            <div class="featured-products">
                <div class="hero-image" style="text-align:center; margin-top: 20px;">
                    <a href="controller?action=productview">
                        <img src="PCForge.png" alt="PC Forge Banner" style="max-width:40%; border-radius:8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
                    </a>
                </div>
            </div>

            <div class="services">
                <h2 class="section-title">Our Services</h2>
                <div class="services-grid">
                    <!-- Service 1 -->
                    <div class="service-card">
                        <div class="service-icon">🔧</div>
                        <div class="service-title">PC Building</div>
                        <div class="service-description">Let our experts build your custom PC with carefully selected components tailored to your needs and budget.</div>
                    </div>
                    <!-- Service 2 -->
                    <div class="service-card">
                        <div class="service-icon">🛠</div>
                        <div class="service-title">Repairs & Upgrades</div>
                        <div class="service-description">Bring new life to your existing PC with our professional repair and upgrade services.</div>
                    </div>
                    <!-- Service 3 -->
                    <div class="service-card">
                        <div class="service-icon">💬</div>
                        <div class="service-title">Expert Consultation</div>
                        <div class="service-description">Get personalized advice from our tech specialists to make informed decisions about your PC components.</div>
                    </div>
                </div>
            </div>

        </div> 
        <div class="footer">
            <div class="footer-bottom">
                &copy; 2025 PC Forge. All rights reserved.
            </div>
        </div>
        <% }%>
    </body>
</html>