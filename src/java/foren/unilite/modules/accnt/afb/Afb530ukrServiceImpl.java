package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Service("afb530ukrService")
public class Afb530ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 회계기간 가져오기
	public List<Map<String, Object>>  selectFnDate(Map param) throws Exception {	
		return  super.commonDao.list("afb530ukrServiceImpl.selectFnDate", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("afb530ukrServiceImpl.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 사용자ID로부터 회계담당자 코드, 담당자명, 사용부서, 사번 정보 가져오기
	public List<Map<String, Object>>  selectChargeInfo(Map param) throws Exception {	
		return  super.commonDao.list("afb530ukrServiceImpl.selectChargeInfo", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		super.commonDao.list("afb530ukrServiceImpl.selectBudgName", param);
		super.commonDao.list("afb530ukrServiceImpl.selectList1", param);
		return  super.commonDao.list("afb530ukrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 예산참조 조회
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		Map selectFnDate = (Map) super.commonDao.queryForObject("afb530ukrServiceImpl.selectFnDate", param);
		Object fnDate = selectFnDate.get("FN_DATE");
		String fnDateYyyy = fnDate.toString().substring(0,4);
		int fnDateNextYyyy = 0;
		fnDateNextYyyy = Integer.parseInt(ObjUtils.getSafeString(fnDateYyyy)) + 0001;
		Map selectToDt = (Map) super.commonDao.queryForObject("accntCommonService.fnGetToDt", param);
		Object toDt = selectToDt.get("STDT");
		String toDtMm = toDt.toString().substring(4,6);
		param.put("sToMonth", fnDateNextYyyy + toDtMm);
		param.put("sNxtMonth", param.get("BUDG_YYYYMM_PLUS"));
		super.commonDao.list("afb530ukrServiceImpl.selectBudgName", param);
		return  super.commonDao.list("afb530ukrServiceImpl.selectList3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 저장전 마감여부 체크
	public List<Map<String, Object>>  selectBudgCloseFg(Map param) throws Exception {	
		return  super.commonDao.list("afb530ukrServiceImpl.selectBudgCloseFg", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
	  logger.debug("[saveAll] paramDetail:" + paramList);

	  //1.로그테이블에서 사용할 KeyValue 생성
	  String keyValue = getLogKey();      
	    
	  //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
	  List<Map> dataList = new ArrayList<Map>();
	  List<List<Map>> resultList = new ArrayList<List<Map>>();
	  Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	  
	  Map<String, Object> deptCode = null;
	  for(Map paramData: paramList) {   
	   
		  dataList = (List<Map>) paramData.get("data");
		  String oprFlag = "N";
		  if(paramData.get("method").equals("insertDetail")) oprFlag="N";
		  if(paramData.get("method").equals("updateDetail")) oprFlag="U";
		  if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

		  for(Map param:  dataList) {
		    param.put("KEY_VALUE", keyValue);
		    param.put("OPR_FLAG", oprFlag);
		    param.put("IWALL_YYYYMM", ((String) param.get("IWALL_YYYYMM")).replace(".", ""));
		    param.put("data", super.commonDao.update("afb530ukrServiceImpl.insertLogAfb530t", param));
		  }
	  }
	//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		//spParam.put("", value)

		super.commonDao.queryForObject("afb530ukrServiceImpl.spReceiving", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update

		if(!ObjUtils.isEmpty(errorDesc)){
			//String[] messsage = errorDesc.split(";");
		    //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			//throw new  Exception(errorDesc);
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		  
		  paramList.add(0, paramMaster);
		  return  paramList;
		 }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
//	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
//		 if(paramList != null)	{
//			List<Map> insertList = null;
//			List<Map> deleteList = null;
//			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("insertDetail")) {		
//					insertList = (List<Map>)dataListMap.get("data");
//				} else if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				}
//			}			
//			if(insertList != null) this.insertDetail(insertList, user);	
//			if(deleteList != null) this.deleteDetail(deleteList, user);		
//		}
//	 	paramList.add(0, paramMaster);
//		return  paramList;
//	}
//	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
//	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
//		for(Map param :paramList )	{
//			Map selectFnDate = (Map) super.commonDao.queryForObject("afb530ukrServiceImpl.selectFnDate", param);
//			Object fnDate = selectFnDate.get("FN_DATE");
//			Map selectToDate = (Map) super.commonDao.queryForObject("accntCommonService.fnGetToDt", param);
//			Object toDate = selectToDate.get("STDT");
//			param.put("sFrMonth", fnDate);
//			param.put("sToMonth", toDate);
//			param.put("IWALL_YYYYMM", ((String) param.get("IWALL_YYYYMM")).replace(".", ""));
//			List<Map> selectAfb510tMaxCalDivi = super.commonDao.list("afb530ukrServiceImpl.selectAfb510tMaxCalDivi", param);
//			if(selectAfb510tMaxCalDivi.size() == 1) {
//				List<Map> MaxCalDivi = super.commonDao.list("afb530ukrServiceImpl.selectAfb510tMaxCalDivi", param);
//				Object CalDivi = MaxCalDivi.get(0).get("CAL_DIVI");
//				param.put("sOriDivi", CalDivi);
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tCalDivi", param);
//				// 에러처리
//			} else {
//				// 에러처리
//			}
//			List<Map> selectAfb510t1 = (List<Map>) super.commonDao.list("afb530ukrServiceImpl.selectAfb510t1", param);
//			if(selectAfb510t1.size() == 1) {
//				if(ObjUtils.parseInt(selectAfb510t1.get(0).get("BUDGET_I")) < ObjUtils.parseInt(param.get("IWALL_YYYYMM"))) {
//					// 에러처리
//				}
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tBudgIwallIInsert1", param);
//			} else {
//				// 에러처리
//				super.commonDao.update("afb530ukrServiceImpl.insertAfb510t1", param);
//			}
//			List<Map> selectAfb510t2 = (List<Map>) super.commonDao.list("afb530ukrServiceImpl.selectAfb510t2", param);
//			if(selectAfb510t2.size() == 1) {
////				if(ObjUtils.parseInt(selectAfb510t2.get(0).get("BUDGET_I")) < 0) {
////					// 에러처리
////				}
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tBudgIwallIInsert2", param);
//			} else {
//				// 에러처리
//				super.commonDao.update("afb530ukrServiceImpl.insertAfb510t2", param);
//			}
//			super.commonDao.update("afb530ukrServiceImpl.insertDetail", param);
//		}
//		return 0;
//	}
//	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// DELETE
//	public Integer deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param :paramList )	{
//			Map selectFnDate = (Map) super.commonDao.queryForObject("afb530ukrServiceImpl.selectFnDate", param);
//			Object fnDate = selectFnDate.get("FN_DATE");
//			Map selectToDate = (Map) super.commonDao.queryForObject("accntCommonService.fnGetToDt", param);
//			Object toDate = selectToDate.get("STDT");
//			param.put("sFrMonth", fnDate);
//			param.put("sToMonth", toDate);
//			param.put("IWALL_YYYYMM", ((String) param.get("IWALL_YYYYMM")).replace(".", ""));
//			List<Map> selectAfb510tMaxCalDivi = super.commonDao.list("afb530ukrServiceImpl.selectAfb510tMaxCalDivi", param);
//			if(selectAfb510tMaxCalDivi.size() == 1) {
//				List<Map> MaxCalDivi = super.commonDao.list("afb530ukrServiceImpl.selectAfb510tMaxCalDivi", param);
//				Object CalDivi = MaxCalDivi.get(0).get("CAL_DIVI");
//				param.put("sOriDivi", CalDivi);
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tCalDivi", param);
//				// 에러처리
//			} else {
//				// 에러처리
//			}
//			List<Map> selectAfb510t1 = (List<Map>) super.commonDao.list("afb530ukrServiceImpl.selectAfb510t1", param);
//			if(selectAfb510t1.size() == 1) {
//				if(ObjUtils.parseInt(selectAfb510t1.get(0).get("BUDGET_I")) < ObjUtils.parseInt(param.get("IWALL_YYYYMM"))) {
//					// 에러처리
//				}
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tBudgIwallIInsert1", param);
//			} else {
//				// 에러처리
//				super.commonDao.update("afb530ukrServiceImpl.insertAfb510t1", param);
//			}
//			List<Map> selectAfb510t2 = (List<Map>) super.commonDao.list("afb530ukrServiceImpl.selectAfb510t2", param);
//			if(selectAfb510t2.size() == 1) {
//				if(ObjUtils.parseInt(selectAfb510t2.get(0).get("BUDGET_I")) < 0) {
//					// 에러처리
//				}
//				super.commonDao.update("afb530ukrServiceImpl.updateAfb510tBudgIwallIInsert2", param);
//			} else {
//				// 에러처리
//				super.commonDao.update("afb530ukrServiceImpl.insertAfb510t2", param);
//			}
//			super.commonDao.update("afb530ukrServiceImpl.deleteDetail", param);
//		}
//		return 0;
//	} 


