package foren.unilite.modules.stock.biv;

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



@Service("biv121ukrvService")
public class Biv121ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// jasper report
	public List<Map<String, Object>> report(Map param) throws Exception {
		return super.commonDao.list("biv121ukrvServiceImpl.report", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 창고 초기화
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv121ukrvServiceImpl.userWhcode", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)						// 구역 콤보박스 조회
	public List<ComboItemModel> getSectorList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("biv121ukrvServiceImpl.getSectorList", param);
		
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 조회
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("biv121ukrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 301T insert
    public int insertExcelData(Map param) throws Exception {
        return super.commonDao.update("biv121ukrvServiceImpl.insertExcelBiv301t", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")		// 데이터 검증 / 저장
	public Object  dataCheckSave(Map<String, String> spParam, LoginVO user) throws Exception {
		spParam.put("LangCode", user.getLanguage());
		super.commonDao.queryForObject("biv121ukrvServiceImpl.spReceiving", spParam);	
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
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
	 
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
		public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("biv121ukrvServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("biv121ukrvServiceImpl.insertDetail", param);
					}
				}	
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			
			return 0;
		}	
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
		public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("biv121ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("biv121ukrvServiceImpl.updateDetail", param);
				 }
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("biv121ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("biv121ukrvServiceImpl.deleteDetail", param);
				 }
			 }
			 return 0;
	} 
	
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("biv121ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("biv121ukrvServiceImpl.excelValidate", param);
	}

	 

}
