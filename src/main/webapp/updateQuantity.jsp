<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 14/12/2025
  Time: 9:59 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Quantity</title>
</head>
<body>

<h2>Update Quantity</h2>

<p>Cake ID: <strong>${cakeId}</strong></p>

<form action="SaveQuantityController" method="post">
    <input type="hidden" name="cakeId" value="${cakeId}">
    <input type="number" name="quantity" min="0" required>
    <br><br>
    <button type="submit">Save</button>
</form>

</body>
</html>

