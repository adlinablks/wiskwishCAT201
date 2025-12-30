package controller;

import cat201project.model.User;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.lang.reflect.Type;
import java.util.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String FILE_PATH = "users.json";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String redirectTo = request.getParameter("redirect");
        HttpSession session = request.getSession();

        // 1. CHECK FOR ADMIN FIRST
        if ("admin@wiskwish.com".equals(email) && "admin123".equals(pass)) {
            session.setAttribute("userRole", "admin");
            session.setAttribute("isLoggedIn", true);
            response.sendRedirect("admin-dashboard.jsp");
            return;
        }

        // 2. CHECK JSON FOR REGULAR USER
        Gson gson = new Gson();
        String path = getServletContext().getRealPath("/") + FILE_PATH;
        File file = new File(path);

        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<ArrayList<User>>(){}.getType();
                List<User> users = gson.fromJson(reader, listType);

                if (users != null) {
                    for (User u : users) {
                        if (u.getEmail().equals(email) && u.getPassword().equals(pass)) {
                            session.setAttribute("userEmail", email);
                            session.setAttribute("userRole", "user");
                            session.setAttribute("isLoggedIn", true);

                            // Return to previous page or Home
                            if (redirectTo != null && !redirectTo.isEmpty()) {
                                response.sendRedirect(redirectTo);
                            } else {
                                response.sendRedirect("homepage.jsp");
                            }
                            return;
                        }
                    }
                }
            }
        }

        // 3. If login fails
        response.sendRedirect("login.jsp?error=invalid");
    }
}