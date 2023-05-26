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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa100ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	/**
	 *
	 * 매출정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesNumMasterList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectSalesNumMaster", param);
	}

	/**
	 *
	 * 매출정보검색 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesNumDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectSalesNumDetail", param);
	}

	/**
	 *
	 * 영업담당자의 부서 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getDeptName(Map param) throws Exception {
		return super.commonDao.select("ssa100ukrvServiceImpl.getDeptName", param);
	}

	/**
	 *
	 * 수주 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectSalesOrderList", param);
	}

	/**
	 *
	 * 수주 참조(선매출) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPreviousSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectPreviousSalesOrderList", param);
	}

	/**
	 *
	 * 예외출고/반품출고참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectIssueList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectIssueList", param);
	}



	/**
	 * 매출정보 Master 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("ssa100ukrvServiceImpl.selectMaster", param);
	}

	/**
	 *
	 * 매출정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.selectDetailList", param);
	}

	/**
	 *
	 * 여신(담보)액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getCustCredit(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.getCustCredit", param);
	}

	/**
	 *
	 * LOT 연계여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getGsManageLotNoYN(Map param) throws Exception {
		return super.commonDao.list("ssa100ukrvServiceImpl.getGsManageLotNoYN", param);
	}

	/**
	 *
	 * ref_code2 = 반품환입인 총건수
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getGlSubCdTotCnt(Map param) throws Exception {
		return super.commonDao.select("ssa100ukrvServiceImpl.getGlSubCdTotCnt", param);
	}

	/**
	 *
	 * 마감 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getGetClosingInfo(Map param) throws Exception {
		return super.commonDao.select("ssa100ukrvServiceImpl.getGetClosingInfo", param);
	}

	/**
	 * 매출정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		//2.매출마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);

		if (ObjUtils.isEmpty(dataMaster.get("BILL_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}
		super.commonDao.insert("ssa100ukrvServiceImpl.insertLogMaster", dataMaster);

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

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("ssa100ukrvServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

	//  if(errorDesc.isEmpty())){
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("BILL_NUM", "");
			/*String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));*/
			throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("BILL_NUM", ObjUtils.getSafeString(spParam.get("BillNum")));
			//매출번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("BILL_NUM", ObjUtils.getSafeString(spParam.get("BillNum")));
					}
				}
			}
		}

		//5.매출마스터 정보 + 매출디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Ssa100ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		dataMaster.setCOMP_CODE(user.getCompCode());
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("BILL_TYPE"		, dataMaster.getBILL_TYPE());
		spParam.put("CARD_CUST_CD"	, dataMaster.getCARD_CUST_CD());
		spParam.put("ORDER_TYPE"	, dataMaster.getORDER_TYPE());
		spParam.put("PROJECT_NO"	, dataMaster.getPROJECT_NO());
		spParam.put("TAX_TYPE"		, dataMaster.getTAX_TYPE());
		spParam.put("REMARK"		, dataMaster.getREMARK());
		spParam.put("COMP_CODE"		, dataMaster.getCOMP_CODE());
		spParam.put("DIV_CODE"		, dataMaster.getDIV_CODE());
		spParam.put("BILL_NUM"		, dataMaster.getBILL_NUM());
		spParam.put("MONEY_UNIT"	, dataMaster.getMONEY_UNIT());
		spParam.put("EXCHG_RATE_O"	, dataMaster.getEXCHG_RATE_O());
		//20190709 추가
		spParam.put("SALE_PRSN"		, dataMaster.getSALE_PRSN());
		//20190709 추가
		spParam.put("PURCH_DOC_NO"	, dataMaster.getPURCH_DOC_NO());
		spParam.put("ISSUE_DATE"	, dataMaster.getISSUE_DATE());
		spParam.put("S_USER_ID"		, user.getUserID());
		// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
		spParam.put("CARD_CUSTOM_CODE", dataMaster.getCARD_CUSTOM_CODE());
		// 20210705 : 결제조건(PAYMENT_TERM), 결제예정일(PAYMENT_DAY) 추가
		spParam.put("PAYMENT_TERM", dataMaster.getPAYMENT_TERM());
		spParam.put("PAYMENT_DAY", dataMaster.getPAYMENT_DAY());
		
		//20200629 추가: SSA100T 업데이트 하기 전에 기표 / 세금계산서 발행여부 체크하는 로직 추가
		String errorDesc = (String) super.commonDao.select("ssa100ukrvServiceImpl.updateMaster", spParam);
		if(ObjUtils.isNotEmpty(errorDesc)) {
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return extResult;
	}

	/**
	 * 매출디테일 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			super.commonDao.insert("ssa100ukrvServiceImpl.insertLogDetail", param);
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
	 * 창고조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  deptWhcode(Map param) throws Exception {
		return  super.commonDao.select("ssa100ukrvServiceImpl.deptWhcode", param);
	}























//	/**
//	 *
//	 * 매출이력 참조 조회
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
//	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
//		return super.commonDao.list("ssa100ukrvServiceImpl.selectRefList", param);
//	}





//	/**
//	 * 매출정보 삭제
//	 *
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
//	public void deleteMaster(Map param, LoginVO user) throws Exception {
//
//		/*매출승인단계 - 체크*/
//		checkStatus( param,  user);
//		/*매출 진행정보 체크*/
//		checkProgress(param, "Master", user);
//		/*견적확정정보 조회 & 견적정보 Update*/
//		checkEstimate(param, user);
//		/*SCM연계정보 조회 체크*/
//		String oScmYn = this.getScm(param);
//		if("Y".equals(oScmYn))	{
//			checkScm(param, user);
//		}
//		super.commonDao.delete("ssa100ukrvServiceImpl.deleteMaster", param);
//	}

//	/**
//	 * 매출 마스터 저장(등록/수정)
//	 *
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_POST)
//	public ExtDirectFormPostResult syncMaster(Ssa100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
//		Map<String, Object> paramMap = this.makeMapParam(param, user);
//
//		if (ObjUtils.isEmpty(paramMap.get("ORDER_NUM") )) {
//			Map<String, Object> autoNum = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.autoNum", paramMap);
//			String OrderNum = ObjUtils.getSafeString(autoNum.get("ORDER_NUM"));
//			paramMap.put("ORDER_NUM", OrderNum);
//			beforeSaveMaster(paramMap, user);
//			super.commonDao.insert("ssa100ukrvServiceImpl.insertMaster", paramMap);
//		}else {
//			beforeSaveMaster(paramMap, user);
//			super.commonDao.update("ssa100ukrvServiceImpl.updateMaster", paramMap);
//		}
//
//		super.commonDao.update("ssa100ukrvServiceImpl.updatePrice", paramMap);
//
//		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
//		extResult.addResultProperty("ORDER_NUM", ObjUtils.getSafeString(paramMap.get("ORDER_NUM")));
//		return extResult;
//	}

















//	public Map<String, Object> saveMaster(Map<String, Object> paramMap, LoginVO user) throws Exception {
//		//Map<String, Object> paramMap = this.makeMapParam(param, user);
//
//		if (ObjUtils.isEmpty(paramMap.get("ORDER_NUM") )) {
//			Map<String, Object> autoNum = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.autoNum", paramMap);
//			String OrderNum = ObjUtils.getSafeString(autoNum.get("ORDER_NUM"));
//			paramMap.put("ORDER_NUM", OrderNum);
//			beforeSaveMaster(paramMap, user);
//			super.commonDao.insert("ssa100ukrvServiceImpl.insertMaster", paramMap);
//		}else {
//			beforeSaveMaster(paramMap, user);
//			super.commonDao.update("ssa100ukrvServiceImpl.updateMaster", paramMap);
//		}
//
//		super.commonDao.update("ssa100ukrvServiceImpl.updatePrice", paramMap);
//
//
//		return paramMap;
//	}
//
//	private Map<String, Object> makeMapParam(Ssa100ukrvModel param, LoginVO user)	{
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//		paramMap.put("ORDER_NUM", param.getORDER_NUM());
//		paramMap.put("COMP_CODE", param.getCOMP_CODE());
//		paramMap.put("DIV_CODE", param.getDIV_CODE());
//
//		paramMap.put("CUSTOM_CODE", param.getCUSTOM_CODE());
//		paramMap.put("AGENT_TYPE", param.getAGENT_TYPE());
//		paramMap.put("ORDER_DATE", param.getORDER_DATE());
//		paramMap.put("ORDER_TYPE", param.getORDER_TYPE());
//		paramMap.put("MONEY_UNIT", param.getMONEY_UNIT());
//		paramMap.put("ORDER_O", param.getORDER_O());
//		paramMap.put("ORDER_TAX_O", param.getORDER_TAX_O());
//		paramMap.put("EXCHG_RATE_O", param.getEXCHG_RATE_O());
//		paramMap.put("ORDER_PRSN", param.getORDER_PRSN());
//		paramMap.put("DEPT_CODE", param.getDEPT_CODE());
//		paramMap.put("PO_NUM", param.getPO_NUM());
//		paramMap.put("CREATE_LOC", param.getCREATE_LOC());
//		paramMap.put("TAX_INOUT", param.getTAX_INOUT());
//		paramMap.put("BILL_TYPE", param.getBILL_TYPE());
//		paramMap.put("RECEIPT_SET_METH", param.getRECEIPT_SET_METH());
//		paramMap.put("PROJECT_NO", param.getPROJECT_NO());
//		paramMap.put("REMARK", param.getREMARK());
//		paramMap.put("PROMO_NUM", param.getPROMO_NUM());
//		paramMap.put("STATUS", param.getSTATUS());
//		paramMap.put("APP_1_ID", param.getAPP_1_ID());
//		paramMap.put("APP_1_DATE", param.getAPP_1_DATE());
//		paramMap.put("AGREE_1_YN", param.getAGREE_1_YN());
//		paramMap.put("APP_2_ID", param.getAPP_2_ID());
//		paramMap.put("APP_2_DATE", param.getAPP_2_DATE());
//		paramMap.put("AGREE_2_YN", param.getAGREE_2_YN());
//		paramMap.put("APP_3_ID", param.getAPP_3_ID());
//		paramMap.put("APP_3_DATE", param.getAPP_3_DATE());
//		paramMap.put("AGREE_3_YN", param.getAGREE_3_YN());
//		paramMap.put("APP_STEP", param.getAPP_STEP());
//		paramMap.put("RETURN_ID", param.getRETURN_ID());
//		paramMap.put("RETURN_DATE", param.getRETURN_DATE());
//		paramMap.put("RETURN_MSG", param.getRETURN_MSG());
//
//		paramMap.put("ORDER_NAME", param.getORDER_NAME());
//		paramMap.put("PAY_METHOD", param.getPAY_METHOD());
//		paramMap.put("INSPECT_ORG", param.getINSPECT_ORG());
//		paramMap.put("DEF_RATE", param.getDEF_RATE());
//		paramMap.put("DEF_TERM", param.getDEF_TERM());
//		paramMap.put("DEF_RESP_TERM", param.getDEF_RESP_TERM());
//		paramMap.put("DEFERMENT_RATE", param.getDEFERMENT_RATE());
//		paramMap.put("PAY_COND", param.getPAY_COND());
//		paramMap.put("gsDraftFlag", param.getGsDraftFlag());
//
//		paramMap.put("S_COMP_CODE", user.getCompCode());
//		paramMap.put("S_USER_ID", user.getUserID());
//
//		return paramMap;
//	}

//	/**
//	 * 마스터 데아타 저장(Insert,Update) 전 확인
//	 * @param param
//	 * @param user
//	 */
//	private void beforeSaveMaster(Map param, LoginVO user) throws Exception	{
//		if("Y".equals(ObjUtils.getSafeString(param.get("gsDraftFlag"))))	{
//			//승인진행여부 확인
//			checkStatus(param, user);
//			//매출 진행 정보 확인
//			checkProgress(param, "Master", user);
//			//수불정보 update
//			super.commonDao.queryForObject("ssa100ukrvServiceImpl.checkOrderType", param);
//		}
//	}
//
//
//	public List<Map> insertDetails(List<Map> params, Map<String,  Object> paramMap, LoginVO user) throws Exception {
//		for(Map param: params)		{
//			param.put("ORDER_NUM", paramMap.get("ORDER_NUM")); //master 의 매출번호
//
//			Map<String, Object> checkSerNo =  (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkSerNo", param);
//			if(!ObjUtils.isEmpty(checkSerNo))	{
//				Map<String, Object> autoSerNo =  (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.autoSerNo", param);
//				param.put("SER_NO", ObjUtils.getSafeString(autoSerNo.get("SER_NO")));
//			}
//			beforeSaveDetail(param, user, "insert");
//			super.commonDao.insert("ssa100ukrvServiceImpl.insertDetail", param);
//		}
//
//		return params;
//	}
//
//
//
//	/**
//	 * 디테일 데아타 저장(Insert,Update) 전 확인
//	 * @param param
//	 * @param user
//	 */
//	private void beforeSaveDetail(Map param, LoginVO user, String saveMode) throws Exception	{
//		if("Y".equals(ObjUtils.getSafeString(param.get("gsDraftFlag"))))	{
//			Map<String, Object> itemInfo = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.itemInfo", param);
//			if(!ObjUtils.isEmpty(itemInfo))	{
//				throw new  UniDirectValidateException(this.getMessage("54445", user));	/* 54445:존재하지 않는 품목입니다. 품목정보를 확인하세요(영업공통) */
//			}else {
//				if("N".equals(itemInfo.get("USE_YN")))	{
//					throw new  UniDirectValidateException(this.getMessage("54444", user));	 /* 54444:사용불가 품목입니다.품목정보의 사용유무를 확인하세요.(영업공통) */
//				}
//			}
//		}
//			//매출 진행 정보 확인
//		//checkProgress(param, "Detail", user);
//
//		//데이타 비교
//		if("update".equals(saveMode) )
//		{
//			checkCompare(param, user);
//		}
//		//견적 확인
//		if(!ObjUtils.isEmpty(param.get("ESTI_NUM")))	{
//			checkEstimateDetail(param, user, saveMode);
//		}
//		//SCM 연계 확인
//		String oScmYn = this.getScm(param);
//		if("Y".equals(oScmYn))	{
//			checkScm(param, user);
//		}
//	}
//
//	private void checkCompare(Map<String, Object> param, LoginVO user) throws Exception {
//		Map<String, Object> checkDetailData = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkDetailData", param);
//		int sCase=0;
//
//		if(!ObjUtils.isEmpty(checkDetailData))	{
//			double saleQ =  ObjUtils.parseDouble(checkDetailData.get("SALE_Q"));
//			String orderStatus =  ObjUtils.getSafeString(checkDetailData.get("ORDER_STATUS"));
//			String accountYnc =  ObjUtils.getSafeString(checkDetailData.get("ACCOUNT_YNC"));
//			String priceYn =  ObjUtils.getSafeString(checkDetailData.get("PRICE_YN"));
//			double orderP =  ObjUtils.parseDouble(checkDetailData.get("ORDER_P"));
//			String itemCode =  ObjUtils.getSafeString(checkDetailData.get("ITEM_CODE"));
//			double orderQ =  ObjUtils.parseDouble(checkDetailData.get("ORDER_Q"));
//			String dvryDate =  ObjUtils.getSafeString(checkDetailData.get("DVRY_DATE"));
//			String taxType =  ObjUtils.getSafeString(checkDetailData.get("TAX_TYPE"));
//			String orderUnit =  ObjUtils.getSafeString(checkDetailData.get("ORDER_UNIT"));
//			String saleCustCd =  ObjUtils.getSafeString(checkDetailData.get("SALE_CUST_CD"));
//			String dvryCustCd =  ObjUtils.getSafeString(checkDetailData.get("DVRY_CUST_CD"));
//			String outDivCode =  ObjUtils.getSafeString(checkDetailData.get("OUT_DIV_CODE"));
//			double transRate =  ObjUtils.parseDouble(checkDetailData.get("TRANS_RATE"));
//			String prodEndDate =  ObjUtils.getSafeString(checkDetailData.get("PROD_END_DATE"));
//			double prodQ =  ObjUtils.parseDouble(checkDetailData.get("PROD_Q"));
//			double issueReqQ =  ObjUtils.parseDouble(checkDetailData.get("ISSUE_REQ_Q"));
//			double outStockQ =  ObjUtils.parseDouble(checkDetailData.get("OUTSTOCK_Q"));
//			double returnQ =  ObjUtils.parseDouble(checkDetailData.get("RETURN_Q"));
//			double reqIssueQty =  ObjUtils.parseDouble(checkDetailData.get("REQ_ISSUE_QTY"));
//			String maxPubNum =  ObjUtils.getSafeString(checkDetailData.get("MAX_PUB_NUM"));
//
//			if(saleQ > 0)	{
//		             if(
//			                 !orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS")))
//			            	 &&
//				             (  	!accountYnc.equals(param.get("ACCOUNT_YNC"))  ||
//					                ( !priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1") ) ||
//					                ( orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1") )
//				             )
//				             &&
//			                 (
//			                    itemCode.equals(param.get("ITEM_CODE")) &&
//			                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
//			                    dvryDate.equals(param.get("DVRY_DATE")) &&
//			                    taxType.equals(param.get("TAX_TYPE")) &&
//			                    orderUnit.equals(param.get("ORDER_UNIT")) &&
//			                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
//			                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
//			                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
//			                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
//			                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
//			                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
//			                )
//		               )
//		            {
//		            	 	sCase = 6;
//
//		            }
//		             else if(
//			                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
//			                 	itemCode.equals(param.get("ITEM_CODE")) &&
//			                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
//			                    orderP == ObjUtils.parseDouble(param.get("ORDER_P")) &&
//			                    dvryDate.equals(param.get("DVRY_DATE")) &&
//			                    priceYn.equals(param.get("PRICE_YN")) &&
//			                    taxType.equals(param.get("TAX_TYPE")) &&
//			                    orderUnit.equals(param.get("ORDER_UNIT")) &&
//			                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
//			                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
//			                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
//			                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
//			                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
//			                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
//			                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
//		            	   )
//		             {
//		                sCase = 5;
//		             }
//		             else if(
//			                 	!orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
//			                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
//			                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
//			                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
//			                    !dvryDate.equals(param.get("DVRY_DATE")) ||
//			                    !priceYn.equals(param.get("PRICE_YN")) ||
//			                    !taxType.equals(param.get("TAX_TYPE")) ||
//			                    !orderUnit.equals(param.get("ORDER_UNIT")) ||
//			                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||
//			                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||
//			                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||
//			                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
//			                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
//			                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
//			                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")) 	)
//		            		 )
//		             {
//		            	 sCase = 4;
//		             }
//		             else if(
//			            		 orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS")))
//				            	 &&
//					             (  	!accountYnc.equals(param.get("ACCOUNT_YNC"))  ||
//						                ( !priceYn.equals(param.get("PRICE_YN")) && priceYn.equals("1") ) ||
//						                ( orderP != ObjUtils.parseDouble(param.get("ORDER_P")) && priceYn.equals("1") )
//					             )
//					             &&
//				                 (
//				                    itemCode.equals(param.get("ITEM_CODE")) &&
//				                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
//				                    dvryDate.equals(param.get("DVRY_DATE")) &&
//				                    taxType.equals(param.get("TAX_TYPE")) &&
//				                    orderUnit.equals(param.get("ORDER_UNIT")) &&
//				                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
//				                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
//				                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
//				                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
//				                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
//				                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
//				                )
//		            		 )
//		             {
//		                sCase = 3;
//		             }
//		             else if(
//			                 	orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
//			                 	(!itemCode.equals(param.get("ITEM_CODE")) ||
//			                    orderQ != ObjUtils.parseDouble(param.get("ORDER_Q")) ||
//			                    orderP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
//			                    !dvryDate.equals(param.get("DVRY_DATE")) ||
//			                    !priceYn.equals(param.get("PRICE_YN")) ||
//			                    !taxType.equals(param.get("TAX_TYPE")) ||
//			                    !orderUnit.equals(param.get("ORDER_UNIT")) ||
//			                    !saleCustCd.equals(param.get("SALE_CUST_CD")) ||
//			                    !dvryCustCd.equals(param.get("DVRY_CUST_CD")) ||
//			                    !outDivCode.equals(param.get("OUT_DIV_CODE")) ||
//			                    transRate != ObjUtils.parseDouble(param.get("TRANS_RATE")) ||
//			                    !prodEndDate.equals(param.get("PROD_END_DATE")) ||
//			                    !accountYnc.equals(param.get("ACCOUNT_YNC")) ||
//			                    prodQ != ObjUtils.parseDouble(param.get("PROD_Q")) 	)
//		            		 )
//		             {
//		                sCase = 2;
//		             } else {
//		                sCase = 1;
//		             }
//			}
//
//	        if("1".equals(priceYn))	{
//	        	if(
//	        			orderStatus.equals(ObjUtils.getSafeString(param.get("ORDER_STATUS"))) &&
//	                 	itemCode.equals(param.get("ITEM_CODE")) &&
//	                    orderQ == ObjUtils.parseDouble(param.get("ORDER_Q")) &&
//	                    dvryDate.equals(param.get("DVRY_DATE")) &&
//	                    priceYn.equals(param.get("PRICE_YN")) &&
//	                    taxType.equals(param.get("TAX_TYPE")) &&
//	                    orderUnit.equals(param.get("ORDER_UNIT")) &&
//	                    saleCustCd.equals(param.get("SALE_CUST_CD")) &&
//	                    dvryCustCd.equals(param.get("DVRY_CUST_CD")) &&
//	                    outDivCode.equals(param.get("OUT_DIV_CODE")) &&
//	                    transRate == ObjUtils.parseDouble(param.get("TRANS_RATE")) &&
//	                    prodEndDate.equals(param.get("PROD_END_DATE")) &&
//	                    accountYnc.equals(param.get("ACCOUNT_YNC")) &&
//	                    prodQ == ObjUtils.parseDouble(param.get("PROD_Q"))
//	        	  )
//	        	{
//	        		sCase = 0;
//	        	}
//
//
//	        }
//
//	        if(sCase != 0)	{
//	        	if( !(sCase == 1 || sCase == 3 ||
//	        	   ((sCase == 5 || sCase == 6) && orderQ > issueReqQ)
//	        	  ) )
//		        {
//		        	throw new  UniDirectValidateException(this.getMessage("54460", user));
//		        }
//	        }
//
//	        if(outStockQ > 0 || returnQ > 0) {
//	        	if(ObjUtils.parseDouble(param.get("OUTSTOCK_Q")) < outStockQ )	{
//	        		throw new  UniDirectValidateException(this.getMessage("54461", user));
//	        	}
//	        	if(itemCode.equals(param.get("ITEM_CODE")))	{
//	        		throw new  UniDirectValidateException(this.getMessage("54431", user));
//	        	}
//	        }
//
//	        if("N".equals(orderStatus) && "Y".equals(param.get("ORDER_STATUS")))	{
//	        	if((orderQ + returnQ - outStockQ) == 0 )	{
//	        		throw new  UniDirectValidateException(this.getMessage("54440", user));	// 54440:해당 매출건에 대해 강제마감할 자료가 없습니다.(완납)
//	        	}
//	        }
//
//	        if(sCase > 0)	{
//	        	if(!(sCase == 1 || sCase == 3 || ((sCase == 5 || sCase ==6) && (reqIssueQty > 0 ))))	{
//	        		Map<String, Object> checkSaleQ = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkSaleQ", param);
//	        		if(!ObjUtils.isEmpty(checkSaleQ))	{
//	        			throw new  UniDirectValidateException(this.getMessage("54494", user));
//	        		}
//	        	}
//	        }
//
//	        if(orderP != ObjUtils.parseDouble(param.get("ORDER_P")))	{
//	        	if(maxPubNum != null && !"".equals(maxPubNum))	{
//	        		throw new  UniDirectValidateException(this.getMessage("54483", user));
//	        	}
//	        }
//
//
//	        if(outStockQ > 0)	{
//		        List<Map<String, Object>> checkListSSA110 = (List<Map<String, Object>>)super.commonDao.list("ssa100ukrvServiceImpl.checkSSA110", param);
//		        if(ObjUtils.isEmpty(checkListSSA110))	{
//		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
//		        } else 	{
//
//		        	for(Map<String, Object> checkSSA110 : checkListSSA110)	{
//		        		int sFlg = 0;
//		        		Map mapfCompute = new HashMap();
//		        		double saleP = ObjUtils.parseDouble(checkSSA110.get("SALE_P"));
//		        		String ssa110_priceYn = ObjUtils.getSafeString(checkSSA110.get("PRICE_YN"));
//		        		if("N".equals(accountYnc) && "Y".equals(param.get("ACCOUNT_YNC")) &&  saleP != ObjUtils.parseDouble(param.get("ORDER_P")) ||
//		        		   "Y".equals(accountYnc) && "N".equals(param.get("ACCOUNT_YNC")) &&  saleP == ObjUtils.parseDouble(param.get("ORDER_P")) ||
//		        		   !ssa110_priceYn.equals(param.get("PRICE_YN")) && "1".equals(ssa110_priceYn)
//		        		  )	{
//		        			Map ssa110Param = new HashMap();
//		        			ssa110Param.put("TAX_TYPE", checkSSA110.get("TAX_TYPE"));
//		        			ssa110Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
//		        			ssa110Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
//		        			ssa110Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
//		        			ssa110Param.put("TRANS_RATE", checkSSA110.get("TRANS_RATE"));
//		        			ssa110Param.put("SALE_Q", checkSSA110.get("SALE_Q"));
//
//		        			double dParam_Unit_P = 0.0;
//		        			if("N".equals(param.get("ACCOUNT_YNC")))	{
//		        				dParam_Unit_P = 0;
//		        			}else {
//		        				dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));
//		        			}
//
//		        			mapfCompute = SalesUtil.fnReCompute(ssa110Param, dParam_Unit_P);
//
//		        			sFlg = 1;
//		        		}else if( !ssa110_priceYn.equals(param.get("PRICE_YN")))	{
//		        			sFlg = 2;
//		        		}
//
//
//		        		if(sFlg != 0)	{
//		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
//		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
//		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
//		        			paramSRQ100.put("OUT_DIV_CODE", param.get("OUT_DIV_CODE"));
//		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
//		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
//		        			paramSRQ100.put("INOUT_NUM", checkSSA110.get("INOUT_NUM"));
//		        			paramSRQ100.put("INOUT_SEQ", checkSSA110.get("INOUT_SEQ"));
//
//		        			if(sFlg == 1)	{
//		        				paramSRQ100.put("INOUT_FOR_P", mapfCompute.get("dParamP"));
//		        				paramSRQ100.put("INOUT_FOR_O", mapfCompute.get("dParamI"));
//		        				paramSRQ100.put("ORDER_UNIT_P", mapfCompute.get("dParam_Unit_P"));
//		        				paramSRQ100.put("ORDER_UNIT_O", mapfCompute.get("dParam_Unit_I"));
//		        				paramSRQ100.put("INOUT_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
//		        			}
//
//
//		        			super.commonDao.update("ssa100ukrvServiceImpl.updateBTR100", paramSRQ100);
//
//		        		}
//		        	}
//
//	        	}
//	        }
//
//	        if(issueReqQ > 0)	{
//	        	List<Map<String, Object>> checkListSRQ100 = (List<Map<String, Object>>)super.commonDao.list("ssa100ukrvServiceImpl.checkSRQ100", param);
//
//		        if(ObjUtils.isEmpty(checkListSRQ100))	{
//		        	throw new  UniDirectValidateException(this.getMessage("54400", user));
//		        }else {
//		        	for(Map<String, Object> checkSRQ100 : checkListSRQ100)	{
//		        		int sFlg = 0;
//		        		Map mapfCompute = new HashMap();
//
//
//		        		if(ObjUtils.parseDouble(param.get("ORDER_P")) != ObjUtils.parseDouble(checkSRQ100.get("ORDER_P")) )	{
//		        			Map ssa110Param = new HashMap();
//		        			ssa110Param.put("TAX_TYPE", checkSRQ100.get("TAX_TYPE"));
//		        			ssa110Param.put("M_TAX_TYPE", checkDetailData.get("M_TAX_TYPE"));
//		        			ssa110Param.put("WON_CALC_BAS", checkDetailData.get("WON_CALC_BAS"));
//		        			ssa110Param.put("VAT_RATE", checkDetailData.get("VAT_RATE"));
//		        			ssa110Param.put("TRANS_RATE", checkSRQ100.get("TRANS_RATE"));
//		        			ssa110Param.put("SALE_Q", checkSRQ100.get("ISSUE_REQ_QTY"));
//
//		        			double dParam_Unit_P = ObjUtils.parseDouble(param.get("ORDER_P"));
//
//		        			mapfCompute = SalesUtil.fnReCompute(ssa110Param, dParam_Unit_P);
//
//		        			sFlg = 1;
//		        		}else if( !priceYn.equals(ObjUtils.getSafeString(checkSRQ100.get("PRICE_YN"))))	{
//		        			sFlg = 2;
//		        		}else if(!accountYnc.equals(ObjUtils.getSafeString(checkSRQ100.get("ACCOUNT_YNC"))))	{
//		        			sFlg = 3;
//		        		}
//
//
//		        		if(sFlg != 0)	{
//		        			Map<String, Object> paramSRQ100 = new HashMap<String, Object>();
//		        			paramSRQ100.put("S_COMP_CODE", param.get("S_COMP_CODE"));
//		        			paramSRQ100.put("ACCOUNT_YNC", param.get("ACCOUNT_YNC"));
//		        			paramSRQ100.put("DIV_CODE", param.get("DIV_CODE"));
//		        			paramSRQ100.put("ORDER_NUM", param.get("ORDER_NUM"));
//		        			paramSRQ100.put("SER_NO", param.get("SER_NO"));
//		        			paramSRQ100.put("INOUT_NUM", checkSRQ100.get("INOUT_NUM"));
//		        			paramSRQ100.put("INOUT_SEQ", checkSRQ100.get("INOUT_SEQ"));
//
//		        			if(sFlg == 1)	{
//		        				paramSRQ100.put("ISSUE_REQ_PRICE", mapfCompute.get("dParam_Unit_P"));
//		        				paramSRQ100.put("ISSUE_REQ_AMT", mapfCompute.get("dParam_Unit_I"));
//		        				paramSRQ100.put("ISSUE_REQ_TAX_AMT", mapfCompute.get("dParam_Unit_T"));
//		        			}
//
//		        			super.commonDao.update("ssa100ukrvServiceImpl.updateSRQ100", paramSRQ100);
//
//		        		}
//		        	}
//		        }
//	        }
//
//		}
//	}
//
//	@ExtDirectMethod(group = "sales")
//	public Integer  syncAll(Map param) throws Exception {
//		logger.debug("syncAll:" + param);
//		return  0;
//	}
//
//	/**
//	 * 매출 Detail 삭제
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//
//
//	/**
//	 * 견적확정정보 조회 & 견적정보 Update
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	private void checkEstimate(Map param, LoginVO user) throws Exception {
//		List<Map<String, Object>> params = super.commonDao.list("ssa100ukrvServiceImpl.checkEstimate", param);
//
//		 if(!ObjUtils.isEmpty(params))	{
//				Map<String, Object> cfrmData = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkEstimateConfirm", params.get(0));
//
//				if(!ObjUtils.isEmpty(cfrmData))	{
//					if(!"2".equals(cfrmData.get("CONFIRM_FLAG")))	{
//						throw new  UniDirectValidateException(this.getMessage("54458", user));	/* 54458:이미 취소되었거나 확정되지 않았습니다. */
//					}
//					for(Map<String, Object> estiParam : params)	{
//						super.commonDao.update("ssa100ukrvServiceImpl.updateEstimateConfirm", estiParam);
//					}
//				}else {
//					throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
//				}
//			}
//
//	}
//
//	/**
//	 * 견적확정정보 조회 & 견적정보 Update - 매출정보 Detail 저장시 사용
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	private void checkEstimateDetail(Map param, LoginVO user, String saveMode) throws Exception {
//
//				Map<String, Object> cfrmData = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkEstiDetail", param);
//				if(!ObjUtils.isEmpty(cfrmData))	{
//					if(!"2".equals(cfrmData.get("CONFIRM_FLAG")))	{
//						throw new  UniDirectValidateException(this.getMessage("54458", user));	/* 54458:이미 취소되었거나 확정되지 않았습니다. */
//					}
//
//					if("update".equals(saveMode))	param.put("SES100T_ORDER_Q", cfrmData.get("ORDER_Q"));
//					else  param.put("SES100T_ORDER_Q", 0);
//
//					super.commonDao.update("ssa100ukrvServiceImpl.updateEstimateDetailConfirm", param);
//
//				}else {
//					throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
//				}
//
//
//
//	}
//
//	/**
//	 * SCM연계정보 조회 체크
//	 * @param param
//	 * @param user
//	 * @throws Exception
//	 */
//	private void checkScm(Map param, LoginVO user) throws Exception {
//		List<Map<String, Object>> params = super.commonDao.list("ssa100ukrvServiceImpl.checkSCM", param);
//		if(!ObjUtils.isEmpty(params))	{
//			Map<String, Object> baseData = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkSCMDetail", param);
//
//			if(!ObjUtils.isEmpty(baseData))	{
//				if(ObjUtils.isEmpty(baseData.get("DB_NAME")))	{
//					throw new  UniDirectValidateException(this.getMessage("68022", user));	/*  68022:B605(=SCM연계정보)의 관련3[DataBase명] 이 누락되어있습니다.*/
//				}
//
//				if(ObjUtils.isEmpty(baseData.get("COMP_CODE")))	{
//					throw new  UniDirectValidateException(this.getMessage("68023", user));	/* 68023:B605(=SCM연계정보)의 관련4[법인코드] 가 누락되어있습니다. */
//				}
//
//				if(ObjUtils.isEmpty(baseData.get("DIV_CODE")))	{
//					throw new  UniDirectValidateException(this.getMessage("68024", user));	/* 68024:B605(=SCM연계정보)의 관련5[사업장코드] 가 누락되어있습니다.*/
//				}
//
//				for(Map<String, Object> scmParam : params)	{
//					scmParam.putAll(baseData);
//					Map<String, Object> dData = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkSCMDelete", scmParam);
//					if(ObjUtils.isEmpty(dData))	{
//						throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통) */
//					}else {
//						String controlStatus = ObjUtils.getSafeString(dData.get("CONTROL_STATUS"));
//						if("2".equals(controlStatus))	{
//							throw new  UniDirectValidateException(this.getMessage("54614", user));/* 54614:입고된 발주는 수정할수 없습니다. [수정불가] */
//						} else if("3".equals(controlStatus))	{
//							throw new  UniDirectValidateException(this.getMessage("54483", user));/* 54483:계산서처리된 자료입니다. 확인하시기 바랍니다. */
//						} else if("8".equals(controlStatus))	{
//							throw new  UniDirectValidateException(this.getMessage("68025", user));/* 68025:수입참조된 자료는 수정 및 삭제가 불가능 합니다. */
//						} else if("9".equals(controlStatus))	{
//							throw new  UniDirectValidateException(this.getMessage("54100", user));/* 54100:이미 마감된 자료 입니다. */
//						} else if("1".equals(controlStatus) || "7".equals(controlStatus))	{
//							super.commonDao.update("ssa100ukrvServiceImpl.updateSCM", scmParam);
//						}
//
//					}
//				}
//			}else {
//				throw new  UniDirectValidateException(this.getMessage("68021", user));	/* 68021:B605(=SCM연계정보)공통코드가 등록되어 있지 않거나 관련 참조값이 누락되어있습니다. */
//			}
//		}
//	}
//
//	/**
//	 * 매출등록(SCM연계) 사용여부 값 조회
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	private String  getScm(Map param)  throws Exception {
//		Map<String, Object> scm = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.getSCM", param);
//		String r = "N";
//		if(!ObjUtils.isEmpty(scm))	{
//			r = ObjUtils.getSafeString(scm.get("REF_CODE1"));
//		}
//		return  r;
//	}
//
//	/**
//	 * 매출승인단계 - 사용
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	private void  checkStatus(Map param, LoginVO user)  throws Exception {
//		Map<String, Object> obj = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkStatus", param);
//		String r = "";
//		if(!ObjUtils.isEmpty(obj))	{
//			r = ObjUtils.getSafeString(obj.get("STATUS"));
//			if(!"1".equals(r) && !"5".equals(r) )	{
//				throw new  UniDirectValidateException(this.getMessage("55442", user));	/* 55442:매출승인이 진행된 건은 수정/삭제할 수 없습니다.*/
//			}
//		}
//	}
//
//	/**
//	 * 매출 진행정보 체크
//	 * @param param
//	 * @param type : Master, Detail
//	 * @param user
//	 * @throws Exception
//	 */
//	private void  checkProgress(Map param, String type, LoginVO user)  throws Exception {
//		// (Map<String, Object>)
//		Map<String, Object> obj = null;
//		if("Master".equals(type))	{
//			obj = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkProgressMaster", param);
//		}else {
//			obj = (Map<String, Object>)super.commonDao.select("ssa100ukrvServiceImpl.checkProgressDetail", param);
//		}
//
//		if(ObjUtils.isEmpty(obj))	{
//			throw new  UniDirectValidateException(this.getMessage("54400", user));	/* 54400:이미 삭제된 자료입니다.(영업공통)*/
//		} else {
//			if(ObjUtils.parseInt(obj.get("ISSUE_REQ_Q")) > 0)	{
//				throw new  UniDirectValidateException(this.getMessage("54460", user));	/* 54460:출하지시가 진행중인 매출내역을 수정/삭제할 수 없습니다.*/
//			}
//
//			if(ObjUtils.parseInt(obj.get("SALE_Q")) > 0)	{
//				throw new  UniDirectValidateException(this.getMessage("54412", user));	/* 54460:출고가 진행중인 매출내역은 삭제가 불가능합니다.(매출내역 삭제시)*/
//			}
//
//			if(ObjUtils.parseInt(obj.get("RETURN_Q")) > 0)	{
//				throw new  UniDirectValidateException(this.getMessage("54446", user));	/* 54446:반품이 진행된 매출내역은 삭제할 수 없습니다.*/
//			}
//		}
//	}
//
//	 /**
//     *
//     * 매출이력 참조 조회
//     * @param param
//     * @return
//     * @throws Exception
//     */
//    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
//    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
//        return super.commonDao.list("ssa100ukrvServiceImpl.selectExcelUploadSheet1", param);
//    }
}