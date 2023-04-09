<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
    SeoulWifiSQLiteDatabaseManager.deleteBookmark(request.getParameter("bookmark-id"));
    response.sendRedirect("bookmark-list.jsp");
%>
</body>
</html>