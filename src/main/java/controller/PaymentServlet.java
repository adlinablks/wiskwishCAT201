package controller;

import cat201project.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

//process payment info and generated order confirmaion
@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        //get payment information from form
        String paymentType = request.getParameter("paymentType");
        String paymentMethod = "";

        //process card payment
        if ("card".equals(paymentType)) {
            String cardHolder = request.getParameter("cardHolder");
            String cardNumber = request.getParameter("cardNumber");

            //mask card number - show only last 4 digits
            String maskedCard = "";
            if (cardNumber != null && !cardNumber.isEmpty()) {
                //remove spaces from card number
                String cleanCard = cardNumber.replace(" ", "");
                if (cleanCard.length() >= 4) {
                    //extract last 4 digits
                    String lastFour = cleanCard.substring(cleanCard.length() - 4);
                    maskedCard = " (****" + lastFour + ")";
                }
            }

            paymentMethod = "Card Payment - " + cardHolder + maskedCard;

        //process online bank transfer
        } else if ("transfer".equals(paymentType)) {
            String bank = request.getParameter("bank");
            paymentMethod = "Online Transfer - " + bank;
        }

        //generate order number
        String orderNumber = "ORD" + System.currentTimeMillis();

        //format current date and time
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy - hh:mm a");
        String orderDate = LocalDateTime.now().format(dateFormatter);

        //calculate estimated delivery date - 5 days after
        DateTimeFormatter deliveryFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
        String estimatedDelivery = LocalDate.now().plusDays(5).format(deliveryFormatter);

        //get customer information from session
        String firstName = (String) session.getAttribute("firstName");
        String lastName = (String) session.getAttribute("lastName");
        String phone = (String) session.getAttribute("phone");
        String address = (String) session.getAttribute("address");
        String city = (String) session.getAttribute("city");
        String postalCode = (String) session.getAttribute("postalCode");

        //get order totals from session
        Double subtotal = (Double) session.getAttribute("subtotal");
        Double tax = (Double) session.getAttribute("tax");
        Double delivery = (Double) session.getAttribute("delivery");
        Double total = (Double) session.getAttribute("total");

        //set attributes for confirmation page
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("estimatedDelivery", estimatedDelivery);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("city", city);
        request.setAttribute("postalCode", postalCode);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("delivery", delivery);
        request.setAttribute("total", total);

        //forward to confirmation page
        request.getRequestDispatcher("order-confirmation.jsp").forward(request, response);
    }
}