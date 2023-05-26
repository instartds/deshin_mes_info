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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("map000ukrvService")
public class Map000ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 거래처기초잔액등록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("map000ukrvServiceImpl.selectList", param);
	}
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
        return super.commonDao.list("map000ukrvServiceImpl.selectExcelUploadSheet", param);
    }
	 
	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("map000ukrvServiceImpl.excelValidate", param);
	} 
	@Transactional(readOnly=true) //사업장에 따른 기초년월
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  checkBasisYM(Map param) throws Exception {	

		return  super.commonDao.select("map000ukrvServiceImpl.checkBasisYM", param);
	}
	
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		//dataMaster.put("COMP_CODE", user.getCompCode());
		
		
		
		
		
		
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
			List<Map> chkList = (List<Map>) super.commonDao.list("map000ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 param.put("BASIS_YYYYMM", dataMaster.get("BASIS_YYYYMM"));
					 super.commonDao.update("map000ukrvServiceImpl.insert", param);
				 }
			}
			
			Map compDivCodeMap = new HashMap();
			
			compDivCodeMap.put("S_COMP_CODE", user.getCompCode());
			compDivCodeMap.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			List<Map> chkCompDiv = (List<Map>) super.commonDao.list("map000ukrvServiceImpl.checkCD", compDivCodeMap);
			//for(Map param : paramList )	{			 
				 for(Map checkCd : chkCompDiv) {
					 if((ObjUtils.parseInt(checkCd.get("CNT")) < 1)){
							super.commonDao.insert("map000ukrvServiceImpl.insertForm", dataMaster);
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
		List<Map> chkList = (List<Map>) super.commonDao.list("map000ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("BASIS_YYYYMM", dataMaster.get("BASIS_YYYYMM"));
					 super.commonDao.insert("map000ukrvServiceImpl.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("map000ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("BASIS_YYYYMM", dataMaster.get("BASIS_YYYYMM"));
					 try {
						 super.commonDao.delete("map000ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
	
	
	
}
