package foren.unilite.modules.human.hum;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("hum760ukrService")
public class Hum760ukrServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("hum760ukrServiceImpl.select", param);
	}
	
	
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("hum760ukrServiceImpl.selectExcelUploadSheet1", param);
    }
	
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)		// 엑셀 적용 사번에 해당하는 데이터 포함
    public List<Map<String, Object>> selectExcelUploadApply(Map param) throws Exception {
        return super.commonDao.list("hum760ukrServiceImpl.selectExcelUploadApply", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("hum760ukrServiceImpl.excelValidate", param);
	}
	
    
    
    
    
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
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
			if(updateList != null) this.updateDetail(updateList, paramMaster, user);				
			if(insertList != null) this.insertDetail(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hum760ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hum760ukrServiceImpl.insertDetail", param);
//					 logger.debug("=============================insert Hum100MasterUpdate ================================");
					 super.commonDao.update("hum760ukrServiceImpl.Hum100MasterUpdate", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hum760ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hum760ukrServiceImpl.updateDetail", param);
//				 logger.debug("=============================update Hum100MasterUpdate ================================");
				 super.commonDao.update("hum760ukrServiceImpl.Hum100MasterUpdate2", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hum760ukrServiceImpl.checkCompCode", compCodeMap);
		
		logger.debug("======================== 삭제 ========================");
		
		
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hum760ukrServiceImpl.deleteDetail", param);
				 logger.debug("======================== 삭제2 ========================");
				 super.commonDao.update("hum760ukrServiceImpl.Hum100MasterUpdate2", param);
			 }
		 }
		 
		 
		 
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveHum100t(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception { 
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("insertHum100tDetail")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.insertHum100tDetail(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")      // INSERT
    public Integer  insertHum100tDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {     
        try {
            Map compCodeMap = new HashMap();
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List<Map>) super.commonDao.list("hum760ukrServiceImpl.checkCompCode", compCodeMap);
            for(Map param : paramList ) {            
                for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     super.commonDao.update("hum760ukrServiceImpl.Hum100MasterUpdate", param); // 인사마스터에 저장
                }
            }   
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return 0;
    }
	
	 
	/**
	 * 자동승급발령대상자
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectAutoGrade(Map param, LoginVO user) throws Exception {
		
		return  super.commonDao.list("hum760ukrServiceImpl.selectAutoGrade", param);
	}
	
	
	
	
}
