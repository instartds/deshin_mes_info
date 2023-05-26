package foren.unilite.modules.prodt.pmp;

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



@Service("pmp203ukrvService")
public class Pmp203ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	

	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("pmp203ukrvServiceImpl.selectDetailList", param);		// 조회
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDelete(Map param) throws Exception {
		return super.commonDao.list("pmp203ukrvServiceImpl.selectDelete", param);	// 삭제 전 확인
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSave(Map param) throws Exception {
		return super.commonDao.list("pmp203ukrvServiceImpl.selectSave", param);		// 저장 전 확인
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
				List<Map> chkList = (List<Map>) super.commonDao.list("pmp203ukrvServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("pmp203ukrvServiceImpl.insertDetail", param);
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
			List<Map> chkList = (List<Map>) super.commonDao.list("pmp203ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("pmp203ukrvServiceImpl.selectSave", param);
					 super.commonDao.update("pmp203ukrvServiceImpl.updateDetail", param);
					 super.commonDao.update("pmp203ukrvServiceImpl.updateDetail2", param);
				 }
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("pmp203ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("pmp203ukrvServiceImpl.selectDelete", param);
					 super.commonDao.update("pmp203ukrvServiceImpl.deleteDetail", param);
					 super.commonDao.update("pmp203ukrvServiceImpl.updateDetail2", param);
				 }
				 /*String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
				 if(!ObjUtils.isEmpty(errorDesc)){
					String[] messsage = errorDesc.split(";");
				    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				} else {
					return 0;
				}*/
			}
			return 0;
	} 
}
