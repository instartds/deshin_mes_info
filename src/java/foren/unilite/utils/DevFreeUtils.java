package foren.unilite.utils;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.joda.time.DateTime;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * <pre>
 * 개발 편의상 수정할 수 있는 Utility Class
 * </pre>
 * 
 * @author 박종영
 */
public class DevFreeUtils {
    /**
     * Error 메시지를 단순화
     * 
     * @param errMsg
     * @return
     */
    public static String errorMsg( String errMsg ) {
        String[] errorMsg = null;
        String[] msg = null;
        String eMsg = null;
        
        try {
            errorMsg = errMsg.split("###");
            msg = errorMsg[1].split(": ");
            eMsg = msg[2].toString().replace("\n", "");
        } catch (Exception e) {
            eMsg = errMsg;
        }
        
        return eMsg;
    }
    
    /**
     * <pre>
     * 중복되지 않는 난수 생성.
     * </pre>
     * 
     * @return
     */
    public static String makeJobID() {
        StringBuffer jobId = new StringBuffer(20);
        DateTime today = new DateTime();
        jobId.append(today.toString("yyyyMMddHHmmssSSS"));
        jobId.append(Math.round(Math.random() * 10000));
        return jobId.toString();
    }
    
    /**
     * <pre>
     * 객체를 받아 String 형으로 반환
     * 추가적으로 확장할 것.
     * </pre>
     * 
     * @param obj
     * @param defValue
     * @return
     */
    public static String getOrDefault( Object obj, String defValue ) {
        
        if (obj == null) return defValue;
        
        try {
            if (obj instanceof String) {
                return (String)obj;
            } else if (obj instanceof Integer) {
                return String.valueOf(( (Integer)obj ).intValue());
            } else if (obj instanceof Float) {
                return String.valueOf(( (Float)obj ).floatValue());
            } else if (obj instanceof Double) {
                return String.valueOf(( (Double)obj ).doubleValue());
            } else if (obj instanceof BigDecimal) {
                return String.valueOf(( (BigDecimal)obj ).doubleValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            return defValue;
        }
        
        return defValue;
    }
    
    /**
     * <pre>
     * 객체를 받아 int 형으로 반환
     * 추가적으로 확장할 것.
     * </pre>
     * 
     * @param obj
     * @param defValue
     * @return
     */
    public static int getOrDefault( Object obj, int defValue ) {
        
        if (obj == null) return defValue;
        
        try {
            if (obj instanceof String) {
                return Integer.parseInt((String)obj);
            } else if (obj instanceof Integer) {
                return ( (Integer)obj ).intValue();
            } else if (obj instanceof Float) {
                return ( (Float)obj ).intValue();
            } else if (obj instanceof Double) {
                return ( (Double)obj ).intValue();
            } else if (obj instanceof BigDecimal) {
                return ( (BigDecimal)obj ).intValue();
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            return defValue;
        }
        
        return defValue;
    }
    
    /**
     * <pre>
     * 문자열에 해당하는 길이만큼 앞쪽에 '0' 를 채움
     * </pre>
     * 
     * @param text 문자열
     * @param size 전체길이
     * @return
     */
    public static String addZero( String text, int size ) {
        String retValue = null;
        if (text.length() < size) {
            retValue = String.format("%0" + String.valueOf(size - text.length()) + "d%s", 0, text);
        } else {
            retValue = text;
        }
        return retValue;
    }
    
    /**
     * <pre>
     * 특수문자가 들어가더라도 정상적으로 Replace All 하는 함수.
     * </pre>
     * 
     * @param original 전체문자열
     * @param regex 대상문자열
     * @param replacement 변경문자열
     * @return
     */
    public static String replaceAll( String original, String regex, String replacement ) {
        regex = regex.replaceAll("(\\p{Punct})", "\\\\$1");
        replacement = replacement.replaceAll("(\\p{Punct})", "\\\\$1");
        return original.replaceAll(regex, replacement);
    }
    
    /**
     * Map 타입 -> Json 타입으로 변환
     * 
     * @param map
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public static String mapToJson( Map map ) {
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
    public static String mapToJson( Map map, boolean indent ) {
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
    public static Map jsonToMap( String json ) {
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
    public static Map<String, Object> jsonToMap( JSONObject object ) throws JSONException {
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
    public static List<Object> jsonToList( JSONArray array ) throws JSONException {
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
    
}
