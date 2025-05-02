<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" class="Model.User" scope="session"></jsp:useBean>
<jsp:include page="../Header.jsp"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Profile</title>
        <style>
            body {
                position:relative;
                top:100px;
                margin: 0;
                padding: 0;
                font-family: sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #ffcccc;

            }

            .profile-container {
                padding: 30px 40px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                width: 400px;
                text-align: center;
                background-color: #ffe8e8;
            }

            img #usericon{
                border-radius: 50%;
                margin-bottom: 20px;
            }

            label {
                display: block;
                text-align: left;
                margin-top: 15px;
                font-weight: bold;
            }

            input[type="text"],
            textarea {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }

            input[type="submit"],
            button {
                margin-top: 20px;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            input[type="submit"] {
                position:relative;
                left:150px;
                width: 100px;
                padding: 10px;
                background-color: #ff9999;
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
                transition: background-color 0.3s;
            }

            button {
                background-color: #ff9999;
                color: black;
                border: none;
                display: block;
                position:absolute;
                top:30px;
                left:30px;
                padding: 10px;
                background-color: #ff9999;
                color: black;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            input[type="submit"]:hover,button:hover {
                background-color: #e47575;
            }

            .changepassword{
                position:static;
                background-color:white;
                color:black;
                font-size:15px;
            }
            .changepassword:hover{
                background-color:lightgray;
            }
            
            #passwordForm{
                display:none;
                position:absolute;
                top:200px;
                left:100px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                padding:30px 30px;
                background-color: #ffe8e8;
            }
            #change{
                position:static;
                right:30px;
                width:170px;
            }
            

        </style>
    </head>
    <body>
        <button type="button" onclick="history.back();" style="width:80px;height:40px;">Back</button>
        <div class="profile-container">
            <h1>Profile</h1>
            <img src="UserIcon.png" alt="" width="100" height="100" id="usericon"
                 style="background-color: white; border-radius: 50%; padding: 5px; box-shadow: 0 0 5px rgba(0,0,0,0.2);" />
            <form action="UserProfileServlet" method="get">
                <label>ID:</label>
                <input type="text" value="<%= user.getId()%>" disabled>
                <input type="hidden" name="id" value="<%= user.getId()%>">
                <input type="hidden" name="editprofile" value="editprofile">

                <label>Username:</label>
                <input type="text" name="name" value="<%= user.getUserLoginName()%>">

                <label>Email:</label>
                <input type="text" name="email" value="<%= user.getEmail()%>">

                <label>Address:</label>
                <textarea name="address"><%= user.getAddress()%></textarea>
                <button type="button" class="changepassword" id="togglePasswordForm" style="background-color: #ff9999" >Change password ?</button>
                <input type="submit" value="Edit">
            </form>
        </div>
        <div id="passwordForm">
            <form action="UserProfileServlet" method="post">
                <h2>Change password</h2>
                <label>Old Password:</label><br>
                <input type="password" name="oldPassword"><br>

                <label>New Password</label><br>
                <input type="password" name="newPassword"><br>
                <input type="hidden" name="id" value="<%= user.getId()%>">

                <input type="submit" value="Change" id="change">
            </form>
        </div>
    </body>
    <script>
        document.getElementById("togglePasswordForm").addEventListener("click", function () {
            var form = document.getElementById("passwordForm");
            if (form.style.display === "none" || form.style.display === "") {
                form.style.display = "block";
            } else {
                form.style.display = "none";
            }
        });
    </script>
</script>
</html>
