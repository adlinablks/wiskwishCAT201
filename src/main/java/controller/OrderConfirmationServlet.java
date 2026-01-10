package controller;

import cat201project.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

//prepares and diplays order confirmation details
@WebServlet("/OrderConfirmationServlet")
public class OrderConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        //get customer info from session
        String firstName = (String) session.getAttribute("firstName");
        String lastName = (String) session.getAttribute("lastName");
        String email = (String) session.getAttribute("email");
        String phone = (String) session.getAttribute("phone");
        String address = (String) session.getAttribute("address");
        String city = (String) session.getAttribute("city");
        String postalCode = (String) session.getAttribute("postalCode");

        //get cart from session
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        //get totals from session - already calculated in CheckoutServlet
        Double subtotal = (Double) session.getAttribute("subtotal");
        Double tax = (Double) session.getAttribute("tax");
        Double delivery = (Double) session.getAttribute("delivery");
        Double total = (Double) session.getAttribute("total");

        //if totals are null, calculate them
        if (subtotal == null) {
            subtotal = 0.0;
            if (cart != null) {
                for (CartItem item : cart) {
                    subtotal += item.getTotalPrice();
                }
            }
            tax = subtotal * 0.06;
            delivery = 15.0;
            total = subtotal + tax + delivery;
        }

        //generate order number
        String orderNumber = "WW" + System.currentTimeMillis();

        //get current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
        String orderDate = dateFormat.format(new Date());

        //estimated delivery - 5 business days
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 5);
        String estimatedDelivery = new SimpleDateFormat("MMMM dd, yyyy").format(cal.getTime());

        //get payment info from session
        String paymentMethod = (String) session.getAttribute("paymentMethod");
        if (paymentMethod == null) {
            paymentMethod = "Payment Completed";
        }

        //set attributes for confirmation page JSP
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("city", city);
        request.setAttribute("postalCode", postalCode);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("delivery", delivery);
        request.setAttribute("total", total);
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("estimatedDelivery", estimatedDelivery);
        request.setAttribute("paymentMethod", paymentMethod);

        //forward to order confirmation page
        request.getRequestDispatcher("order-confirmation.jsp").forward(request, response);
    }

    //handle post request same as GET
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}