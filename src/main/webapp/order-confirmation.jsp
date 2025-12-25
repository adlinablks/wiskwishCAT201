<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    // Get customer info from session
    String firstName = (String) session.getAttribute("customerFirstName");
    String lastName = (String) session.getAttribute("customerLastName");
    String email = (String) session.getAttribute("customerEmail");
    String phone = (String) session.getAttribute("customerPhone");
    String address = (String) session.getAttribute("customerAddress");
    String city = (String) session.getAttribute("customerCity");
    String postalCode = (String) session.getAttribute("customerPostalCode");

    // Get cart
    List<cat201project.model.CartItem> cart =
            (List<cat201project.model.CartItem>) session.getAttribute("cart");

    // Calculate totals
    double subtotal = 0;
    if(cart != null) {
        for(CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }
    }

    double tax = subtotal * 0.06;
    double delivery = 15;
    double total = subtotal + tax + delivery;

    // Generate order number
    String orderNumber = "WW" + System.currentTimeMillis();

    // Get current date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
    String orderDate = dateFormat.format(new Date());

    // Estimated delivery (3-5 business days)
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DAY_OF_MONTH, 5);
    String estimatedDelivery = new SimpleDateFormat("MMMM dd, yyyy").format(cal.getTime());
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

       <%-- .success-icon {
            width: 80px;
            height: 80px;
            background-color: #4CAF50;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 45px;
            color: white;
            animation: scaleIn 0.5s ease-out;
        } --%>


        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
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

        .confirmation-message {
            font-size: 16px;
            color: #666;
            line-height: 1.6;
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
            letter-spacing: 0.5px;
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

        .btn-secondary {
            background-color: white;
            color: lightblue;
            border: 2px solid lightblue;
        }

        .btn-secondary:hover {
            background-color: aliceblue;
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
<div class="header">
    <div class="header-title">Wisk Wish</div>
</div>

<div class="container">
    <!-- Success Banner -->
    <div class="success-banner">
        <%--<div class="success-icon">✓</div> --%>
        <h1>Order Successfully Placed!</h1>
        <div class="status-badge">Payment Confirmed</div>
        <div class="order-number">
            Order Number: <strong><%= orderNumber %></strong>
        </div>
        <div class="order-date"><%= orderDate %></div>
    </div>

    <!-- Order Items -->
    <div class="info-section">
        <div class="section-title">Order Items</div>

        <% if(cart != null && !cart.isEmpty()) {
            for(CartItem item : cart) { %>
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

        <div class="total-row">
            <span>Total Paid</span>
            <span>RM <%= String.format("%.2f", total) %></span>
        </div>

        <div class="payment-info">
            <div class="payment-method">
                <span class="payment-label">Payment Method:</span>
                <span class="payment-value" id="paymentMethod">Processing...</span>
            </div>
        </div>
    </div>

    <!-- Delivery Information -->
    <div class="info-section">
        <div class="section-title">Delivery Information</div>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Recipient Name</div>
                <div class="info-value"><%= firstName %> <%= lastName %></div>
            </div>

            <div class="info-item">
                <div class="info-label">Phone Number</div>
                <div class="info-value"><%= phone %></div>
            </div>

            <div class="info-item" style="grid-column: 1 / -1;">
                <div class="info-label">Delivery Address</div>
                <div class="info-value">
                    <%= address %><br>
                    <%= city %>, <%= postalCode %>
                </div>
            </div>
        </div>

        <div class="delivery-timeline">
            <div class="timeline-label">Estimated Delivery Date</div>
            <div class="timeline-date"><%= estimatedDelivery %></div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <a href="track-order.jsp?orderNumber=<%= orderNumber %>" class="btn btn-secondary">Track Order</a>
    </div>
</div>

<script>
    // Store order number in session storage for tracking
    sessionStorage.setItem('lastOrderNumber', '<%= orderNumber %>');

    // Display payment method from session storage
    const paymentMethod = sessionStorage.getItem('paymentMethod');
    const paymentMethodEl = document.getElementById('paymentMethod');

    if (paymentMethod === 'Debit Card') {
        const cardLast4 = sessionStorage.getItem('cardLast4');
        paymentMethodEl.textContent = 'Debit Card (****' + cardLast4 + ')';
    } else if (paymentMethod === 'Online Transfer') {
        const selectedBank = sessionStorage.getItem('selectedBank');
        paymentMethodEl.textContent = 'Online Transfer - ' + selectedBank;
    } else {
        paymentMethodEl.textContent = 'Payment Completed';
    }
</script>

</body>
</html>