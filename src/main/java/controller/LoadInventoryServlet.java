package controller;
import cat201project.model.InventoryItem;

import java.io.*;
import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.*;

//provide statistic utility methods to load and query inventory data
//admin dashboard use to display inventory info
@WebServlet("/LoadInventoryServlet")
public class LoadInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    //get total quantity for all cakes
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

    //get quantities by tier for specific cake
    public static Map<String, Integer> getQuantitiesByTier(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "tier");
    }

    //get quantities by flavour for specific cake
    public static Map<String, Integer> getQuantitiesByFlavour(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "flavour");
    }

    //get quantities by size for specific cake
    public static Map<String, Integer> getQuantitiesBySize(ServletContext context, String cakeId) {
        return getQuantitiesByOption(context, cakeId, "size");
    }

    //get quantities by size for specific cake
    private static Map<String, Integer> getQuantitiesByOption(ServletContext context,
                                                              String cakeId, String optionType) {
        List<InventoryItem> items = loadAllItems(context);
        Map<String, Integer> result = new HashMap<>();

        for (InventoryItem item : items) {
            if (item.getCakeId().equals(cakeId)) {
                String key = switch (optionType) {
                    case "tier" -> item.getTier();
                    case "flavour" -> item.getFlavour();
                    case "size" -> item.getSize();
                    default -> "";
                };
                result.put(key, result.getOrDefault(key, 0) + item.getQuantity());
            }
        }
        return result;
    }

    //load all inventory items from json file
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
