<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        #BookmarkGroupAdd {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
            height: 100%;
        }

        #BookmarkGroupAdd td, #BookmarkGroupAdd th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #BookmarkGroupAdd tr:nth-child(even) {background-color: #f2f2f2;}
        #BookmarkGroupAdd tr:hover {background-color: #ddd;}

        #BookmarkGroupAdd td:first-child {
            background-color: #04AA6D;
            color: white;
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
        }

        #BookmarkGroupAdd tr:last-child td {
            text-align: center;
            background-color: white;
        }

    </style>


    <title>와이파이 정보 구하기</title>
</head>
<body>
    <h1>북마크 그룹 추가</h1>

    <div></div>
    <p>
        <a href="index.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="wifi-load.jsp">Open API 와이파이 정보 가져오기</a> |
        <a href="wifi-load.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </p>


    <table id = "BookmarkGroupAdd">
        <tr>
            <td>북마크 이름</td>
            <td><input id = "input-bookmark-name" name = "input-bookmark-name" type="text" placeholder="북마크 이름 입력.." accept-charset = "UTF-8"></td>
        </tr>
        <tr>
            <td>순서</td>
            <td><input id = "input-bookmark-order" name = "input-bookmark-order" type="text" placeholder="북마크 순서 입력.."  accept-charset = "UTF-8"></td>
        </tr>
        <tr><td colspan="2">
            <input id = 'add-bookmark-group-bttn' name = 'group'
                   value = "추가"  type="button" onclick="bookmarkGroupAddSubmit()">
            <form id="add-bookmark-group-form" action="bookmark-group-add-submit.jsp" method="post" accept-charset="UTF-8">
                <input type="hidden" id="form-value-input-bookmark-name", name="form-value-input-bookmark-name">;
                <input type="hidden" id="form-value-input-bookmark-order", name="form-value-input-bookmark-order">;
            </form>
        </td></tr>
    </table>

    <script>
        function bookmarkGroupAddSubmit(){
            var form = document.getElementById("add-bookmark-group-form");
            document.getElementById("form-value-input-bookmark-name").value = document.getElementById("input-bookmark-name").value;
            document.getElementById("form-value-input-bookmark-order").value = document.getElementById("input-bookmark-order").value;

            if(window.confirm("북마크 그룹 정보를 추가하시겠습니까?.")) {
                form.submit();
            }
        }
    </script>


</body>
</html>