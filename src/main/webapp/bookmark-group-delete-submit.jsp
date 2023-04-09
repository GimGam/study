<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
    SeoulWifiSQLiteDatabaseManager.deleteBookmarkGroup(request.getParameter("bookmark_id"));
    response.sendRedirect("bookmark-group.jsp");
%>
</body>
</html>