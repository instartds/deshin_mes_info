package foren.unilite.modules.busmaintain.gme;

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

@Service("gme300ukrvService")
public class Gme300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gme300ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map>)dataListMap.get("data");		
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if(insertList != null) this.insert(insertList);
			if(updateList != null) this.update(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  insert(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
		
			if(param.get("DIAGNOSIS") == null 	|| ObjUtils.isEmpty(param.get("DIAGNOSIS"))) 	param.put("DIAGNOSIS",0.0);
			if(param.get("MAINTENANCE") == null || ObjUtils.isEmpty(param.get("MAINTENANCE"))) 	param.put("MAINTENANCE",0.0);
			if(param.get("ARC") == null 		|| ObjUtils.isEmpty(param.get("ARC"))) 			param.put("ARC",0.0);
			if(param.get("DUTY") == null 		|| ObjUtils.isEmpty(param.get("DUTY"))) 		param.put("DUTY",0.0);
			if(param.get("CNG") == null 		|| ObjUtils.isEmpty(param.get("CNG"))) 			param.put("CNG",0.0);
				
			super.commonDao.update("gme300ukrvServiceImpl.insert", param);	
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  update(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gme300ukrvServiceImpl.update", param);
		}
		return 0;
	}


}
