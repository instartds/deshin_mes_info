package foren.unilite.modules.matrl.mpo;

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




@Service("mpo030ukrvService")
public class Mpo030ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 지급내역
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> noPayList(Map param) throws Exception {
		return super.commonDao.list("mpo030ukrvServiceImpl.noPayList", param);
	}
	
	/**
	 * 미지급참조
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectNoPay(Map param) throws Exception {
		return super.commonDao.list("mpo030ukrvServiceImpl.selectNoPay", param);
	}

	
	
	@Transactional(readOnly=true) //미지급잔액
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  checkBlanAmt(Map param) throws Exception {	

		return  super.commonDao.select("mpo030ukrvServiceImpl.checkBlanAmt", param);
	}
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	/*
		Map<String, Object> spParam = new HashMap<String, Object>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("mrp160ukrvServiceImpl.checkCompCode", compCodeMap);
		
		
		for(Map checkCompCode : chkList) {
			 spParam.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
		 }
		spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
		spParam.put("TABLE_ID","MAP030T");
		spParam.put("PREFIX", "M");
		spParam.put("BASIS_DATE", dataMaster.get("PAYMENT_DATE"));
		spParam.put("AUTO_TYPE", "1");

		super.commonDao.queryForObject("mpo030ukrvServiceImpl.spAutoNum", spParam);
		

		
		//출하지시 마스터 출하지시 번호 update
		
				
		
		dataMaster.put("PAYMENT_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));*/
		
		
		
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
			Map<String, Object> spParam = new HashMap<String, Object>();
			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("mpo030ukrvServiceImpl.checkCompCode", compCodeMap);
			
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
						
						
						
						spParam.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 
						spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
						spParam.put("TABLE_ID","MAP030T");
						spParam.put("PREFIX", "M");
						spParam.put("BASIS_DATE", dataMaster.get("PAYMENT_DATE"));
						spParam.put("AUTO_TYPE", "1");

						super.commonDao.queryForObject("mpo030ukrvServiceImpl.spAutoNum", spParam);
						

						
						//출하지시 마스터 출하지시 번호 update
						
								
						
					dataMaster.put("PAYMENT_NUM", ObjUtils.getSafeString(spParam.get("sAUTO_NUM")));
					 
					 
					 
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					 param.put("PAYMENT_DATE", dataMaster.get("PAYMENT_DATE"));
					 param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
					 param.put("PAY_CUSTOM_CODE", dataMaster.get("PAY_CUSTOM_CODE"));
					 param.put("PAYMENT_PRSN", dataMaster.get("PAYMENT_PRSN"));
					 param.put("PAYMENT_NUM", dataMaster.get("PAYMENT_NUM"));
					 param.put("PAY_DIV_CODE", dataMaster.get("PAY_DIV_CODE"));
					 
					 super.commonDao.update("mpo030ukrvServiceImpl.insertDetail", param);
					 super.commonDao.update("mpo030ukrvServiceImpl.updateDate", param);
					 
					 }
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user,  Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("mpo030ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				 param.put("PAYMENT_DATE", dataMaster.get("PAYMENT_DATE"));
				 param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
				 param.put("PAY_CUSTOM_CODE", dataMaster.get("PAY_CUSTOM_CODE"));
				 param.put("PAYMENT_PRSN", dataMaster.get("PAYMENT_PRSN"));
				// param.put("PAYMENT_NUM", dataMaster.get("PAYMENT_NUM"));
				 param.put("PAY_DIV_CODE", dataMaster.get("PAY_DIV_CODE"));
				
					 super.commonDao.insert("mpo030ukrvServiceImpl.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user,  Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("mpo030ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				 param.put("PAYMENT_DATE", dataMaster.get("PAYMENT_DATE"));
				 param.put("CUSTOM_CODE", dataMaster.get("CUSTOM_CODE"));
				 param.put("PAY_CUSTOM_CODE", dataMaster.get("PAY_CUSTOM_CODE"));
				 param.put("PAYMENT_PRSN", dataMaster.get("PAYMENT_PRSN"));
				// param.put("PAYMENT_SEQ", dataMaster.get("PAYMENT_SEQ"));
				 param.put("PAY_DIV_CODE", dataMaster.get("PAY_DIV_CODE"));
					 try {
						 super.commonDao.delete("mpo030ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
}