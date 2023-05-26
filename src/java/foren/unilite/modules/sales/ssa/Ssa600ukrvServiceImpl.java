package foren.unilite.modules.sales.ssa;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa600ukrvService")
public class Ssa600ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 조회
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("ssa600ukrvServiceImpl.selectList", param);
    }
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("ssa600ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("ssa600ukrvServiceImpl.excelValidate", param);
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
				List<Map> chkList = (List<Map>) super.commonDao.list("ssa600ukrvServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("ssa600ukrvServiceImpl.insertDetail", param);
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
			for(Map param :paramList )	{	
				super.commonDao.update("ssa600ukrvServiceImpl.updateDetail", param);
			}
			return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			for(Map param :paramList )	{	
				super.commonDao.update("ssa600ukrvServiceImpl.deleteDetail", param);
			}
			return 0;
	} 
}
