package api.foren.pda2.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.foren.pda2.dto.covDto.Pdm100ukrvDTO;
import api.foren.pda2.dto.covDto.Pdm100ukrvDetailDTO;
import api.foren.pda2.dto.covDto.Pds200ukrvDTO;
import api.foren.pda2.dto.covDto.Pds200ukrvDetailDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
 
@SuppressWarnings("unchecked")
@Service("pdaCovService")
public class PdaCovServiceImpl extends TlabAbstractServiceImpl {

	public List<Map<String, Object>> searchListPdm100ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaCovService.searchListPdm100ukrvMain",params);
	}

	// 구매입고 미입고내역
	public List<Map<String, Object>> searchListPdm100ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaCovService.searchListPdm100ukrvSub1",params);
	}

	public void savePdm100ukrv(Pdm100ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
//		for (Pdm100ukrvDTO masterData : dtos) {
			List<Pdm100ukrvDetailDTO> detailList = dtos.getItemList();

			for (Pdm100ukrvDetailDTO detailData : detailList) {
				Map<String, Object> paramMaster = buildParamMaster(dtos);
				Map<String, Object> paramDetails = buildParamDetails(detailData);
				Map<String, Object> params = new HashMap<>();
				params.put("KEY_VALUE", keyValue);
				params.put("OPR_FLAG", "N");
				
//				params.put("CREATE_TYPE", "1"); // 출고유형: '생산' '외주'
//				params.put("ORDER_TYPE", ""); // 생산출고 = '' , 제품출고 ='10', 외주출고 일때는 '4'
				params.putAll(paramMaster);
				params.putAll(paramDetails);
				params.put("INOUT_SEQ", ++seq);
				params.put("S_USER_ID", user.getUserID());
				super.commonDao.insert("pdaCovService.insertPdm100ukrv", params);
			}
//		}
		
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", "KR");
		spParam.put("CreateType", "2");

		super.commonDao.queryForObject("pdaCovService.spReceiving", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {			
			//throw new Exception(ErrorDesc);
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
		}
	}
	
	private Map<String, Object> buildParamDetails(Pdm100ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();
		
		paramDetails.put("ORDER_NUM", detail.getOrderNum());               /* 발주번호 */
		paramDetails.put("CUSTOM_CODE", detail.getCustomCode());             /* 거래처 */
		paramDetails.put("CUSTOM_NAME", detail.getCustomName());             /* 거래처명 */
		paramDetails.put("WH_CODE", detail.getWhCode());                 /* 입고창고 */
		paramDetails.put("DVRY_DATE", detail.getDvryDate());               /* 입고일 */
		paramDetails.put("RECEIPT_NAME", detail.getReceiptName());            /* 입고담당 */
		paramDetails.put("ORDER_TYPE", detail.getOrderType());              /* 생성경로/발주형태 */
		paramDetails.put("INOUT_NUM", detail.getInoutNum());               /* 입고번호 */ 
		paramDetails.put("MONEY_UNIT", detail.getMoneyUnit());              /* 화폐 */
		paramDetails.put("EXCHG_RATE_O", detail.getExchgRateO());            /* 환율 */
		paramDetails.put("ORDER_SEQ", detail.getOrderSeq());               /* 순번 */
		paramDetails.put("RECEIPT_TYPE", detail.getReceiptType());            /* 입고유형 */
		paramDetails.put("ITEM_CODE", detail.getItemCode());               /* 품목코드 */
		paramDetails.put("ITEM_NAME", detail.getItemName());               /* 품목명 */
		paramDetails.put("SPEC", detail.getSpec());                    /* 규격 */
		paramDetails.put("ORDER_UNIT", detail.getOrderUnit());              /* 단위 */
		paramDetails.put("INOUT_Q", detail.getInoutQ());                 /* 입고수량 */
		paramDetails.put("INOUT_P", detail.getInoutP());                 /* 입고단가 */
		paramDetails.put("INOUT_I", detail.getInoutI());                 /* 입고금액 */
		paramDetails.put("LOT_NO", detail.getLotNo());                  /* LOT NO */
		paramDetails.put("ORDER_UNIT_P", detail.getOrderUnitP());            /* 자사단가 */
		paramDetails.put("ORDER_UNIT_O", detail.getOrderUnitO());            /* 자사금액 */
		paramDetails.put("TRNS_RATE", detail.getTrnsRate());               /* 입수 */
		paramDetails.put("ITEM_STATUS", detail.getItemStatus());             /* 품목상태 */
		paramDetails.put("RECEIPT_NUM", detail.getReceiptNum());             /* 접수번호 */
		paramDetails.put("RECEIPT_SEQ", detail.getReceiptSeq());             /* 접수순번 */
		paramDetails.put("INSPEC_NUM", detail.getInspecNum());              /* 검사번호 */
		paramDetails.put("INSPEC_SEQ", detail.getInspecSeq());              /* 검사순번 */

		return paramDetails;
	}
	
	private Map<String, Object> buildParamMaster(Pdm100ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("WH_CODE", master.getWhCode());
		paramMaster.put("INOUT_DATE", master.getInoutDate());
		paramMaster.put("INOUT_PRSN", master.getInoutPrsn());
		paramMaster.put("CUSTOM_CODE",master.getCustomCode());
/*		paramMaster.put("INOUT_NUM", "");
		paramMaster.put("INOUT_METH", "3");
		paramMaster.put("INOUT_TYPE", "2");
		paramMaster.put("INOUT_CODE_TYPE", "2");
		paramMaster.put("INOUT_TYPE_DETAIL", "95");
		paramMaster.put("CREATE_LOC", "2");
		paramMaster.put("LOT_NO", "");
		paramMaster.put("ITEM_STATUS", "1");

		paramMaster.put("MONEY_UNIT", material.getMoneyUnit() == null ? "KRW" : material.getMoneyUnit());
		paramMaster.put("EXCHG_RATE_O", material.getExchgRateO() == null ? 1.0 : material.getExchgRateO());
		paramMaster.put("ORDER_UNIT_P", material.getOrderUnitP() == null ? 1.0 : material.getOrderUnitP());

		paramMaster.put("ITEM_CODE", material.getItemCode());
		paramMaster.put("ORDER_UNIT", material.getOrderUnit());
		paramMaster.put("TRNS_RATE", material.getTrnsRate());

		paramMaster.put("TO_WH_CODE", material.getToWhCode());
		paramMaster.put("TO_WH_CELL_CODE", material.getToCellCode());

		paramMaster.put("INOUT_DATE", material.getInoutDate());
		paramMaster.put("INOUT_PRSN", material.getInoutPrsn());

		paramMaster.put("ORDER_NUM", material.getOrderNum());
		paramMaster.put("ORDER_SEQ", material.getOrderSeq());
		paramMaster.put("BASIS_NUM", material.getBasisNum());
		paramMaster.put("BASIS_SEQ", material.getBasisSeq());
		paramMaster.put("PATH_CODE", material.getPathCode());

		paramMaster.put("OUTSTOCK_NUM", material.getOutStockNum());
		paramMaster.put("REF_WKORD_NUM", material.getRefWkordNum());
		paramMaster.put("REMARK", material.getRemark());
		paramMaster.put("PROJECT_NO", material.getProjectNo());
*/
		return paramMaster;
	}
	
	
	/**
	 * 제품출고 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPds200ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaCovService.searchListPds200ukrvMain",params);
	}
	
	/**
	 * 제품출고 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	
	public void savePds200ukrv(Pds200ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		List<Pds200ukrvDetailDTO> detailList = dtos.getDetailList();
		Map<String, Object> paramMaster = buildParamMaster(dtos);
		int seq = 0;
		Map<String, Object> params = new HashMap<>();
		params.putAll(paramMaster);
		for (Pds200ukrvDetailDTO detailData : detailList) {
			Map<String, Object> paramDetails = buildParamDetails(detailData);
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("S_USER_ID", user.getUserID());
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);
			super.commonDao.insert("pdaCovService.insertPds200ukrv", params);
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		super.commonDao.queryForObject("pdaCovService.spCallPds200ukrv", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	private Map<String, Object> buildParamMaster(Pds200ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("INOUT_DATE", master.getInoutDate());
		paramMaster.put("SALES_DATE", master.getSalesDate());
		paramMaster.put("INOUT_PRSN", master.getInoutPrsn());
		paramMaster.put("OUT_TYPE", master.getOutType());
		return paramMaster;
	}
	
	private Map<String, Object> buildParamDetails(Pds200ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("INOUT_TYPE_DETAIL",detail.getInoutTypeDetail());
		paramDetails.put("CUSTOM_CODE",detail.getCustomCode());
		paramDetails.put("CUSTOM_NAME",detail.getCustomName());
		paramDetails.put("WH_CODE",detail.getWhCode());
		paramDetails.put("ITEM_CODE",detail.getItemCode());
		paramDetails.put("ITEM_NAME",detail.getItemName());
		paramDetails.put("SPEC",detail.getSpec());
		paramDetails.put("LOT_NO",detail.getLotNo());
		paramDetails.put("ORDER_UNIT",detail.getOrderUnit());
		paramDetails.put("TRANS_RATE",detail.getTransRate());
		paramDetails.put("ISSUE_REQ_PRICE",detail.getIssueReqPrice());
		paramDetails.put("OUT_Q",detail.getOutQ());
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
		paramDetails.put("TAX_TYPE",detail.getTaxType());
		
		return paramDetails;
	}
	

	/**
	 * 재고조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdv100skrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaCovService.searchListPdv100skrvMain",params);
	}

	/**
	 * 작업지시서 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdp100skrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaCovService.searchListPdp100skrvMain",params);
	}
}
