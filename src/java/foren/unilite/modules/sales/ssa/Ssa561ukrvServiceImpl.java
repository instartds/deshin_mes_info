package foren.unilite.modules.sales.ssa;

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
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa561ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa561ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	/**
	 * 사업장별 신고사업장 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectBillDivList(Map param) throws Exception {
		return super.commonDao.select("ssa561ukrvServiceImpl.selectBillDivList", param);
	}

	/**
	 * 신고사업장 정보 조회 form set용
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectBillDivInfo(Map param) throws Exception {
		return super.commonDao.select("ssa561ukrvServiceImpl.selectBillDivInfo", param);
	}

	/**
	 * 계산서번호 검색 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectBillNoMasterList(Map param) throws Exception {
		return super.commonDao.list("ssa561ukrvServiceImpl.selectBillNoMasterList", param);
	}

	/**
	 * 매출참조 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectReferList(Map param) throws Exception {
		return super.commonDao.list("ssa561ukrvServiceImpl.selectReferList", param);
	}

	/** 
	 * 개별세금계산서 마스터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object selectMasterList(Map param) throws Exception {
		return super.commonDao.select("ssa561ukrvServiceImpl.selectMasterList", param);
	}

	/** 
	 * 개별세금계산서 디테일 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa561ukrvServiceImpl.selectDetailList", param);
	}



	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map<String, Object> spParam = new HashMap<String, Object>();	//returnData
		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.매출마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트	
		dataMaster.put("KEY_VALUE", keyValue);

		if (ObjUtils.isEmpty(dataMaster.get("PUB_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("ssa561ukrvServiceImpl.insertLogMaster", dataMaster);

		
		//3.매출디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
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
		//4.저장 Stored Procedure 실행	
		spParam.put("KeyValue", keyValue);
		spParam.put("BeforePumNum", dataMaster.get("BEFORE_PUB_NUM"));
		spParam.put("OrgPubNum", dataMaster.get("ORIGIN_PUB_NUM"));
		
		super.commonDao.queryForObject("ssa561ukrvServiceImpl.pubIssue", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("PUB_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			dataMaster.put("PUB_NUM", ObjUtils.getSafeString(spParam.get("ReturnPumNum")));
			for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("PUB_NUM", ObjUtils.getSafeString(spParam.get("ReturnPumNum")));
                    }
                }
            }
		}
		
		//5.마스터 정보 + 디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Ssa561ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		
//		String keyValue = getLogKey();			
		//2.수주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
//		dataMaster.setCOMP_CODE(user.getCompCode());
//		dataMaster.setKEY_VALUE(keyValue);
//
//		if (ObjUtils.isEmpty(dataMaster.getPUB_NUM() )) {
//			dataMaster.setOPR_FLAG("N");
//		} else {
//			dataMaster.setOPR_FLAG("U");
//		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		if(dataMaster.getM_MODE().equals("modifyUpdate")){
			
			spParam.put("Flag", dataMaster.getM_FLAG());
			spParam.put("CompCode", dataMaster.getM_COMP_CODE());
			spParam.put("DivCode", dataMaster.getM_DIV_CODE());
			spParam.put("PubNum", dataMaster.getM_PUB_NUM());
			spParam.put("OriginPubNum", dataMaster.getM_ORIGIN_PUB_NUM());
			spParam.put("SalePrsn", dataMaster.getM_SALE_PRSN());
			spParam.put("Remark", dataMaster.getM_REMARK());
			spParam.put("UserId", dataMaster.getM_USER_ID());
			spParam.put("BfoIssuId", dataMaster.getM_BFO_ISSU_ID());			
			super.commonDao.queryForObject("ssa561ukrvServiceImpl.pubModifyIssue", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));			
			if(!ObjUtils.isEmpty(errorDesc)){
				extResult.addResultProperty("PUB_NUM", "");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				extResult.addResultProperty("PUB_NUM", ObjUtils.getSafeString(spParam.get("AutoNum")));
			}			
		}else if(dataMaster.getM_MODE().equals("contractCancel")){
			
			spParam.put("Flag", dataMaster.getM_FLAG());
			spParam.put("CompCode", dataMaster.getM_COMP_CODE());
			spParam.put("DivCode", dataMaster.getM_DIV_CODE());
			spParam.put("PubNum", dataMaster.getM_PUB_NUM());
			spParam.put("OriginPubNum", dataMaster.getM_ORIGIN_PUB_NUM());
			spParam.put("SalePrsn", dataMaster.getM_SALE_PRSN());
			spParam.put("Remark", dataMaster.getM_REMARK());
			spParam.put("UserId", dataMaster.getM_USER_ID());
			spParam.put("MakeDate", dataMaster.getM_MAKE_DATE());
			spParam.put("BfoIssuId", dataMaster.getM_BFO_ISSU_ID());
			spParam.put("ModiReason", dataMaster.getM_MODI_REASON());			
			super.commonDao.queryForObject("ssa561ukrvServiceImpl.pubContractCancel", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				extResult.addResultProperty("PUB_NUM", "");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				extResult.addResultProperty("PUB_NUM", ObjUtils.getSafeString(spParam.get("AutoNum")));
			}
		}else{
			String keyValue = getLogKey();			
			//2.수주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
			dataMaster.setM_COMP_CODE(user.getCompCode());
			dataMaster.setM_KEY_VALUE(keyValue);

			if (ObjUtils.isEmpty(dataMaster.getM_PUB_NUM() )) {
				dataMaster.setM_OPR_FLAG("N");
			} else {
				dataMaster.setM_OPR_FLAG("U");
			}

			super.commonDao.insert("ssa561ukrvServiceImpl.insertLogMaster2", dataMaster);

			//4.수주저장 Stored Procedure 실행
			spParam.put("KeyValue", keyValue);
			spParam.put("LangCode", user.getLanguage());
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			super.commonDao.queryForObject("ssa561ukrvServiceImpl.pubIssue", spParam);
			if(!ObjUtils.isEmpty(errorDesc)){
				extResult.addResultProperty("PUB_NUM", "");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				extResult.addResultProperty("PUB_NUM", ObjUtils.getSafeString(spParam.get("AutoNum")));
			}
		}		

		//4.수주저장 Stored Procedure 실행
		

//		spParam.put("KeyValue", keyValue);
//		spParam.put("LangCode", user.getLanguage());
//
//		super.commonDao.queryForObject("spSalesOrder", spParam);
		
//		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
//		if(!errorDesc.isEmpty()){
//			extResult.addResultProperty("ORDER_NUM", "");
//			throw new Exception(errorDesc);
//		} else {
//			extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
//		}
		
//		dataMaster.setS_COMP_CODE(user.getCompCode());
//		super.commonDao.update("sof100ukrvServiceImpl.updateMasterForm", dataMaster);
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}

	/**
	 * 수정발행
	 * @param param
	 * @return
	 * @throws Exception
	 */
/*	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String> modifyUpdate(Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map<String, Object> spParam = new HashMap<String, Object>();	//returnData
		if(dataMaster.get("MODE") == "modifyUpdate"){	//수정발행
			spParam.put("StatusM", dataMaster.get("STATUS_M"));
			spParam.put("CompCode", dataMaster.get("COMP_CODE"));
			spParam.put("DivCode", dataMaster.get("DIV_CODE"));
			spParam.put("PubNum", dataMaster.get("PUB_NUM"));
			spParam.put("OriginPubNum", dataMaster.get("ORIGIN_PUB_NUM"));
			spParam.put("SalePrsn", dataMaster.get("SALE_PRSN"));
			spParam.put("Remark", dataMaster.get("REMARK"));
			spParam.put("UserId", dataMaster.get("USER_ID"));
			spParam.put("BfoIssuId", dataMaster.get("BFO_ISSU_ID"));			
				
			super.commonDao.queryForObject("ssa561ukrvServiceImpl.pubModifyIssue", spParam);
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

			if(!ObjUtils.isEmpty(errorDesc)){
				dataMaster.put("PUB_NUM", "");
				String[] messsage = errorDesc.split(";");
//			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			} else {
				dataMaster.put("PUB_NUM", ObjUtils.getSafeString(spParam.get("ReturnPumNum")));
			}	
			return  dataMaster;
		}
	}*/

	/**
	 * 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("ssa561ukrvServiceImpl.insertLogDetail", param);
		}
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {	
		return params;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		
	}

	/**
	 * 국세청전송완료건 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getBillSendCloseChk(Map param) throws Exception {
		return super.commonDao.select("ssa561ukrvServiceImpl.getBillSendCloseChk", param);
	}
}
