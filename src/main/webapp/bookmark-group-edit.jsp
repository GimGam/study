<%@ page import="SeoulWifiApi.SeoulWifiSQLiteDatabaseManager" %>
<%@ page import="SQLiteManager.SQLiteManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #BookmarkGroupEdit {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
            height: 100%;
        }

        #BookmarkGroupEdit td, #BookmarkGroupEdit th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #BookmarkGroupEdit tr:nth-child(even) {background-color: #f2f2f2;}
        #BookmarkGroupEdit tr:hover {background-color: #ddd;}

        #BookmarkGroupEdit td:first-child {
            background-color: #04AA6D;
            color: white;
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
        }

        #BookmarkGroupEdit tr:last-child td {
            text-align: center;
            background-color: white;
        }
    </style>


    <title>와이파이 정보 구하기</title>
</head>
<body>
    <h1>북마크 그룹 수정</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="bookmark-list.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>


    <table id = "BookmarkGroupEdit">
        <tr>
            <td>북마크 이름</td>
            <td><input id = "input-bookmark-name" name = "input-bookmark-name" type="text" placeholder="북마크 이름 입력.." accept-charset = "UTF-8"></td>
        </tr>
        <tr>
            <td>순서</td>
            <td><input id = "input-bookmark-order" name = "input-bookmark-order" type="text" placeholder="북마크 순서 입력.."  accept-charset = "UTF-8"></td>
        </tr>
        <tr><td colspan="2">
            <a href="javascript:history.back()">돌아가기</a>
            <input id = 'edit-bookmark-group-bttn' name = 'group'
                   value = "수정"  type="button" onclick="bookmarkGroupEditSubmit()">
            <form id="edit-bookmark-group-form" action="bookmark-group-edit-submit.jsp" method="post" accept-charset="UTF-8">
                <input type="hidden" id="form-value-url-bookmark-id" name="form-value-url-bookmark-id">;
                <input type="hidden" id="form-value-input-bookmark-name" name="form-value-input-bookmark-name">;
                <input type="hidden" id="form-value-input-bookmark-order" name="form-value-input-bookmark-order">;
            </form>
        </td></tr>
    </table>


    <script>
        function bookmarkGroupEditSubmit(){
            var form = document.getElementById("edit-bookmark-group-form");

            const urlParams = new URLSearchParams(window.location.search);

            document.getElementById("form-value-url-bookmark-id").value = urlParams.get("bookmarkGroupID");
            document.getElementById("form-value-input-bookmark-name").value = document.getElementById("input-bookmark-name").value;
            document.getElementById("form-value-input-bookmark-order").value = document.getElementById("input-bookmark-order").value;

            if(window.confirm("북마크 그룹 정보를 수정하시겠습니까?.")) {
                form.submit();
            }
        }
    </script>


</body>
</html>