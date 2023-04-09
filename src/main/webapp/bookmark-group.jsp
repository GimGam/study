<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #BookmarkGroupTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #BookmarkGroupTable td, #BookmarkGroupTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #BookmarkGroupTable tr:nth-child(even){background-color: #f2f2f2;}

        #BookmarkGroupTable tr:hover {background-color: #ddd;}

        #BookmarkGroupTable th {
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
    <h1>북마크 그룹 목록</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>

    <div></div>
    <button id = "add-boorkmark-bttn", name = "add-boorkmark-bttn" onclick="location.href = 'bookmark-group-add.jsp'">
    북마크 그룹 이름 추가
    </button>


    <table id = "BookmarkGroupTable">
        <tr>
            <th>ID</th>
            <th>북마크 이름</th>
            <th>순서</th>
            <th>등록일자</th>
            <th>수정일자</th>
            <th>비고</th>
        </tr>


        <%
            StringBuilder sb = new StringBuilder();

           //북마크 그룹이 없는경우.
            if(0 == SeoulWifiSQLiteDatabaseManager.getBookmarkGroupCount()){
                out.write("<tr><td colspan=\"6\" align=\"center\">북마크 그룹을 먼저 생성해주세요..</td></tr>");
            }
            else{
                String sql = "select* from BOOK_MARK_GROUP order by ORDER_NUM;";

                SQLiteManager.getConnection();
                SQLiteManager.getStatement(sql);
                SQLiteManager.excuteQueryResultSet();
                ResultSet rs = SQLiteManager.getResultSet();

                while (rs.next()){
                    out.write("<tr>");

                    String bookmarkGroupID = rs.getString("ID");

                    sb.append("<td>");
                    sb.append(bookmarkGroupID);
                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    sb.append("<td>");
                    sb.append(rs.getString("NAME"));
                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    sb.append("<td>");
                    sb.append(rs.getString("ORDER_NUM"));
                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    sb.append("<td>");
                    sb.append(rs.getString("DT"));
                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    sb.append("<td>");
                    sb.append(rs.getString("EDIT_DT"));
                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    sb.append("<td>");

                    sb.append("<button onclick=\"location.href= 'bookmark-group-edit.jsp");
                    sb.append("?bookmarkGroupID= " + bookmarkGroupID + "'\">수정</button>");

                    sb.append("<button onclick=\"deleteBookmarkGroup(this)\">");
                    sb.append("삭제");
                    sb.append("</button>");

                    sb.append("</td>");
                    out.write(sb.toString());
                    sb.delete(0, sb.length());

                    out.write("</tr>");
                }

                SQLiteManager.close();
            }
        %>

    </table>

    <form id="delete-bookmark-form-id" action="bookmark-group-delete-submit.jsp" method="post">
        <input id = 'bookmark_id' name = 'bookmark_id' value = ""  type="hidden">
    </form>

    <script>
        function deleteBookmarkGroup(button){
            if(window.confirm("북마크 그룹 정보를 삭제하시겠습니까?.")) {
                var row = button.parentNode.parentNode;
                document.getElementById("bookmark_id").value = row.getElementsByTagName("td")[0].innerHTML;
                document.getElementById("delete-bookmark-form-id").submit();
            }
        }
    </script>
</body>
</html>