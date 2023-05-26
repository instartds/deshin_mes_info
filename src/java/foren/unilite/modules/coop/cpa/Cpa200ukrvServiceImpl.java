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

@Service("cpa200ukrvService")
public class Cpa200ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// masterGrid
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("cpa200ukrvService.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// detailGrid
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("cpa200ukrvService.selectDetailList", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// cpa100t update
	public List<Map<String, Object>> cpa100tUpdate(Map param) throws Exception {
		return super.commonDao.list("cpa200ukrvService.updateCpa100t", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// cpa100t update(DELETE)
	public List<Map<String, Object>> cpa100tUpdate2(Map param) throws Exception {
		return super.commonDao.list("cpa200ukrvService.updateCpa100t2", param);
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
			List<Map> chkList = (List<Map>) super.commonDao.list("cpa200ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("cpa200ukrvService.insertDetail", param);
					 super.commonDao.list("cpa200ukrvService.updateCpa100t", param);
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
		List<Map> chkList = (List<Map>) super.commonDao.list("cpa200ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("cpa200ukrvService.updateDetail", param);
				 super.commonDao.list("cpa200ukrvService.updateCpa100t", param);
			 }
		 }
		 return 0;
	} 
	
	@ExtDirectMethod(group = "coop", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("cpa200ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.list("cpa200ukrvService.updateCpa100t2", param);
				 super.commonDao.update("cpa200ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	} 
}
