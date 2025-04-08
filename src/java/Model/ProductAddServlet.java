package Model;

import Util.DatabaseConnection;
import Util.ProductValidator;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet("/ProductAddServlet")
public class ProductAddServlet extends HttpServlet {
    private static final String IMAGE_SAVE_DIR = "images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminname") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }

        String productName = request.getParameter("productname");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        Part file = request.getPart("image");
        String categoryIdStr = request.getParameter("category");
        String categoryName = request.getParameter("categoryName");

        if (productName == null || priceStr == null || quantityStr == null || file == null || categoryIdStr == null ||
            productName.isEmpty() || priceStr.isEmpty() || quantityStr.isEmpty() || file.getSize() == 0 || categoryIdStr.isEmpty()) {
            sendAlertAndRedirect(response, "All fields are required!", "controller?action=productadd");
            return;
        }

        // Validate product name
        if (!ProductValidator.isValidProductName(productName)) {
            sendAlertAndRedirect(response, "Product name should not contain special characters.", "controller?action=productadd");
            return;
        }

        // Validate price
        if (!ProductValidator.isValidPrice(priceStr)) {
            sendAlertAndRedirect(response, "Price must be greater than 0.", "controller?action=productadd");
            return;
        }

        // Validate quantity
        if (!ProductValidator.isValidQuantity(quantityStr)) {
            sendAlertAndRedirect(response, "Quantity must be greater than 0.", "controller?action=productadd");
            return;
        }
        
        double price = Double.parseDouble(priceStr);
        int quantity = Integer.parseInt(quantityStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        // Validate category name if provided
        if (categoryName != null && !categoryName.isEmpty() && !ProductValidator.isValidCategoryName(categoryName)) {
            sendAlertAndRedirect(response, "Category name must contain only letters and spaces.", "controller?action=productadd");
            return;
        }

        // Validate image file
        String fileName = Paths.get(file.getSubmittedFileName()).getFileName().toString();
        if (!ProductValidator.isValidImageFile(fileName)) {
            sendAlertAndRedirect(response, "Only PNG, JPG, and JPEG image formats are allowed.", "controller?action=productadd");
            return;
        }

        // Get absolute path from their device
        String uploadDirPath = getServletContext().getRealPath("/") + IMAGE_SAVE_DIR;
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File imageFile = new File(uploadDir, fileName);
        
        // Save the image file
        try (InputStream input = file.getInputStream(); FileOutputStream output = new FileOutputStream(imageFile)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }

        String imageUrl = IMAGE_SAVE_DIR + "/" + fileName;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO products (product_name, price, quantity, image_url, category_id) VALUES (?, ?, ?, ?, ?)")) {

            stmt.setString(1, productName);
            stmt.setDouble(2, price);
            stmt.setInt(3, quantity);
            stmt.setString(4, imageUrl);
            stmt.setInt(5, categoryId);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                sendAlertAndRedirect(response, "Product added successfully!", "controller?action=productmanage");
            } else {
                sendAlertAndRedirect(response, "Failed to add product.", "controller?action=productadd");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendAlertAndRedirect(response, "Database error: " + e.getMessage(), "controller?action=productadd");
        }
    }

    private void sendAlertAndRedirect(HttpServletResponse response, String message, String redirectURL) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<script>alert('" + message + "'); window.location='" + redirectURL + "';</script>");
    }
}
