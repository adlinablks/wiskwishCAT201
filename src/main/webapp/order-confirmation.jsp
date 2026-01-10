<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    //get cart from session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    //get customer info from request attribute
    String firstName = (String) request.getAttribute("firstName");
    String lastName = (String) request.getAttribute("lastName");
    String phone = (String) request.getAttribute("phone");
    String address = (String) request.getAttribute("address");
    String city = (String) request.getAttribute("city");
    String postalCode = (String) request.getAttribute("postalCode");

    //get order total from request attribute
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double tax = (Double) request.getAttribute("tax");
    Double delivery = (Double) request.getAttribute("delivery");
    Double total = (Double) request.getAttribute("total");

    //get order details from request attributes
    String orderNumber = (String) request.getAttribute("orderNumber");
    String orderDate = (String) request.getAttribute("orderDate");
    String estimatedDelivery = (String) request.getAttribute("estimatedDelivery");
    String paymentMethod = (String) request.getAttribute("paymentMethod");

    //provide default values if null
    if (subtotal == null) subtotal = 0.0;
    if (tax == null) tax = 0.0;
    if (delivery == null) delivery = 0.0;
    if (total == null) total = 0.0;

    //clear cart after showing confirmation
    session.removeAttribute("cart");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - Wisk Wish</title>
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
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header-title {
            font-size: 25px;
            font-weight: bold;
            color: lightblue;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 40px;
        }

        .success-banner {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 32px;
            color: #333;
            margin-bottom: 12px;
        }

        .status-badge {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .order-number {
            font-size: 18px;
            color: #666;
            margin-bottom: 8px;
        }

        .order-number strong {
            color: lightblue;
            font-size: 20px;
        }

        .order-date {
            font-size: 14px;
            color: #999;
            margin-bottom: 20px;
        }

        .info-section {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .section-title {
            font-size: 22px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-item {
            margin-bottom: 15px;
        }

        .info-label {
            font-size: 13px;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-details {
            flex: 2;
        }

        .item-name {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .item-quantity {
            font-size: 14px;
            color: #666;
        }

        .item-price {
            font-size: 16px;
            font-weight: bold;
            color: lightblue;
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

        .total-row {
            display: flex;
            justify-content: space-between;
            font-size: 22px;
            font-weight: bold;
            color: lightblue;
            padding-top: 15px;
            border-top: 2px solid lightblue;
            margin-top: 15px;
        }

        .payment-info {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .payment-method {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .payment-label {
            font-size: 15px;
            color: #666;
        }

        .payment-value {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        .delivery-timeline {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            text-align: center;
        }

        .timeline-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }

        .timeline-date {
            font-size: 20px;
            font-weight: bold;
            color: #1976d2;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background-color: lightblue;
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
        }

        .full-width {
            grid-column: 1 / -1;
        }

        @media (max-width: 767px) {
            .container {
                padding: 0 20px;
            }

            .success-banner {
                padding: 25px;
            }

            h1 {
                font-size: 24px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
<!-- header -->
<div class="header">
    <div class="header-title">Wisk Wish</div>
</div>

<div class="container">
    <!-- success banner -->
    <div class="success-banner">
        <h1>Order Successfully Placed!</h1>
        <div class="status-badge">Payment Confirmed</div>
        <div class="order-number">
            Order Number: <strong><%= orderNumber %></strong>
        </div>
        <div class="order-date"><%= orderDate %></div>
    </div>

    <!-- order items -->
    <div class="info-section">
        <div class="section-title">Order Items</div>

        <!-- display each cart items -->
        <% if (cart != null && !cart.isEmpty()) {
            for (CartItem item : cart) { %>
        <div class="order-item">
            <div class="item-details">
                <div class="item-name"><%= item.getName() %></div>
                <div class="item-quantity">Quantity: <%= item.getQuantity() %> × RM <%= String.format("%.2f", item.getPrice()) %></div>
            </div>
            <div class="item-price">RM <%= String.format("%.2f", item.getTotalPrice()) %></div>
        </div>
        <%  }
        } %>

        <hr class="summary-divider">

        <!-- order total breakdown -->
        <div class="summary-row">
            <span class="summary-label">Subtotal</span>
            <span class="summary-value">RM <%= String.format("%.2f", subtotal) %></span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Delivery Fee</span>
            <span class="summary-value">RM <%= String.format("%.2f", delivery) %></span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Tax (6%)</span>
            <span class="summary-value">RM <%= String.format("%.2f", tax) %></span>
        </div>

        <!-- grand total -->
        <div class="total-row">
            <span>Total Paid</span>
            <span>RM <%= String.format("%.2f", total) %></span>
        </div>

        <!-- payment method info -->
        <div class="payment-info">
            <div class="payment-method">
                <span class="payment-label">Payment Method:</span>
                <span class="payment-value"><%= paymentMethod %></span>
            </div>
        </div>
    </div>

    <!-- delivery info -->
    <div class="info-section">
        <div class="section-title">Delivery Information</div>

        <div class="info-grid">
            <!-- customer name -->
            <div class="info-item">
                <div class="info-label">Recipient Name</div>
                <div class="info-value"><%= firstName %> <%= lastName %></div>
            </div>

            <!-- contact number -->
            <div class="info-item">
                <div class="info-label">Phone Number</div>
                <div class="info-value"><%= phone %></div>
            </div>

            <!-- full delivery address -->
            <div class="info-item full-width">
                <div class="info-label">Delivery Address</div>
                <div class="info-value">
                    <%= address %><br>
                    <%= city %>, <%= postalCode %>
                </div>
            </div>
        </div>

        <!-- estimated delivery date display -->
        <div class="delivery-timeline">
            <div class="timeline-label">Estimated Delivery Date</div>
            <div class="timeline-date"><%= estimatedDelivery %></div>
        </div>
    </div>

    <!-- action buttons -->
    <div class="action-buttons">
        <a href="homepage.jsp" class="btn btn-primary">Go Back to Homepage</a>
    </div>
</div>

</body>
</html>