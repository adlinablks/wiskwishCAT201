<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="cat201project.model.CartItem" %>

<%
    // Get cart from session
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    double subtotal = 0;
    if (cart != null) {
        for (CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }
    }

    double tax = subtotal * 0.06;
    double delivery = 15;
    double total = subtotal + tax + delivery;

    // Generate simple transaction number
    String transactionNo = "TXN" + System.currentTimeMillis();
    session.setAttribute("transactionNo", transactionNo);
    session.setAttribute("paymentMethod", "Online Banking");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Bank Payment Approval</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background: lightblue;
        }

        .card {
            background: white;
            width: 450px;
            margin: 80px auto;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
        }

        .row {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
        }

        .amount {
            font-size: 26px;
            color: lightblue;
            font-weight: bold;
            margin: 20px 0;
        }

        .btn {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }

        .approve {
            background: #4CAF50;
            color: white;
        }

        .cancel {
            background: white;
            color: red;
            border: 2px solid red;
        }
    </style>
</head>

<body>

<div class="card">
    <h2>Approve Payment</h2>

    <div class="row">
        <span>Merchant</span>
        <span>Wisk Wish</span>
    </div>

    <div class="row">
        <span>Payment Method</span>
        <span>Online Banking</span>
    </div>

    <div class="row">
        <span>Transaction No</span>
        <span><%= transactionNo %></span>
    </div>

    <div class="amount">
        RM <%= String.format("%.2f", total) %>
    </div>

    <form action="order-confirmation.jsp" method="post">
        <button class="btn approve" type="submit">Approve Payment</button>
    </form>

    <form action="payment.jsp" method="get">
        <button class="btn cancel" type="submit">Cancel</button>
    </form>
</div>

</body>
</html>
