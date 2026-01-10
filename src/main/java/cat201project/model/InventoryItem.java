package cat201project.model;

//single inventory item for specific cake customization
public class InventoryItem {
    private String cakeId;
    private String tier;
    private String flavour;
    private String size;
    private int quantity;
    private String lastUpdated;

    //default constructor
    public InventoryItem() {}

    //setter and getter for cakeID
    public String getCakeId() { return cakeId; }
    public void setCakeId(String cakeId) { this.cakeId = cakeId; }

    //setter and getter for tier
    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    //setter and getter for flavour
    public String getFlavour() { return flavour; }
    public void setFlavour(String flavour) { this.flavour = flavour; }

    //setter and getter for size
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    //setter and getter for quantity
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    //setter and getter last updated timestamp
    public void setLastUpdated(String lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public String getLastUpdated() {
        if (lastUpdated == null || lastUpdated.isEmpty()) {
            return String.valueOf(new java.util.Date().getTime());
        }
        return lastUpdated;
    }
}