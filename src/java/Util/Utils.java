package Util;

import java.io.PrintWriter;
import java.io.IOException;
//import java.security.MessageDigest;
//import java.security.NoSuchAlgorithmException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Utils {

    // Method to hash a password using SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());
            byte[] byteData = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : byteData) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Method to verify if input password matches the stored hash
    public static boolean verifyPassword(String inputPassword, String storedHash) {
        String hashedInput = hashPassword(inputPassword); // Hash the input password
        return hashedInput != null && hashedInput.equals(storedHash); // Compare hashes
    }

    // Method to show alert and redirect
    public static void showAlert(PrintWriter out, String message, HttpServletRequest request, HttpServletResponse response, String redirectPage) throws IOException {
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='" + request.getContextPath() + "/" + redirectPage + "';");
        out.println("</script>");
        out.flush();
    }
}

