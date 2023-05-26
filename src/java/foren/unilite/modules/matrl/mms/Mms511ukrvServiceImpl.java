package foren.unilite.modules.matrl.mms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.exolab.castor.mapping.xml.Param;
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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("mms511ukrvService")
public class Mms511ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 입고등록(SP+통합)-> 입고내역 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 
	 * 입고등록(SP+통합)-> 입고번호 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinoutNoMasterList(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectinoutNoMasterList", param);
	}

	/**
	 * 
	 * 입고등록(SP+통합)-> 미입고참조(master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectnoReceiveListMaster(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectnoReceiveListMaster", param);
	}
	/**
	 * 
	 * 입고등록(SP+통합)-> 미입고참조(detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectnoReceiveListDetail(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectnoReceiveListDetail", param);
	}
	/**
	 * 
	 * 입고등록(SP+통합)-> 반품가능발주참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreturnPossibleList(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectreturnPossibleList", param);
	}
	
	/**
	 * 
	 * 입고등록(SP+통합)-> 접수결과참조(master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinspectResultListMaster(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectinspectResultListMaster", param);
	}
	/**
	 * 
	 * 입고등록(SP+통합)-> 접수결과참조(detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinspectResultListDetail(Map param) throws Exception {
		return super.commonDao.list("mms511ukrvServiceImpl.selectinspectResultListDetail", param);
	}
	

	
	/**
	 * 단가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnOrderPrice(Map param) throws Exception {	

		return  super.commonDao.select("mms511ukrvServiceImpl.fnOrderPrice", param);
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
		
		return  super.commonDao.select("mms511ukrvServiceImpl.userWhcode", param);
	}
	/**
	 * 
	 * 공급가액,부가세,합계금액관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnGetCalcTaxAmt(Map param) throws Exception {	
		
		return  super.commonDao.select("mms511ukrvServiceImpl.fnGetCalcTaxAmt", param);
	}
	
	/**
	 * 
	 * 과세구분
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  taxType(Map param) throws Exception {	
		
		return  super.commonDao.select("mms511ukrvServiceImpl.taxType", param);
	}
	
	/**
	 * 
	 * 납품예정정보관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  deliveryYn(Map param) throws Exception {	
		
		return  super.commonDao.select("mms511ukrvServiceImpl.deliveryYn", param);
	}
	
	/**
	 * 입고등록(SP+통합)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType 
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
		//2.입고등록 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
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
				
				if(param.get("LOT_ASSIGNED_YN").equals(true)){
					param.put("LOT_ASSIGNED_YN",'Y');
				}else if(param.get("LOT_ASSIGNED_YN").equals(false)){
					param.put("LOT_ASSIGNED_YN",'N');
				}else{
					param.put("LOT_ASSIGNED_YN",'N');
				}
			//	param.put("UPDATE_DB_USER", 0);
			//	param.put("UPDATE_DB_TIME", 0);
//				param.put("PICK_BOX_QTY", 0);
//				param.put("PICK_EA_QTY", 0);
//				param.put("PICK_STATUS", "");
				
				
				if(oprFlag.equals("N")  && param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
					if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
//						throw new  UniDirectValidateException("입고유형이 금액보정이 아닐때  구매단가가 0 이거나 0보다 작을 수 없습니다");
						throw new  UniDirectValidateException(this.getMessage("800004",user));
					}else{
						param.put("data", super.commonDao.insert("mms511ukrvServiceImpl.insertLogDetail", param));
					}
				}else{
					param.put("data", super.commonDao.insert("mms511ukrvServiceImpl.insertLogDetail", param));
				}
					
			}
		}

		//4.입고등록저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		//CreateType = paramData.get("CREATE_LOC");

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("CreateType", "1");

		super.commonDao.queryForObject("mms511ukrvServiceImpl.spReceiving", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//입고등록 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			logger.info("######  mms511ukrvServiceImpl.spReceiving  #######");
			logger.info("######  InOutNum : {}", ObjUtils.getSafeString(spParam.get("InOutNum")));
			logger.info("######  errorDesc : {}", errorDesc);

			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			//마스터에 SET
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			//그리드에 SET
			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}		
			
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
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
}