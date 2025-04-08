package Util;

import java.util.regex.*;

public class ProductValidator {

    private static final String PRODUCT_NAME_PATTERN = "^[a-zA-Z0-9\\s]+$"; // Letters, numeric numbers, and spaces
    private static final String CATEGORY_NAME_PATTERN = "^[a-zA-Z\\s]+$"; // Letters and spaces
    private static final String[] ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"};

    // Validate product name
    public static boolean isValidProductName(String productName) {
        return productName != null && !productName.isEmpty() && productName.matches(PRODUCT_NAME_PATTERN);
    }

    // Validate category name
    public static boolean isValidCategoryName(String categoryName) {
        return categoryName != null && !categoryName.isEmpty() && categoryName.matches(CATEGORY_NAME_PATTERN);
    }

    // Validate price
    public static boolean isValidPrice(String priceStr) {
        try {
            double price = Double.parseDouble(priceStr);
            return price > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Validate quantity
    public static boolean isValidQuantity(String quantityStr) {
        try {
            int quantity = Integer.parseInt(quantityStr);
            return quantity > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // Validate file extension
    public static boolean isValidFileExtension(String fileName) {
        for (String ext : ALLOWED_EXTENSIONS) {
            if (fileName.toLowerCase().endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    // Validate image file (null check and extension check)
    public static boolean isValidImageFile(String fileName) {
        return fileName != null && !fileName.isEmpty() && isValidFileExtension(fileName);
    }
}
