package foren.unilite.modules.bussafety.gac;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;

@Service("gac120ukrvService")
public class Gac120ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gac120ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "bussafety")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map>)dataListMap.get("data");		
					
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if(deleteList != null) this.delete(deleteList);
			if(insertList != null) this.insert(insertList);
			if(updateList != null) this.update(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(group = "bussafety",value = ExtDirectMethodType.STORE_MODIFY)
	public Integer  insert(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			Map<String, Object> rMap = (Map<String, Object>) super.commonDao.queryForObject("gac120ukrvServiceImpl.insert", param);	
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "bussafety",value = ExtDirectMethodType.STORE_MODIFY)
	public Integer  update(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gac120ukrvServiceImpl.update", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "bussafety",value = ExtDirectMethodType.STORE_MODIFY)
	public Integer  delete(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gac120ukrvServiceImpl.delete", param);	
		}
		return 0;
	}


}
