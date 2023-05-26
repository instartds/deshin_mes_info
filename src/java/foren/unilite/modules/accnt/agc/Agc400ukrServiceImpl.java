package foren.unilite.modules.accnt.agc;

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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

@Service("agc400ukrService")
public class Agc400ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	@Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rList = null;
		String flag = ObjUtils.getSafeString(param.get("FLAG"));
		
		if("2".equals(ObjUtils.getSafeString(param.get("GUBUN"))))	{
			Map stDtParam = new HashMap();
			stDtParam.put("S_COMP_CODE", user.getCompCode());
			List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(stDtParam);        //당기시작년월        
			String stDt = "";
			boolean check = false;
			if(getStDt != null && getStDt.size() > 0)	{
				stDt = ObjUtils.getSafeString(getStDt.get(0).get("STDT"));
				param.put("STDT", stDt);
				check = true;
			} 
			if(!check) {
				throw new  UniDirectValidateException("당기시작일이 설정되지 않았습니다.");
			}
		}
		
		if(flag != null && "SEARCH".equals(flag) )	{
			rList = (List) super.commonDao.list("agc400ukrServiceImpl.selectList", param);
		} else {
			rList = (List) super.commonDao.list("agc400ukrServiceImpl.selectNewList", param);
		}
		return rList;
	}

	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnGetExchgRate(Map param) throws Exception {
		return (List) super.commonDao.list("agc400ukrServiceImpl.getExchgRate", param);
	}
	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRef1(Map param) throws Exception {
		return (List) super.commonDao.list("agc400ukrServiceImpl.selectRef1", param);
	}
	
	/**
	 * 마스터 그리드 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster,  LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			Map paramMasterData = (Map) paramMaster.get("data");
			paramMasterData.put("S_COMP_CODE", user.getCompCode());
			paramMasterData.put("S_USER_ID", user.getUserID());
			paramMasterData.put("ACCNT", ObjUtils.nvlObj(paramMasterData.get("ACCNT"), ""));
			 
			Map masterData = (Map) super.commonDao.select("agc400ukrServiceImpl.selectCheckMaster", paramMasterData);
			if(masterData != null &&  ObjUtils.parseInt(masterData.get("CNT")) ==  0)	{
				 super.commonDao.update("agc400ukrServiceImpl.insertMaster", paramMasterData);
			}
			 
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user);
			//if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList,  user);				
		}
		
		paramList.add(0, paramMaster);		
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		
	public List<Map>  insertList(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param : paramList )	{			 
			super.commonDao.update("agc400ukrServiceImpl.insertList", param);
			param.put("FLAG", "");
		}	
		return paramList;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public List<Map> updateList(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			 if("N".equals(ObjUtils.getSafeString(param.get("FLAG"))))	{
				 
				 Map seqMap = (Map) super.commonDao.select("agc400ukrServiceImpl.selectSeq", param);
				 if(seqMap != null && ObjUtils.isNotEmpty(seqMap.get("SEQ")))	{
					 param.put("SEQ", ObjUtils.parseInt(seqMap.get("SEQ")));
				 } else {
					 param.put("SEQ", 1);
				 }
				 
				 param.put("ACCNT", ObjUtils.nvlObj(param.get("ACCNT"), ""));
				 super.commonDao.update("agc400ukrServiceImpl.insertDetail", param);
			 } else {
				 super.commonDao.update("agc400ukrServiceImpl.updateDetail", param);
			 }
			 param.put("FLAG", "");
		 }
		 return paramList;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			if(!"N".equals(ObjUtils.getSafeString(param.get("FLAG"))))	{
				
				Map checkMap = (Map) super.commonDao.select("agc400ukrServiceImpl.selectCheckDelete", param);
				if(checkMap == null || (ObjUtils.isEmpty(checkMap.get("EX_DATE")) && ObjUtils.isEmpty(checkMap.get("J_EX_DATE")))) {
					super.commonDao.update("agc400ukrServiceImpl.deleteDetail", param);
				} else {
					throw new  UniDirectValidateException("전표가 생성되어 삭제할 수 없습니다.");
				}
			}
		 }
		 return 0;
	}
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		
	public Map deleteAll(Map param,  LoginVO user) throws Exception {
		Map checkMap = (Map) super.commonDao.select("agc400ukrServiceImpl.selectCheckDelete", param);
		if(checkMap == null || (ObjUtils.isEmpty(checkMap.get("EX_DATE")) && ObjUtils.isEmpty(checkMap.get("J_EX_DATE")))) {
			super.commonDao.update("agc400ukrServiceImpl.deleteAll", param);
		} else {
			throw new  UniDirectValidateException("전표가 생성되어 삭제할 수 없습니다.");
		}
		return param;
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> agjInformation(Map param) throws Exception {
		return (List) super.commonDao.list("agc400ukrServiceImpl.agjInformation", param);
	}
	
	
}
