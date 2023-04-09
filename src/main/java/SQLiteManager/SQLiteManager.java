package SQLiteManager;

import java.sql.*;

public class SQLiteManager{

    static private Connection connection = null;
    static private PreparedStatement statement = null;
    static private ResultSet rs = null;

    final static private String className = "org.sqlite.JDBC";
    final static private String url = "jdbc:sqlite:WIFI_DB.db";

    static public void getConnection(){
        if(null != connection){
            return;
        }

        try {
            Class.forName(className);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        try {
            connection = DriverManager.getConnection(url);
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }
    }

    static public PreparedStatement getStatement(final String sql){
        if(null == connection){
            return statement;
        }

        closeStatement();

        try {
            statement = connection.prepareStatement(sql);
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }

        return statement;
    }

    static public PreparedStatement getStatement(final String sql, String[] param){
        if(null == connection){
            return statement;
        }

        closeStatement();

        try {
            statement = connection.prepareStatement(sql);

            for (int i = 0; i < param.length; i++) {
                statement.setString(i, param[i]);
            }
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }

        return statement;
    }

    static public ResultSet getResultSet(){return rs;}

    //결괏값 ResultSet을 반환하는 Query문을 실행시킵니다.
    static public boolean excuteQueryResultSet(){
        if(null == statement){
            return false;
        }

        try {
            rs = statement.executeQuery();
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }

        return true;
    }

    //결괏값 boolean을 반환하는 Query를 실행시킵니다.
    static public boolean excuteQuery(){
        if(null == statement){
            return false;
        }

        try {
            statement.execute();
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }

        return true;
    }

    //영향을 받은 row의 갯수 int를 반환하는 Query를 실행시킵니다.
    static public int excuteQueryUpdate(){
        if(null == statement){
            return -1;
        }

        int row = 0;
        try {
            row = statement.executeUpdate();
        } catch (SQLException e) {
            close();
            throw new RuntimeException(e);
        }

        return row;
    }

    static public void close() {
        boolean error = false;
        SQLException[] exceptionArr = {null, null, null};

        try {
            if(null != rs && !rs.isClosed()){
                rs.close();
                rs = null;
            }
        } catch (SQLException e) {
            exceptionArr[0] = e;
            error = true;
        }

        try {
            if(null != statement && !statement.isClosed()){
                statement.close();
                statement = null;
            }
        } catch (SQLException e) {
            exceptionArr[1] = e;
            error = true;
        }

        try {
            if(null != connection && !connection.isClosed()){
                connection.close();
                connection = null;
            }
        } catch (SQLException e) {
            exceptionArr[2] = e;
            error = true;
        }

        if(error){
            for(SQLException e : exceptionArr){
                if(null != e){
                    throw new RuntimeException(e);
                }
            }
        }
    }

    static private void closeStatement(){
        try {
            if(null != statement && !statement.isClosed()){
                statement.close();
                statement = null;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}