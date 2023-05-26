package foren.unilite.modules.z_jw;

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
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
//import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_mpo501ukrv_jwService")
public class S_mpo501ukrv_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 발주서출력
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_mpo501ukrv_jwServiceImpl.mainReport", param);
	}
	
	/**
     * 
     * 긴급발주등록(SP) 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectOrderPrsn(Map param) throws Exception {
        return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectOrderPrsn", param);
    }
    
    /**
     * 긴급발주등록 Master 조회 
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.FORM_LOAD)
    public Object selectMaster(Map param) throws Exception {
        return super.commonDao.select("s_mpo501ukrv_jwServiceImpl.selectMaster", param);
    }
	
	/**
	 * 
	 * 긴급발주등록(SP) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectList", param);
	}
	
	/**
     * 
     * 타발주 -> 그리드SET 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectList2", param);
    }

	/**
	 * 
	 * 긴급발주등록(SP) -> 발주번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectOrderNumMasterList", param);
	}
	
	/**
	 * 
	 * 긴급발주등록(SP) -> 타발주참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList2(Map param) throws Exception {
		return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectOrderNumMasterList2", param);
	}
	
	/**
     * 
     * 긴급발주등록(SP) ->  발주요청등록 참조
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMre100tList(Map param) throws Exception {
        return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectMre100tList", param);
    }

	/**
	 * 
	 * 긴급발주등록(SP) -> BPR200T에서 품질대상여부(INSPEC_YN) 가져와서 그리드의 품질대상여부(INSPEC_FLAG)에 넣어준다.
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callInspecyn(Map param) throws Exception {	
		
		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.callInspecyn", param);
	}
	/**
	 * 
	 *  구매담당 선택시 승인자 가져옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userName(Map param) throws Exception {	
		
		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.userName", param);
	}

	/**
	 * 
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.userWhcode", param);
	}
/*	*//**
	 * 
	 *  userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  ref1(Map param) throws Exception {	
		
		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.ref1", param);
	}*/
	/**
	 * 단가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {	

		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.fnOrderPrice", param);
	}
	/**
	 * 
	 * 품질검사여부 관련 (부서별)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  callDeptInspecFlag(Map param) throws Exception {	
		
		return  super.commonDao.select("s_mpo501ukrv_jwServiceImpl.callDeptInspecFlag", param);
	}
	
	
/*	*//**
	 * 긴급발주등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
				
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
			//	param.put("UPDATE_DB_USER", 0);
			//	param.put("UPDATE_DB_TIME", 0);
//				param.put("PICK_BOX_QTY", 0);
//				param.put("PICK_EA_QTY", 0);
//				param.put("PICK_STATUS", "");
				param.put("data", super.commonDao.insert("s_mpo501ukrv_jwServiceImpl.insertLogMaster", param));
			}
		}
		
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spSalesOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!errorDesc.isEmpty()){
			dataMaster.put("ORDER_NUM", "");
			throw new Exception(errorDesc);
		} else {
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spPurchaseOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		

		
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				
		if(!errorDesc.isEmpty()){
			dataMaster.put("ORDER_NUM", "");
			throw new Exception(errorDesc);
		} else {
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}
		
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
*/
	
	
	/**
	 * 긴급발주등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.발주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("ORDER_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_mpo501ukrv_jwServiceImpl.insertLogMaster", dataMaster);
		
		//3.발주디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
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

		//4.발주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_mpo501ukrv_jwServiceImpl.spPurchaseOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(ObjUtils.isEmpty(errorDesc)){
			//마스터에 SET
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
					}
				}
			}	
						
		} else {
			dataMaster.put("ORDER_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		
		//5.발주마스터 정보 + 발주디테일 정보 결과셋 리턴
		//마스터정보가 없을 경우에도 작성
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(S_mpo501ukrv_jwModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		
		String keyValue = getLogKey();			
		//2.발주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		dataMaster.setCOMP_CODE(user.getCompCode());
		dataMaster.setKEY_VALUE(keyValue);

		if (ObjUtils.isEmpty(dataMaster.getORDER_NUM() )) {
			dataMaster.setOPR_FLAG("N");
		} else {
			dataMaster.setOPR_FLAG("U");
		}

		super.commonDao.insert("s_mpo501ukrv_jwServiceImpl.insertLogMaster", dataMaster);

		//4.발주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_mpo501ukrv_jwServiceImpl.spPurchaseOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		if(!ObjUtils.isEmpty(errorDesc)){
			extResult.addResultProperty("ORDER_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}
		
//		dataMaster.setS_COMP_CODE(user.getCompCode());
//		super.commonDao.update("sof100ukrvServiceImpl.updateMasterForm", dataMaster);
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}

	/**
	 * 발주등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("s_mpo501ukrv_jwServiceImpl.insertLogDetail", param);
		}
		return params;
	}
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}

	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
	
/**
  * 
  * 발주 엑셀 참조 
  * @param param
  * @return
  * @throws Exception
  */
 @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
 public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
     return super.commonDao.list("s_mpo501ukrv_jwServiceImpl.selectExcelUploadSheet1", param);
 }
 
	public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("s_mpo501ukrv_jwServiceImpl.excelValidate", param);
	}
}
