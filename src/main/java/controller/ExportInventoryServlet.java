package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;

@WebServlet("/ExportInventoryServlet")
public class ExportInventoryServlet extends HttpServlet {

    private static final String INVENTORY_FILE = "inventory.json";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin authentication
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the inventory.json file path
        String filePath = getServletContext().getRealPath("/WEB-INF/" + INVENTORY_FILE);
        File file = new File(filePath);

        if (!file.exists()) {
            response.setContentType("text/plain");
            response.getWriter().write("Inventory file not found");
            return;
        }

        // Set response headers for file download
        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"inventory.json\"");
        response.setContentLength((int) file.length());

        // Read and write the file to response
        try (FileInputStream fileInputStream = new FileInputStream(file);
             OutputStream outputStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            outputStream.flush();
        }
    }
}