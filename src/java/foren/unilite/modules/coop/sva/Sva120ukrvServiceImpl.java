package foren.unilite.modules.coop.sva;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("sva120ukrvService")
public class Sva120ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	
	/**
	 * 
	 * 매출집계 체크 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public Object  billDateCheck(Map param) throws Exception {	
		
		return  super.commonDao.select("sva120ukrvServiceImpl.billDateCheck", param);
	}
	
	
	/**
	 * 자판기수금등록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sva120ukrvServiceImpl.selectList", param);
	}
	

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "coop")
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
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			Map<String, Object> spParam = new HashMap<String, Object>();
			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("sva120ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 
					 
					 	spParam.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
						spParam.put("TABLE_ID","SCO100T");
						spParam.put("PREFIX", "C");
						spParam.put("BASIS_DATE", dataMaster.get("FR_DATE"));
						spParam.put("AUTO_TYPE", "1");

						super.commonDao.queryForObject("sva120ukrvServiceImpl.spAutoNum", spParam);
						

						
						//수금번호 update
						
								
						
					dataMaster.put("COLLECT_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));
					 
					 
					 
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					 param.put("COLLECT_DATE", dataMaster.get("FR_DATE"));
					 param.put("POS_NO", dataMaster.get("POS_NO"));
					 param.put("COLET_CUST_CD", dataMaster.get("POS_NO"));
					 param.put("TREE_NAME", dataMaster.get("DEPT_NAME"));
					 param.put("COLLECT_NUM", dataMaster.get("COLLECT_NUM"));
					 param.put("COLLECT_DIV", dataMaster.get("DIV_CODE"));
					 
					 super.commonDao.update("sva120ukrvServiceImpl.insertDetail", param);
					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map<String, Object> spParam = new HashMap<String, Object>();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("sva120ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 if(param.get("COLLECT_NUM") == ""){
				 
				 
				 	spParam.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					spParam.put("TABLE_ID","SCO100T");
					spParam.put("PREFIX", "S");
					spParam.put("BASIS_DATE", dataMaster.get("FR_DATE"));
					spParam.put("AUTO_TYPE", "1");

					super.commonDao.queryForObject("sva120ukrvServiceImpl.spAutoNum", spParam);
					

					
					//수금번호 update
					
							
					
				dataMaster.put("COLLECT_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));
				 
				 
				 
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				 param.put("COLLECT_DATE", dataMaster.get("FR_DATE"));
//				 param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
				 param.put("COLET_CUST_CD", param.get("POS_NO"));
				 param.put("COLLECT_PRSN", dataMaster.get("DIV_CODE")); 
				 param.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
				 param.put("TREE_NAME", dataMaster.get("DEPT_NAME"));
				 param.put("COLLECT_NUM", dataMaster.get("COLLECT_NUM"));
				 param.put("COLLECT_DIV", dataMaster.get("DIV_CODE"));
				 
				 
				 super.commonDao.update("sva120ukrvServiceImpl.insertDetail", param);
				 super.commonDao.insert("sva120ukrvServiceImpl.updateDetail2", param);
				 }else{
					 
					 
					 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					 param.put("COLLECT_DATE", dataMaster.get("FR_DATE"));
					 super.commonDao.insert("sva120ukrvServiceImpl.updateDetail", param);
//					 super.commonDao.insert("sva120ukrvServiceImpl.updateDetail3", param);
				 }
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("sva120ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("sva120ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
	
	
	
}
