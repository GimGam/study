<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #BookmarkListTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #BookmarkListTable td, #BookmarkListTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #BookmarkListTable tr:nth-child(even){background-color: #f2f2f2;}

        #BookmarkListTable tr:hover {background-color: #ddd;}

        #BookmarkListTable th {
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
    <h1>북마크 목록</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>

    <table id = "BookmarkListTable">
        <tr>
            <th>ID</th>
            <th>북마크 이름</th>
            <th>와이파이명</th>
            <th>등록일자</th>
            <th>비고</th>
        </tr>

        <%
            if(0 == SeoulWifiSQLiteDatabaseManager.getBookmarkCount()){
                out.write("<tr><td colspan = \"5\" align=\"center\">북마크가 없습니다..</td></tr>");
            }
            else{
                SQLiteManager.getConnection();
                SQLiteManager.getStatement(SeoulWifiSQLiteDatabaseManager.getQuery_BookmarkData());
                SQLiteManager.excuteQueryResultSet();
                ResultSet rs = SQLiteManager.getResultSet();

                while(rs.next()){
                    out.write("<tr>");
                    try {
                        out.write("<td>" + rs.getString("ID") + "</td>");
                        out.write("<td>" + rs.getString("BOOK_MARK_NAME") + "</td>");
                        out.write("<td>" + rs.getString("WIFI_NAME") + "</td>");
                        out.write("<td>" + rs.getString("DT") + "</td>");
                        out.write("<td>" + "<button onclick=\"deleteBookmark(this)\">삭제</button>" + "</td>");

                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                    out.write("</tr>");
                }
                SQLiteManager.close();
            }
        %>
    </table>

    <form id="deleteBookmarkForm" action="bookmark-delete-submit.jsp" method="post">
        <input id = 'bookmark-id' name = 'bookmark-id' value = ""  type="hidden">
    </form>

    <script>
        function deleteBookmark(button){
            if(window.confirm("북마크를 삭제하시겠습니까?")){
                var row = button.parentNode.parentNode;
                document.getElementById("bookmark-id").value = row.getElementsByTagName("td")[0].innerHTML;
                document.getElementById("deleteBookmarkForm").submit();
            }
        }
    </script>


</body>
</html>