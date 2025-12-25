<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    List<cat201project.model.CartItem> cart =
            (List<cat201project.model.CartItem>) session.getAttribute("cart");

    double subtotal = 0;
    if(cart != null) {
        for(CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }
    }

    double tax = subtotal * 0.06; // 6% tax
    double delivery = 15; // same delivery fee as cart page
    double total = subtotal + tax + delivery;
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Wisk Wish</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: lightblue;
            min-height: 100vh;
        }

        .header {
            background-color: white;
            padding: 20px 45px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-title {
            font-size: 25px;
            font-weight: bold;
            color: lightblue;
        }

        .container {
            max-width: 1300px;
            margin: 40px auto;
            padding: 0 40px;
        }

        .page-title {
            font-size: 35px;
            color: white;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .checkout-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .checkout-form {
            flex: 2;
            min-width: 300px;
        }

        .form-section {
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 22px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }

        .form-group {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .form-group.full {
            flex: 100%;
        }

        .form-label {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .form-input {
            padding: 12px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            font-size: 14px;
        }

        .form-input:focus {
            outline: none;
            border-color: lightblue;
        }

        .order-summary {
            flex: 1;
            min-width: 300px;
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 120px;
        }

        .summary-title {
            font-size: 22px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 20px;
        }

        #order-items {
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 16px;
        }

        .summary-label {
            color: #666;
        }

        .summary-value {
            font-weight: bold;
            color: #333;
        }

        .summary-divider {
            border: none;
            border-top: 2px solid #f0f0f0;
            margin: 20px 0;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 25px;
        }

        .total-label,
        .total-value {
            color: lightblue;
        }

        .checkout-btn {
            width: 100%;
            background-color: lightblue;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            margin-bottom: 10px;
        }

        .checkout-btn:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
        }

        .back-btn {
            width: 100%;
            background-color: white;
            color: lightblue;
            border: 2px solid lightblue;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .back-btn:hover {
            background-color: aliceblue;
        }

        @media (max-width: 767px) {
            .checkout-container {
                flex-direction: column;
            }

            .order-summary {
                position: static;
            }

            .form-row {
                flex-direction: column;
            }

            .page-title {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-title">Wisk Wish</div>
</div>

<div class="container">
    <h1 class="page-title">Checkout</h1>

    <div class="checkout-container">

        <div class="checkout-form">

            <div class="form-section">
                <div class="section-title">Customer Information</div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">First Name</label>
                        <input class="form-input" type="text">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name</label>
                        <input class="form-input" type="text">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input class="form-input" type="email">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone</label>
                        <input class="form-input" type="tel">
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="section-title">Delivery Address</div>
                <div class="form-row">
                    <div class="form-group full">
                        <label class="form-label">Address</label>
                        <input class="form-input" type="text">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">City</label>
                        <input class="form-input" type="text">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Postal Code</label>
                        <input class="form-input" type="text">
                    </div>
                </div>
            </div>

        </div>

        <div class="order-summary">
            <div class="summary-title">Order Summary</div>

            <div id="order-items">
                <% if(cart == null || cart.isEmpty()) { %>
                <div>Your cart is empty</div>
                <% } else {
                    for(CartItem item : cart) { %>
                <div class="summary-row">
                    <span class="summary-label"><%= item.getName() %> (x<%= item.getQuantity() %>)</span>
                    <span class="summary-value">RM <%= String.format("%.2f", item.getTotalPrice()) %></span>
                </div>
                <%  }
                } %>

            </div>


            <hr class="summary-divider">

            <div class="summary-row">
                <span class="summary-label">Subtotal</span>
                <span class="summary-value">RM <%= String.format("%.2f", subtotal) %></span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Delivery</span>
                <span class="summary-value">RM <%= String.format("%.2f", delivery) %></span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Tax (6%)</span>
                <span class="summary-value">RM <%= String.format("%.2f", tax) %></span>
            </div>

            <div class="summary-total">
                <span class="total-label">Total</span>
                <span class="total-value">RM <%= String.format("%.2f", total) %></span>
            </div>

            <button class="checkout-btn">Place Order</button>
            <form action="cart-page.jsp" method="get">
                <button type="submit" class="back-btn">Back to Cart</button>
            </form>
        </div>

    </div>
</div>

</body>
</html>
