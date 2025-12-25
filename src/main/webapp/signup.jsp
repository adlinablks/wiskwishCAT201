<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Wisk Wish</title>

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

        .signup-btn {
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

        .signup-btn:hover {
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
    <h2>Create Account</h2>

    <form>
        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="signup-btn">Sign Up</button>
    </form>

    <p>
        Already have an account?
        <a href="login.jsp">Login</a>
    </p>
</div>

</body>
</html>
