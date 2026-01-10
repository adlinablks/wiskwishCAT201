package controller;

import cat201project.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
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

        if (name == null || email == null || pass == null || name.isEmpty() || email.isEmpty()) {
            response.sendRedirect("signup.jsp?error=emptyfields");
            return;
        }

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String path = getServletContext().getRealPath("/WEB-INF/") + FILE_PATH;
        File file = new File(path);

        List<User> userList = new ArrayList<>();

        // Read existing users if the file exists
        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<ArrayList<User>>(){}.getType();
                userList = gson.fromJson(reader, listType);
                if (userList == null) {
                    userList = new ArrayList<>();
                }
            }
        }

        //  Check if email already exists
        for (User u : userList) {
            if (u.getEmail().equalsIgnoreCase(email)) {
                // If email is found, go to signup page
                response.sendRedirect("signup.jsp?error=exists");
                return;
            }
        }

        userList.add(new User(name, email, pass, "user"));

        // Save updated list back to users.json
        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(userList, writer);
            System.out.println("Successfully saved user to: " + path);
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=servererror");
            return;
        }

        response.sendRedirect("login.jsp?signup=success");
    }
}