package foren.unilite.modules.busevaluation.grh;

import java.util.ArrayList;
import java.util.HashMap;
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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("grh100ukrvService")
public class Grh100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busevalution", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("grh100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busevalution")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map<String, Object> rMap;
//		
//		if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM")))	{
//			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", dataMaster);
//			dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
//		}else {
//			super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
//		}		
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
			if(deleteList != null) this.deleteDetail(deleteList, user,paramMaster);
			if(insertList != null) this.insertDetail(insertList, user,paramMaster);
			if(updateList != null) this.updateDetail(updateList, user,paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "busevalution")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("grh100ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("BASE_YEAR", dataMaster.get("BASE_YEAR"));
					 super.commonDao.update("grh100ukrvServiceImpl.insertDetail", param);
					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "busevalution")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("grh100ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("BASE_YEAR", dataMaster.get("BASE_YEAR"));
					 super.commonDao.insert("grh100ukrvServiceImpl.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "busevalution")
	//@ExtDirectMethod(group = "busevalution", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("grh100ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("BASE_YEAR", dataMaster.get("BASE_YEAR"));
					 try {
						 super.commonDao.delete("grh100ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
}
