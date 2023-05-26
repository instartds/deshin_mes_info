package test;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

public class JackJsonTest {

	public static void main(String[] args)  throws Exception{
		ObjectMapper mapper = new ObjectMapper();
		String json1 = "{name:'ksj',list:[1,2,3]}";
		Map obj = new HashMap();
		obj.put("a","Apple");
		//out(convertValue(mapper, json1, HashMap.class).toString());
		 out(mapper.writeValueAsString(obj));
	}


	public static void out(String str) {
		System.out.print(str);
	}
	
	/**
	 * Converts one object into another.
	 * 
	 * @param object the source
	 * @param clazz the type of the target
	 * @return the converted object
	 */
	public static <T> T convertValue(ObjectMapper mapper, final Object object, final Class<T> clazz) {
		return mapper.convertValue(object, clazz);
	}
}
