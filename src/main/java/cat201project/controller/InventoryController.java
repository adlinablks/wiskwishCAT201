package cat201project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/InventoryController")
public class InventoryController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cakeId = request.getParameter("cakeId");

        // Pass data to JSP
        request.setAttribute("cakeId", cakeId);

        // Forward to update page
        request.getRequestDispatcher("updateQuantity.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve the parameters sent by the JavaScript hidden form
        String cakeId = request.getParameter("cakeId");
        String tier = request.getParameter("tier");
        String flavour = request.getParameter("flavour");
        String size = request.getParameter("size");

        // 2. LOGIC: This is where you would update your database
        // For now, let's print it to the IntelliJ console to verify it works
        System.out.println("--- New Order Received ---");
        System.out.println("Cake ID: " + cakeId);
        System.out.println("Selected Tier: " + tier);
        System.out.println("Selected Flavour: " + flavour);
        System.out.println("Selected Size: " + size);

        // 3. (Optional) Set a success message to show on the JSP
        request.getSession().setAttribute("message", "Inventory updated for " + cakeId);

        // 4. Redirect back to the dashboard so the page refreshes
        response.sendRedirect("admin-dashboard.jsp");
    }
}

