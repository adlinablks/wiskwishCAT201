package controller;

import java.io.*;
import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.*;

import cat201project.model.InventoryItem;

@WebServlet("/LoadInventoryServlet")
public class LoadInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    /**
     * Get quantity for a specific combination
     */
    public static int getQuantity(ServletContext context, String cakeId,
                                  String tier, String flavour, String size) {

        List<InventoryItem> items = loadAllItems(context);

        for (InventoryItem item : items) {
            if (item.getCakeId().equals(cakeId) &&
                    item.getTier().equals(tier) &&
                    item.getFlavour().equals(flavour) &&
                    item.getSize().equals(size)) {
                return item.getQuantity();
            }
        }
        return 0;
    }

    /**
     * Get total quantity for a cake
     */
    public static int getTotalQuantity(ServletContext context, String cakeId) {
        List<InventoryItem> items = loadAllItems(context);
        int total = 0;

        for (InventoryItem item : items) {
            if (item.getCakeId().equals(cakeId)) {
                total += item.getQuantity();
            }
        }

        return total;
    }

    /**
     * Get quantities grouped by customization option for display
     */
    public static Map<String, Integer> getQuantitiesByTier(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "tier");
    }

    public static Map<String, Integer> getQuantitiesByFlavour(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "flavour");
    }

    public static Map<String, Integer> getQuantitiesBySize(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "size");
    }

    private static Map<String, Integer> getQuantitiesByOption(ServletContext context, String cakeId, String optionType) {
        List<InventoryItem> items = loadAllItems(context);
        Map<String, Integer> result = new HashMap<>();

        for (InventoryItem item : items) {
            if (item.getCakeId().equals(cakeId)) {
                String key = "";
                switch (optionType) {
                    case "tier" -> key = item.getTier();
                    case "flavour" -> key = item.getFlavour();
                    case "size" -> key = item.getSize();
                }
                result.put(key, result.getOrDefault(key, 0) + item.getQuantity());
            }
        }

        return result;
    }

    /**
     * Load all inventory items from JSON
     */
    public static List<InventoryItem> loadAllItems(ServletContext context) {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + INVENTORY_FILE);
            File file = new File(filePath);

            if (!file.exists()) {
                return new ArrayList<>();
            }

            Reader reader = new FileReader(file);
            Type listType = new TypeToken<ArrayList<InventoryItem>>(){}.getType();
            List<InventoryItem> items = gson.fromJson(reader, listType);
            reader.close();

            return items != null ? items : new ArrayList<>();

        } catch (Exception e) {
            System.err.println("Error loading inventory: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}