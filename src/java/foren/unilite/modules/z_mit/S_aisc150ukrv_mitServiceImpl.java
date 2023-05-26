package foren.unilite.modules.z_mit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "s_aisc150ukrv_mitService" )
public class S_aisc150ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
   
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return  super.commonDao.list("s_aisc150ukrv_mitServiceImpl.selectList", param);
    }
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectLogList( Map param, LoginVO user ) throws Exception {
    	String keyValue = this.getLogKey();
    	param.put("KEY_VALUE", keyValue);
    	Map<String, Object> r = (Map<String, Object>) super.commonDao.select("s_aisc150ukrv_mitServiceImpl.recalulate", param);
    	if(r != null && ObjUtils.isNotEmpty(r.get("errorDesc")) )	{
    		String errorDesc = ObjUtils.getSafeString(r.get("errorDesc"));
    		throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
    	}
        return  super.commonDao.list("s_aisc150ukrv_mitServiceImpl.selectLogList", param);
    }
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
    	if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			String keyValue = this.getLogKey();
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert(insertList, user, keyValue);
			if(updateList != null) this.update(updateList, user, keyValue);	
			
			Map<String, Object> param = new HashMap();
			param.put("KEY_VALUE", keyValue);
			param.put("S_USER_ID", user.getUserID());
			param.put("S_LANG_CODE", user.getLanguage());
	    	Map<String, Object> r = (Map<String, Object>) super.commonDao.select("s_aisc150ukrv_mitServiceImpl.save", param);
	    	if(r != null && ObjUtils.isNotEmpty(r.get("errorDesc")) )	{
	    		String errorDesc = ObjUtils.getSafeString(r.get("errorDesc"));
	    		throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
	    	}
		}
		paramList.add(0, paramMaster);
		return  paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return 0;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return 0;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insert( List<Map> paramList, LoginVO user, String keyValue ) throws Exception {
		for(Map param : paramList )	{			 
			 param.put("COMP_CODE", user.getCompCode());
			 param.put("KEY_VALUE", keyValue);
			 param.put("OPR_FLAG", "N");
			 super.commonDao.update("s_aisc150ukrv_mitServiceImpl.insertDetail", param);
		}
        return 0;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer update( List<Map> paramList, LoginVO user,String keyValue ) throws Exception {
    	for(Map param : paramList )	{			 
			 param.put("COMP_CODE", user.getCompCode());
			 param.put("KEY_VALUE", keyValue);
			 param.put("OPR_FLAG", "U");
			 super.commonDao.update("s_aisc150ukrv_mitServiceImpl.insertDetail", param);
		}
        return 0;
    }
    
}
