<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
    double lat = Double.parseDouble(request.getParameter("user_lat"));
    double lnt = Double.parseDouble(request.getParameter("user_lnt"));
    SeoulWifiSQLiteDatabaseManager.insertHistory(lat, lnt);
%>

<script>
    window.history.back();
</script>
</body>
</html>