package cat201project.model;

public class InventoryItem {
    private String cakeId;
    private String tier;
    private String flavour;
    private String size;
    private int quantity;
    private long lastUpdated;

    public InventoryItem() {}

    public String getCakeId() { return cakeId; }
    public void setCakeId(String cakeId) { this.cakeId = cakeId; }

    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    public String getFlavour() { return flavour; }
    public void setFlavour(String flavour) { this.flavour = flavour; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public long getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(long lastUpdated) { this.lastUpdated = lastUpdated; }
}