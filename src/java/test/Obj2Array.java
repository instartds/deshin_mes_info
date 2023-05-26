package test;

import java.util.HashMap;
import java.util.Map;

import foren.framework.utils.ArrayUtil;
import foren.framework.utils.ObjUtils;

public class Obj2Array {
	public static void main(String[] args)  throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		String[] colnames = {"COL_1","COL_2"};
		String[] colnames2 = {"COL_1","COL_2"};
		param.put("A1", colnames);
		param.put("CUSTOM_TYPE", "A");
		param.put("A3", "string2array");
		param.put("A5", colnames2);
		
		param = ArrayUtil.object2arryaInMap(param,"CUSTOM_TYPE");
		
//		conv2array(param,"A3");
//		conv2array(param,"A4");
		
		out("Colnames");
		out(ObjUtils.getSafeString(param));
		
	}
	
//	public static Map object2arryaInMap(Map param, String key) {
//		if(param!= null && param.containsKey(key)) {
//			Object o = param.get(key);			
//			param.put(key, ArrayUtil.toArray(o));
//		}
//		return param;
//	}
	
	
	public static void out(String str) {
		System.out.print(str);
	}
}
