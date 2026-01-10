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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }


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


        String path = getServletContext().getRealPath("/WEB-INF/orders.json");
        File file = new File(path);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<Map<String, Object>> allOrders = new ArrayList<>();

        // read existing orders
        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                Type type = new TypeToken<List<Map<String, Object>>>(){}.getType();
                allOrders = gson.fromJson(reader, type);
                if (allOrders == null) allOrders = new ArrayList<>();
            }
        }

        // for new order
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


        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(allOrders, writer);
            writer.flush();
        }


        response.sendRedirect("checkout.jsp?status=success");
    }
}