<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || !userRole.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Wisk Wish</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

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
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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

        .admin-text {
            font-weight: bold;
            color: lightblue;
        }

        .logout-button {
            background-color: lightblue;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
        }

        .container {
            max-width: 1300px;
            margin: 40px auto;
            padding: 0 40px;
        }

        .page-title {
            font-size: 30px;
            color: white;
            font-weight: bold;
            margin-bottom: 25px;
        }

        .tabs {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .tab {
            background: white;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            color: lightblue;
        }

        .tab.active {
            background-color: lightblue;
            color: white;
        }

        .inventory-list {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .inventory-item {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 3px solid aliceblue;
        }

        .item-image {
            width: 90px;
            height: 90px;
            margin-right: 20px;
        }

        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .item-details { flex: 1; }

        .item-id {
            color: #999;
            font-weight: bold;
            font-size: 14px;
        }

        .item-name {
            color: lightblue;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .customization-row {
            display: flex;
            gap: 10px;
            margin-bottom: 6px;
        }

        .customization-label {
            font-weight: bold;
            min-width: 70px;
            color: #666;
        }

        .option-badge {
            background-color: lightblue;
            color: white;
            padding: 5px 10px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: bold;
        }

        .item-stock {
            background-color: lightblue;
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            font-weight: bold;
            margin-right: 20px;
        }

        .update-button {
            background-color: lightblue;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="header">
    <div class="header-title">Wisk Wish Dashboard</div>
    <div class="header-right">
        <span class="admin-text">Admin</span>
        <button class="logout-button" onclick="location.href='logout.jsp'">Logout</button>
    </div>
</div>

<div class="container">
    <h1 class="page-title">Inventory</h1>

    <div class="tabs">
        <div class="tab">Review Order Status</div>
        <div class="tab active">Inventory</div>
    </div>

    <div class="inventory-list">

        <!-- C01 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/ribbon-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C01</div>
                <div class="item-name">Ribbon Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (15)</span><span class="option-badge">2 Tiers (10)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (13)</span><span class="option-badge">Chocolate (12)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">7 inch (14)</span><span class="option-badge">10 inch (11)</span></div>
            </div>
            <div class="item-stock">Total: 25</div>
            <a href="update-inventory.jsp?cakeId=C01&cakeName=Ribbon%20Cake" class="update-button">Update Quantity</a>
        </div>

        <!-- C02 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/stitch-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C02</div>
                <div class="item-name">Stitch Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (10)</span><span class="option-badge">2 Tiers (8)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (9)</span><span class="option-badge">Chocolate (9)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">7 inch (10)</span><span class="option-badge">10 inch (8)</span></div>
            </div>
            <div class="item-stock">Total: 18</div>
            <a href="update-inventory.jsp?cakeId=C02&cakeName=Stitch%20Cake" class="update-button">Update Quantity</a>
        </div>

        <!-- C03 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/two-tier-flower-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C03</div>
                <div class="item-name">Real Flower Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (12)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (6)</span><span class="option-badge">Chocolate (6)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">10 inch (12)</span></div>
            </div>
            <div class="item-stock">Total: 12</div>
            <a href="update-inventory.jsp?cakeId=C03&cakeName=Real%20Flower%20Cake" class="update-button">Update Quantity</a>
        </div>

        <!-- C04 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/fox-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C04</div>
                <div class="item-name">Fox Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (8)</span><span class="option-badge">2 Tiers (7)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (8)</span><span class="option-badge">Chocolate (7)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">7 inch (8)</span><span class="option-badge">10 inch (7)</span></div>
            </div>
            <div class="item-stock">Total: 15</div>
            <a href="update-inventory.jsp?cakeId=C04&cakeName=Fox%20Cake" class="update-button">Update Quantity</a>
        </div>

        <!-- C05 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/drawing-flower-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C05</div>
                <div class="item-name">Drawn Flower Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (20)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (10)</span><span class="option-badge">Chocolate (10)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">7 inch (11)</span><span class="option-badge">10 inch (9)</span></div>
            </div>
            <div class="item-stock">Total: 20</div>
            <a href="update-inventory.jsp?cakeId=C05&cakeName=Drawn%20Flower%20Cake" class="update-button">Update Quantity</a>
        </div>

        <!-- C06 -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/bomb-cake.jpg">
            </div>
            <div class="item-details">
                <div class="item-id">C06</div>
                <div class="item-name">Bomb Cake</div>
                <div class="customization-row"><span class="customization-label">Tier:</span><span class="option-badge">1 Tier (10)</span></div>
                <div class="customization-row"><span class="customization-label">Flavour:</span><span class="option-badge">Vanilla (5)</span><span class="option-badge">Chocolate (5)</span></div>
                <div class="customization-row"><span class="customization-label">Size:</span><span class="option-badge">7 inch (10)</span></div>
            </div>
            <div class="item-stock">Total: 10</div>
            <a href="update-inventory.jsp?cakeId=C06&cakeName=Bomb%20Cake" class="update-button">Update Quantity</a>
        </div>

    </div>
</div>

</body>
</html>