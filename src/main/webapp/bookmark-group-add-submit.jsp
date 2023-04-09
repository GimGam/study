<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>

<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("form-value-input-bookmark-name");
    String order = request.getParameter("form-value-input-bookmark-order");
    SeoulWifiSQLiteDatabaseManager.insertBookmarkGroup(name, order);
    response.sendRedirect("bookmark-group.jsp");
%>

</body>
</html>