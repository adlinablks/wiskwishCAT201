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

//handles inventory updates from admin dashboard
//and process request to update quantities in JSON
@WebServlet("/UpdateInventoryServlet")
public class UpdateInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        //only allow admin to update inventory
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        //get form parameters
        String cakeId = request.getParameter("cakeId");
        String cakeName = request.getParameter("cakeName");
        String tier = request.getParameter("tier");
        String flavour = request.getParameter("flavour");
        String size = request.getParameter("size");
        String quantityStr = request.getParameter("quantity");

        //validate inputs
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

            //update JSON file - without updating timestamp
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

    //update inventory quantity in JSOn for specific cake customization
    private boolean updateInventoryInJSON(String cakeId, String tier,
                                          String flavour, String size, int quantity) {
        try {
            String filePath = getServletContext().getRealPath("/WEB-INF/" + INVENTORY_FILE);
            File file = new File(filePath);

            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }

            List<InventoryItem> inventoryList;

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

            //find and update the item
            boolean found = false;
            for (InventoryItem item : inventoryList) {
                if (item.getCakeId().equals(cakeId) &&
                        item.getTier().equals(tier) &&
                        item.getFlavour().equals(flavour) &&
                        item.getSize().equals(size)) {

                    item.setQuantity(quantity);
                    found = true;
                    break;
                }
            }

            //if not found, add new item
            if (!found) {
                InventoryItem newItem = new InventoryItem();
                newItem.setCakeId(cakeId);
                newItem.setTier(tier);
                newItem.setFlavour(flavour);
                newItem.setSize(size);
                newItem.setQuantity(quantity);
                //leave lastUpdated null for new items - will be set on export
                inventoryList.add(newItem);
            }

            //write back to file
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