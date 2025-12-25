package cat201project.model;

public class CartItem {
    private String id;
    private String name;
    private String flavor;
    private String tier;       // new field
    private String size;       // new field
    private int quantity;
    private double price;
    private String image;

    // Updated constructor to include tier and size
    public CartItem(String id, String name, String flavor,
                    String tier, String size,
                    int quantity, double price, String image) {
        this.id = id;
        this.name = name;
        this.flavor = flavor;
        this.tier = tier;
        this.size = size;
        this.quantity = quantity;
        this.price = price;
        this.image = image;
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getFlavor() { return flavor; }
    public String getTier() { return tier; }       // new getter
    public String getSize() { return size; }       // new getter
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public String getImage() { return image; }

    // Setter for quantity
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Total price calculation
    public double getTotalPrice() {
        return price * quantity;
    }
}
