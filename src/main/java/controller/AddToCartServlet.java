package controller;

import cat201project.model.CartItem;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String flavor = request.getParameter("flavor");
        String tier = request.getParameter("tier");
        String size = request.getParameter("size");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));
        String image = request.getParameter("image");

        // Add item with tier and size
        cart.add(new CartItem(id, name, flavor, tier, size, quantity, price, image));

        session.setAttribute("cart", cart);

        response.sendRedirect("cart-page.jsp");
    }
}
