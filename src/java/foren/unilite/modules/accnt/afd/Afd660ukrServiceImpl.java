package foren.unilite.modules.accnt.afd;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("afd660ukrService")
public class Afd660ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return (List)super.commonDao.list("afd660ukrServiceImpl.selectList", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteDetail")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertDetail")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateDetail")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteDetail(deleteList, user);
				if(insertList != null) this.insertDetail(insertList, user);
				if(updateList != null) this.updateDetail(updateList, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	 
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
		public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param : paramList )	{			 
				
				 super.commonDao.update("afd660ukrServiceImpl.insertDetail", param);
			}
			
			return 0;
		}	
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
		public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
			for(Map param :paramList )	{	
				 
				 super.commonDao.update("afd660ukrServiceImpl.updateDetail", param);
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			for(Map param :paramList )	{	
				super.commonDao.update("afd660ukrServiceImpl.deleteDetail", param);
			 }
			 return 0;
	}
    
}
