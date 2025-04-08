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
import javax.servlet.http.Part;


@MultipartConfig          
@WebServlet("/ProductUpdateServlet")
public class ProductUpdateServlet extends HttpServlet {
    private static final String IMAGE_SAVE_DIR = "images";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        System.out.println("ProductUpdateServlet triggered!");

        String idStr = request.getParameter("id");
        String productName = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String categoryIdStr = request.getParameter("category");
        Part file = request.getPart("image"); // gets the <input type="file">
        String existImageUrl = request.getParameter("existingImageUrl");

        System.out.println("Received data - ID: " + idStr + ", Name: " + productName + 
                           ", Price: " + priceStr + ", Quantity: " + quantityStr + 
                           ", Category: " + categoryIdStr + ", Existing Image URL: " + existImageUrl);

        if (idStr == null || productName == null || priceStr == null || quantityStr == null || categoryIdStr == null ) {
            System.out.println("Error: Missing form data!");
            response.sendRedirect("controller?action=productmanage&message=Missing required fields");
            return;
        }
        
        // Validate product name
        if (!ProductValidator.isValidProductName(productName)) {
            sendAlertAndRedirect(response, "Product name should not contain special characters.", "controller?action=productEdit&id=" + idStr);
            return;
        }

        // Validate price
        if (!ProductValidator.isValidPrice(priceStr)) {
            sendAlertAndRedirect(response, "Price must be greater than 0.", "controller?action=productEdit&id=" + idStr);
            return;
        }

        // Validate quantity
        if (!ProductValidator.isValidQuantity(quantityStr)) {
            sendAlertAndRedirect(response, "Quantity must be greater than 0.", "controller?action=productEdit&id=" + idStr);
            return;
        }

            //Declare type converter
            int categoryId = Integer.parseInt(categoryIdStr);
            int productId = Integer.parseInt(idStr);
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);
            String imageUrl = existImageUrl; // Default to the existing image

           
            // If a new image is uploaded, validate and save it
            if (file != null && file.getSize() > 0) {
            String fileName = Paths.get(file.getSubmittedFileName()).getFileName().toString();
            if (!ProductValidator.isValidImageFile(fileName)) {
                sendAlertAndRedirect(response, "Only PNG, JPG, and JPEG image formats are allowed.", "controller?action=productEdit&id=" + idStr);
                return;
            }

            // Get absolute path from their device
            String uploadDirPath = getServletContext().getRealPath("/") + IMAGE_SAVE_DIR;
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Full path where file will be saved
            File imageFile = new File(uploadDir, fileName);
            try (InputStream input = file.getInputStream(); FileOutputStream output = new FileOutputStream(imageFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // Save relative image path for DB
            imageUrl = IMAGE_SAVE_DIR + "/" + fileName;
            
            //Delete old file if new uploaded 
            if (!imageUrl.equals(existImageUrl)) {
                File oldImageFile = new File(getServletContext().getRealPath("/") + existImageUrl);
                if (oldImageFile.exists()) {
                 oldImageFile.delete();
                }
             }
            }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "UPDATE products SET product_name = ?, price = ?, quantity = ?, category_id = ?, image_url = ? WHERE id = ?")) {

            stmt.setString(1, productName);
            stmt.setDouble(2, price);
            stmt.setInt(3, quantity);
            stmt.setInt(4, categoryId);
            stmt.setString(5, imageUrl); 
            stmt.setInt(6, productId);

            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Executing SQL: UPDATE products SET product_name = " + productName + ", price = " + price + ", quantity = " + quantity + ", category_id = " + categoryId + ", image_url = " + imageUrl + " WHERE id = " + productId);
            if (rowsUpdated > 0) {
                System.out.println("Update successful!");
                response.getWriter().write("<script>alert('Product updated successfully!'); window.location.href='controller?action=productmanage';</script>");
            } else {
                System.out.println("Update failed.");
                response.getWriter().write("<script>alert('Update failed!'); window.history.back();</script>");
            }
        }catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<script>alert('Update failed!'); window.history.back();</script>");
        }
    }
    
    private void sendAlertAndRedirect(HttpServletResponse response, String message, String redirectURL) throws IOException {
        response.setContentType("text/html");
        response.getWriter().write("<script>alert('" + message + "'); window.location='" + redirectURL + "';</script>");
    }
}
