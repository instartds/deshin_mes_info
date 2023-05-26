package foren.unilite.modules.com.login;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.ehcache.EhCacheManagerFactoryBean;
import org.springframework.cache.annotation.Cacheable;


public class LoginCacheManager  {
 
	//private static final long serialVersionUID = -7302306805298756490L;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private final Map<String, Object> item = new HashMap<String, Object>();


	@Cacheable(value="sampleMem", key="#gKey")
	public void setCache(String gKey, Map<String, Object> pItem)	{
		this.item.putAll(item);
	}
	
	@Cacheable(value="sampleMem", key="#gKey")
	public Map<String, Object> getCache(String gKey, Map<String, Object> pItem)	{
		return this.item;
	}
    
}