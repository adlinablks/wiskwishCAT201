package controller;

import cat201project.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.util.*;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get customer information from form
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String postalCode = request.getParameter("postalCode");

        // Get cart from session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // Calculate totals
        double subtotal = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                subtotal += item.getTotalPrice();
            }
        }

        double tax = subtotal * 0.06; // 6% tax
        double delivery = 15.0; // delivery fee
        double total = subtotal + tax + delivery;

        // Store checkout information in session for payment page
        session.setAttribute("firstName", firstName);
        session.setAttribute("lastName", lastName);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        session.setAttribute("address", address);
        session.setAttribute("city", city);
        session.setAttribute("postalCode", postalCode);
        session.setAttribute("subtotal", subtotal);
        session.setAttribute("tax", tax);
        session.setAttribute("delivery", delivery);
        session.setAttribute("total", total);

        // Redirect to payment page
        response.sendRedirect("payment.jsp");
    }
}