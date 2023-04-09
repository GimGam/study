<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
</head>
<body>
    <%
        SeoulWifiSQLiteDatabaseManager.createTable();
        SeoulWifiSQLiteDatabaseManager.loadWifiData();
        int affectedRow = SeoulWifiSQLiteDatabaseManager.getTableRowCount();
    %>

    <div style = "text-align: center">
    <h1>
        <%=affectedRow%>개의 WIFI 정보를 정상적으로 저장하였습니다.
    </h1>
    </div>

    <div style = "text-align: center">
        <a href="index.jsp">홈으로 가기</a>
    </div>


</body>
</html>