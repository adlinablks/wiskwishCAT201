package controller;

import cat201project.model.CartItem;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.lang.reflect.Type;
import java.util.*;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    // CHANGE 1: This was doPost, change it to doGet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This handles the redirect from LoginServlet
        doPost(request, response);
    }

    // CHANGE 2: This remains doPost and contains your logic
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (userEmail == null || cart == null || cart.isEmpty()) {
            response.sendRedirect("cart-page.jsp");
            return;
        }

        // 1. Path to your WEB-INF orders file
        String path = getServletContext().getRealPath("/WEB-INF/orders.json");
        File file = new File(path);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<Map<String, Object>> allOrders = new ArrayList<>();

        // 2. Read existing orders
        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                Type type = new TypeToken<List<Map<String, Object>>>(){}.getType();
                allOrders = gson.fromJson(reader, type);
                if (allOrders == null) allOrders = new ArrayList<>();
            }
        }

        // 3. Create the new Order Entry
        Map<String, Object> orderEntry = new HashMap<>();
        orderEntry.put("userEmail", userEmail);
        orderEntry.put("orderDate", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

        List<Map<String, Object>> itemsList = new ArrayList<>();
        for (CartItem item : cart) {
            Map<String, Object> itemData = new HashMap<>();
            itemData.put("name", item.getName());
            itemData.put("flavor", item.getFlavor());
            itemData.put("tier", item.getTier());
            itemData.put("size", item.getSize());
            itemData.put("quantity", item.getQuantity());
            itemData.put("price", item.getTotalPrice());
            itemsList.add(itemData);
        }
        orderEntry.put("items", itemsList);
        allOrders.add(orderEntry);

        // 4. Save back to file
        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(allOrders, writer);
            writer.flush(); // Added flush for safety
        }

        // 5. Success! Clear cart and go to a thank you page
        response.sendRedirect("checkout.jsp?status=success");
    }
}