package foren.unilite.modules.pos.pos;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("bsa260ukrvService")
public class Bsa260ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "tlabCodeService")
	 protected TlabCodeService tlabCodeService;
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectMasterCodeList(Map param) throws Exception {
		return super.commonDao.list("bsa260ukrvService.selectMasterCodeList", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> getAutoCode(Map<String, Object> paramMap, LoginVO user) throws Exception {
		//Map<String, Object> paramMap = this.makeMapParam(param, user);

			Map<String, Object> getAutoCode = (Map<String, Object>)super.commonDao.select("bsa260ukrvService.getAutoCode", paramMap);
			String groupCode = ObjUtils.getSafeString(getAutoCode.get("GROUP_CODE"));				
			paramMap.put("GROUP_CODE", groupCode);
			
		return paramMap;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  insertCodes(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			 //
			Map<String, Object> chkData = (Map<String, Object>)super.commonDao.select("bsa260ukrvService.chkCode", param);
			if(chkData != null && ObjUtils.parseInt(chkData.get("CNT")) > 0 )	throw  new  UniDirectValidateException(this.getMessage("2627", user));
			
			super.commonDao.insert("bsa260ukrvService.MaininsertCode", param);
		}
		
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "base")
	public List<Map> updateCodes(List<Map> paramList ) throws Exception {
		
		for(Map param :paramList )	{			
			super.commonDao.update("bsa260ukrvService.MainupdateCode", param);
		}
		 return paramList;
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map> deleteCodes(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bsa260ukrvService.MaindeleteCode", param);
		 }
		 return paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  DetailinsertCodes(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			 //
			super.commonDao.insert("bsa260ukrvService.DetailinsertCode", param);
		}
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "base")
	public List<Map> DetailupdateCodes(List<Map> paramList ) throws Exception {
		
		for(Map param :paramList )	{			
			super.commonDao.update("bsa260ukrvService.DetailupdateCode", param);
		}
		 return paramList;
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map> DetaildeleteCodes(List<Map> paramList) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bsa260ukrvService.DetaildeleteCode", param);
		 }
		 return paramList;
	}
	
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectDetailCodeList(Map param) throws Exception {
		return super.commonDao.list("bsa260ukrvService.selectDetailCodeList", param);
	}
	

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			List<Map> insertList2 = null;
			List<Map> updateList2 = null;
			List<Map> deleteList2 = null;

			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteCodes")) {   		// master 삭제
					deleteList = (List<Map>)dataListMap.get("data");
					
				}else if(dataListMap.get("method").equals("insertCodes")) {		// master 저장
					insertList = (List<Map>)dataListMap.get("data");		
					
				} else if(dataListMap.get("method").equals("updateCodes")) {	// master 업데이트
					updateList = (List<Map>)dataListMap.get("data");	
					
				}else if(dataListMap.get("method").equals("DetailupdateCodes")) {	// detail 업데이트	
					updateList2 = (List<Map>)dataListMap.get("data");		
					
				}else if(dataListMap.get("method").equals("DetailinsertCodes")) {	// detail 저장		
					insertList2 = (List<Map>)dataListMap.get("data");		
					
				}else if(dataListMap.get("method").equals("DetaildeleteCodes")) {	// detail 삭제		
					deleteList2 = (List<Map>)dataListMap.get("data");		
					
				}
			}
			if(deleteList != null) this.deleteCodes(deleteList);
			if(insertList != null) this.insertCodes(insertList,user);
			if(updateList != null) this.updateCodes(updateList);
			
			if(deleteList2 != null) this.DetaildeleteCodes(deleteList2);
			if(insertList2 != null) this.DetailinsertCodes(insertList2,user);
			if(updateList2 != null) this.DetailupdateCodes(updateList2);

		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

}
