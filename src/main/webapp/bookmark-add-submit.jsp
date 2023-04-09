<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String bookmarkGroupName = request.getParameter("bookmarkGroupName");
    String wifiName = request.getParameter("wifiName");
    SeoulWifiSQLiteDatabaseManager.insertBookmark(bookmarkGroupName, wifiName);
    response.sendRedirect("bookmark-list.jsp");
%>
</body>
</html>