<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
    SeoulWifiSQLiteDatabaseManager.deleteHistory(request.getParameter("history_table_id"));
    response.sendRedirect("history.jsp");
%>
</body>
</html>