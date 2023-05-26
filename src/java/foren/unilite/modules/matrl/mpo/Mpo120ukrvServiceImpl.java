package foren.unilite.modules.matrl.mpo;

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
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("mpo120ukrvService")
public class Mpo120ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	//20201215 뱃지기능 추가
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;	
	
	@ExtDirectMethod(group = "matrl")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {		
		return super.commonDao.list("mpo120ukrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("mpo120ukrvServiceImpl.selectDetailList", param);
	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
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
				} else if(dataListMap.get("method").equals("AgreeUpdate")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.AgreeUpdate(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
		
		//20201215 뱃지기능 추가
		tlabBadgeService.reload();		
				
		return  paramList;
	}
	
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("mpo120ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 super.commonDao.update("mpo120ukrvServiceImpl.insertDetail", param);
					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer AgreeUpdate(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		
		Map compCodeMap = new HashMap();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("mpo120ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("AGREE_PRSN", dataMaster.get("AGREE_PRSN1"));
				 param.put("AGREE_DATE", dataMaster.get("FR_DATE"));
				
//					super.commonDao.insert("mpo120ukrvServiceImpl.AgreeUpdate", param);
			 	Map<String, Object> err = (Map<String, Object>)super.commonDao.queryForObject("mpo120ukrvServiceImpl.AgreeUpdate", param);
				if(err != null){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				
					if(!ObjUtils.isEmpty(errorDesc)){
						String[] messsage = errorDesc.split(";");
					    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
					}
				}

			 }
				//20201215 뱃지기능 추가
				super.commonDao.update("mpo120ukrvServiceImpl.updateAlert", param);			 
		 }
		
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("mpo120ukrvServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("mpo120ukrvServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}

}
