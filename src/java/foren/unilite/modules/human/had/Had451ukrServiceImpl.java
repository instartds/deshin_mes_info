package foren.unilite.modules.human.had;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("had451ukrService")
public class Had451ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had451ukrServiceImpl.selectList", param);		
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) this.delete(deleteList );
			if(insertList != null) this.insert(insertList );
			if(updateList != null) this.update(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had451ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			Map rMap = (Map)super.commonDao.select("had451ukrServiceImpl.getSeq", param);	
			param.put("SEQ_NO", rMap.get("SEQ_NO"));
			
			super.commonDao.update("had451ukrServiceImpl.insert", param);
			
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had451ukrServiceImpl.update", param);
		}
		return paramList;		
	}
}
//