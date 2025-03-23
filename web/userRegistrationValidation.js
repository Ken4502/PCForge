
            document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("name").addEventListener("focusout", validateUsername);
            document.getElementById("email").addEventListener("focusout", validateEmail);
            document.getElementById("password").addEventListener("focusout", validatePassword);
            document.getElementById("repass").addEventListener("focusout", validateRePassword);
        });
        
        function validateUsername() {
            let username = document.getElementById("name").value;
            let errorMessage = document.getElementById("usernameError");
            let usernameRegex = /^(?=.*[A-Z])[A-Za-z0-9 ]{4,}$/; //Least 4 characters; a uppercase letter

            if (username.trim() === ""){
                errorMessage.innerText = "Username cannot be blank.";
                errorMessage.style.display = "block";
                return false;
            } 
              else if (!usernameRegex.test(username)){
                errorMessage.innerText = "Username must be at least 4 characters long and contain a uppercase letter.";
                errorMessage.style.display = "block";
                return false;
            } else {
                errorMessage.style.display = "none";
            }
            return true;
        }
        
        function validateEmail(){
            let email = document.getElementById("email").value;
            let errorMessage = document.getElementById("emailError");
            let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/; //(sample@email.com)
            
            if (email === "") {
             errorMessage.innerText = "Email cannot be blank.";
             errorMessage.style.display = "block";
             return false;
          } else if (!emailRegex.test(email)) {
             errorMessage.innerText = "Email must be '(sample@email.com)'. ";
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
            let passwordRegex = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/; //Least 8 character; one letter and one number

            if (password === "") {
                errorMessage.innerText = "Password cannot be blank";
                errorMessage.style.display = "block";
                return false;
            } else if (!passwordRegex.test(password)) {
                errorMessage.innerText = "Password must be at least 8 characters long and contain at least one letter and one number.";
                errorMessage.style.display = "block";
                return false;
            } else {
                errorMessage.style.display = "none";
            }
            return true;
        }
        
        function validateRePassword() {
            let password = document.getElementById("password").value;
            let repass = document.getElementById("repass").value;
            let errorMessage = document.getElementById("repassError");

            if (repass === "") {
                errorMessage.innerText = "Confirm Password cannot be blank";
                errorMessage.style.display = "block";
                return false;
            }else if (repass !== password){
                errorMessage.innerText = "Password is not matching";
                errorMessage.style.display = "block";
                return false;
            }else {
                errorMessage.style.display = "none";
            }
            return true;
        }
        
        function validateForm() {
            let isValid = validateUsername() && validateEmail() && validatePassword() && validateRePassword();
            return isValid;
        }



