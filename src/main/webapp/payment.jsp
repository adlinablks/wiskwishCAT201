<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cat201project.model.CartItem" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    Double subtotal = (Double) session.getAttribute("subtotal");
    Double tax = (Double) session.getAttribute("tax");
    Double delivery = (Double) session.getAttribute("delivery");
    Double total = (Double) session.getAttribute("total");
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

        .payment-tabs {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .tab-input {
            display: none;
        }

        .tab-label {
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
            text-align: center;
            transition: 0.3s;
            display: block;
        }

        .tab-label:hover {
            background-color: #e0f7ff;
        }

        .tab-input:checked + .tab-label {
            background-color: lightblue;
            color: white;
        }

        .payment-form {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
        }

        #tab-card:checked ~ .forms-container #card-form,
        #tab-transfer:checked ~ .forms-container #transfer-form {
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

        .form-group label {
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


        .error-text {
            color: #ff4444;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        input:invalid:not(:focus):not(:placeholder-shown) + .error-text {
            display: block;
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

        .cart-items {
            margin-bottom: 20px;
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

        @media (max-width: 767px) {
            .header {
                padding: 15px 20px;
            }

            .container {
                padding: 0 20px;
            }

            .payment-tabs {
                flex-direction: column;
            }

            .tab-label {
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

    <input type="radio" name="payment-tab" id="tab-card" class="tab-input" checked>
    <input type="radio" name="payment-tab" id="tab-transfer" class="tab-input">

    <div class="payment-tabs">
        <label for="tab-card" class="tab-label">Card Payment</label>
        <label for="tab-transfer" class="tab-label">Online Transfer</label>
    </div>

    <div class="forms-container">
        <!-- Card Payment Form -->
        <div id="card-form" class="payment-form">
            <h2>Card Payment (Visa / MasterCard)</h2>
            <form action="PaymentServlet" method="post">
                <div class="form-group full">
                    <label for="cardNumber">Card Number *</label>
                    <input
                            type="text"
                            id="cardNumber"
                            name="cardNumber"
                            pattern="[0-9]{4}\s[0-9]{4}\s[0-9]{4}\s[0-9]{4}"
                            maxlength="19"
                            placeholder="1234 5678 9012 3456"
                            title="Enter a valid 16-digit card number"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\d{4})(?=\d)/g, '$1 ').trim()"
                            required>
                    <span class="error-text">Please enter a valid 16-digit card number</span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="expiryDate">Expiration Date *</label>
                        <input
                                type="text"
                                id="expiryDate"
                                name="expiryDate"
                                pattern="(0[1-9]|1[0-2])\/[0-9]{2}"
                                maxlength="5"
                                placeholder="MM/YY"
                                title="Enter expiry date in MM/YY format"
                                oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/^(\d{2})(\d)/, '$1/$2').substr(0, 5)"
                                required>
                        <span class="error-text">Enter valid expiry (MM/YY)</span>
                    </div>

                    <div class="form-group">
                        <label for="cvv">CVV *</label>
                        <input
                                type="text"
                                id="cvv"
                                name="cvv"
                                pattern="[0-9]{3}"
                                maxlength="3"
                                placeholder="123"
                                title="Enter a valid 3-digit CVV"
                                oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                required>
                        <span class="error-text">Enter valid 3-digit CVV</span>
                    </div>
                </div>

                <div class="form-group full">
                    <label for="cardHolder">Card Holder Name *</label>
                    <input
                            type="text"
                            id="cardHolder"
                            name="cardHolder"
                            pattern="[A-Za-z\s]{2,}"
                            placeholder="
"
                            minlength="2"
                            title="Enter the full name on the card"
                            oninput="this.value = this.value.replace(/[^A-Za-z\s]/g, '')"
                            required>
                    <span class="error-text">Please enter the card holder name</span>
                </div>

                <input type="hidden" name="paymentType" value="card">
                <button type="submit" class="submit-btn">Proceed to Payment</button>
            </form>
        </div>

        <!-- Bank Transfer Form -->
        <div id="transfer-form" class="payment-form">
            <h2>Select Bank for Online Transfer</h2>
            <form action="PaymentServlet" method="post">
                <div class="form-group full">
                    <label for="bank">Choose a Bank *</label>
                    <select id="bank" name="bank" required>
                        <option value="">--Select a Bank--</option>
                        <option value="Maybank">Maybank</option>
                        <option value="CIMB Bank">CIMB Bank</option>
                        <option value="Public Bank">Public Bank</option>
                        <option value="RHB Bank">RHB Bank</option>
                        <option value="Hong Leong Bank">Hong Leong Bank</option>
                        <option value="AmBank">AmBank</option>
                    </select>
                    <span class="error-text">Please select a bank</span>
                </div>

                <input type="hidden" name="paymentType" value="transfer">
                <button type="submit" class="submit-btn">Proceed to Payment Approval</button>
            </form>
        </div>
    </div>

    <div class="cart-summary">
        <h2>Order Summary</h2>

        <div class="cart-items">
            <% if (cart == null || cart.isEmpty()) { %>
            <div>Your cart is empty</div>
            <% } else {
                for (CartItem item : cart) { %>
            <div class="cart-item">
                <div class="item-details">
                    <div class="item-name"><%= item.getName() %></div>
                    <div class="item-quantity">Quantity: <%= item.getQuantity() %></div>
                </div>
                <div class="item-price">RM <%= String.format("%.2f", item.getTotalPrice()) %></div>
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

        <div class="total-row">
            <span>Total</span>
            <span>RM <%= String.format("%.2f", total) %></span>
        </div>
    </div>
</div>

</body>
</html>