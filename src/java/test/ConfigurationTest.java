package test;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.configuration.AbstractConfiguration;
import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.HierarchicalConfiguration;
import org.apache.commons.configuration.XMLConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.utils.ObjUtils;

public class ConfigurationTest {
	private final static Logger logger = LoggerFactory.getLogger(ConfigurationTest.class);

    private static final String BASE_CONFIG_FILE_NAME = "foren/conf/OmegaPlusBaseConfiguration.xml";
	private static final String CONFIG_FILE_NAME = "foren/conf/sample/OmegaPlusConfigurationSample.xml";
	private static final String GLOBAL_KEY_NAME = "GLOBAL";
	
	private static final String PATH_APPLICATION = "applications.application";
	private static final String PATH_CONTEXT = "contexts.context";

	public static void main(String args[]) throws Exception {
		
		Map<String, Configuration> configMap = buildConfiMap();
		
		for (Entry<String, Configuration> entry : configMap.entrySet()){
		   
		    debug(entry.getKey(), entry.getValue());
		}
	}
	
	public static Map<String,Configuration>  buildConfiMap() throws Exception {
		Map<String,Configuration> configMap = new HashMap<String,Configuration>();
		//AbstractConfiguration.setDefaultListDelimiter(':');
//		CombinedConfiguration configRaw = new CombinedConfiguration();
		
		
		XMLConfiguration baseConfig = new XMLConfiguration(BASE_CONFIG_FILE_NAME);
		List<HierarchicalConfiguration> applicationConfigs = null;
		HierarchicalConfiguration globalConfig =null;
		try {
			XMLConfiguration xmlConfig = new XMLConfiguration(CONFIG_FILE_NAME);
			
			globalConfig = xmlConfig.configurationAt("global");
			applicationConfigs = xmlConfig.configurationsAt(PATH_APPLICATION);
		} catch (Exception e) {
			logger.error("Global Configuration file[{}] loading error.", CONFIG_FILE_NAME, e);
		}
		
		configMap.put(GLOBAL_KEY_NAME, combineConfig( globalConfig, baseConfig));
		if(applicationConfigs != null) {
			for(HierarchicalConfiguration applicationConfig : applicationConfigs) {
				String applicationID = applicationConfig.getString("[@id]");
	
				Configuration config = combineConfig( applicationConfig, globalConfig, baseConfig);
				
				configMap.put(GLOBAL_KEY_NAME+"."+applicationID, config );
				List<HierarchicalConfiguration> contextConfigs = applicationConfig.configurationsAt(PATH_CONTEXT);
				applicationConfig.clearTree(PATH_CONTEXT);
				if(contextConfigs != null && contextConfigs.size() > 0 ) {
					for(HierarchicalConfiguration contextConfig : contextConfigs) {
						String contextID = contextConfig.getString("[@id]");
						Configuration configi = combineConfig( contextConfig, applicationConfig, globalConfig, baseConfig);
						//debug("Context " + applicationID + "." + contextID , config);
						configMap.put(GLOBAL_KEY_NAME+"."+applicationID+"." + contextID , configi );
					}
				} 
			}
		}
		return configMap;
	}
	
	public static Configuration combineConfig( AbstractConfiguration ... args) {
		// 먼저 추가된것이 우선 값이 됨
		// CombinedConfiguration  를 사용 하면 중복 되는 값이 다남음.
		CompositeConfiguration  config = new CompositeConfiguration ();
		for(AbstractConfiguration arg : args) {
			if(arg != null) {
				config.addConfiguration(arg);
			}
		}
		if(config != null) {
			config.clearProperty("[@id]");
		}
		return config;
	}
	
	public static void debug(String name, Configuration config) {
		TestUtil.out("========="+name+"============");
		if(config != null) {
			Iterator<String> itr = config.getKeys();
			while (itr.hasNext()) {
				String key = itr.next();
				Object prop = config.getList(key);
				TestUtil.out( key, "=", prop);
			}
		}
	}
	
}
