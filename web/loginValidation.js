
            document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("username").addEventListener("focusout", validateUsername);
            document.getElementById("password").addEventListener("focusout", validatePassword);
        });

        function validateUsername() {
            let username = document.getElementById("username").value;
            let errorMessage = document.getElementById("usernameError");

            if (username.trim() === ""){
                errorMessage.innerText = "Username cannot be blank.";
                errorMessage.style.display = "block";
                return false;
            } else {
                errorMessage.style.display = "none";
            }
            return true;
        }
        
        function validatePassword() {
            let password = document.getElementById("password").value;
            let errorMessage = document.getElementById("passwordError");


            if (password === "") {
                errorMessage.innerText = "Password cannot be blank";
                errorMessage.style.display = "block";
                return false;
            } else {
                errorMessage.style.display = "none";
            }
            return true;
        }

