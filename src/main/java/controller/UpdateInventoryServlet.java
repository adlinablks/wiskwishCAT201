package controller;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import cat201project.model.InventoryItem;

@WebServlet("/UpdateInventoryServlet")
public class UpdateInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin authentication
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get form parameters
        String cakeId = request.getParameter("cakeId");
        String cakeName = request.getParameter("cakeName");
        String tier = request.getParameter("tier");
        String flavour = request.getParameter("flavour");
        String size = request.getParameter("size");
        String quantityStr = request.getParameter("quantity");

        // Validate inputs
        if (cakeId == null || tier == null || flavour == null ||
                size == null || quantityStr == null) {
            request.setAttribute("error", "All fields are required");
            request.setAttribute("cakeId", cakeId);
            request.setAttribute("cakeName", cakeName);
            request.getRequestDispatcher("update-inventory.jsp").forward(request, response);
            return;
        }

        try {
            int quantity = Integer.parseInt(quantityStr);

            if (quantity < 0) {
                request.setAttribute("error", "Quantity cannot be negative");
                request.setAttribute("cakeId", cakeId);
                request.setAttribute("cakeName", cakeName);
                request.getRequestDispatcher("update-inventory.jsp").forward(request, response);
                return;
            }

            // Update JSON file
            boolean success = updateInventoryInJSON(cakeId, tier, flavour, size, quantity);

            if (success) {
                response.sendRedirect("admin-dashboard.jsp?update=success");
            } else {
                request.setAttribute("error", "Failed to update inventory");
                request.setAttribute("cakeId", cakeId);
                request.setAttribute("cakeName", cakeName);
                request.getRequestDispatcher("update-inventory.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity format");
            request.setAttribute("cakeId", cakeId);
            request.setAttribute("cakeName", cakeName);
            request.getRequestDispatcher("update-inventory.jsp").forward(request, response);
        }
    }

    private boolean updateInventoryInJSON(String cakeId, String tier,
                                          String flavour, String size, int quantity) {
        try {
            String filePath = getServletContext().getRealPath("/WEB-INF/" + INVENTORY_FILE);
            File file = new File(filePath);

            // Ensure parent directory exists
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            List<InventoryItem> inventoryList;

            // Read existing data
            if (file.exists()) {
                Reader reader = new FileReader(file);
                Type listType = new TypeToken<ArrayList<InventoryItem>>(){}.getType();
                inventoryList = gson.fromJson(reader, listType);
                reader.close();

                if (inventoryList == null) {
                    inventoryList = new ArrayList<>();
                }
            } else {
                inventoryList = new ArrayList<>();
            }

            // Get current formatted date (e.g., "2026-01-10 13:45:00")
            String currentDate = sdf.format(new Date());

            // Find and update the item
            boolean found = false;
            for (InventoryItem item : inventoryList) {
                if (item.getCakeId().equals(cakeId) &&
                        item.getTier().equals(tier) &&
                        item.getFlavour().equals(flavour) &&
                        item.getSize().equals(size)) {

                    item.setQuantity(quantity);
                    item.setLastUpdated(currentDate); // Saves as String
                    found = true;
                    break;
                }
            }

            // If not found, add new item
            if (!found) {
                InventoryItem newItem = new InventoryItem();
                newItem.setCakeId(cakeId);
                newItem.setTier(tier);
                newItem.setFlavour(flavour);
                newItem.setSize(size);
                newItem.setQuantity(quantity);
                newItem.setLastUpdated(currentDate); // Saves as String
                inventoryList.add(newItem);
            }

            // Write back to file
            Writer writer = new FileWriter(file);
            gson.toJson(inventoryList, writer);
            writer.close();

            return true;

        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}