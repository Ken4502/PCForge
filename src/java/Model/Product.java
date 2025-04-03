package Model;

public class Product {
    private int id;
    private String productName;
    private double price;
    private int quantity;
    private String imageUrl;
    private String categoryName;

    public Product(int id, String productName, double price, int quantity, String imageUrl, String categoryName) {
        this.id = id;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
        this.categoryName = categoryName;
    }

    public int getId() { return id; }
    public String getProductName() { return productName; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public String getImageUrl() { return imageUrl; }
    public String getCategoryName() { return categoryName; }
}
