/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

/**
 *
 * @author User
 */
public class registrationValidator {
    
    private static final String USERNAME_REGEX = "^(?=.*[A-Z])[A-Za-z0-9 ]{4,}$"; //Least 4 characters; an Uppercase letter
    private static final String EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"; //(sample@email.com)  
    private static final String PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"; //Least 8 character; one letter and one number
            
    //Validate username
    public static boolean isValidUsername(String name) {
        return name != null && name.matches(USERNAME_REGEX);
    }

    //Validate email
    public static boolean isValidEmail(String email) {
        return email != null && email.matches(EMAIL_REGEX);
    }

    //Validate password
    public static boolean isValidPassword(String password) {
        return password != null && password.matches(PASSWORD_REGEX);
    }

    //Validate confirm password
    public static boolean passwordsMatch(String password, String repass) {
        return password != null && password.equals(repass);
    }
}
