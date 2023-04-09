package SeoulWifiApi;


import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

class WifiInfo{
    public String X_SWIFI_MGR_NO;	             //관리번호
    public String X_SWIFI_WRDOFC;	            //자치구
    public String X_SWIFI_MAIN_NM;	            //와이파이명
    public String X_SWIFI_ADRES1;	            //도로명주소
    public String X_SWIFI_ADRES2;	            //상세주소
    public String X_SWIFI_INSTL_FLOOR;	        //설치위치(층)
    public String X_SWIFI_INSTL_TY;	            //설치유형
    public String X_SWIFI_INSTL_MBY;	        //설치기관
    public String X_SWIFI_SVC_SE;	            //서비스구분
    public String X_SWIFI_CMCWR;	            //망종류
    public String X_SWIFI_CNSTC_YEAR;	        //설치년도
    public String X_SWIFI_INOUT_DOOR;	        //실내외구분
    public String X_SWIFI_REMARS3;	            //wifi접속환경
    public double LAT;	                        //Y좌표
    public double LNT;	                        //X좌표
    public String WORK_DTTM;	                //작업일자
}

public class SeoulWifiApiLoader{
    private int insertIdx = 0;
    private int loadTotalCount = 0;
    //API에서 정해놓은 한번에 로드 가능한 갯수.
    final static public int loadPageLimit = 1000;

    public WifiInfo[] load(final String apiKey){
        //Load할 총 Wifi갯수를 먼저 구한다.
        loadTotalCount =  parseJsonWifiCount(getJsonData(apiKey, 0, 1));

        //모든 WIFI정보들을 가져온다.
        WifiInfo[] loadWifiInfoArr = new WifiInfo[loadTotalCount];
        for (int i = 0; i < loadTotalCount; i += loadPageLimit) {
            parseJsonWifiData(getJsonData(apiKey, i, Math.min(i + loadPageLimit - 1, loadTotalCount)), loadWifiInfoArr);
        }

        return loadWifiInfoArr;
    }

    public int getLoadWifiCount(){
        return loadTotalCount;
    }

    //서울시 공공 WIFI API가 제공하는 규칙에 맞는 형식으로  (endPage - startPage)갯수만큼 wifi정보를 json포맷의 스트링 형식으로 가져온다.
    private String getJsonData(final String apiKey, final int startPage, final int endPage) {
        StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088/");   //url
        urlBuilder.append(apiKey + "/");                                                    //key
        urlBuilder.append("json/");                                                         //file type
        urlBuilder.append("TbPublicWifiInfo/");                                             //service
        urlBuilder.append(startPage + "/");                                                 //start page
        urlBuilder.append(endPage + "/");                                                   //end page

        URL url = null;
        HttpURLConnection connection = null;
        StringBuilder sb = new StringBuilder();

        try {
            url = new URL(urlBuilder.toString());

            connection = (HttpURLConnection)url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Content-type", "application/json");

            final int responseCode = connection.getResponseCode();
            BufferedReader br = null;
            if(200 <= responseCode && responseCode <= 300){
                br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            }
            else{
                br = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
            }

            String line;
            while((line = br.readLine()) != null){
                sb.append(line);
            }
            br.close();
            connection.disconnect();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }


        return sb.toString();
    }

    //가져온 json포맷에서 서울시 공공 WIFI API가 제공하는 WIFI의 갯수를 가져온다.
    private int parseJsonWifiCount(final String jsonStr){
        JsonElement jsonElement = JsonParser.parseString(jsonStr).getAsJsonObject().get("TbPublicWifiInfo");
        //Wifi정보 총 갯수.
        return jsonElement.getAsJsonObject().get("list_total_count").getAsInt();
    }

    //가져온 json포맷에서 서울시 공공 WIFI API가 제공하는 WIFI정보를 가져와서 멤버로 저장한다.
    private void parseJsonWifiData(final String jsonStr, WifiInfo[] loadWifiInfoArray){
        JsonElement jsonElement = JsonParser.parseString(jsonStr).getAsJsonObject().get("TbPublicWifiInfo");

        //Load한 Wifi정보 json배열
        JsonArray jsonArray = jsonElement.getAsJsonObject().getAsJsonArray("row");

        JsonObject wifiInfoJsonObj = null;

        for (int i = 0; i < jsonArray.size(); i++, insertIdx++) {
            wifiInfoJsonObj = jsonArray.get(i).getAsJsonObject();

            WifiInfo wifiInfo = new WifiInfo();
            wifiInfo.X_SWIFI_MGR_NO = wifiInfoJsonObj.get("X_SWIFI_MGR_NO").getAsString();
            wifiInfo.X_SWIFI_WRDOFC = wifiInfoJsonObj.get("X_SWIFI_WRDOFC").getAsString();
            wifiInfo.X_SWIFI_MAIN_NM = wifiInfoJsonObj.get("X_SWIFI_MAIN_NM").getAsString();
            wifiInfo.X_SWIFI_ADRES1 = wifiInfoJsonObj.get("X_SWIFI_ADRES1").getAsString();
            wifiInfo.X_SWIFI_ADRES2 = wifiInfoJsonObj.get("X_SWIFI_ADRES2").getAsString();
            wifiInfo.X_SWIFI_INSTL_FLOOR = wifiInfoJsonObj.get("X_SWIFI_INSTL_FLOOR").getAsString();
            wifiInfo.X_SWIFI_INSTL_TY = wifiInfoJsonObj.get("X_SWIFI_INSTL_TY").getAsString();
            wifiInfo.X_SWIFI_INSTL_MBY = wifiInfoJsonObj.get("X_SWIFI_INSTL_MBY").getAsString();
            wifiInfo.X_SWIFI_SVC_SE = wifiInfoJsonObj.get("X_SWIFI_SVC_SE").getAsString();
            wifiInfo.X_SWIFI_CMCWR = wifiInfoJsonObj.get("X_SWIFI_CMCWR").getAsString();
            wifiInfo.X_SWIFI_CNSTC_YEAR = wifiInfoJsonObj.get("X_SWIFI_CNSTC_YEAR").getAsString();
            wifiInfo.X_SWIFI_INOUT_DOOR = wifiInfoJsonObj.get("X_SWIFI_INOUT_DOOR").getAsString();
            wifiInfo.X_SWIFI_REMARS3 = wifiInfoJsonObj.get("X_SWIFI_REMARS3").getAsString();
            wifiInfo.LAT = wifiInfoJsonObj.get("LAT").getAsDouble();
            wifiInfo.LNT = wifiInfoJsonObj.get("LNT").getAsDouble();
            wifiInfo.WORK_DTTM = wifiInfoJsonObj.get("WORK_DTTM").getAsString();
            loadWifiInfoArray[insertIdx] = wifiInfo;
        }
    }
}
