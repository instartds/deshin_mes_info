package foren.unilite.modules.base.bsa;

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

@Service("bsa540ukrvService")
public class Bsa540ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 그룹조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("bsa540ukrvService.selectMaster", param);
	}
	
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("bsa540ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProgramList(Map param) throws Exception {
		return super.commonDao.list("bsa540ukrvService.selectProgramList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
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
			if(insertList != null) this.insertDetail(insertList, user , paramMaster);
			if(updateList != null) this.updateDetail(updateList, user);	
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());	
			
			List<Map> chkList = (List<Map>) super.commonDao.list("bsa540ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 super.commonDao.update("bsa540ukrvService.insertDetail", param);
				}
			}	
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bsa540ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("bsa540ukrvService.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bsa540ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("bsa540ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	} 
}
