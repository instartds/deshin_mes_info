package api.foren.pda.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JsonUtils {
	
	/**
	 * json 字符串转map
	 */
	public static Map jsonToMap(Object object) {
	    Map data = new HashMap();
	    JSONObject jsonObject = JSONObject.fromObject(object);
	    Iterator ite = jsonObject.keys();
	    while (ite.hasNext()) {
	        String key = ite.next().toString();
	        String value = jsonObject.get(key).toString();
	        data.put(key, value);
	    }
	    return data;
	}
	/**
	 * json转map
	 */
	public static Map parseJSON2Map(String jsonStr){
        //最外层解析  
        if(jsonStr!=null&&jsonStr.startsWith("{")&&jsonStr.endsWith("}")){
            Map<String, Object> map = new HashMap<String, Object>();  
            
            JSONObject json = JSONObject.fromObject(jsonStr);  
            for(Object k : json.keySet()){
                
                Object v = json.get(k);   
                //如果内层还是数组的话，继续解析  
                if(v instanceof JSONArray){  
                    List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();  
                    Iterator<JSONObject> it = ((JSONArray)v).iterator();  
                    while(it.hasNext()){  
                        JSONObject json2 = it.next();  
                        list.add(parseJSON2Map(json2.toString()));  
                    }  
                    map.put(k.toString(), list);  
                } else {  
                    Map<String, Object> m = parseJSON2Map(v.toString());
                    if(m==null)
                        map.put(k.toString(), v);
                    else 
                        map.put(k.toString(), m);  
                }  
            }  
            return map;  
        }else{
            return null;
        }
    } 
	
	/**
	 * map转json
	 */
	public static String parseMap2JSON(Map map){
		JSONObject jsonObject = JSONObject.fromObject(map);
		if(jsonObject == null){
			return null;
		}
		return jsonObject.toString();
	}
}
