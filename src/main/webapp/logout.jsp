<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 30/12/2025
  Time: 11:04 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();

    response.sendRedirect("homepage.jsp");
%>
