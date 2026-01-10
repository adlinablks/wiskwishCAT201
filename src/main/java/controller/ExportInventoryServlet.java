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

//handles inventory export function and generates summary report in JSON
@WebServlet("/ExportInventoryServlet")
public class ExportInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private static final String LAST_EXPORT_FILE = "last-export.txt";
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        //check only admin can export
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        //export summary
        exportSummary(response);

        //save the current timestamp as the last export time
        saveLastExportTimestamp();
    }

    //summary report and organize data according to tier, flavour and size
    private void exportSummary(HttpServletResponse response) throws IOException {
        String filePath = getServletContext().getRealPath("/WEB-INF/" + INVENTORY_FILE);
        File file = new File(filePath);

        if (!file.exists()) {
            response.setContentType("text/plain");
            response.getWriter().write("Inventory file not found");
            return;
        }

        //read inventory
        List<InventoryItem> inventoryList;
        try (Reader reader = new FileReader(file)) {
            Type listType = new TypeToken<ArrayList<InventoryItem>>(){}.getType();
            inventoryList = gson.fromJson(reader, listType);
        }

        if (inventoryList == null) {
            inventoryList = new ArrayList<>();
        }

        //create summary structure
        Map<String, Object> summaryReport = new LinkedHashMap<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        String exportDate = dateFormat.format(new Date());

        //add metadata
        summaryReport.put("exportDate", exportDate);
        summaryReport.put("exportTimestamp", new Date().getTime());

        //calculate overall quantities for all cakes
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

        //process each cake in order
        List<String> cakeOrder = Arrays.asList("C01", "C02", "C03", "C04", "C05", "C06");
        List<Map<String, Object>> cakesList = new ArrayList<>();

        for (String cakeId : cakeOrder) {
            //check if this cake has any inventory
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

            //calculate breakdown
            Map<String, Integer> tierQty = new LinkedHashMap<>();
            Map<String, Integer> flavourQty = new LinkedHashMap<>();
            Map<String, Integer> sizeQty = new LinkedHashMap<>();
            int totalQty = 0;

            //aggregate and calculate quantities
            for (InventoryItem item : inventoryList) {
                if (item.getCakeId().equals(cakeId)) {
                    totalQty += item.getQuantity();

                    //tier
                    String tier = item.getTier();
                    tierQty.put(tier, tierQty.getOrDefault(tier, 0) + item.getQuantity());

                    //flavour
                    String flavour = item.getFlavour();
                    flavourQty.put(flavour, flavourQty.getOrDefault(flavour, 0) + item.getQuantity());

                    //size
                    String size = item.getSize();
                    sizeQty.put(size, sizeQty.getOrDefault(size, 0) + item.getQuantity());
                }
            }

            cakeData.put("totalQuantity", totalQty);

            //format tier breakdowns
            List<String> tierList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : tierQty.entrySet()) {
                tierList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("tiers", tierList);

            //format flavour breakdowns
            List<String> flavourList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : flavourQty.entrySet()) {
                flavourList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("flavours", flavourList);

            //format size breakdown
            List<String> sizeList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : sizeQty.entrySet()) {
                sizeList.add(entry.getKey() + ": " + entry.getValue());
            }
            cakeData.put("sizes", sizeList);

            cakesList.add(cakeData);
        }

        //add final summary statistic
        summaryReport.put("totalCakeTypes", cakesList.size());
        summaryReport.put("inventory", cakesList);

        //set response headers
        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"inventory-summary.json\"");

        //write summary to response
        String jsonOutput = gson.toJson(summaryReport);
        response.getWriter().write(jsonOutput);
        response.getWriter().flush();
    }

    //save current timestamp to track inventory last reported
    private void saveLastExportTimestamp() {
        try {
            String exportFilePath = getServletContext().getRealPath("/WEB-INF/" + LAST_EXPORT_FILE);
            File exportFile = new File(exportFilePath);

            File parentDir = exportFile.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            BufferedWriter writer = new BufferedWriter(new FileWriter(exportFile));
            writer.write(String.valueOf(new Date().getTime()));
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}