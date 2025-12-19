package cat201project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/SaveQuantityController")
public class SaveQuantityController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cakeId = request.getParameter("cakeId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Later: save to database or file
        System.out.println("Updated " + cakeId + " to " + quantity);

        response.sendRedirect("admin-dashboard.jsp");
    }
}

