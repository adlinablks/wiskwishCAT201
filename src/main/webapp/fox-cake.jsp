
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fox Cake - Wisk Wish</title>
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

        .product-container {
            max-width: 1300px;
            margin: 60px auto;
            padding: 0 40px;
            display: flex;
            gap: 60px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        .product-image-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .main-image {
            width: 100%;
            max-width: 500px;
            height: 500px;
            background-color: #f5f5f5;
            border-radius: 15px;
            overflow: hidden;
        }

        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-details-section {
            flex: 1;
        }

        .product-category {
            font-size: 14px;
            color: #999;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .product-title {
            font-size: 35px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .product-price {
            font-size: 30px;
            color: #333;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .option-group {
            margin-bottom: 25px;
        }

        .option-label {
            font-size: 16px;
            color: #333;
            font-weight: bold;
            margin-bottom: 10px;
            display: block;
        }

        .size-options, .flavor-options, .tier-options {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .size-option, .flavor-option, .tier-option {
            padding: 10px 20px;
            border: 2px solid lightblue;
            background-color: white;
            color: lightblue;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        .size-option:hover, .flavor-option:hover, .tier-option:hover {
            background-color: aliceblue;
        }

        .size-option.selected, .flavor-option.selected, .tier-option.selected {
            background-color: lightblue;
            color: white;
        }

        .product-description {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .stock-info {
            font-size: 14px;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 2px solid lightblue;
            background-color: white;
            color: lightblue;
            border-radius: 8px;
            cursor: pointer;
            font-size: 20px;
            font-weight: bold;
            transition: 0.3s;
        }

        .quantity-btn:hover {
            background-color: lightblue;
            color: white;
        }

        .quantity-input {
            width: 60px;
            height: 40px;
            text-align: center;
            border: 2px solid lightblue;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
        }

        .add-to-cart-btn {
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
        }

        .add-to-cart-btn:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
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

            .product-container {
                flex-direction: column;
                gap: 30px;
            }

            .product-title {
                font-size: 28px;
            }

            .product-price {
                font-size: 24px;
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
            <a class="nav-link" href="#home">Home</a>
            <a class="nav-link" href="#cakes">Our Cakes</a>
            <a class="nav-link" href="#about">About</a>
            <a class="nav-link" href="#contact">Contact</a>
        </div>
        <button class="login-button">Login</button>
    </div>
</div>

<div class="product-container">
    <div class="product-image-section">
        <div class="main-image">
            <img src="pictures/fox-cake.jpg" alt="Fox Cake">
        </div>
    </div>

    <div class="product-details-section">
        <div class="product-category">C04</div>
        <h1 class="product-title">Fox Cake</h1>
        <div class="product-price" id="price">RM99.99</div>

        <input type="hidden" id="basePriceInput" value="99.99">
        <div class="option-group">
            <label class="option-label">Tier:</label>
            <div class="tier-options">
                <button type="button" class="tier-option selected" onclick="selectTier(this, '1')">1 Tier</button>
                <button type="button" class="tier-option" onclick="selectTier(this, '2')">2 Tier</button>
            </div>
        </div>

        <div class="option-group">
            <label class="option-label">Size:</label>
            <div class="size-options">
                <button type="button" class="size-option selected" onclick="selectSize(this, '7')">7 inch </button>
                <button type="button" class="size-option" onclick="selectSize(this, '10')">10 inch</button>
            </div>
        </div>

        <div class="option-group">
            <label class="option-label">Flavor:</label>
            <div class="flavor-options">
                <button type="button" class="flavor-option selected" onclick="selectFlavor(this, 'Vanilla')">Vanilla</button>
                <button type="button" class="flavor-option" onclick="selectFlavor(this, 'Chocolate')">Chocolate</button>
            </div>
        </div>

        <p class="product-description">
            Cute woodland creature cake featuring an adorable fox design. Perfect for nature lovers and children's parties!
        </p>

        <div class="stock-info">Available Stock: 15</div>

        <div class="quantity-selector">
            <button type="button" class="quantity-btn" onclick="changeQty(-1)">-</button>
            <input type="number" class="quantity-input" id="quantity" value="1" min="1" max="15" readonly>
            <button type="button" class="quantity-btn" onclick="changeQty(1)">+</button>
        </div>

        <form action="addToCart" method="post" onsubmit="syncData()">

            <!-- Fixed product data -->
            <input type="hidden" name="id" value="C04">
            <input type="hidden" name="name" value="Fox Cake">
            <input type="hidden" name="image" value="pictures/fox-cake.jpg">

            <!-- Dynamic data (used by JS) -->
            <input type="hidden" name="tier" id="tierInput" value="1">
            <input type="hidden" name="size" id="sizeInput" value="7">
            <input type="hidden" name="flavor" id="flavorInput" value="Vanilla">
            <input type="hidden" name="quantity" id="qtyInput" value="1">
            <input type="hidden" name="price" id="priceInput" value="99.99">

            <button type="submit" class="add-to-cart-btn">
                ADD TO CART
            </button>
        </form>
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
<script src="js/product.js"></script>
</body>
</html>