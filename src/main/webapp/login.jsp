<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userRole = (String) session.getAttribute("userRole");
    boolean isLoggedIn = (userEmail != null || "admin".equals(userRole));

    String redirectPage = request.getParameter("redirect");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Wisk Wish</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: lightblue;
            font-family: Arial, Helvetica, sans-serif;
        }

        .container {
            background-color: white;
            padding: 35px;
            border-radius: 15px;
            width: 360px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.15);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: lightblue;
            font-size: 26px;
            font-weight: bold;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        input {
            padding: 12px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: lightblue;
        }

        .login-btn {
            margin-top: 10px;
            padding: 14px;
            border: none;
            border-radius: 10px;
            background-color: lightblue;
            color: white;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        .login-btn:hover {
            background-color: #4fc3f7;
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        p {
            text-align: center;
            font-size: 14px;
            margin-top: 20px;
        }

        p a {
            color: lightblue;
            font-weight: bold;
            text-decoration: none;
        }

        p a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="container">
    <% if (isLoggedIn) { %>
    <div class="logged-in-msg">
        <h2>Already Logged In</h2>
        <p>You are currently signed in as: <br><strong><%= (userEmail != null) ? userEmail : "Admin" %></strong></p>
        <a href="homepage.jsp" class="login-btn" style="text-decoration: none; display: block; text-align: center; margin-bottom: 15px;">Go to Home</a>
        <p><a href="logout.jsp" style="color: lightblue; text-decoration: none; font-size: 12px;">Log out of this account</a></p>
    </div>
    <% } else { %>
    <h2>Login</h2>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
    <p style="color: red; text-align: center; font-size: 13px; margin-bottom: 10px;">Wrong email or password.</p>
    <% } %>

    <form action="LoginServlet" method="post">
        <input type="hidden" name="redirect" value="<%= (redirectPage != null) ? redirectPage : "homepage.jsp" %>">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="login-btn">Login</button>
    </form>

    <p>
        Don’t have an account?
        <a href="signup.jsp">Sign Up</a>
    </p>
    <% } %>
</div>
</body>
</html>
