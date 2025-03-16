import utils.Utils;
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author user
 */
public class AdminHash {
    public static void main(String[] args) {
        String adminPassword = "administrator"; // Your chosen admin password
        String hashedPassword = Utils.hashPassword(adminPassword); // Hash it
        System.out.println("Admin hashed password: " + hashedPassword);
    }
}
