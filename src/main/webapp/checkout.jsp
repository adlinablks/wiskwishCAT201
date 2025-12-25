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

        .form-input.error {
            border-color: #ff4444;
        }

        .error-message {
            color: #ff4444;
            font-size: 12px;
            margin-top: 5px;
            display: none;
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

        .checkout-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
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

        <form id="checkoutForm" class="checkout-form" action="payment.jsp" method="post">

            <div class="form-section">
                <div class="section-title">Customer Information</div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">First Name *</label>
                        <input class="form-input" type="text" name="firstName" id="firstName" required>
                        <span class="error-message" id="firstNameError">Please enter your first name</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name *</label>
                        <input class="form-input" type="text" name="lastName" id="lastName" required>
                        <span class="error-message" id="lastNameError">Please enter your last name</span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Email *</label>
                        <input class="form-input" type="email" name="email" id="email" required>
                        <span class="error-message" id="emailError">Please enter a valid email</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone *</label>
                        <input class="form-input" type="tel" name="phone" id="phone" required>
                        <span class="error-message" id="phoneError">Please enter a valid phone number</span>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="section-title">Delivery Address</div>
                <div class="form-row">
                    <div class="form-group full">
                        <label class="form-label">Address *</label>
                        <input class="form-input" type="text" name="address" id="address" required>
                        <span class="error-message" id="addressError">Please enter your address</span>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">City *</label>
                        <input class="form-input" type="text" name="city" id="city" required>
                        <span class="error-message" id="cityError">Please enter your city</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Postal Code *</label>
                        <input class="form-input" type="text" name="postalCode" id="postalCode" required>
                        <span class="error-message" id="postalCodeError">Please enter your postal code</span>
                    </div>
                </div>
            </div>

            <!-- Hidden fields to pass cart data -->
            <input type="hidden" name="subtotal" value="<%= subtotal %>">
            <input type="hidden" name="tax" value="<%= tax %>">
            <input type="hidden" name="delivery" value="<%= delivery %>">
            <input type="hidden" name="total" value="<%= total %>">

        </form>

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

            <button type="button" class="checkout-btn" onclick="proceedToPayment()">Proceed to Payment</button>
            <form action="cart-page.jsp" method="get">
                <button type="submit" class="back-btn">Back to Cart</button>
            </form>
        </div>

    </div>
</div>

<script>
    function validateForm() {
        let isValid = true;

        // Reset all error messages
        document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
        document.querySelectorAll('.form-input').forEach(el => el.classList.remove('error'));

        // First Name validation
        const firstName = document.getElementById('firstName');
        if (!firstName.value.trim()) {
            showError('firstName', 'firstNameError');
            isValid = false;
        }

        // Last Name validation
        const lastName = document.getElementById('lastName');
        if (!lastName.value.trim()) {
            showError('lastName', 'lastNameError');
            isValid = false;
        }

        // Email validation
        const email = document.getElementById('email');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim() || !emailRegex.test(email.value)) {
            showError('email', 'emailError');
            isValid = false;
        }

        // Phone validation
        const phone = document.getElementById('phone');
        const phoneRegex = /^[0-9]{10,15}$/;
        if (!phone.value.trim() || !phoneRegex.test(phone.value.replace(/[\s-]/g, ''))) {
            showError('phone', 'phoneError');
            isValid = false;
        }

        // Address validation
        const address = document.getElementById('address');
        if (!address.value.trim()) {
            showError('address', 'addressError');
            isValid = false;
        }

        // City validation
        const city = document.getElementById('city');
        if (!city.value.trim()) {
            showError('city', 'cityError');
            isValid = false;
        }

        // Postal Code validation
        const postalCode = document.getElementById('postalCode');
        if (!postalCode.value.trim()) {
            showError('postalCode', 'postalCodeError');
            isValid = false;
        }

        return isValid;
    }

    function showError(inputId, errorId) {
        document.getElementById(inputId).classList.add('error');
        document.getElementById(errorId).style.display = 'block';
    }

    function proceedToPayment() {
        if (validateForm()) {
            document.getElementById('checkoutForm').submit();
        } else {
            alert('Please fill in all required fields correctly.');
        }
    }
</script>

</body>
</html>