package test;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.constants.Unilite;




public class ConfigTest {
    private final static Logger logger = LoggerFactory.getLogger(ConfigTest.class);

    public static void main(String args[]) throws Exception {
//       String key1 ="Globals.Context.list";
//       String key2="App.Context";
//       String[] contexts = ConfigUtil.getStringArrayValue(Unilite.CONTEXT_LIST_KEY);
//       for(String context:contexts) {
//    	   out(">>", context, ":", ConfigUtil.getString("Context."+context+".name"),",", ConfigUtil.getString("Context."+context+".path"));
//       }
//       out(Unilite.CONTEXT_LIST_KEY,": " , ConfigUtil.getStringArrayValue(Unilite.CONTEXT_LIST_KEY));
       out("license.modules: " , ConfigUtil.getStringArrayValue("license.modules"));
       out("MainUrl:", Unilite.getMainUrl());
       
       
       out("server.list",": " , Unilite.getContextList() );
       out("server.isDevelopServer",": ",ConfigUtil.getBooleanValue("system.isDevelopServer",false) );
       List<Object> t = ConfigUtil.getList("servers.server[@name]");
       out("servers.server",": " , t);
       
       //out(JsonUtils.toJsonStr(Unilite.getContextList()));
    }
    
	public static void out(Object ... args) {
		for(Object obj : args) {
			System.out.print(ObjUtils.getSafeString(obj));
		}
		System.out.println();
	}
}