package api.rest.utils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.joda.time.DateTime;

import foren.framework.utils.JsonUtils;
import foren.unilite.com.constants.Unilite;

public class RestUtils {
    
    public StringBuffer getContextListJson() {
        return JsonUtils.toJsonStr(Unilite.getContextList());
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map getParameterMap( HttpServletRequest request ) {
        
        Map parameterMap = new HashMap();
        Enumeration enums = request.getParameterNames();
        while (enums.hasMoreElements()) {
            String paramName = (String)enums.nextElement();
            String[] parameters = request.getParameterValues(paramName);
            
            // Parameter가 배열일 경우
            if (parameters.length > 1) {
                parameterMap.put(paramName, parameters);
                // Parameter가 배열이 아닌 경우
            } else {
                parameterMap.put(paramName, parameters[0]);
            }
        }
        
        return parameterMap;
    }
    
    public String makeExcelJobID() {
        StringBuffer jobId = new StringBuffer(20);
        DateTime today = new DateTime();
        jobId.append(today.toString("yyyyMMddHHmmss.SSS"));
        jobId.append(Math.round(Math.random() * 10000));
        return jobId.toString();
    }
    
    public String makeJobID() {
        StringBuffer jobId = new StringBuffer(20);
        DateTime today = new DateTime();
        jobId.append(today.toString("yyyyMMddHHmmssSSS"));
        jobId.append(Math.round(Math.random() * 10000));
        return jobId.toString();
    }
    
    /**
     * Map 타입 -> Json 타입으로 변환
     * 
     * @param map
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String mapToJson( Map map ) {
        return mapToJson(map, false);
    }
    
    /**
     * Map 타입 -> Json 타입으로 변환
     * 
     * @param map
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String mapToJson( Map map, boolean indent ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        if (indent) objMapper.configure(SerializationConfig.Feature.INDENT_OUTPUT, true);
        
        try {
            sb.append(objMapper.writeValueAsString(map));
        } catch (JsonGenerationException e) {
            e.printStackTrace();
            return "";
        } catch (JsonMappingException e) {
            e.printStackTrace();
            return "";
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
        
        return sb.toString();
    }
    
    /**
     * Json 타입 -> Map 타입으로 변환
     * 
     * @param json
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public Map jsonToMap( String json ) {
        JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(json));
        
        Map<String, Object> map = null;
        
        try {
            map = jsonToMap(jsonObj);
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
        
        return map;
    }
    
    /**
     * json Object를 Map으로 변경
     * 
     * @param object
     * @return
     * @throws JSONException
     */
    @SuppressWarnings( "unchecked" )
    public Map<String, Object> jsonToMap( JSONObject object ) throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        
        Iterator<String> keysItr = object.keys();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);
            
            if (value instanceof JSONArray) {
                System.out.println("JSONArray :: ");
                value = jsonToList((JSONArray)value);
            } else if (value instanceof JSONObject) {
                System.out.println("JSONObject :: ");
                value = jsonToMap((JSONObject)value);
            }
            
            map.put(key, value);
            map.put("S_USER_ID", "WebService");
        }
        
        return map;
    }
    
    /**
     * json Object를 List로 변경
     * 
     * @param array
     * @return
     * @throws JSONException
     */
    public List<Object> jsonToList( JSONArray array ) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for (int i = 0; i < array.size(); i++) {
            Object value = array.get(i);
            
            if (value instanceof JSONArray) {
                value = jsonToList((JSONArray)value);
            } else if (value instanceof JSONObject) {
                value = jsonToMap((JSONObject)value);
            }
            
            list.add(value);
        }
        
        return list;
    }
    
    /**
     * 메시지를 Map 으로 만들어 줌.
     * 
     * @param code
     * @param msg
     * @return
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map convMessage( String msg ) {
        Map map = new HashMap();
        map.put("status", "0");
        map.put("message", msg);
        
        return map;
    }
    
    /**
     * Error 메시지를 Map 으로 만들어 줌.
     * 
     * @param code
     * @param msg
     * @return
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map convErrorMessage( String code, String msg ) {
        Map map = new HashMap();
        map.put("status", "1");
        map.put("message", msg);
        
        return map;
    }
    
    /**
     * sDateNTimeForm 형식의 현재 시각 문자열을 얻는다. 현재시각 Formatting 문자열(년도:yyyy 월:MM 일:dd 시:HH 분:mm 초:ss 밀리:SSS)<br>
     * example - yyyyMMddHHmmss, yyyy년 MM월 dd일 HH시 mm분 ss초
     * 
     * @param sDateNTimeForm 현재시각 Formatting 문자열
     * @return 현재 시간 문자열
     */
    public static String getDateByFormat( String sDateNTimeForm ) {
        Calendar Today = new GregorianCalendar();
        SimpleDateFormat sdf = new SimpleDateFormat(sDateNTimeForm);
        String sDateNTime = sdf.format(Today.getTime());
        
        return sDateNTime;
    }
    
    public String getIFNo() {
        return getDateByFormat("yyyyMMddHHmmssSSS");
    }
    
    public String errParse(String errMsg) {
        System.out.println(errMsg);
        // 중복오류
        if(errMsg.indexOf("PRIMARY KEY 제약 조건") > 0) {
            //System.out.println("시작 :: " + errMsg.indexOf("PRIMARY KEY 제약 조건"));
            //System.out.println("입니다." + errMsg.indexOf("입니다."));
            //System.out.println("문자열 :: " + errMsg.substring(errMsg.indexOf("PRIMARY KEY 제약 조건"), errMsg.indexOf("입니다.") + 6));
            
            return errMsg.substring(errMsg.indexOf("PRIMARY KEY 제약 조건"), errMsg.indexOf("입니다.") + 4);
        } else if(errMsg.indexOf("문자열이나") > 0) {
            return errMsg.substring(errMsg.indexOf("문자열이나"), errMsg.indexOf("잘립니다.") + 5);
        } else if(errMsg.indexOf("테이블 '") > 0) {
            return errMsg.substring(errMsg.indexOf("테이블 '"), errMsg.indexOf("실패했습니다.") + 6);
        } else if(errMsg.indexOf("열 이름 '") > 0) {
            return errMsg.substring(errMsg.indexOf("열 이름 '"), errMsg.indexOf("잘못되었습니다.") + 7);
        } else if(errMsg.indexOf("키워드 '") > 0) {
            return errMsg.substring(errMsg.indexOf("키워드 '"), errMsg.indexOf("잘못되었습니다.") + 7);
        } else if(errMsg.indexOf("데이터 형식") > 0) {
            return errMsg.substring(errMsg.indexOf("데이터 형식"), errMsg.indexOf("실행하십시오.") + 7);
        }
        
        
        return errMsg;
    }
    
    /**
     * Error 메시지를 단순화
     * 
     * @param errMsg
     * @return
     */ 
    public String errorMsg(String errMsg) {
        String[] errorMsg = null;
        String[] msg = null;
        String eMsg = null;
        
        try {
            errorMsg = errMsg.split("###");                    
            msg = errorMsg[1].split(": ");
            eMsg = msg[2].toString().replace("\n", "");
        } catch(Exception e) {
            eMsg = errMsg;
        }
        
        return eMsg;
    }
}
