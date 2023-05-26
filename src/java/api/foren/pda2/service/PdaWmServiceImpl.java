package api.foren.pda2.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import api.foren.pda2.dto.wmDto.Pdm300ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdm300ukrvDetailDTO;
import api.foren.pda2.dto.wmDto.Pdm400ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdm400ukrvDetailDTO;
import api.foren.pda2.dto.wmDto.Pdp400ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdp400ukrvDetailDTO;
import api.foren.pda2.dto.wmDto.Pds200ukrvDTO;
import api.foren.pda2.dto.wmDto.Pds200ukrvDetailDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.z_wm.S_Str104ukrv_wmServiceImpl;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@SuppressWarnings("unchecked")
@Service("pdaWmService")
public class PdaWmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "s_str104ukrv_wmService")
	private S_Str104ukrv_wmServiceImpl erpWmService;


	/**
	 * 생산실적 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> s_pdp100ukrv_wm_search(Map<String,Object> params){
		return super.commonDao.list("pdaWmService.s_pdp100ukrv_wm_search",params);
	}
	/**
	 * 출고정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> s_pdp100ukrv_wm_chk_save11(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[s_pdp100ukrv_wm_chk_save] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
//		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);

				param.put("data", super.commonDao.insert("PdaWmServiceImpl.insert_pdp100ukrv", param));
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("PdaWmServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String salePrsnChk = ObjUtils.getSafeString(spParam.get("SalePrsnChk"));

		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			if(!ObjUtils.isEmpty(salePrsnChk)){
				dataMaster.put("SALE_PRSN_CHK", salePrsnChk);
			}
			//수주번호 그리드에 SET
			for(Map param: paramList) {
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
	 * 출고요청 저장
	 * @param paramList
	 * @throws Exception

	public void s_pdp100ukrv_wm_chk_save2222(List<Map> paramList) throws Exception {
		logger.debug("[saveAll] params:" + paramList);

		logger.debug("**********************************************************************" );
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", 'N');
		logger.debug("keyValue" + keyValue);
		super.commonDao.list("pdaWmService.insert_pdp100ukrv",params);

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", "");

		super.commonDao.queryForObject("PdaWmServiceImpl.spReceiving", spParam);
		String ErrorDesc = ObjUtils.getSafeString(params.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, "").substring(this.getMessage(ErrorDesc, "").indexOf("||")+2));

//			throw new Exception(ErrorDesc);
		}

	} */

	public void s_pdp100ukrv_wm_chk_save(List<Map> paramList) throws Exception {
			String keyValue = getLogKey();
			int seq = 0;
			List<Map> dataList = new ArrayList<Map>();
			for(Map params:	paramList) {
			SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
			Date dateGet = new Date ();
			String dateGetString = dateFormat.format(dateGet);

			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", 'N');

			//super.commonDao.list("pdaWmService.insert_pdp100ukrv",params);

			//params.put("PRODT_NUM",	ObjUtils.getSafeString(params.get("KEY_NUMBER")));

			super.commonDao.insert("pdaWmService.insert_pdp100ukrv", params);

			params.put("KeyValue", keyValue);
			params.put("LangCode", "");

			logger.debug("[************************] paramDetail:" + params);
			super.commonDao.queryForObject("pdaWmService.spReceiving", params);


			String ErrorDesc = ObjUtils.getSafeString(params.get("ErrorDesc"));


			if (!ObjUtils.isEmpty(ErrorDesc)) {
				throw new UniDirectValidateException(this.getMessage(ErrorDesc, "").substring(this.getMessage(ErrorDesc, "").indexOf("||")+2));

//				throw new Exception(ErrorDesc);
			}
		}
	}

	/**
	 * 생산실적 저장
	 * @param paramList
	 * @throws Exception
	 */
	public void s_pdp100ukrv_wm_save(List<Map> paramList) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		List<Map> dataList = new ArrayList<Map>();
		for(Map params:	paramList) {
			SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
			Date dateGet = new Date ();
			String dateGetString = dateFormat.format(dateGet);

			params.put("TABLE_ID","PMR100T");
			params.put("PREFIX", "P");
			params.put("BASIS_DATE", dateGetString);
			params.put("AUTO_TYPE", "1");
			params.put("PRODT_Q", ObjUtils.parseDouble(params.get("WORK_Q")));
			params.put("GOOD_PRODT_Q", ObjUtils.parseDouble(params.get("WORK_Q")));
			params.put("BAD_PRODT_Q", 0.0);
			params.put("CONTROL_STATUS", "9");
			params.put("MAN_HOUR", 0);
			params.put("FR_TIME", "000000");
			params.put("TO_TIME", "000000");

			super.commonDao.queryForObject("pdaWmService.spAutoNumPdp200ukrv", params);
			params.put("PRODT_NUM",	ObjUtils.getSafeString(params.get("KEY_NUMBER")));

			super.commonDao.insert("pdaWmService.insertPdp200ukrv", params);

			params.put("GOOD_WH_CELL_CODE","");
			params.put("GOOD_PRSN","");
			params.put("BAD_WH_CELL_CODE","");
			params.put("BAD_PRSN","");
			params.put("PRODT_TYPE",	"2");	// (1: 공정별, 2: 작지별, 3: ......)
			params.put("STATUS",	"N");

			super.commonDao.queryForObject("pdaWmService.spCallPdp200ukrv", params);

			String ErrorDesc = ObjUtils.getSafeString(params.get("ERROR_DESC"));
			if (!ObjUtils.isEmpty(ErrorDesc)) {
				//throw new UniDirectValidateException(this.getMessage(ErrorDesc, "").substring(this.getMessage(ErrorDesc, "").indexOf("||")+2));
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, ""));
//				throw new Exception(ErrorDesc);
			}

		}
	}


	/**
	 * 접수/도착등록 메인조회
	 * @param params
	 * @return
	 */

	public List<Map<String, Object>> searchListPdm300ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaWmService.searchListPdm300ukrvMain",params);
	}



	/**
	 * 접수/도착등록 품목검색
	 * @param params
	 * @return
	 */

	public List<Map<String, Object>> searchListPdm300ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaWmService.searchListPdm300ukrvSub1",params);
	}



	public void savePdm300ukrv(Pdm300ukrvDTO dtos, LoginVO user) throws Exception {

		List<Pdm300ukrvDetailDTO> detailList = dtos.getItemList();
		Map<String, Object> paramMaster = buildParamMaster(dtos);

		if(detailList.get(0).getReceiptNum().equals("")){
			//추가 하여 입력된 데이터들
			int seq = 0;
			Map<String, Object> spParam = new HashMap<String, Object>();

			spParam.put("COMP_CODE",paramMaster.get("COMP_CODE"));
			spParam.put("DIV_CODE", paramMaster.get("DIV_CODE"));
			spParam.put("TABLE_ID","PMR100T");
			spParam.put("PREFIX", "A");
			spParam.put("BASIS_DATE", paramMaster.get("ARRIVAL_DATE"));
			spParam.put("AUTO_TYPE", "1");

			super.commonDao.queryForObject("pdaWmService.spAutoNumPdm300ukrv", spParam);

			Map<String, Object> params = new HashMap<>();
			params.put("S_USER_ID", user.getUserID());
			params.put("RECEIPT_NUM",	ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));

			params.putAll(paramMaster);


			super.commonDao.insert("pdaWmService.insertPdm300ukrvMaster", params);

			for (Pdm300ukrvDetailDTO detailData : detailList) {

				Map<String, Object> paramDetails = buildParamDetails(detailData);

				params.putAll(paramDetails);
				params.put("RECEIPT_NUM",	ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
				params.put("RECEIPT_SEQ", ++seq);

				super.commonDao.insert("pdaWmService.insertPdm300ukrvDetail", params);
			}
		}else{
			for (Pdm300ukrvDetailDTO detailData : detailList) {
				//조회된 데이터 수정 시
				Map<String, Object> paramDetails = buildParamDetails(detailData);

				Map<String, Object> params = new HashMap<>();

				params.put("S_USER_ID", user.getUserID());
				params.putAll(paramMaster);
				params.putAll(paramDetails);

				super.commonDao.insert("pdaWmService.updatePdm300ukrvDetail", params);
			}
		}

	}

	private Map<String, Object> buildParamDetails(Pdm300ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();

	    paramDetails.put("ITEM_CODE", detail.getItemCode());
	    paramDetails.put("ITEM_NAME", detail.getItemName());
	    paramDetails.put("SPEC", detail.getSpec());
	    paramDetails.put("ORDER_UNIT", detail.getOrderUnit());

	    paramDetails.put("RECEIPT_Q", detail.getReceiptQ());
	    paramDetails.put("INSTOCK_Q", detail.getInstockQ());
	    paramDetails.put("RECEIPT_NUM", detail.getReceiptNum());
	    paramDetails.put("RECEIPT_SEQ", detail.getReceiptSeq());

		return paramDetails;
	}

	private Map<String, Object> buildParamMaster(Pdm300ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();

		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("CUSTOM_PRSN", master.getCustomPrsn());
		paramMaster.put("RECEIPT_PRSN", master.getReceiptPrsn());
		paramMaster.put("PHONE_NUM", master.getPhoneNum());
		paramMaster.put("ARRIVAL_DATE", master.getArrivalDate());

		return paramMaster;
	}

	/**
	 * 제품출고등록 운송장번호체크
	 * @param params
	 * @return
	 */
	public Map<String, Object> invoiceNumCheck(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaWmService.invoiceNumCheck", params);
	}

	/**
	 * 제품출고등록 메인조회
	 * @param params
	 * @return
	 */

	public List<Map<String, Object>> searchListPds200ukrvMain(Map<String,Object> params) throws Exception {

		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaWmService.invoiceNumCheck",params);
		if(ObjUtils.isEmpty(checkMap)){
			throw new Exception("운송장번호가 존재하지 않습니다.");
		}else{
			if(checkMap.get("ORDER_STATUS").equals("Y")){
				throw new Exception("취소(마감)된 주문입니다.");
			}
		}

		return super.commonDao.list("pdaWmService.searchListPds200ukrvMain",params);
	}


	/**
	 * 제품출고등록 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	public void savePds200ukrv(Pds200ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		List<Pds200ukrvDetailDTO> detailList = dtos.getItemList();
		Map<String, Object> paramMaster = buildParamMaster(dtos);
		int seq = 0;
		Map<String, Object> params = new HashMap<>();
		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");
		params.put("S_USER_ID", user.getUserID());
		params.putAll(paramMaster);
		for (Pds200ukrvDetailDTO detailData : detailList) {
			Map<String, Object> paramDetails = buildParamDetails(detailData);
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);
			if (!params.containsKey("LOT_NO") || params.get("LOT_NO") == null)
				params.put("LOT_NO", "");
			super.commonDao.insert("pdaWmService.insertPds200ukrv", params);
			List list = super.commonDao.list("pdaWmService.searchListIfOrderListPut",params);
			if(list != null && list.size() > 0){
				params.put("S_COMP_CODE", params.get("COMP_CODE"));
				super.commonDao.update("s_str104ukrv_wmServiceImpl.insertIfOrderListPut", params);
			}
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		super.commonDao.queryForObject("pdaWmService.spCallPds200ukrv", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			//throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
//			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildParamDetails(Pds200ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("INOUT_TYPE_DETAIL",detail.getInoutTypeDetail());
		paramDetails.put("CUSTOM_CODE",detail.getCustomCode());
		paramDetails.put("ITEM_CODE",detail.getItemCode());
		paramDetails.put("LOT_NO",detail.getLotNo());
		paramDetails.put("ORDER_UNIT",detail.getOrderUnit());
		paramDetails.put("TRANS_RATE",detail.getTransRate());
		paramDetails.put("ISSUE_REQ_PRICE",detail.getIssueReqPrice());
		paramDetails.put("NOT_REQ_Q",detail.getNotReqQ());
		paramDetails.put("ORDER_TYPE",detail.getOrderType());
		paramDetails.put("MONEY_UNIT",detail.getMoneyUnit());
		paramDetails.put("EXCHANGE_RATE",detail.getExchangeRate());
		paramDetails.put("ACCOUNT_YNC",detail.getAccountYnc());
		paramDetails.put("BILL_TYPE",detail.getBillType());
		paramDetails.put("PRICE_YN",detail.getPriceYn());
		paramDetails.put("SALE_CUSTOM_CODE",detail.getSaleCustomCode());
		paramDetails.put("ORDER_NUM",detail.getOrderNum());
		paramDetails.put("ORDER_SEQ",detail.getOrderSeq());
		paramDetails.put("ISSUE_REQ_NUM",detail.getIssueReqNum());
		paramDetails.put("ISSUE_REQ_SEQ",detail.getIssueReqSeq());
		paramDetails.put("CUSTOM_NAME",detail.getCustomName());
		paramDetails.put("ITEM_NAME",detail.getItemName());
		paramDetails.put("INVOICE_NUM",detail.getInvoiceNum());
		paramDetails.put("TAX_TYPE",detail.getTaxType());
		paramDetails.put("ISSUE_REQ_AMT",detail.getIssueReqAmt());
		paramDetails.put("ISSUE_REQ_TAX_AMT",detail.getIssueReqTaxAmt());
		paramDetails.put("ISSUE_FOR_AMT",detail.getIssueForAmt());
		paramDetails.put("ISSUE_FOR_PRICE",detail.getIssueForPrice());

		return paramDetails;
	}

	private Map<String, Object> buildParamMaster(Pds200ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();

		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("WH_CODE", master.getWhCode());
		paramMaster.put("WH_CELL_CODE", master.getWhCellCode());
		paramMaster.put("INOUT_PRSN", master.getInoutPrsn());

		return paramMaster;
	}



	/**
	 * 자재출고등록 메인조회
	 * @param params
	 * @return
	 */


	public List<Map<String, Object>> searchListPdm400ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaWmService.searchListPdm400ukrvMain",params);
	}
	/**
	 * 자재출고등록 품목정보,그룹 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdm400ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaWmService.searchListPdm400ukrvSub1",params);
	}

	/**
	 * 자재출고등록 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	public void savePdm400ukrv(Pdm400ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		List<Pdm400ukrvDetailDTO> detailList = dtos.getItemList();
		Map<String, Object> paramMaster = buildParamMaster(dtos);
		int seq = 0;
		Map<String, Object> params = new HashMap<>();
		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");
		params.put("S_USER_ID", user.getUserID());
		params.putAll(paramMaster);
		for (Pdm400ukrvDetailDTO detailData : detailList) {
			Map<String, Object> paramDetails = buildParamDetails(detailData);
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);
			super.commonDao.insert("pdaWmService.insertPdm400ukrv", params);
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		super.commonDao.queryForObject("pdaWmService.uspMatrlMtr200ukr", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildParamDetails(Pdm400ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();
		paramDetails.put("WORK_SHOP_CODE",detail.getWorkShopCode());
		paramDetails.put("ITEM_CODE",detail.getItemCode());
		paramDetails.put("ORDER_UNIT",detail.getOrderUnit());
		paramDetails.put("OUT_Q",detail.getOutQ());
		paramDetails.put("WKORD_NUM",detail.getWkordNum());
		paramDetails.put("LOT_NO",detail.getLotNo());
		paramDetails.put("REMARK",detail.getRemark());
		paramDetails.put("PROJECT_NO",detail.getProjectNo());

		return paramDetails;
	}

	private Map<String, Object> buildParamMaster(Pdm400ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();

		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("WH_CODE", master.getWhCode());
		paramMaster.put("WH_CELL_CODE", master.getWhCellCode());
		paramMaster.put("INOUT_PRSN", master.getInoutPrsn());
		paramMaster.put("INOUT_DATE", master.getInoutDate());
		paramMaster.put("WKORD_NUM", master.getWkordNum());

		return paramMaster;
	}

	/**
	 * 출하검사 메인조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdp400ukrvMain(Map<String,Object> params) throws Exception {
		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaWmService.orderStatusCheck",params);
		if(ObjUtils.isNotEmpty(checkMap)){
			if(checkMap.get("ORDER_STATUS").equals("Y")){
				throw new Exception("취소(마감)된 주문입니다. 주문정보를 확인하세요.");
			}
		}
		return super.commonDao.list("pdaWmService.searchListPdp400ukrvMain",params);
	}

	/**
	 * 출하검사 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	public void savePdp400ukrv(Pdp400ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		List<Pdp400ukrvDetailDTO> detailList = dtos.getItemList();
		Map<String, Object> paramMaster = buildParamMaster(dtos);
		int seq = 0;
		Map<String, Object> params = new HashMap<>();
		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");
		params.put("S_USER_ID", user.getUserID());
		params.putAll(paramMaster);
		for (Pdp400ukrvDetailDTO detailData : detailList) {
			Map<String, Object> paramDetails = buildParamDetails(detailData);
			params.putAll(paramDetails);
			params.put("INSPEC_SEQ", ++seq);
			super.commonDao.insert("pdaWmService.insertPdp400ukrv", params);
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		super.commonDao.queryForObject("pdaWmService.spCallPdp400ukrv", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildParamDetails(Pdp400ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("ITEM_CODE",detail.getItemCode());
		paramDetails.put("NOT_INSPEC_Q",detail.getNotInspecQ());
		paramDetails.put("RECEIPT_NUM",detail.getReceiptNum());
		paramDetails.put("RECEIPT_SEQ",detail.getReceiptSeq());
		paramDetails.put("LOT_NO",detail.getLotNo());
		paramDetails.put("PRODT_NUM",detail.getProdtNum());
		paramDetails.put("WKORD_NUM",detail.getWkordNum());

		return paramDetails;
	}

	private Map<String, Object> buildParamMaster(Pdp400ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();

		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("WH_CODE", master.getWhCode());
		paramMaster.put("WH_CELL_CODE", master.getWhCellCode());
		paramMaster.put("INSPEC_PRSN", master.getInspecPrsn());
		paramMaster.put("INSPEC_DATE", master.getInspecDate());

		return paramMaster;
	}


}
