<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>

        #WifiDetail {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
            height: 100%;
        }

        #WifiDetail td, #WifiInfoTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #WifiDetail tr:nth-child(even) {background-color: #f2f2f2;}
        #WifiDetail tr:hover {background-color: #ddd;}

        #WifiDetail tr td:first-child {
            background-color: #04AA6D;
            color: white;
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
        }

        select{
            border-radius: 30px;
        }
        select option{
            background-color: black;
            color: #f2f2f2;
            border-radius: 30px;
        }
    </style>


    <title>와이파이 정보 구하기</title>
</head>
<body>
    <h1>와이파이 정보 디테일</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>

    <%
        StringBuilder sb = null;
        ResultSet rs = null;
    %>

    <div></div>
    <select id="selectedBookmarkGroup">
        <option value="" selected disabled>북마크 그룹 이름 선택</option>
        <%
            String sql = SeoulWifiSQLiteDatabaseManager.getQuery_GetBookmarkGroupNameList();
            SQLiteManager.getConnection();
            SQLiteManager.getStatement(sql);
            SQLiteManager.excuteQueryResultSet();
            rs = SQLiteManager.getResultSet();

            sb = new StringBuilder();
            while(rs.next()){
                sb.append("<option>");
                sb.append(rs.getString("NAME"));
                sb.append("</option>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            }

            SQLiteManager.close();
        %>
    </select>

    <button onclick="addBookmark()">북마크 추가하기</button>
    <%
        sb = new StringBuilder();

        String mgrNo = request.getParameter("mgrNo");
        String query = SeoulWifiSQLiteDatabaseManager.getQuery_SelectWifiData(mgrNo);

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(query);
        SQLiteManager.excuteQueryResultSet();
        rs = SQLiteManager.getResultSet();

        String X_SWIFI_WRDOFC = null;
        String X_SWIFI_MAIN_NM = null;
        String X_SWIFI_ADRES1 = null;
        String X_SWIFI_ADRES2 = null;
        String X_SWIFI_INSTL_FLOOR = null;
        String X_SWIFI_INSTL_TY = null;
        String X_SWIFI_INSTL_MBY = null;
        String X_SWIFI_SVC_SE = null;
        String X_SWIFI_CMCWR = null;
        String X_SWIFI_CNSTC_YEAR = null;
        String X_SWIFI_INOUT_DOOR = null;
        String X_SWIFI_REMARS3 = null;
        String LAT = null;
        String LNT = null;
        String WORK_DTTM = null;
        while(rs.next()){
            X_SWIFI_WRDOFC = rs.getString("X_SWIFI_WRDOFC");
            X_SWIFI_MAIN_NM = rs.getString("X_SWIFI_MAIN_NM");
            X_SWIFI_ADRES1 = rs.getString("X_SWIFI_ADRES1");
            X_SWIFI_ADRES2 = rs.getString("X_SWIFI_ADRES2");
            X_SWIFI_INSTL_FLOOR = rs.getString("X_SWIFI_INSTL_FLOOR");
            X_SWIFI_INSTL_TY = rs.getString("X_SWIFI_INSTL_TY");
            X_SWIFI_INSTL_MBY = rs.getString("X_SWIFI_INSTL_MBY");
            X_SWIFI_SVC_SE = rs.getString("X_SWIFI_SVC_SE");
            X_SWIFI_CMCWR = rs.getString("X_SWIFI_CMCWR");
            X_SWIFI_CNSTC_YEAR = rs.getString("X_SWIFI_CNSTC_YEAR");
            X_SWIFI_INOUT_DOOR = rs.getString("X_SWIFI_INOUT_DOOR");
            X_SWIFI_REMARS3 = rs.getString("X_SWIFI_REMARS3");
            LAT = rs.getString("LAT");
            LNT = rs.getString("LNT");
            WORK_DTTM = rs.getString("WORK_DTTM");
        }


        SQLiteManager.close();
    %>

    <table id = "WifiDetail">
        <tr>
            <td>거리(Km)</td>
            <%
                sb.append("<td>");
                sb.append(request.getParameter("distance"));
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>관리번호</td>
            <%
                sb.append("<td>");
                sb.append(request.getParameter("mgrNo"));
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>자치구</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_WRDOFC);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>와이파이명</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_MAIN_NM);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>도로명주소</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_ADRES1);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>상세주소</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_ADRES2);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>설치위치(층)</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_INSTL_FLOOR);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>설치유형</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_INSTL_TY);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>설치기관</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_INSTL_MBY);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>서비스구분</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_SVC_SE);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>망종류</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_CMCWR);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>실내외구분</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_INOUT_DOOR);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>WIFI접속환경</td>
            <%
                sb.append("<td>");
                sb.append(X_SWIFI_REMARS3);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>x좌표</td>
            <%
                sb.append("<td>");
                sb.append(LAT);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>Y좌표</td>
            <%
                sb.append("<td>");
                sb.append(LNT);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
        <tr>
            <td>작업일자</td>
            <%
                sb.append("<td>");
                sb.append(WORK_DTTM);
                sb.append("</td>");
                out.write(sb.toString());
                sb.delete(0, sb.length());
            %>
        </tr>
    </table>

    <form id="addBookMarkForm" action="bookmark-add-submit.jsp" method="post">
        <input id = 'bookmarkGroupName' name = 'bookmarkGroupName' value = ""  type="hidden">
        <input id = 'wifiName' name = 'wifiName' value = ""  type="hidden">
    </form>

    <script>
        function addBookmark(){
            var selectBox = document.getElementById("selectedBookmarkGroup");
            var selectedValue = selectBox.value;

            if(selectedValue === ""){
                window.confirm("선택된 북마크 그룹이 없습니다.");
            }
            else{
                if(window.confirm("북마크를 추가하시겠습니까?")){
                    document.getElementById("bookmarkGroupName").value = selectedValue;
                    document.getElementById("wifiName").value =
                        document.getElementById("WifiDetail").rows[3].cells[1].textContent;
                    document.getElementById("addBookMarkForm").submit();
                }
            }
        }
    </script>


</body>
</html>