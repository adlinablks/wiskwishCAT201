<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    // Get customer info from checkout
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String postalCode = request.getParameter("postalCode");

    // Store in session for order confirmation
    session.setAttribute("customerFirstName", firstName);
    session.setAttribute("customerLastName", lastName);
    session.setAttribute("customerEmail", email);
    session.setAttribute("customerPhone", phone);
    session.setAttribute("customerAddress", address);
    session.setAttribute("customerCity", city);
    session.setAttribute("customerPostalCode", postalCode);

    // Get order totals
    String subtotalStr = request.getParameter("subtotal");
    String taxStr = request.getParameter("tax");
    String deliveryStr = request.getParameter("delivery");
    String totalStr = request.getParameter("total");

    double subtotal = Double.parseDouble(subtotalStr);
    double tax = Double.parseDouble(taxStr);
    double delivery = Double.parseDouble(deliveryStr);
    double total = Double.parseDouble(totalStr);

    // Get cart
    List<cat201project.model.CartItem> cart =
            (List<cat201project.model.CartItem>) session.getAttribute("cart");

    // Example payment method (you already have this from form / selection)
    String paymentMethod = request.getParameter("paymentMethod");

    // Generate simple transaction number
    String transactionNo = "TXN" + System.currentTimeMillis();

    // Save to session
    session.setAttribute("paymentMethod", paymentMethod);
    session.setAttribute("transactionNo", transactionNo);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Wisk Wish</title>
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
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 40px;
        }

        h1 {
            font-size: 30px;
            color: white;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .payment-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .payment-buttons button {
            flex: 1;
            min-width: 150px;
            background-color: white;
            color: lightblue;
            border: 2px solid lightblue;
            padding: 15px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: 0.3s;
        }

        .payment-buttons button:hover,
        .payment-buttons button.active {
            background-color: lightblue;
            color: white;
        }

        .payment-form {
            display: none;
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .payment-form.active {
            display: block;
        }

        h2 {
            font-size: 22px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            flex: 1;
            margin-bottom: 10px;
        }

        .form-group.full {
            flex: 100%;
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-size: 14px;
            color: #333;
            font-weight: bold;
            margin-bottom: 10px;
        }

        input, select {
            width: 100%;
            padding: 14px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: 0.3s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: lightblue;
        }

        input.error {
            border-color: #ff4444;
        }

        .error-message {
            color: #ff4444;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .submit-btn {
            width: 100%;
            background-color: lightblue;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: 0.3s;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .cart-summary {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .cart-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .item-details {
            flex: 2;
        }

        .item-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .item-quantity {
            font-size: 14px;
            color: #666;
        }

        .item-price {
            font-weight: bold;
            color: lightblue;
        }

        .summary-divider {
            border: none;
            border-top: 2px solid #f0f0f0;
            margin: 20px 0;
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

        .total-row {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: bold;
            color: lightblue;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid lightblue;
        }

        @media (max-width: 767px) {
            .header {
                padding: 15px 20px;
            }

            .container {
                padding: 0 20px;
            }

            .payment-buttons {
                flex-direction: column;
            }

            .payment-buttons button {
                min-width: 100%;
            }

            .form-row {
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
    <h1>Select Payment Method</h1>

    <div class="payment-buttons">
        <button id="debitBtn" onclick="showPaymentForm('debit')">Card Payment</button>
        <button id="transferBtn" onclick="showPaymentForm('transfer')">Online Transfer</button>
    </div>

    <!-- Debit Card Form -->
    <div id="debit-form" class="payment-form">
        <h2>Card Payment (Visa / MasterCard)</h2>
        <form id="debitForm" onsubmit="return validateDebitCard(event)">
            <!-- Card Number -->
            <div class="form-group full">
                <label for="cardNumber">Card Number *</label>
                <input type="text" id="cardNumber" maxlength="19" placeholder="1234 5678 9012 3456">
                <span class="error-message" id="cardNumberError">
                Please enter a valid 16-digit card number
            </span>
            </div>

            <!-- Expiry + CVV -->
            <div class="form-row">
                <div class="form-group">
                    <label for="expiryDate">Expiration Date *</label>
                    <input type="text" id="expiryDate" maxlength="5" placeholder="MM/YY">
                    <span class="error-message" id="expiryError">Enter valid expiry (MM/YY)</span>
                </div>

                <div class="form-group">
                    <label for="cvv">CVV *</label>
                    <input type="text" id="cvv" maxlength="3" placeholder="123">
                    <span class="error-message" id="cvvError">Enter valid 3-digit CVV</span>
                </div>
            </div>

            <!-- Card Holder Name (moved below) -->
            <div class="form-group full">
                <label for="cardHolder">Card Holder Name *</label>
                <input type="text" id="cardHolder">
                <span class="error-message" id="cardHolderError">
                Please enter the card holder name
            </span>
            </div>

            <button type="submit" class="submit-btn">Proceed to Payment</button>
        </form>
    </div>


    <!-- Bank Transfer Form -->
    <div id="bank-form" class="payment-form">
        <h2>Select Bank for Online Transfer</h2>
        <form id="bankForm" onsubmit="return validateBankTransfer(event)">
            <div class="form-group full">
                <label for="bank">Choose a Bank *</label>
                <select id="bank">
                    <option value="">--Select a Bank--</option>
                    <option value="Maybank">Maybank</option>
                    <option value="CIMB Bank">CIMB Bank</option>
                    <option value="Public Bank">Public Bank</option>
                    <option value="RHB Bank">RHB Bank</option>
                    <option value="Hong Leong Bank">Hong Leong Bank</option>
                    <option value="AmBank">AmBank</option>
                </select>
                <span class="error-message" id="bankError">Please select a bank</span>
            </div>

            <button type="submit" class="submit-btn">Proceed to Payment Approval</button>
        </form>
    </div>

    <div class="cart-summary">
        <h2>Order Summary</h2>

        <% if(cart != null && !cart.isEmpty()) {
            for(CartItem item : cart) { %>
        <div class="cart-item">
            <div class="item-details">
                <div class="item-name"><%= item.getName() %></div>
                <div class="item-quantity">Quantity: <%= item.getQuantity() %></div>
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
            <span class="summary-label">Delivery</span>
            <span class="summary-value">RM <%= String.format("%.2f", delivery) %></span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Tax (6%)</span>
            <span class="summary-value">RM <%= String.format("%.2f", tax) %></span>
        </div>

        <div class="total-row">
            <span>Total</span>
            <span>RM <%= String.format("%.2f", total) %></span>
        </div>
    </div>
</div>

<script>
    let selectedPaymentMethod = '';

    function showPaymentForm(method) {
        // Hide all forms
        document.querySelectorAll('.payment-form').forEach(form => {
            form.classList.remove('active');
        });

        // Remove active class from all buttons
        document.querySelectorAll('.payment-buttons button').forEach(btn => {
            btn.classList.remove('active');
        });

        // Show selected form and activate button
        if (method === 'debit') {
            document.getElementById('debit-form').classList.add('active');
            document.getElementById('debitBtn').classList.add('active');
            selectedPaymentMethod = 'Debit Card';
        } else if (method === 'transfer') {
            document.getElementById('bank-form').classList.add('active');
            document.getElementById('transferBtn').classList.add('active');
            selectedPaymentMethod = 'Online Transfer';
        }
    }

    // Format card number with spaces
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s/g, '');
        let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
        e.target.value = formattedValue;
    });

    // Format expiry date
    document.getElementById('expiryDate').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.slice(0, 2) + '/' + value.slice(2, 4);
        }
        e.target.value = value;
    });

    // Only allow numbers in CVV
    document.getElementById('cvv').addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });

    function validateDebitCard(event) {
        event.preventDefault();
        let isValid = true;

        // Reset errors
        document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input').forEach(el => el.classList.remove('error'));

        // Validate card number (16 digits)
        const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
        if (!/^\d{16}$/.test(cardNumber)) {
            showError('cardNumber', 'cardNumberError');
            isValid = false;
        }

        // Validate card holder
        const cardHolder = document.getElementById('cardHolder').value.trim();
        if (!cardHolder || cardHolder.length < 3) {
            showError('cardHolder', 'cardHolderError');
            isValid = false;
        }

        // Validate expiry date
        const expiry = document.getElementById('expiryDate').value;
        const expiryRegex = /^(0[1-9]|1[0-2])\/\d{2}$/;
        if (!expiryRegex.test(expiry)) {
            showError('expiryDate', 'expiryError');
            isValid = false;
        } else {
            // Check if card is expired
            const [month, year] = expiry.split('/');
            const expiryDate = new Date(2000 + parseInt(year), parseInt(month) - 1);
            const today = new Date();
            if (expiryDate < today) {
                showError('expiryDate', 'expiryError');
                document.getElementById('expiryError').textContent = 'Card has expired';
                isValid = false;
            }
        }

        // Validate CVV
        const cvv = document.getElementById('cvv').value;
        if (!/^\d{3}$/.test(cvv)) {
            showError('cvv', 'cvvError');
            isValid = false;
        }

        if (isValid) {
            // Store payment method
            sessionStorage.setItem('paymentMethod', 'Debit Card');
            sessionStorage.setItem('cardLast4', cardNumber.slice(-4));
            // Redirect to order confirmation
            window.location.href = 'order-confirmation.jsp';
        }

        return false;
    }

    function validateBankTransfer(event) {
        event.preventDefault();

        const bank = document.getElementById('bank').value;
        if (!bank) {
            showError('bank', 'bankError');
            return false;
        }

        // Store payment method and bank
        sessionStorage.setItem('paymentMethod', 'Online Transfer');
        sessionStorage.setItem('selectedBank', bank);

        // Redirect to bank approval page
        window.location.href = 'bank-approval.jsp';
        return false;
    }

    function showError(inputId, errorId) {
        document.getElementById(inputId).classList.add('error');
        document.getElementById(errorId).style.display = 'block';
    }
</script>

</body>
</html>