package foren.unilite.modules.busmaintain.gre;

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

@Service("gre100ukrvService")
public class Gre100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gre100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.FORM_LOAD)
	public Object  select(Map param) throws Exception {	
		return  super.commonDao.select("gre100ukrvServiceImpl.select", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveMasterAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteDetail(deleteList);			
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public List<Map<Object, String>>  selectDetailList(Map param) throws Exception {	
		return  super.commonDao.list("gre100ukrvServiceImpl.selectDetailList", param);
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  delete(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre100ukrvServiceImpl.delete", param);	
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Object  checkDetail(Map param) throws Exception {
		return  super.commonDao.select("gre100ukrvServiceImpl.checkDetail", param);
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map<String, Object> rMap;
		
		if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM")))	{
			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", dataMaster);
			dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
		}else {
			super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
		}
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");		
					for(Map tmp : insertList)	{
						tmp.put("REQUEST_NUM", dataMaster.get("REQUEST_NUM"));
					}
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			
			if(deleteList != null) this.deleteDetail(deleteList);
			if(insertList != null) this.insertDetail(insertList);
			if(updateList != null) this.updateDetail(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  insertDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			super.commonDao.update("gre100ukrvServiceImpl.insertDetail", param);	
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  updateDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre100ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  deleteDetail(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gre100ukrvServiceImpl.deleteDetail", param);	
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "bussafety" , value = ExtDirectMethodType.FORM_POST)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult  insertMaster(Gre100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
			param.setS_COMP_CODE(user.getCompCode());
			param.setS_USER_ID(user.getUserID());
			Map<String, Object> rMap = null;
			if(ObjUtils.isEmpty(param.getREQUEST_NUM()))	{
				rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", param);
			}else {
				super.commonDao.update("gre100ukrvServiceImpl.update", param);
			}
			ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			if(ObjUtils.isEmpty(param.getREQUEST_NUM()))	{
				extResult.addResultProperty("REQUEST_NUM", ObjUtils.getSafeString(rMap.get("REQUEST_NUM")));
			}
		return extResult;
	}
	
	@ExtDirectMethod(group = "busmaintain")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}

}
