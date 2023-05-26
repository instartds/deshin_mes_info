package foren.unilite.modules.coop.cpa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("cpa100ukrvService")
public class Cpa100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("cpa100ukrvService.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("cpa100ukrvService.selectExcelUploadSheet1", param);
    }
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드2
    public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
        return super.commonDao.list("cpa100ukrvService.selectExcelUploadSheet2", param);
    }
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드2(적용버튼)
    public List<Map<String, Object>> selectExcelUpload2(Map param) throws Exception {
        return super.commonDao.list("cpa100ukrvService.selectExcelUpload2", param);
    }
	
	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("cpa100ukrvService.excelValidate", param);
	}
	
	public void excelValidate2(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("cpa100ukrvService.excelValidate2", param);
	}
	
	/**
	 * 조합원 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("cpa100ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "coop")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
	  
	 if(paramList != null)	{
		 	List<Map> deleteList = null;
			List<Map> insertList = null;
			List<Map> updateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				}
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);	
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			
			List<Map> chkList = (List<Map>) super.commonDao.list("cpa100ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));        
				     param.put("STOP_DATE",UniliteUtil.chgDateFormat(param.get("STOP_DATE")));   
				     param.put("REPAYMENT_DATE",UniliteUtil.chgDateFormat(param.get("REPAYMENT_DATE")));
				     
					 if(param.get("OPR_FLAG").equals("U")) {
						 super.commonDao.update("cpa100ukrvService.updateDetail", param);
					 } else {
						 super.commonDao.update("cpa100ukrvService.insertDetail", param);
						 super.commonDao.update("cpa100ukrvService.insertDetail2", param);
					 }
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("cpa100ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("START_DATE",UniliteUtil.chgDateFormat(param.get("START_DATE")));        
			     param.put("STOP_DATE",UniliteUtil.chgDateFormat(param.get("STOP_DATE")));   
			     param.put("REPAYMENT_DATE",UniliteUtil.chgDateFormat(param.get("REPAYMENT_DATE")));

				 super.commonDao.update("cpa100ukrvService.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	@ExtDirectMethod(group = "coop", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("cpa100ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("cpa100ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	} 
}
