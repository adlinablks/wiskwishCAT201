<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String address = (String) session.getAttribute("customerAddress");
    String city = (String) session.getAttribute("customerCity");
    String phone = (String) session.getAttribute("customerPhone");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order - Wisk Wish</title>
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
            cursor: pointer;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 40px;
        }

        h1 {
            font-size: 32px;
            color: white;
            font-weight: bold;
            margin-bottom: 30px;
            text-align: center;
        }

        .tracking-card {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .order-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
        }

        .order-number-display {
            font-size: 18px;
            color: #666;
            margin-bottom: 10px;
        }

        .order-number-display strong {
            color: lightblue;
            font-size: 22px;
        }

        .order-status {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 10px 25px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: bold;
            margin-top: 15px;
        }

        .tracking-timeline {
            position: relative;
            padding: 20px 0;
        }

        .timeline-item {
            position: relative;
            padding: 25px 0 25px 60px;
            min-height: 80px;
        }

        .timeline-icon {
            position: absolute;
            left: 0;
            top: 25px;
            width: 40px;
            height: 40px;
            background-color: lightblue;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            z-index: 2;
        }

        .timeline-icon.completed {
            background-color: #4CAF50;
        }

        .timeline-icon.pending {
            background-color: #e0e0e0;
            color: #999;
        }

        .timeline-line {
            position: absolute;
            left: 19px;
            top: 65px;
            bottom: -25px;
            width: 2px;
            background-color: #e0e0e0;
        }

        .timeline-item:last-child .timeline-line {
            display: none;
        }

        .timeline-content {
            padding-left: 10px;
        }

        .timeline-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .timeline-date {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }

        .timeline-description {
            font-size: 14px;
            color: #999;
        }

        .delivery-info {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-top: 30px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .info-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .info-label {
            font-size: 14px;
            color: #666;
        }

        .info-value {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            text-align: right;
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

        .support-section {
            text-align: center;
            padding: 25px;
            background-color: #fff3cd;
            border-radius: 10px;
            margin-top: 20px;
        }

        .support-title {
            font-size: 16px;
            font-weight: bold;
            color: #856404;
            margin-bottom: 10px;
        }

        .support-text {
            font-size: 14px;
            color: #856404;
            margin-bottom: 15px;
        }

        .contact-link {
            display: inline-block;
            background-color: #ffc107;
            color: white;
            padding: 10px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        .contact-link:hover {
            background-color: #e0a800;
        }

        @media (max-width: 767px) {
            .container {
                padding: 0 20px;
            }

            .tracking-card {
                padding: 25px;
            }

            h1 {
                font-size: 24px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .timeline-item {
                padding-left: 50px;
            }

            .timeline-icon {
                width: 35px;
                height: 35px;
                font-size: 18px;
            }

            .timeline-line {
                left: 16px;
            }
        }
    </style>
</head>

<body>
<div class="header">
    <div class="header-title" onclick="location.href='home.jsp'">Wisk Wish</div>
</div>

<div class="container">
    <h1>Track Your Order</h1>

    <div class="tracking-card">
        <div class="order-header">
            <div class="order-number-display">
                Order Number: <strong id="orderNumber">Loading...</strong>
            </div>
            <div class="order-status">In Progress</div>
        </div>

        <div class="tracking-timeline">
            <div class="timeline-item">
                <div class="timeline-icon completed">✓</div>
                <div class="timeline-line"></div>
                <div class="timeline-content">
                    <div class="timeline-title">Order Placed</div>
                    <div class="timeline-date" id="orderDate">December 25, 2025 at 02:30 PM</div>
                    <div class="timeline-description">Your order has been received and confirmed</div>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon completed">✓</div>
                <div class="timeline-line"></div>
                <div class="timeline-content">
                    <div class="timeline-title">Payment Confirmed</div>
                    <div class="timeline-date" id="paymentDate">December 25, 2025 at 02:31 PM</div>
                    <div class="timeline-description">Payment has been successfully processed</div>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon">🎂</div>
                <div class="timeline-line"></div>
                <div class="timeline-content">
                    <div class="timeline-title">Preparing Your Order</div>
                    <div class="timeline-date">In Progress</div>
                    <div class="timeline-description">Our bakers are crafting your custom cake with care</div>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon pending">📦</div>
                <div class="timeline-line"></div>
                <div class="timeline-content">
                    <div class="timeline-title">Out for Delivery</div>
                    <div class="timeline-date">Pending</div>
                    <div class="timeline-description">Your order will be dispatched soon</div>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon pending">✓</div>
                <div class="timeline-content">
                    <div class="timeline-title">Delivered</div>
                    <div class="timeline-date">Pending</div>
                    <div class="timeline-description">Order will be delivered to your address</div>
                </div>
            </div>
        </div>

        <div class="delivery-info">
            <div class="info-row">
                <span class="info-label">Estimated Delivery</span>
                <span class="info-value" id="estimatedDelivery">December 30, 2025</span>
            </div>

            <div class="info-row">
                <span class="info-label">Delivery Address</span>
                <span class="info-value">
            <%= (address != null && city != null)
                    ? address + ", " + city
                    : "Address not available" %>
        </span>
            </div>

            <div class="info-row">
                <span class="info-label">Contact Number</span>
                <span class="info-value">
            <%= (phone != null) ? phone : "Contact not available" %>
        </span>
            </div>
        </div>


        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/homepage.jsp"  class="btn btn-primary">Continue Shopping</a>
            <a href="order-confirmation.jsp" class="btn btn-secondary">View Order Details</a>
        </div>
    </div>

    <div class="support-section">
        <div class="support-title">Need Help with Your Order?</div>
        <div class="support-text">Our customer support team is here to assist you</div>
        <a href="https://wa.me/+60126103271" class="contact-link" target="_blank">Contact Support</a>
    </div>
</div>

<script>
    // Get order number from URL or session storage
    const urlParams = new URLSearchParams(window.location.search);
    let orderNumber = urlParams.get('orderNumber');

    if (!orderNumber) {
        orderNumber = sessionStorage.getItem('lastOrderNumber');
    }

    if (orderNumber) {
        document.getElementById('orderNumber').textContent = orderNumber;
    } else {
        document.getElementById('orderNumber').textContent = 'N/A';
    }

    // Get current date for order date
    const now = new Date();
    const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    const currentDate = now.toLocaleDateString('en-US', options);
    document.getElementById('orderDate').textContent = currentDate;

    const paymentTime = new Date(now.getTime() + 60000); // 1 minute later
    document.getElementById('paymentDate').textContent = paymentTime.toLocaleDateString('en-US', options);

    // Calculate estimated delivery (5 days from now)
    const deliveryDate = new Date(now.getTime() + (5 * 24 * 60 * 60 * 1000));
    const deliveryOptions = { year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('estimatedDelivery').textContent = deliveryDate.toLocaleDateString('en-US', deliveryOptions);

    // Try to get customer info from session storage
    const customerAddress = sessionStorage.getItem('customerAddress');
    const customerCity = sessionStorage.getItem('customerCity');
    const customerPhone = sessionStorage.getItem('customerPhone');

    if (customerAddress && customerCity) {
        document.getElementById('deliveryAddress').textContent = customerAddress + ', ' + customerCity;
    } else {
        document.getElementById('deliveryAddress').textContent = 'Address on file';
    }

    if (customerPhone) {
        document.getElementById('contactNumber').textContent = customerPhone;
    } else {
        document.getElementById('contactNumber').textContent = 'Phone on file';
    }
</script>

</body>
</html>