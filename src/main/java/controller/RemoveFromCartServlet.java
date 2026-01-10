
package cat201project.controller;

import cat201project.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Iterator;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the ID of the item to be removed
        String itemIdToRemove = request.getParameter("itemId");

        // 2. Access the current session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && itemIdToRemove != null) {
            // 3. Use an Iterator to safely remove the item by its ID
            Iterator<CartItem> iterator = cart.iterator();
            while (iterator.hasNext()) {
                CartItem item = iterator.next();

                // Compare the ID (Ensure your CartItem class has a getId() method)
                if (item.getId().equals(itemIdToRemove)) {
                    iterator.remove();
                    break; // Exit loop once the item is found and removed
                }
            }

            // 4. Update the session attribute
            session.setAttribute("cart", cart);
        }

        // 5. Redirect the user back to the cart page to see the updated list
        response.sendRedirect("cart-page.jsp");
    }
}