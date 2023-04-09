<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <style>
        #HistoryTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #HistoryTable td, #HistoryTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #HistoryTable tr:nth-child(even){background-color: #f2f2f2;}

        #HistoryTable tr:hover {background-color: #ddd;}

        #HistoryTable th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #04AA6D;
            color: white;
        }
    </style>

    <title>와이파이 정보 구하기</title>
</head>
<body>
    <h1>위치 히스토리 목록</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>
    <div></div>

    <form id="getClickedTableRowForm" action="actionHistory.jsp" method="post">
        <input id = 'history_table_id' name = 'history_table_id' value = ""  type="hidden">
    </form>

    <script>
        function getTableRow(button){
            var row = button.parentNode.parentNode;
            document.getElementById("history_table_id").value = row.getElementsByTagName("td")[0].innerHTML;
            document.getElementById("getClickedTableRowForm").submit();
        }
    </script>

    <table id = "HistoryTable">
        <tr>
            <th>ID</th>
            <th>X좌표</th>
            <th>X좌표</th>
            <th>조회일자</th>
            <th>비고</th>
        </tr>

        <%
            if(0 == SeoulWifiSQLiteDatabaseManager.getHistoryCount()){
                out.write("<tr><td colspan = \"5\" align=\"center\">위치 히스토리가 없습니다..</td></tr>");
            }
            else{
                SQLiteManager.getConnection();
                SQLiteManager.getStatement(SeoulWifiSQLiteDatabaseManager.getQuery_HistoryDesc());
                SQLiteManager.excuteQueryResultSet();
                ResultSet rs = SQLiteManager.getResultSet();


                while(rs.next()){
                    out.write("<tr>");
                    try {
                        out.write("<td>" + rs.getString("ID") + "</td>");
                        out.write("<td>" + rs.getString("LAT") + "</td>");
                        out.write("<td>" + rs.getString("LNT") + "</td>");
                        out.write("<td>" + rs.getString("DT") + "</td>");
                        out.write("<td>" + "<button onclick=\"getTableRow(this)\">삭제</button>" + "</td>");

                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                    out.write("</tr>");
                }

                SQLiteManager.close();
            }
        %>
    </table>
</body>
</html>
