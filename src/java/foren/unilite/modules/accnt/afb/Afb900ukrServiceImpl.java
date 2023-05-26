package foren.unilite.modules.accnt.afb;

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



@Service("afb900ukrService")
public class Afb900ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	/**
	 * 이체지급등록 브랜치연계 사용 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck1(Map param) throws Exception {
		return super.commonDao.select("afb900ukrServiceImpl.selectCheck1", param);
	}
	
	/**
	 * 브랜치연계 시스템명 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck2(Map param) throws Exception {
		return super.commonDao.select("afb900ukrServiceImpl.selectCheck2", param);
	}
	
/*	
	*//**
	 * 
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("afb900ukrServiceImpl.selectMasterList", param);
	}	*/
	
	/**
	 * 
	 * detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("afb900ukrServiceImpl.selectDetailList", param);
	}	
	/**
	 * 
	 * 이제대상참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectFundingTargetList(Map param) throws Exception {
		return super.commonDao.list("afb900ukrServiceImpl.selectFundingTargetList", param);
	}	

	/**
	 * 자금이체등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();		
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
			//자금이체등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
			List<Map> dataList = new ArrayList<Map>();
			List<List<Map>> resultList = new ArrayList<List<Map>>();
			if(paramList != null)	{
				for(Map param: paramList) {
					dataList = (List<Map>)param.get("data");
		
					if(param.get("method").equals("insertDetail")) {
						param.put("data", insertLogDetails(dataList, keyValue, "N") );	
					} else if(param.get("method").equals("updateDetail")) {
						param.put("data", insertLogDetails(dataList, keyValue, "U") );	
					} else if(param.get("method").equals("deleteDetail")) {
						param.put("data", insertLogDetails(dataList, keyValue, "D") );	
					}
				}
			}
	
			//자금이체등록 Stored Procedure 실행
			Map<String, Object> spParam = new HashMap<String, Object>();
	
			spParam.put("KeyValue", keyValue);
			spParam.put("LangCode", user.getLanguage());
			spParam.put("UserId", user.getUserID());
			
			super.commonDao.queryForObject("spUspAccntAfb900ukr", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			String ProvDraftNo = ObjUtils.getSafeString(spParam.get("ProvDraftNo"));
	
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
			
			
		
		//자금이체등록 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
/*	
	*//**
	 * Branch정보 로그 저장
	 *//*
	public List<Map> insertLogBranch(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("afb900ukrServiceImpl.insertLogBranch", param);
		}		

		return params;
	}*/
	
	
	/**
	 * 자금이체등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("afb900ukrServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afb900ukrServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("afb900ukrServiceImpl.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("afb900ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	/**
	 * Branch(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> sendBranch(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		 
		String keyValue = getLogKey();	
		//branch 정보 관련 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertSendBranch")) {
					if(dataMaster.get("BRANCH_OPR_FLAG").equals("B")) {
						param.put("data", insertLogBranch(dataList, keyValue, "B") );	
					} else if(dataMaster.get("BRANCH_OPR_FLAG").equals("C")) {
						param.put("data", insertLogBranch(dataList, keyValue, "C") );	
					} else if(dataMaster.get("BRANCH_OPR_FLAG").equals("R")) {
						param.put("data", insertLogBranch(dataList, keyValue, "R") );	
					}
				}else{
				}
				
				
			}
		}
		if(dataMaster.get("BRANCH_OPR_FLAG").equals("B")) {
			//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
			Map<String, Object> spParam = new HashMap<String, Object>();
	
			spParam.put("KeyValue", keyValue);
			spParam.put("CompCode", user.getCompCode());
			spParam.put("FrDate", dataMaster.get("FR_DATE"));
			spParam.put("ToDate", dataMaster.get("TO_DATE"));
			spParam.put("LangCode", user.getLanguage());
			spParam.put("UserId", user.getUserID());
			
			super.commonDao.queryForObject("spUspAccntAfb900ukrBrBatch", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
	
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}else if(dataMaster.get("BRANCH_OPR_FLAG").equals("C")) {
			//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
			Map<String, Object> spParam = new HashMap<String, Object>();
	
			spParam.put("KeyValue", keyValue);
			spParam.put("CompCode", user.getCompCode());
			spParam.put("FrDate", dataMaster.get("FR_DATE"));
			spParam.put("ToDate", dataMaster.get("TO_DATE"));
			spParam.put("LangCode", user.getLanguage());
			spParam.put("UserId", user.getUserID());
			
			super.commonDao.queryForObject("spUspAccntAfb900ukrBrCaseBy", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
	
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}else if(dataMaster.get("BRANCH_OPR_FLAG").equals("R")) {
			//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
			Map<String, Object> spParam = new HashMap<String, Object>();
	
			spParam.put("KeyValue", keyValue);
			spParam.put("CompCode", user.getCompCode());
			spParam.put("FrDate", dataMaster.get("FR_DATE"));
			spParam.put("ToDate", dataMaster.get("TO_DATE"));
			spParam.put("LangCode", user.getLanguage());
			spParam.put("UserId", user.getUserID());
			
			super.commonDao.queryForObject("spUspAccntAfb900ukrBrResult", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
	
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Branch정보 로그 저장
	 */
	public List<Map> insertLogBranch(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("afb900ukrServiceImpl.insertLogBranch", param);
		}		

		return params;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertSendBranch(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afb900ukrServiceImpl.insertSendBranch", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateSendBranch(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("afb900ukrServiceImpl.updateSendBranch", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteSendBranch(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("afb900ukrServiceImpl.deleteSendBranch", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
/*	@ExtDirectMethod(group = "accnt")
	public List<Map> sendBranchTest1(List<Map> paramList) throws Exception {
		
		String keyValue = getLogKey();	
					//branch 정보 관련 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
					List<Map> dataList = new ArrayList<Map>();
//					Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
					
					if(paramList != null)	{
						for(Map param: paramList) {
							dataList = (List<Map>)param.get("data");
				
//							if(dataMaster.get("BRANCH_OPR_FLAG").equals("B")) {
								param.put("data", insertLogBranch(dataList, keyValue, "B") );	
							} else if(dataMaster.get("BRANCH_OPR_FLAG").equals("C")) {
								param.put("data", insertLogBranch(dataList, keyValue, "C") );	
							} else if(dataMaster.get("BRANCH_OPR_FLAG").equals("R")) {
								param.put("data", insertLogBranch(dataList, keyValue, "R") );	
							}
						}
					}
					if(dataMaster.get("BRANCH_OPR_FLAG").equals("B")) {
						//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
						Map<String, Object> spParam = new HashMap<String, Object>();
				
						spParam.put("KeyValue", keyValue);
						spParam.put("CompCode", user.getCompCode());
						spParam.put("FrDate", dataMaster.get("FR_DATE"));
						spParam.put("TrDate", dataMaster.get("TO_DATE"));
						spParam.put("LangCode", user.getLanguage());
						spParam.put("UserId", user.getUserID());
						
						super.commonDao.queryForObject("spUspAccntAfb900ukrBrBatch", spParam);
						
						String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
						if(!ObjUtils.isEmpty(errorDesc)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
						}
					}else if(dataMaster.get("BRANCH_OPR_FLAG").equals("C")) {
						//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
						Map<String, Object> spParam = new HashMap<String, Object>();
				
						spParam.put("KeyValue", keyValue);
						spParam.put("CompCode", user.getCompCode());
						spParam.put("FrDate", dataMaster.get("FR_DATE"));
						spParam.put("TrDate", dataMaster.get("TO_DATE"));
						spParam.put("LangCode", user.getLanguage());
						spParam.put("UserId", user.getUserID());
						
						super.commonDao.queryForObject("spUspAccntAfb900ukrBrCaseBy", spParam);
						
						String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
						if(!ObjUtils.isEmpty(errorDesc)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
						}
					}else if(dataMaster.get("BRANCH_OPR_FLAG").equals("R")) {
						//branch 정보 관련 Stored Procedure 실행	Branch로보내기(대량)
						Map<String, Object> spParam = new HashMap<String, Object>();
				
						spParam.put("KeyValue", keyValue);
						spParam.put("CompCode", user.getCompCode());
						spParam.put("FrDate", dataMaster.get("FR_DATE"));
						spParam.put("TrDate", dataMaster.get("TO_DATE"));
						spParam.put("LangCode", user.getLanguage());
						spParam.put("UserId", user.getUserID());
						
						super.commonDao.queryForObject("spUspAccntAfb900ukrBrResult", spParam);
						
						String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
						if(!ObjUtils.isEmpty(errorDesc)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
						}
					}
					
				
		List<String> NewRecords = (List)param.get("C");
		List<String> UpdateRecords = (List)param.get("U");
		List<String> RemoveRecords = (List)param.get("D");

		if(RemoveRecords.size() > 0 ){
			List<Map<String, Object>> RemoveRecordList = stringArrayToListMap(RemoveRecords);
			
			for(Map<String, Object> record : RemoveRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.delete(record);
			}
		};
		
		if(UpdateRecords.size() > 0 ){
			List<Map<String, Object>> UpdateRecordList = stringArrayToListMap(UpdateRecords);
			
			for(Map<String, Object> record : UpdateRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.update(record);
			}
		};
		
		if(NewRecords.size() > 0 ){
			List<Map<String, Object>> NewRecordList = stringArrayToListMap(NewRecords);
			
			for(Map<String, Object> record : NewRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.insert(record);
			}
		};
		
//		return true; 
//					paramList.add(0, paramMaster);
					
					return  paramList;
	}*/
}
