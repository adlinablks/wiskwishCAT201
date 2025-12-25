<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    // Get cart and totals from session
    List<cat201project.model.CartItem> cart =
            (List<cat201project.model.CartItem>) session.getAttribute("cart");

    double subtotal = 0;
    if(cart != null) {
        for(CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }
    }

    double tax = subtotal * 0.06;
    double delivery = 15;
    double total = subtotal + tax + delivery;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Payment Approval - Wisk Wish</title>
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
            max-width: 600px;
            margin: 60px auto;
            padding: 0 40px;
        }

        .approval-card {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
        }

        .bank-logo {
            width: 80px;
            height: 80px;
            background-color: lightblue;
            border-radius: 50%;
            margin: 0 auto 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            color: white;
            font-weight: bold;
        }

        h1 {
            font-size: 26px;
            color: #333;
            margin-bottom: 15px;
        }

        .bank-name {
            font-size: 20px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .transaction-details {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin: 25px 0;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .detail-label {
            color: #666;
            font-size: 15px;
        }

        .detail-value {
            font-weight: bold;
            color: #333;
            font-size: 15px;
        }

        .amount-highlight {
            font-size: 28px;
            color: lightblue;
            font-weight: bold;
            margin: 25px 0;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .approve-btn {
            flex: 1;
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .approve-btn:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }

        .cancel-btn {
            flex: 1;
            background-color: white;
            color: #ff4444;
            border: 2px solid #ff4444;
            padding: 15px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .cancel-btn:hover {
            background-color: #fff5f5;
        }

        .security-notice {
            margin-top: 25px;
            padding: 15px;
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            border-radius: 5px;
            text-align: left;
            font-size: 13px;
            color: #856404;
        }

        .loading {
            display: none;
            margin-top: 20px;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid lightblue;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 767px) {
            .container {
                padding: 0 20px;
            }

            .approval-card {
                padding: 25px;
            }

            .button-group {
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
    <div class="approval-card">
        <div class="bank-logo" id="bankLogo">🏦</div>
        <h1>Approve Transaction</h1>
        <div class="bank-name" id="bankName"></div>

        <div class="transaction-details">
            <div class="detail-row">
                <span class="detail-label">Merchant</span>
                <span class="detail-value">Wisk Wish</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Transaction Type</span>
                <span class="detail-value">Online Purchase</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Transaction ID</span>
                <span class="detail-value" id="transactionId"></span>
            </div>
        </div>

        <div class="amount-highlight">
            RM <%= String.format("%.2f", total) %>
        </div>

        <div class="button-group" id="buttonGroup">
            <button class="approve-btn" onclick="approvePayment()">
                ✓ Approve Payment
            </button>
            <button class="cancel-btn" onclick="cancelPayment()">
                ✗ Cancel
            </button>
        </div>

        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Processing payment...</p>
        </div>

        <div class="security-notice">
            <strong>🔒 Secure Transaction</strong><br>
            Your payment is processed through a secure encrypted connection.
            Never share your banking credentials with anyone.
        </div>
    </div>
</div>

<script>
    // Generate random transaction ID
    function generateTransactionId() {
        return 'TXN' + Date.now() + Math.floor(Math.random() * 1000);
    }

    // Display transaction ID
    document.getElementById('transactionId').textContent = generateTransactionId();

    // Display selected bank
    const selectedBank = sessionStorage.getItem('selectedBank');
    if (selectedBank) {
        document.getElementById('bankName').textContent = selectedBank;
    }

    function approvePayment() {
        // Hide buttons and show loading
        document.getElementById('buttonGroup').style.display = 'none';
        document.getElementById('loading').style.display = 'block';

        // Simulate payment processing
        setTimeout(function() {
            // Store transaction approval
            sessionStorage.setItem('paymentApproved', 'true');
            sessionStorage.setItem('transactionId', document.getElementById('transactionId').textContent);

            // Redirect to order confirmation
            window.location.href = 'order-confirmation.jsp';
        }, 2000);
    }

    function cancelPayment() {
        if (confirm('Are you sure you want to cancel this payment?')) {
            alert('Payment cancelled. Redirecting back to payment page...');
            window.location.href = 'payment.jsp';
        }
    }
</script>

</body>
</html>