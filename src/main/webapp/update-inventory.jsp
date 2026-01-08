<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || !userRole.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String cakeId = request.getParameter("cakeId");
    String cakeName = request.getParameter("cakeName");

    // Check if coming from error redirect
    if (cakeId == null) {
        cakeId = (String) request.getAttribute("cakeId");
    }
    if (cakeName == null) {
        cakeName = (String) request.getAttribute("cakeName");
    }

    if (cakeId == null || cakeName == null) {
        response.sendRedirect("admin-dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Inventory - Wisk Wish</title>
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
        }

        .header-title {
            font-size: 25px;
            font-weight: bold;
            color: lightblue;
        }

        .back-button {
            background-color: lightblue;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: 0.3s;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 40px;
        }

        .page-title {
            font-size: 30px;
            margin-bottom: 30px;
            color: white;
            font-weight: bold;
        }

        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .cake-info {
            background-color: aliceblue;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .cake-info-title {
            font-size: 18px;
            color: lightblue;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .cake-info-id {
            font-size: 14px;
            color: #666;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 16px;
            color: #333;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .form-select, .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid lightblue;
            border-radius: 10px;
            font-size: 16px;
            transition: 0.3s;
        }

        .form-select:focus, .form-input:focus {
            outline: none;
            border-color: #4fc3f7;
            box-shadow: 0 0 0 3px rgba(173, 216, 230, 0.2);
        }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            text-align: center;
            display: block;
        }

        .btn-primary {
            background-color: lightblue;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background-color: #e0e0e0;
            color: #666;
        }

        .btn-secondary:hover {
            background-color: #d0d0d0;
        }

        @media (max-width: 767px) {
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="header-title">Wisk Wish Dashboard</div>
    <a href="admin-dashboard.jsp" class="back-button">Back to Inventory</a>
</div>

<div class="container">
    <h1 class="page-title">Update Inventory Quantity</h1>

    <div class="form-card">
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
        </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <div class="cake-info">
            <div class="cake-info-title"><%= cakeName %></div>
            <div class="cake-info-id">Product ID: <%= cakeId %></div>
        </div>

        <form action="${pageContext.request.contextPath}/UpdateInventoryServlet" method="POST">
            <input type="hidden" name="cakeId" value="<%= cakeId %>">
            <input type="hidden" name="cakeName" value="<%= cakeName %>">

            <div class="form-group">
                <label for="tier" class="form-label">Tier</label>
                <select name="tier" id="tier" class="form-select" required>
                    <option value="">Select Tier</option>
                    <option value="1 Tier">1 Tier</option>
                    <option value="2 Tiers">2 Tiers</option>
                </select>
            </div>

            <div class="form-group">
                <label for="flavour" class="form-label">Flavour</label>
                <select name="flavour" id="flavour" class="form-select" required>
                    <option value="">Select Flavour</option>
                    <option value="Vanilla">Vanilla</option>
                    <option value="Chocolate">Chocolate</option>
                </select>
            </div>

            <div class="form-group">
                <label for="size" class="form-label">Size</label>
                <select name="size" id="size" class="form-select" required>
                    <option value="">Select Size</option>
                    <option value="7 inch">7 inch</option>
                    <option value="10 inch">10 inch</option>
                </select>
            </div>

            <div class="form-group">
                <label for="quantity" class="form-label">New Quantity</label>
                <input type="number" name="quantity" id="quantity"
                       class="form-input" min="0" required
                       placeholder="Enter new quantity">
            </div>

            <div class="button-group">
                <a href="admin-dashboard.jsp" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Update Quantity</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>