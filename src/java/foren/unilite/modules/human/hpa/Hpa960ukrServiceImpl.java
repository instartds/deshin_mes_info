package foren.unilite.modules.human.hpa;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpa960ukrService")
public class Hpa960ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/* fnGetTax  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object spFnGetTax(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("hpa960ukrServiceImpl.spFnGetTax", param);
		String CPARAM0 = ObjUtils.getSafeString(param.get("CPARAM0"));
		String CPARAM1 = ObjUtils.getSafeString(param.get("CPARAM1"));
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  UniDirectValidateException(errorDesc);
		} else {
			return param;
		}
	}	

	
	/**
	 * 주식매수권/우리사주인출금등록  조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return (List) super.commonDao.list("hpa960ukrServiceImpl.selectList1", param);
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List) super.commonDao.list("hpa960ukrServiceImpl.selectList2", param);
	}
	
	// SAVE All1
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll1(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteList1")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertList1")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList1")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(insertList != null) this.insertList1(insertList, user);
				if(updateList != null) this.updateList1(updateList, user);				
				if(deleteList != null) this.deleteList1(deleteList, user);
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	/**
	 *추가
	 */
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
		public Integer  insertList1(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("hpa960ukrServiceImpl.insertList1", param);
					}
				}	
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			
			return 0;
		}	
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
		public Integer updateList1(List<Map> paramList, LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hpa960ukrServiceImpl.updateList1", param);
				 }
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteList1(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hpa960ukrServiceImpl.deleteList1", param);
				 }
			 }
			 return 0;
	} 
		
		// SAVE All2
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
		 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		 public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			 
			 if(paramList != null)	{
					List<Map> insertList = null;
					List<Map> updateList = null;
					List<Map> deleteList = null;
					for(Map dataListMap: paramList) {
						if(dataListMap.get("method").equals("deleteList2")) {
							deleteList = (List<Map>)dataListMap.get("data");
						}else if(dataListMap.get("method").equals("insertList2")) {		
							insertList = (List<Map>)dataListMap.get("data");
						} else if(dataListMap.get("method").equals("updateList2")) {
							updateList = (List<Map>)dataListMap.get("data");	
						} 
					}			
					if(insertList != null) this.insertList2(insertList, user);
					if(updateList != null) this.updateList2(updateList, user);				
					if(deleteList != null) this.deleteList2(deleteList, user);
				}
			 	paramList.add(0, paramMaster);
					
			 	return  paramList;
		}
		/**
		 *추가
		 */
		 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
			public Integer  insertList2(List<Map> paramList, LoginVO user) throws Exception {		
				try {
					Map compCodeMap = new HashMap();
					compCodeMap.put("S_COMP_CODE", user.getCompCode());
					List<Map> chkList = (List<Map>) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
					for(Map param : paramList )	{			 
						for(Map checkCompCode : chkList) {
							 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
							 super.commonDao.update("hpa960ukrServiceImpl.insertList2", param);
						}
					}	
				}catch(Exception e){
					throw new  UniDirectValidateException(this.getMessage("2627", user));
				}
				
				return 0;
			}	
			
			@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
			public Integer updateList2(List<Map> paramList, LoginVO user) throws Exception {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
				 for(Map param :paramList )	{	
					 for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("hpa960ukrServiceImpl.updateList2", param);
					 }
				 }
				 return 0;
			} 
			
			
			@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
			public Integer deleteList2(List<Map> paramList,  LoginVO user) throws Exception {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List) super.commonDao.list("hpa960ukrServiceImpl.checkCompCode", compCodeMap);
				 for(Map param :paramList )	{	
					 for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("hpa960ukrServiceImpl.deleteList2", param);
					 }
				 }
				 return 0;
		} 
}
