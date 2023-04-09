package SeoulWifiApi;

import java.lang.reflect.Field;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import SQLiteManager.SQLiteManager;

public class SeoulWifiSQLiteDatabaseManager{
    //-------------------------------------------------------------------------
    //WIFI_DATA Table
    //-------------------------------------------------------------------------
    final static private String tableName = "WIFI_DATA";
    static private boolean haveTable(){
        StringBuilder sb = new StringBuilder();
        boolean result = false;
        String sql = " select count(*) as count from sqlite_master where name =";
        sb.append(sql);
        sb.append(" '");
        sb.append(tableName);
        sb.append("';");
        sql = sb.toString();

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            int a = rs.getInt(1);
            result = rs.getInt(1) != 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return result;
    }

    static public boolean createTable(){
        //테이블이 없을 경우에만 생성
        StringBuilder sb = new StringBuilder("create table if not exists ");
        sb.append(tableName);
        sb.append(" (");

        WifiInfo wifiInfo = new WifiInfo();
        Field[] fields = wifiInfo.getClass().getDeclaredFields();
        for(Field field : fields){
            sb.append(" ");
            sb.append(field.getName());
            sb.append(" ");
            sb.append(convertToSQLiteDataType(field));
            sb.append(" NOT NULL");
            sb.append(",");
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(");");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQuery();
        SQLiteManager.close();

        return true;
    }

    static public boolean dropTable(){
        if(!haveTable()){
            return false;
        }

        String sql = "drop table " + tableName + " ;";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQuery();
        SQLiteManager.close();

        return true;
    }

    static public boolean loadWifiData(){
        //테이블이 존재하지않거나
        if(!haveTable()){
            return false;
        }

        //테이블이 존재하고, 적재되어있는 데이터수가 0이아니라면 이미 WIFI정보를 불러왔다고 판단
        if(getTableRowCount() != 0){
            return false;
        }

        int affectedRow = 0;

        SeoulWifiApiLoader loader = new SeoulWifiApiLoader();
        WifiInfo[] wifiInfoArr = loader.load(GlobalData.seoulWifiKey);
        StringBuilder sb = new StringBuilder();

        //불러온 Wifi정보들을 한번에 쿼리문으로 insert했을때 SQLite에서 정해놓은 양?을 초과해서
        //1000개씩 끊어서 테이블에 insert
        final int queryLimit = 1000;
        WifiInfo wifiInfo = null;

        SQLiteManager.getConnection();
        for (int i = 0; i < loader.getLoadWifiCount(); i+= queryLimit) {

            sb.append("insert into ");
            sb.append(tableName);
            sb.append(" ");
            sb.append("values");

            for (int j = i; j < Math.min(i + queryLimit, loader.getLoadWifiCount()); j++) {
                wifiInfo = wifiInfoArr[j];

                sb.append(" (");

                Field[] fields = wifiInfo.getClass().getDeclaredFields();
                for(Field field : fields){

                    sb.append(" ");
                    try{
                        if(convertToSQLiteDataType(field).equals("TEXT")){

                            String value = field.get(wifiInfo).toString();
                            sb.append("'");
                            int pos = value.indexOf("'", 0);

                            if(pos != -1){
                                //문자열에 이스케이스 시퀀스 처리용
                                //작은 따옴표가 들어있는 정보가 하나있어서
                                //그것만 처리할수있도록 만듬
                                StringBuilder escapeHandler = new StringBuilder(value);
                                while(pos != -1){
                                    escapeHandler.insert(pos, "'");
                                    pos = escapeHandler.indexOf("'", pos + 2);
                                }
                                value = escapeHandler.toString();
                            }

                            sb.append(value);
                            sb.append("'");
                        }
                        else{
                            sb.append(field.get(wifiInfo).toString());
                        }
                    }catch(IllegalAccessException e){
                        throw new RuntimeException(e);
                    }
                    sb.append(",");
                }
                sb.deleteCharAt(sb.length() - 1);

                sb.append("),");
            }
            sb.deleteCharAt(sb.length() - 1);
            sb.append(";");
            SQLiteManager.getStatement(sb.toString());
            affectedRow += SQLiteManager.excuteQueryUpdate();

            sb.delete(0, sb.length());
        }
        SQLiteManager.close();

        return affectedRow == loader.getLoadWifiCount();
    }

    static public int getTableRowCount(){
        int count = 0;
        SQLiteManager.getConnection();
        String sql = "select count(*) from " + tableName + ";";
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            count = rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();
        return count;
    }
    static private String convertToSQLiteDataType(Field field){
        String str = field.getType().toString();

        str =  str.substring(str.lastIndexOf('.') + 1, str.length());

        switch(str){
            case "String" : str = "TEXT";
            break;
            case "double" : str = "REAL";
            break;
        }

        return str;
    }

    //-------------------------------------------------------------------------
    //USER_POS TABLE
    //-------------------------------------------------------------------------
    static public void setUserPos(double lat, double lnt){
        StringBuilder sb = new StringBuilder("update USER_POS set ");
        sb.append("LAT = ");
        sb.append(Double.toString(lat)+ ", ");
        sb.append("LNT = ");
        sb.append(Double.toString(lnt) + ";");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    static public double getUserPosLat(){
        double result = 0.0;
        String sql = "select* from USER_POS;";

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            result = rs.getDouble("LAT");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return result;
    }

    static public double getUserPosLnt(){
        double result = 0.0;
        String sql = "select* from USER_POS;";

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            result = rs.getDouble("LNT");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return result;
    }

    //-------------------------------------------------------------------------
    //HISTORY TABLE
    //-------------------------------------------------------------------------
    static public int getHistoryCount(){
        int count = 0;
        String sql = "select count(*) as historyCount from HISTORY;";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            count = rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return count;
    }

    static public int getHistoryMaxId(){
        int maxId = 0;
        String sql = "select MAX(h.ID) from HISTORY h;";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            maxId = rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return maxId;
    }

    static public void insertHistory(double lat, double lnt){
        StringBuilder sb = new StringBuilder("insert into HISTORY (LAT, LNT, DT) values(");
        sb.append(lat);                 //LAN
        sb.append(",");
        sb.append(lnt);                 //LNT
        sb.append(",");

        String dt = LocalDateTime.now().toString();             //DATETIME
        dt = dt.substring(0, dt.toString().lastIndexOf('.'));
        sb.append("'");
        sb.append(dt);
        sb.append("'");
        sb.append(");");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    static public void deleteHistory(final String id){
        String sql = "DELETE FROM HISTORY WHERE ID= " + id + ";";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    //-------------------------------------------------------------------------
    //BOOKMARK_GROUP Table
    //-------------------------------------------------------------------------
    static public int getBookmarkGroupCount(){
        int count = 0;
        String sql = "select count(*) as bookmarkGroupCount from BOOK_MARK_GROUP;";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            count = rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return count;
    }

    static public void insertBookmarkGroup(String name, String order){
        StringBuilder sb = new StringBuilder("insert into BOOK_MARK_GROUP (NAME, ORDER_NUM, DT, EDIT_DT) values(");

        sb.append("'");
        sb.append(name);
        sb.append("',");

        sb.append(Integer.parseInt(order));
        sb.append(",");

        sb.append("'");
        String dt = LocalDateTime.now().toString();             //DATETIME
        dt = dt.substring(0, dt.toString().lastIndexOf('.'));
        sb.append(dt);
        sb.append("',");

        sb.append("'');");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    static public void updateBookmarkGroup(String id, String name, String order){
        String editDate = LocalDateTime.now().toString();
        editDate = editDate.substring(0, editDate.toString().lastIndexOf('.'));

        StringBuilder sb = new StringBuilder("UPDATE BOOK_MARK_GROUP SET ");
        sb.append("NAME = ");
        sb.append("'");
        sb.append(name);
        sb.append("',");

        sb.append("ORDER_NUM = ");
        sb.append(order);
        sb.append(",");

        sb.append("EDIT_DT = ");
        sb.append("'");
        sb.append(editDate);
        sb.append("' ");

        sb.append("WHERE ID = ");
        sb.append(id);
        sb.append(";");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    static public void deleteBookmarkGroup(String id){
        StringBuilder sb = new StringBuilder("delete from BOOK_MARK_GROUP where ID = ");
        sb.append(id);
        sb.append(";");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    //-------------------------------------------------------------------------
    //BOOKMARK Table
    //-------------------------------------------------------------------------
    static public int getBookmarkCount(){
        int count = 0;
        String sql = "select count(*) as bookmarkCount from BOOK_MARK;";
        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sql);
        SQLiteManager.excuteQueryResultSet();
        ResultSet rs = SQLiteManager.getResultSet();
        try {
            count = rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        SQLiteManager.close();

        return count;
    }

    static public void insertBookmark(String bookmarkName, String wifiName){
        StringBuilder sb = new StringBuilder("insert into BOOK_MARK (BOOK_MARK_NAME, WIFI_NAME, DT) values");
        sb.append("(");

        sb.append("'");
        sb.append(bookmarkName);
        sb.append("'");
        sb.append(",");

        sb.append("'");
        sb.append(wifiName);
        sb.append("'");
        sb.append(",");

        sb.append("'");
        String dt = LocalDateTime.now().toString();
        sb.append(dt.substring(0, dt.toString().lastIndexOf('.')));
        sb.append("'");

        sb.append(");");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    static public void deleteBookmark(String id){
        StringBuilder sb = new StringBuilder("delete from BOOK_MARK where ID = ");
        sb.append("'");
        sb.append(id);
        sb.append("';");

        SQLiteManager.getConnection();
        SQLiteManager.getStatement(sb.toString());
        SQLiteManager.excuteQueryUpdate();
        SQLiteManager.close();
    }

    //-------------------------------------------------------------------------
    //GET QUERY
    //-------------------------------------------------------------------------
    static public String getQuery_NearWifiInfo(){
        //하버사인 공식
        return "SELECT \n" +
                "\tDISTANCE.distance, wd_2.*\n" +
                "FROM \n" +
                "\tWIFI_DATA wd_2,\n" +
                "\t(\n" +
                "\t\tSELECT \n" +
                "\t\t( 6371 * acos( cos( radians(up.LAT) ) * cos( radians(wd.LAT) ) * cos( radians( wd.LNT  ) - radians(up.LNT) ) + sin( radians(up.LAT) ) * sin( radians( wd.LAT  ) ) ) ) AS distance, \n" +
                "\t\twd.X_SWIFI_MGR_NO as id\n" +
                "\t\tFROM \n" +
                "\t\tWIFI_DATA wd, \n" +
                "\t\tUSER_POS up\n" +
                "\t)as DISTANCE\n" +
                "WHERE \n" +
                "\tDISTANCE.id = wd_2.X_SWIFI_MGR_NO \n" +
                "ORDER BY \n" +
                "\tDISTANCE.distance ASC \n" +
                "limit 20\n" +
                ";";
    }

    static public String getQuery_HistoryDesc(){
        return "select* from HISTORY h order by h.ID desc;";
    }

    static public String getQuery_SelectWifiData(String mgrNo){
        return "select* from WIFI_DATA wd WHERE wd.X_SWIFI_MGR_NO = '" + mgrNo + "';";
    }

    static public String getQuery_SelectBookmarkGroupData(String id){
        return "select* from BOOK_MARK_GROUP bmg where ID = '" + id + "';";
    }
    static public String getQuery_GetBookmarkGroupNameList(){return "select NAME from BOOK_MARK_GROUP;";}
    static public String getQuery_BookmarkData(){
        return "select* from BOOK_MARK order by ID;";
    }
}
