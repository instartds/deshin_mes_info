package foren.unilite.modules.human.hbs;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hbs030ukrService")
public class Hbs030ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList1(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList1", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList2", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList3(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList3", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList4(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList4", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList5(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList5", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList6(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList6", param);
	}
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList7(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.selectList7", param);
	}

	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> checkMonth(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.checkMonth", param);
	}
	
	/* 간이소득세액표
	 *  HBS110T의 가장 최근 년월 가져오기 
	 *  */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> fnLoadMaxTaxYearMM(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs030ukrServiceImpl.fnLoadMaxTaxYearMM", param);
	}
	
	
	/**
	 * 간이소득세액표 엑셀
	 * 
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("hbs030ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("hbs030ukrServiceImpl.excelValidate", param);
	}
	
	/**
	 * 표준보수월액등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail1(deleteList, user);
			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030", param);
			 }
		 }
		 return 0;
	}
	
	
	/**
	 * 종합소득세율등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030_2", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_2", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030_2", param);
			 }
		 }
		 return 0;
	}
	
	
	/**
	 * 퇴직소득공제등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail3(deleteList, user);
			if(insertList != null) this.insertDetail3(insertList, user);
			if(updateList != null) this.updateDetail3(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030_3", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_3", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030_3", param);
			 }
		 }
		 return 0;
	}
	
	/**
	 * 간이소득세액표
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail4(deleteList, user);
			if(insertList != null) this.insertDetail4(insertList, user);
			if(updateList != null) this.updateDetail4(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030_4", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_4", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030_4", param);
			 }
		 }
		 return 0;
	}
	
	/**
	 * 비과세근로소득코드등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll5(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail5(deleteList, user);
			if(insertList != null) this.insertDetail5(insertList, user);
			if(updateList != null) this.updateDetail5(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030_5", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_5", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030_5", param);
			 }
		 }
		 return 0;
	}
	
	/**
	 * 원천징수신고코드등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll6(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail6(deleteList, user);
			if(insertList != null) this.insertDetail6(insertList, user);
			if(updateList != null) this.updateDetail6(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// INSERT
	public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hbs030ukrServiceImpl.insertHbs030_6", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")		// UPDATE
	public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_6", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hbs", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs030ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs030ukrServiceImpl.deleteHbs030_6", param);
			 }
		 }
		 return 0;
	}
	
	
	
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateHbs030_7(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("hbs030ukrServiceImpl.updateHbs030_7", param);
		}
		return paramList;
	}
	/**
	 * 삭제
	 */
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param) throws Exception {
		return (int)super.commonDao.update("hbs030ukrServiceImpl.doBatch", param);
		
	}

}
