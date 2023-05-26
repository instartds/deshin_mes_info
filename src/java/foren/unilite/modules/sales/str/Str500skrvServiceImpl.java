package foren.unilite.modules.sales.str;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("str500skrvService")
public class Str500skrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 신용카드사정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("str500skrvService.selectDetailList", param);
	}
		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
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
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {			
			for(Map param : paramList )	{					
				 super.commonDao.update("str500skrvService.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("str500skrvService.updateDetail", param);
		 }
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateButtonSave(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("str500skrvService.updateButtonSave", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {		
		try {
			for(Map param :paramList )	{
				super.commonDao.delete("str500skrvService.deleteDetail", param);						
			 }
		 }catch(Exception e){
 			throw new  UniDirectValidateException(this.getMessage("547",user));
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
				
		return super.commonDao.list("str500skrvService.selectExcelUploadSheet", param);
	}
	

	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("str500skrvService.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("ITEM_CODE", data.get("ITEM_CODE"));
			
			}
		}
	}
}
