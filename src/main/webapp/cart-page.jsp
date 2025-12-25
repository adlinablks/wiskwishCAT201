<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="cat201project.model.CartItem" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Wisk Wish</title>
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
            cursor: pointer;
        }

        .header-right {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-links {
            display: flex;
            gap: 25px;
        }

        .nav-link {
            color: lightblue;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
            cursor: pointer;
        }

        .nav-link:hover {
            color: #4fc3f7;
        }

        .login-button {
            background-color: lightblue;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
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

        .cart-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .cart-items-section {
            flex: 2;
            min-width: 300px;
        }

        .cart-item {
            background-color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            gap: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .item-image {
            width: 120px;
            height: 120px;
            background-color: #f5f5f5;
            border-radius: 10px;
            overflow: hidden;
        }

        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .item-details {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .item-name {
            font-size: 20px;
            color: lightblue;
            font-weight: bold;
        }

        .item-id {
            font-size: 12px;
            color: #999;
            font-weight: bold;
        }

        .item-options {
            font-size: 14px;
            color: #666;
        }

        .item-price {
            font-size: 18px;
            color: #333;
            font-weight: bold;
            margin-top: auto;
        }

        .item-actions {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: flex-end;
        }

        .remove-btn {
            background-color: transparent;
            border: none;
            color: #ff4444;
            cursor: pointer;
            font-size: 20px;
            padding: 5px;
            transition: 0.3s;
        }

        .remove-btn:hover {
            color: #cc0000;
            transform: scale(1.2);
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: auto;
        }

        .qty-btn {
            width: 30px;
            height: 30px;
            border: 2px solid lightblue;
            background-color: white;
            color: lightblue;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
        }

        .qty-btn:hover {
            background-color: lightblue;
            color: white;
        }

        .qty-display {
            font-size: 16px;
            font-weight: bold;
            min-width: 30px;
            text-align: center;
        }

        .cart-summary {
            flex: 1;
            min-width: 300px;
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
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

        .total-label {
            color: lightblue;
        }

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
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: 0.3s;
            margin-bottom: 15px;
        }

        .checkout-btn:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .continue-shopping {
            width: 100%;
            background-color: white;
            color: lightblue;
            border: 2px solid lightblue;
            padding: 15px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: 0.3s;
        }

        .continue-shopping:hover {
            background-color: aliceblue;
        }

        .empty-cart {
            background-color: white;
            border-radius: 15px;
            padding: 60px 40px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .empty-cart-icon {
            font-size: 80px;
            color: lightblue;
            margin-bottom: 20px;
        }

        .empty-cart-text {
            font-size: 20px;
            color: #666;
            margin-bottom: 30px;
        }

        .footer {
            background-color: white;
            padding: 40px 50px;
            margin-top: 80px;
            box-shadow: 0 -2px 15px rgba(0, 0, 0, 0.1);
        }

        .footer-content {
            max-width: 1300px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .footer-text {
            color: lightblue;
            font-weight: bold;
        }

        .footer-links {
            display: flex;
            gap: 20px;
        }

        .footer-link {
            color: lightblue;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        .footer-link:hover {
            color: #4fc3f7;
        }

        @media (max-width: 767px) {
            .header {
                padding: 15px 20px;
            }

            .header-title {
                font-size: 20px;
            }

            .nav-links {
                display: none;
            }

            .cart-item {
                flex-direction: column;
            }

            .item-actions {
                flex-direction: row;
                justify-content: space-between;
                width: 100%;
            }

            .cart-summary {
                position: static;
            }

            .page-title {
                font-size: 28px;
            }

            .footer-content {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="header-title">Wisk Wish</div>
    <div class="header-right">
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/homepage.jsp#home">Home</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/homepage.jsp#cakes">Our Cakes</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/homepage.jsp#about">About</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/homepage.jsp#contact">Contact</a>
        </div>
        <button class="login-button">Login</button>
    </div>
</div>

<div class="container">
    <h1 class="page-title">Shopping Cart</h1>

    <div class="cart-container" id="cartContainer">
        <div class="cart-items-section">
            <%
                List<cat201project.model.CartItem> cart =
                        (List<CartItem>) session.getAttribute("cart");

                double subtotal = 0;

                if (cart == null || cart.isEmpty()) {
            %>
            <div class="empty-cart">
                <div class="empty-cart-icon">🛒</div>
                <div class="empty-cart-text">Your cart is empty</div>
            </div>
            <%
            } else {
                for (cat201project.model.CartItem item : cart) {
                    subtotal += item.getTotalPrice();
            %>
            <div class="cart-item">
                <div class="item-image">
                    <img src="<%= item.getImage() %>">
                </div>

                <div class="item-details">
                    <div class="item-name"><%= item.getName() %></div>
                    <div class="item-id"><%= item.getId() %></div>
                    <div class="item-options">
                        Flavor: <%= item.getFlavor() %>, Tier: <%= item.getTier() %>, Size: <%= item.getSize() %> inch
                    </div>
                    <div class="item-price">
                        RM <%= String.format("%.2f", item.getTotalPrice()) %>
                    </div>
                </div>


                <div class="item-actions">
                    <div class="qty-display">Qty: <%= item.getQuantity() %></div>
                </div>
            </div>
            <%
                    }
                }
                double tax = subtotal * 0.06;
                double total = subtotal + tax + 15;
            %>
        </div>


        <div class="cart-summary">
            <div class="summary-title">Order Summary</div>

            <div class="summary-row">
                <span class="summary-label">Subtotal</span>
                <span class="summary-value">
    RM <%= String.format("%.2f", subtotal) %>
</span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Delivery Fee</span>
                <span class="summary-value" id="delivery">RM15.00</span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Tax (6%)</span>
                <span class="summary-value">
    RM <%= String.format("%.2f", tax) %>
</span>
            </div>

            <hr class="summary-divider">

            <div class="summary-total">
                <span class="total-label">Total</span>
                <span class="total-value">
    RM <%= String.format("%.2f", total) %>
</span>
            </div>

            <form action="checkout.jsp" method="get">
                <button type="submit" class="checkout-btn">PROCEED TO CHECKOUT</button>
            </form>

            <form action="homepage.jsp" method="get">
                <button type="submit" class="continue-shopping">CONTINUE SHOPPING</button>
            </form>
        </div>
    </div>
</div>

<div class="footer">
    <div class="footer-content">
        <div class="footer-text">© 2024 Wisk Wish. All rights reserved.</div>
        <div class="footer-links">
            <a href="https://wa.me/601136007067" class="footer-link" target="_blank">Contact Us</a>
        </div>
    </div>
</div>


</body>
</html>