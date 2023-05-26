package foren.unilite.modules.matrl.map;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("map080ukrvService")
public class Map080ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 지불예정명세서등록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("map080ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 
	 * MAX 차수관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  getCollectDay(Map param) throws Exception {	
		
		return  super.commonDao.select("map080ukrvServiceImpl.getCollectDay", param);
	}
	/**
	 * 지불예정명세서등록 차수관련
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getNewCollectDay(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("map080ukrvServiceImpl.getNewCollectDay", param);
		
	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
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
			if(deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			
			List<Map> chkList = (List<Map>) super.commonDao.list("map080ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("PAY_YYYYMM", dataMaster.get("PAY_YYYYMM"));
					 param.put("COLLECT_DAY_MAX", dataMaster.get("COLLECT_DAY_MAX"));
//					 param.put("COLLECT_SEQ", Math.max(dataMaster.get("COLLECT_DAY"),dataMaster.get("COLLECT_DAY")));
					 param.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
					 param.put("PAY_DATE", dataMaster.get("PAY_DATE"));
						 super.commonDao.update("map080ukrvServiceImpl.insertDetail", param);
					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("map080ukrvServiceImpl.checkCompCode", compCodeMap);
		
		Map parameter = new HashMap();
		parameter.put("S_COMP_CODE", user.getCompCode());
		parameter.put("DIV_CODE", dataMaster.get("DIV_CODE"));
		parameter.put("PAY_YYYYMM", dataMaster.get("PAY_YYYYMM"));
		 
		Map newCollectDay = (Map) super.commonDao.select("map080ukrvServiceImpl.getCollectDay", parameter);
		
		
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("PAY_YYYYMM", dataMaster.get("PAY_YYYYMM"));
				 param.put("COLLECT_DAY_MAP050", dataMaster.get("COLLECT_DAY_MAP050"));
				 
				 if(ObjUtils.isEmpty(param.get("COLLECT_DAY_MAP050"))){
//				 param.put("COLLECT_DAY", dataMaster.get("S_COLLECT_DAY"));
					 param.put("COLLECT_DAY_MAX", newCollectDay.get("COLLECT_DAY"));
				 }else{
					 param.put("COLLECT_DAY_MAX", dataMaster.get("COLLECT_DAY_MAP050"));	 
				 }
				 param.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
				 param.put("PAY_DATE", dataMaster.get("PAY_DATE"));
				 
				 if(param.get("CHECK").equals("1")){
					 super.commonDao.update("map080ukrvServiceImpl.insertDetail", param);
				 }else if(param.get("CHECK").equals("2") && param.get("PAY_YYYYMM_CHECK") != null){
					 super.commonDao.delete("map080ukrvServiceImpl.deleteDetail", param);
				 }else if(param.get("CHECK").equals("3") && param.get("PAY_YYYYMM_CHECK") != null)
					 super.commonDao.insert("map080ukrvServiceImpl.updateDetail", param);
			 	 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("map080ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("map080ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
	
	
	
}
