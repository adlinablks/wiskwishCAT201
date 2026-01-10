package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import cat201project.model.InventoryItem;
import java.io.*;
import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/ExportInventoryServlet")
public class ExportInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private static final String LAST_EXPORT_FILE = "last-export.txt";
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin authentication
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Export summary
        exportSummary(response);

        // Save the current timestamp as the last export time
        saveLastExportTimestamp();
    }

    private void exportSummary(HttpServletResponse response) throws IOException {
        String filePath = getServletContext().getRealPath("/WEB-INF/" + INVENTORY_FILE);
        File file = new File(filePath);

        if (!file.exists()) {
            response.setContentType("text/plain");
            response.getWriter().write("Inventory file not found");
            return;
        }

        // Read inventory
        List<InventoryItem> inventoryList;
        try (Reader reader = new FileReader(file)) {
            Type listType = new TypeToken<ArrayList<InventoryItem>>(){}.getType();
            inventoryList = gson.fromJson(reader, listType);
        }

        if (inventoryList == null) {
            inventoryList = new ArrayList<>();
        }

        // Create summary structure
        Map<String, Object> summaryReport = new LinkedHashMap<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        String exportDate = dateFormat.format(new Date());

        // Add metadata
        summaryReport.put("exportDate", exportDate);
        summaryReport.put("exportTimestamp", new Date().getTime());

        // Calculate overall statistics
        int grandTotal = 0;
        for (InventoryItem item : inventoryList) {
            grandTotal += item.getQuantity();
        }
        summaryReport.put("grandTotalQuantity", grandTotal);

        Map<String, String> cakeNames = new LinkedHashMap<>();
        cakeNames.put("C01", "Ribbon Cake");
        cakeNames.put("C02", "Stitch Cake");
        cakeNames.put("C03", "Real Flower Cake");
        cakeNames.put("C04", "Fox Cake");
        cakeNames.put("C05", "Drawn Flower Cake");
        cakeNames.put("C06", "Bomb Cake");

        // Process each cake in order
        List<String> cakeOrder = Arrays.asList("C01", "C02", "C03", "C04", "C05", "C06");
        List<Map<String, Object>> cakesList = new ArrayList<>();

        for (String cakeId : cakeOrder) {
            // Check if this cake has any inventory
            boolean hasInventory = false;
            for (InventoryItem item : inventoryList) {
                if (item.getCakeId().equals(cakeId)) {
                    hasInventory = true;
                    break;
                }
            }

            if (!hasInventory) continue;

            Map<String, Object> cakeData = new LinkedHashMap<>();
            cakeData.put("cakeId", cakeId);
            cakeData.put("cakeName", cakeNames.get(cakeId));

            // Calculate breakdown
            Map<String, Integer> tierQty = new LinkedHashMap<>();
            Map<String, Integer> flavourQty = new LinkedHashMap<>();
            Map<String, Integer> sizeQty = new LinkedHashMap<>();
            int totalQty = 0;

            for (InventoryItem item : inventoryList) {
                if (item.getCakeId().equals(cakeId)) {
                    totalQty += item.getQuantity();

                    // Tier breakdown
                    String tier = item.getTier();
                    tierQty.put(tier, tierQty.getOrDefault(tier, 0) + item.getQuantity());

                    // Flavour breakdown
                    String flavour = item.getFlavour();
                    flavourQty.put(flavour, flavourQty.getOrDefault(flavour, 0) + item.getQuantity());

                    // Size breakdown
                    String size = item.getSize();
                    sizeQty.put(size, sizeQty.getOrDefault(size, 0) + item.getQuantity());
                }
            }

            cakeData.put("totalQuantity", totalQty);

            // Format breakdowns as readable strings
            List<String> tierList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : tierQty.entrySet()) {
                tierList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("tiers", tierList);

            List<String> flavourList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : flavourQty.entrySet()) {
                flavourList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("flavours", flavourList);

            List<String> sizeList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : sizeQty.entrySet()) {
                sizeList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("sizes", sizeList);

            cakesList.add(cakeData);
        }

        summaryReport.put("totalCakeTypes", cakesList.size());
        summaryReport.put("inventory", cakesList);

        // Set response headers
        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"inventory-summary.json\"");

        // Write summary to response
        String jsonOutput = gson.toJson(summaryReport);
        response.getWriter().write(jsonOutput);
        response.getWriter().flush();
    }

    private void saveLastExportTimestamp() {
        try {
            String exportFilePath = getServletContext().getRealPath("/WEB-INF/" + LAST_EXPORT_FILE);
            File exportFile = new File(exportFilePath);

            // Ensure parent directory exists
            File parentDir = exportFile.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            // Write current timestamp
            BufferedWriter writer = new BufferedWriter(new FileWriter(exportFile));
            writer.write(String.valueOf(new Date().getTime()));
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}