package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had420ukrService")
public class Had420ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had420ukrServiceImpl.selectList", param);		
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
			Map<String,Object> param = new HashMap<String,Object>();
			if(deleteList != null) {
				this.delete(deleteList );
				param = deleteList.get(0);
			}
 			if(insertList != null) {
				this.insert(insertList );
				param = insertList.get(0);
			}
			if(updateList != null) {
				this.update(updateList );
				param = updateList.get(0);
			}
			
			if(param != null && ObjUtils.isNotEmpty(param.get("PERSON_NUMB")))	{
				this.update430(param);
			}
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void update430(Map<String, Object> param) throws Exception {
		super.commonDao.update("had420ukrServiceImpl.update430", param);
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had420ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.insert("had420ukrServiceImpl.insert", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had420ukrServiceImpl.update", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectHad420Check(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("had420ukrServiceImpl.selectCheckFamily", param);		
	}
	
	@ExtDirectMethod(group = "human")
	public void saveHad420(Map param, LoginVO loginVo) throws Exception {
		Map<String, Object> checkFamily = (Map<String, Object>) super.commonDao.select("had410ukrServiceImpl.selectCheckFamily", param);
		if(ObjUtils.parseInt(checkFamily.get("CNT")) == 0)	{
			throw new  UniDirectValidateException(this.getMessage("55229;", loginVo)); 
		}
		super.commonDao.update("had420ukrServiceImpl.update420_1", param);	
		super.commonDao.update("had420ukrServiceImpl.update420_2", param);	
		super.commonDao.update("had420ukrServiceImpl.update420_3", param);
	}
}
