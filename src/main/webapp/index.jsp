<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #WifiInfoTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #WifiInfoTable td, #WifiInfoTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #WifiInfoTable tr:nth-child(even){background-color: #f2f2f2;}

        #WifiInfoTable tr:hover {background-color: #ddd;}

        #WifiInfoTable th {
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
    <h1>와이파이 정보 구하기</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>
        <%
            //최초 index페이지인 경우. table의 값을 0.0, 0.0으로 초기화.
            if(null == request.getParameter("lat") && null == request.getParameter("lnt")){
                SeoulWifiSQLiteDatabaseManager.setUserPos(0.0, 0.0);
            }
            //아닌경우 parameter로 넘어온 값을 테이블에 저장.
            else{
                double user_lat = Double.parseDouble(request.getParameter("lat"));
                double user_lnt = Double.parseDouble(request.getParameter("lnt"));

                SeoulWifiSQLiteDatabaseManager.setUserPos(user_lat, user_lnt);
            }
        %>

        <form id="getUserLocationForm" action="action.jsp" method="post">
            LAT:<input id = 'user_lat' name = 'user_lat' value = <%= SeoulWifiSQLiteDatabaseManager.getUserPosLat()%>  type="text">
            LNT:<input id = 'user_lnt' name = 'user_lnt' value = <%= SeoulWifiSQLiteDatabaseManager.getUserPosLnt()%>  type="text">
        </form>

        <button id = 'location_bttn' name = 'location_bttn' onclick="getUserLocation()">내 위치 가져오기 </button>
        <button id = 'wifi_bttn' name = 'wifi_bttn'onclick= "showNearWifiInfo()"> 근처 WIPI 정보 보기</button>

    <script>
            function getUserLocation(){
                navigator.geolocation.getCurrentPosition(position => {
                    setUserLocation(position.coords.latitude, position.coords.longitude)
                })
            }

            function setUserLocation(lat, lnt){
                document.getElementById("user_lat").value = lat.toString();
                document.getElementById("user_lnt").value = lnt.toString();

                let form = document.getElementById("getUserLocationForm");
                form.submit();
            }

            function showNearWifiInfo(){
                location.href = "index.jsp?lat="+document.getElementById("user_lat").value.toString()+"&"+
                "lnt=" +document.getElementById("user_lnt").value.toString();
            }

        </script>

    <table id = "WifiInfoTable">
        <tr>
            <th>거리(km)</th>
            <th>관리번호</th>
            <th>자치구</th>
            <th>와이파이명</th>
            <th>도로명주소</th>
            <th>상세주소</th>
            <th>설치위치(층)</th>
            <th>설치유형</th>
            <th>설치기관</th>
            <th>서비스구분</th>
            <th>망종류</th>
            <th>설치년도</th>
            <th>실내외구분</th>
            <th>WIFI접속환경</th>
            <th>X좌표</th>
            <th>Y좌표</th>
            <th>작업일자</th>
        </tr>

        <%
            if(null == request.getParameter("lat") && null == request.getParameter("lnt")){
                out.write("<tr><td colspan = \"17\" align=\"center\">위치 정보를 입력한 후에 조회해 주세요.</td></tr>");
            }
            else{
                final String query = SeoulWifiSQLiteDatabaseManager.getQuery_NearWifiInfo();
                SQLiteManager.getConnection();
                SQLiteManager.getStatement(query);
                SQLiteManager.excuteQueryResultSet();
                ResultSet rs = SQLiteManager.getResultSet();


                while(rs.next()){
                    out.write("<tr>");
                    try {
                        String distance = String.format("%.4f", rs.getDouble("distance"));
                        out.write("<td>" + distance + "</td>");

                        String mgrNo = rs.getString("X_SWIFI_MGR_NO");
                        out.write("<td>" + mgrNo + "</td>");

                        out.write("<td>" + rs.getString("X_SWIFI_WRDOFC") + "</td>");

                        String str1 = "<a href = \"detail.jsp?mgrNo=" + mgrNo + "&distance="+ distance + "\">";
                        out.write("<td>" + str1 + rs.getString("X_SWIFI_MAIN_NM") + "</a></td>");


                        out.write("<td>" + rs.getString("X_SWIFI_ADRES1") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_ADRES2") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_INSTL_FLOOR") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_INSTL_TY") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_INSTL_MBY") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_SVC_SE") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_CMCWR") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_CNSTC_YEAR") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_INOUT_DOOR") + "</td>");
                        out.write("<td>" + rs.getString("X_SWIFI_REMARS3") + "</td>");
                        out.write("<td>" + rs.getDouble("LAT") + "</td>");
                        out.write("<td>" + rs.getDouble("LNT") + "</td>");
                        out.write("<td>" + rs.getString("WORK_DTTM") + "</td>");

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