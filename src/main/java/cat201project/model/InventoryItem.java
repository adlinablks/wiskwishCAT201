package cat201project.model;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

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

    public String getLastUpdatedFormatted() {
        //get the value (use your getter to handle the null check logic you wrote)
        String timeString = getLastUpdated();

        //safety check: If for some reason it's still null/empty, return a placeholder
        if (timeString == null || timeString.isEmpty()) {
            return "N/A";
        }

        try {
            //convert String "1768..." to Long 1768...
            long unixTime = Long.parseLong(timeString);

            //format it
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")
                    .withZone(ZoneId.of("Asia/Kuala_Lumpur"));

            return formatter.format(Instant.ofEpochMilli(unixTime));

        } catch (NumberFormatException e) {
            // This handles cases where the data might be corrupted (e.g. "abc")
            return "Invalid Date";
        }
    }
}