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

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final String FILE_PATH = "users.json";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        Gson gson = new Gson();
        List<User> userList = new ArrayList<>();

        // 1. Read existing users
        String path = getServletContext().getRealPath("/") + FILE_PATH;
        File file = new File(path);

        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<ArrayList<User>>(){}.getType();
                userList = gson.fromJson(reader, listType);
                if (userList == null) userList = new ArrayList<>();
            }
        }

        // 2. Add the new user as a "user" role
        userList.add(new User(name, email, pass, "user"));

        // 3. Save updated list back to users.json
        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(userList, writer);
        }

        // Go to login page so they can sign in
        response.sendRedirect("login.jsp");
    }
}