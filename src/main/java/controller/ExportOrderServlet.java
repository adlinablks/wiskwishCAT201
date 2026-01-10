package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/ExportOrderServlet")
public class ExportOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        // 1. Optional Security: Check if admin
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        if (!"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // 2. Locate the orders file in WEB-INF
        String path = getServletContext().getRealPath("/WEB-INF/orders.json");
        File file = new File(path);

        if (file.exists()) {
            // 3. Set download headers
            response.setContentType("application/json");
            response.setHeader("Content-Disposition", "attachment; filename=all_orders_backup.json");

            // 4. Stream the file content
            try (InputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Orders file not found in WEB-INF.");
        }
    }
}