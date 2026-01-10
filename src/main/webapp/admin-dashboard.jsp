<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="controller.LoadInventoryServlet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    //only allow admin to access this page
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

        .header-button {
            background-color: lightblue;
            color: white;
            border: none;
            font-size: 14px;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            transition: 0.3s;
        }

        .header-button:hover {
            background-color: #4fc3f7;
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

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: bold;
            border: 2px solid #c3e6cb;
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

        /* Container for Total and Action Button */
        .item-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }

        .item-stock {
            background-color: lightblue;
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            font-weight: bold;
            text-align: center;
            min-width: 100px;
        }

        .update-button {
            background-color: lightblue;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }

        /* CSS FOR DATE */
        .last-updated {
            font-size: 12px;
            color: #888;
            margin-top: 5px;
            font-style: italic;
        }
    </style>
</head>

<body>

<!-- header with navigation and controls -->
<div class="header">
    <div class="header-title">Wisk Wish Dashboard</div>
    <div class="header-right">
        <span class="admin-text">Admin</span>
        <a href="${pageContext.request.contextPath}/ExportInventoryServlet" class="header-button">Export Inventory</a>
        <a href="${pageContext.request.contextPath}/ExportOrderServlet" class="header-button">Export Orders</a>
        <button class="header-button" onclick="location.href='logout.jsp'">Logout</button>
    </div>
</div>

<div class="container">
    <h1 class="page-title">Inventory</h1>

    <%
        //read last export date
        String lastExportDate = "Never";
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

        try {
            String exportFilePath = getServletContext().getRealPath("/WEB-INF/last-export.txt");
            File exportFile = new File(exportFilePath);
            if (exportFile.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(exportFile));
                String timestamp = reader.readLine();
                reader.close();

                if (timestamp != null && !timestamp.isEmpty()) {
                    long ts = Long.parseLong(timestamp);
                    Date date = new Date(ts);
                    lastExportDate = dateFormat.format(date);
                }
            }
        } catch (Exception e) {
            lastExportDate = "Error reading date";
        }
    %>

    <!-- display last export information -->
    <div class="export-info">
        <div class="export-date">
            Last inventory export: <strong><%= lastExportDate %></strong>
        </div>
    </div>

    <% if ("success".equals(request.getParameter("update"))) { %>
    <div class="success-message">
        ✓ Inventory updated successfully!
    </div>
    <% } %>

    <div class="tabs">
        <div class="tab">Review Order Status</div>
    </div>

    <div class="inventory-list">

        <%
            // Define cake data
        <%
            //define cake data
            String[][] cakes = {
                    {"C01", "Ribbon Cake", "ribbon-cake.jpg"},
                    {"C02", "Stitch Cake", "stitch-cake.jpg"},
                    {"C03", "Real Flower Cake", "two-tier-flower-cake.jpg"},
                    {"C04", "Fox Cake", "fox-cake.jpg"},
                    {"C05", "Drawn Flower Cake", "drawing-flower-cake.jpg"},
                    {"C06", "Bomb Cake", "bomb-cake.jpg"}
            };

            ServletContext context = application;

            //loop through each cake
            for (String[] cake : cakes) {
                String cakeId = cake[0];
                String cakeName = cake[1];
                String cakeImage = cake[2];

                // Get quantities
                Map<String, Integer> tierQty = LoadInventoryServlet.getQuantitiesByTier(context, cakeId);
                Map<String, Integer> flavourQty = LoadInventoryServlet.getQuantitiesByFlavour(context, cakeId);
                Map<String, Integer> sizeQty = LoadInventoryServlet.getQuantitiesBySize(context, cakeId);
                int totalQty = LoadInventoryServlet.getTotalQuantity(context, cakeId);
        %>



        <!-- individual cake inventory item -->
        <div class="inventory-item">
            <div class="item-image">
                <img src="${pageContext.request.contextPath}/pictures/<%= cakeImage %>" alt="<%= cakeName %>">
            </div>

            <div class="item-details">
                <div class="item-id"><%= cakeId %></div>
                <div class="item-name"><%= cakeName %></div>

                <!--- display tier options --->
                <div class="customization-row">
                    <span class="customization-label">Tier:</span>
                    <%
                        for (Map.Entry<String, Integer> entry : tierQty.entrySet()) {
                            if (entry.getValue() > 0) {
                    %>
                    <span class="option-badge"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                    <%
                            }
                        }
                    %>
                </div>

                <!--- display flavour options --->
                <div class="customization-row">
                    <span class="customization-label">Flavour:</span>
                    <%
                        for (Map.Entry<String, Integer> entry : flavourQty.entrySet()) {
                            if (entry.getValue() > 0) {
                    %>
                    <span class="option-badge"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                    <%
                            }
                        }
                    %>
                </div>

                <!--- display size options --->
                <div class="customization-row">
                    <span class="customization-label">Size:</span>
                    <%
                        for (Map.Entry<String, Integer> entry : sizeQty.entrySet()) {
                            if (entry.getValue() > 0) {
                    %>
                    <span class="option-badge"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!--- total stocka and update button --->
            <div class="item-actions">
                <div class="item-stock">Total: <%= totalQty %></div>
                <a href="update-inventory.jsp?cakeId=<%= cakeId %>&cakeName=<%= java.net.URLEncoder.encode(cakeName, StandardCharsets.UTF_8) %>" class="update-button">Update Quantity</a>
            </div>

        </div>

        <%
            }
        %>

    </div>
</div>

</body>
</html>