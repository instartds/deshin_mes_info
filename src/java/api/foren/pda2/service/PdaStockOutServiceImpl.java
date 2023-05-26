package api.foren.pda2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.foren.pda2.dto.LotDTO;
import api.foren.pda2.dto.StockOutMaterialDTO;
import api.foren.pda2.dto.StockOutMoveCellDTO;
import api.foren.pda2.dto.StockOutMoveDTO;
import api.foren.pda2.dto.StockOutProductDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pdaStockOutService")
@SuppressWarnings("unchecked")
public class PdaStockOutServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PdaStockOutServiceImpl.class);

	public Map<String, Object> selectStockOutManufacture(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaStockOutService.selectStockOutManufacture", params);
	}

	public List<Map<String, Object>> getStockOutManufacture(Map<String, Object> params) {
		return super.commonDao.list("pdaStockOutService.getStockOutManufacture", params);
	}

	public Map<String, Object> selectStockOutProduct(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaStockOutService.selectStockOutProduct", params);
	}

	public List<Map<String, Object>> getStockOutProduct(Map<String, Object> params) {
		return super.commonDao.list("pdaStockOutService.getStockOutProduct", params);
	}
	
	public List<Map<String, Object>> getStockOutProductBySearch(Map<String, Object> params) {
		return super.commonDao.list("pdaStockOutService.getStockOutProductBySearch", params);
	}

	public Map<String, Object> selectStockOutExternal(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaStockOutService.selectStockOutExternal", params);
	}

	public List<Map<String, Object>> getStockOutExternal(Map<String, Object> params) {
		return super.commonDao.list("pdaStockOutService.getStockOutExternal", params);
	}

	public List<Map<String, Object>> getStockOutMove(Map<String, Object> params) {
		return super.commonDao.list("pdaStockOutService.getStockOutMove", params);
	}

	public Integer insertLog(Map<String, Object> param) throws Exception {
		logger.debug("insert data: {}", param);
		return super.commonDao.insert("pdaStockOutService.insertLogData", param);
	}

	public void saveStockOutManufacture(List<StockOutMaterialDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (StockOutMaterialDTO material : dtos) {
			List<LotDTO> lotList = material.getLotList();

			for (LotDTO lot : lotList) {
				Map<String, Object> paramMaster = buildManufactureParamMaster(material);
				Map<String, Object> paramDetails = buildParamDetails(lot);
				Map<String, Object> params = new HashMap<>();
				params.put("KEY_VALUE", keyValue);
				params.put("OPR_FLAG", "N");
				params.put("CREATE_TYPE", "1"); // 출고유형: '생산' '외주'
				params.put("ORDER_TYPE", ""); // 생산출고 = '' , 제품출고 ='10', 외주출고 일때는 '4'
				params.putAll(paramMaster);
				params.putAll(paramDetails);
				params.put("INOUT_SEQ", ++seq);
				params.put("S_USER_ID", user.getUserID());
				super.commonDao.insert("pdaStockOutService.insertManufactureLogData", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockOutService.spStockOutMaterialProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	public void saveStockOutProduct(List<StockOutProductDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (StockOutProductDTO product : dtos) {
			List<LotDTO> lotList = product.getLotList();

			for (LotDTO lot : lotList) {
				Map<String, Object> params = buildProductParams(product, lot);
				params.put("KEY_VALUE", keyValue);
				params.put("OPR_FLAG", "N");
				params.put("ORDER_TYPE", "10"); // 생산출고 = '' , 제품출고 ='10', 외주출고 일때는 '4'
				params.put("INOUT_SEQ", ++seq);
				params.put("S_USER_ID", user.getUserID());
				super.commonDao.insert("pdaStockOutService.insertProductLogData", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockOutService.spStockOutProductProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildProductParams(StockOutProductDTO product, LotDTO lot) {
		Map<String, Object> params = new HashMap<>();
		Map<String, Object> paramMaster = new HashMap<>();
		Map<String, Object> paramDetails = new HashMap<>();

		double trnsRate = product.getTrnsRate();
		double exchgRateO = product.getExchgRateO() == null ? 1.0 : product.getExchgRateO();
		double issueReqPrice = product.getIssueReqPrice();
		double issueReqAmt = product.getIssueReqAmt();
		double issueReqTaxAmt = product.getIssueReqTaxAmt();
		double orderUnitQ = lot.getOrderUnitQ();

		paramMaster.put("COMP_CODE", product.getCompCode());
		paramMaster.put("DIV_CODE", product.getDivCode());
		paramMaster.put("CUSTOM_CODE", product.getCustomCode());
		paramMaster.put("INOUT_NUM", "");
		paramMaster.put("INOUT_METH", "1");
		paramMaster.put("INOUT_TYPE", "2");
		paramMaster.put("INOUT_CODE_TYPE", "4");
		paramMaster.put("INOUT_TYPE_DETAIL", "10");
		paramMaster.put("CREATE_LOC", "1");
		paramMaster.put("SALE_TYPE", "10");

		paramMaster.put("ITEM_CODE", product.getItemCode());
		paramMaster.put("ORDER_UNIT", product.getOrderUnit());
		paramMaster.put("TRNS_RATE", trnsRate);
		paramMaster.put("LOT_NO", product.getLotNo());
		paramMaster.put("ORDER_UNIT_P", product.getOrderUnitP() == null ? 0 : product.getOrderUnitP());
		paramMaster.put("ITEM_STATUS", "1");

		paramMaster.put("INOUT_DATE", product.getInoutDate());
		paramMaster.put("INOUT_PRSN", product.getInoutPrsn());
		paramMaster.put("INOUT_CODE", product.getInoutCode());

		paramMaster.put("MONEY_UNIT", product.getMoneyUnit() == null ? "KRW" : product.getMoneyUnit());
		paramMaster.put("EXCHG_RATE_O", exchgRateO);

		paramMaster.put("ORDER_NUM", product.getOrderNum());
		paramMaster.put("ORDER_SEQ", product.getOrderSeq());
		paramMaster.put("ORDER_TYPE", product.getOrderType());

		paramMaster.put("ISSUE_REQ_NUM", product.getIssueReqNum());
		paramMaster.put("ISSUE_REQ_SEQ", product.getIssueReqSeq());
		paramMaster.put("REMARK", product.getRemark());

		paramMaster.put("BILL_TYPE", product.getBillType() == null ? "10" : product.getBillType());
		paramMaster.put("TAX_TYPE", product.getTaxType() == null ? "1" : product.getTaxType());
		paramMaster.put("PRICE_YN", product.getPriceYn() == null ? "2" : product.getPriceYn());
		paramMaster.put("SALE_PRSN", product.getSalePrsn() == null ? "" : product.getSalePrsn());
		paramMaster.put("SALE_DIV_CODE",
				product.getSaleDivCode() == null ? product.getDivCode() : product.getSaleDivCode());
		paramMaster.put("SALE_CUSTOM_CODE",
				product.getSaleCustomCode() == null ? product.getCustomCode() : product.getSaleCustomCode());
		paramMaster.put("TRADE_LOC", product.getTradeLoc() == null ? "1" : product.getTradeLoc());
		paramMaster.put("ACCOUNT_YNC", product.getAccountYnc() == null ? "Y" : product.getAccountYnc());

		paramDetails.put("WH_CODE", lot.getWhCode());
		paramDetails.put("WH_CELL_CODE", lot.getWhCellCode());
		paramDetails.put("LOT_NO", lot.getLotNo());
		paramDetails.put("ORDER_UNIT_Q", lot.getOrderUnitQ());

		paramMaster.put("ORDER_UNIT_P", issueReqPrice * exchgRateO);
		paramMaster.put("ORDER_UNIT_FOR_P", issueReqPrice);
		paramDetails.put("ORDER_UNIT_O", issueReqPrice * orderUnitQ * exchgRateO);
		paramMaster.put("INOUT_P", issueReqPrice / trnsRate * exchgRateO);
		paramDetails.put("INOUT_I", (issueReqPrice / trnsRate) * (trnsRate * orderUnitQ) * exchgRateO);
		paramMaster.put("INOUT_FOR_P", issueReqPrice / trnsRate);
		paramDetails.put("INOUT_FOR_O", (issueReqPrice / trnsRate) * (trnsRate * orderUnitQ));

		paramMaster.put("INOUT_TAX_AMT", (issueReqPrice * orderUnitQ) * (issueReqTaxAmt / issueReqAmt));

		params.putAll(paramMaster);
		params.putAll(paramDetails);

		return params;
	}

	public void saveStockOutMove(List<StockOutMoveDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (StockOutMoveDTO move : dtos) {
			List<LotDTO> lotList = move.getLotList();

			for (LotDTO lot : lotList) {
				Map<String, Object> paramMaster = buildMoveParamMaster(move);
				Map<String, Object> paramDetails = buildMoveDetails(lot);
				Map<String, Object> params = new HashMap<>();
				params.put("KEY_VALUE", keyValue);
				params.put("OPR_FLAG", "N");
				params.putAll(paramMaster);
				params.putAll(paramDetails);
				params.put("INOUT_SEQ", ++seq);
				params.put("S_USER_ID", user.getUserID());
				super.commonDao.insert("pdaStockOutService.insertMoveLogData", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockOutService.spStockOutMoveProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	public void saveStockOutMoveCell(List<StockOutMoveCellDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (StockOutMoveCellDTO moveCell : dtos) {
			Map<String, Object> params = buildMoveCellParamMaster(moveCell);
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("INOUT_SEQ", ++seq);
			params.put("S_USER_ID", user.getUserID());
			super.commonDao.insert("pdaStockOutService.insertMoveLogData", params);
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockOutService.spStockOutMoveProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildMoveCellParamMaster(StockOutMoveCellDTO move) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("S_COMP_CODE", move.getCompCode());
		paramMaster.put("DIV_CODE", move.getDivCode());

		paramMaster.put("INOUT_NUM", "");
		paramMaster.put("INOUT_TYPE", "2");
		paramMaster.put("INOUT_METH", "3");
		paramMaster.put("INOUT_TYPE_DETAIL", "99"); // 移库
		paramMaster.put("INOUT_CODE_TYPE", "2"); // 出库
		paramMaster.put("IN_ITEM_STATUS", "1");
		paramMaster.put("BASIS_NUM", "");
		paramMaster.put("BASIS_SEQ", 0);
		
		paramMaster.put("ORDER_NUM", "");
		paramMaster.put("ORDER_SEQ", 0);

		paramMaster.put("INOUT_DATE", move.getInoutDate());
		paramMaster.put("INOUT_FOR_P", 0.0);
		paramMaster.put("INOUT_FOR_O", 0.0);
		paramMaster.put("EXCHG_RATE_O", 1.00);
		paramMaster.put("MONEY_UNIT", "");

		paramMaster.put("TO_DIV_CODE", move.getDivCode());
		paramMaster.put("INOUT_CODE", move.getInWhCode());
		paramMaster.put("INOUT_CODE_DETAIL", move.getInWhCellCode());

		paramMaster.put("WH_CODE", move.getOutWhCode());
		paramMaster.put("WH_CELL_CODE", move.getOutWhCellCode());

		paramMaster.put("DEPT_CODE", "");
		paramMaster.put("ITEM_CODE", move.getItemCode());
		paramMaster.put("ITEM_STATUS", "1");
		paramMaster.put("INOUT_Q", move.getInoutQ());

		paramMaster.put("INOUT_PRSN", move.getInoutPrsn());
		paramMaster.put("LOT_NO", move.getLotNo());

		paramMaster.put("REMARK", "");
		paramMaster.put("PROJECT_NO", "");
		paramMaster.put("CREATE_LOC", "4");
		paramMaster.put("BILL_TYPE", "*");
		paramMaster.put("SALE_TYPE", "*");
		paramMaster.put("SALE_DIV_CODE", "*");
		paramMaster.put("SALE_CUSTOM_CODE", "*");
		paramMaster.put("SALE_C_YN", "N");

		paramMaster.put("MAKE_DATE", move.getInoutDate());
		paramMaster.put("MAKE_EXP_DATE", null);

		return paramMaster;
	}

	private Map<String, Object> buildMoveDetails(LotDTO lot) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("WH_CODE", lot.getWhCode());
		paramDetails.put("WH_CELL_CODE", lot.getWhCellCode());
		paramDetails.put("LOT_NO", lot.getLotNo());
		paramDetails.put("INOUT_Q", lot.getOrderUnitQ());

		return paramDetails;
	}

	private Map<String, Object> buildMoveParamMaster(StockOutMoveDTO move) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("S_COMP_CODE", move.getCompCode());
		paramMaster.put("DIV_CODE", move.getOutDivCode());

		paramMaster.put("INOUT_NUM", "");
		paramMaster.put("INOUT_TYPE", "2");
		paramMaster.put("INOUT_METH", "3");
		paramMaster.put("INOUT_TYPE_DETAIL", "99"); // 移库
		paramMaster.put("INOUT_CODE_TYPE", "2"); // 出库
		paramMaster.put("IN_ITEM_STATUS", "1");
		paramMaster.put("BASIS_NUM", "");
		paramMaster.put("BASIS_SEQ", 0);

		paramMaster.put("ORDER_NUM", move.getOrderNum());
		paramMaster.put("ORDER_SEQ", move.getOrderSeq());

		paramMaster.put("INOUT_DATE", move.getInoutDate());
		paramMaster.put("INOUT_FOR_P", 0.0);
		paramMaster.put("INOUT_FOR_O", 0.0);
		paramMaster.put("EXCHG_RATE_O", 1.00);
		paramMaster.put("MONEY_UNIT", "");

		paramMaster.put("TO_DIV_CODE", move.getDivCode());
		paramMaster.put("INOUT_CODE", move.getInoutCode());
		paramMaster.put("INOUT_CODE_DETAIL", move.getInoutCodeDetail());
		paramMaster.put("DEPT_CODE", "");
		paramMaster.put("ITEM_CODE", move.getItemCode());
		paramMaster.put("ITEM_STATUS", "1");

		paramMaster.put("INOUT_PRSN", move.getInoutPrsn());

		paramMaster.put("REMARK", move.getRemark());
		paramMaster.put("PROJECT_NO", move.getProjectNo());
		paramMaster.put("CREATE_LOC", "4");
		paramMaster.put("BILL_TYPE", "*");
		paramMaster.put("SALE_TYPE", "*");
		paramMaster.put("SALE_DIV_CODE", "*");
		paramMaster.put("SALE_CUSTOM_CODE", "*");
		paramMaster.put("SALE_C_YN", "N");

		paramMaster.put("MAKE_DATE", move.getInoutDate());
		paramMaster.put("MAKE_EXP_DATE", null);

		return paramMaster;
	}

	public void saveStockOutExternal(List<StockOutMaterialDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (StockOutMaterialDTO dto : dtos) {
			List<LotDTO> lotList = dto.getLotList();

			for (LotDTO lot : lotList) {
				Map<String, Object> paramMaster = buildExternalParamMaster(dto);
				Map<String, Object> paramDetails = buildParamDetails(lot);
				Map<String, Object> params = new HashMap<>();
				params.put("KEY_VALUE", keyValue);
				params.put("OPR_FLAG", "N");
				params.put("ORDER_TYPE", "4"); // 외주출고 일때는 '4'
				params.putAll(paramMaster);
				params.putAll(paramDetails);
				params.put("INOUT_SEQ", ++seq);
				params.put("S_USER_ID", user.getUserID());
				super.commonDao.insert("pdaStockOutService.insertStockOutExternalLogData", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockOutService.spStockOutExternalProcedure", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildExternalParamMaster(StockOutMaterialDTO dto) {
		Map<String, Object> paramMaster = new HashMap<>();

		paramMaster.put("INOUT_NUM", "");
		paramMaster.put("INOUT_METH", "1");
		paramMaster.put("INOUT_TYPE", "2");
		paramMaster.put("INOUT_CODE_TYPE", "5");
		paramMaster.put("INOUT_TYPE_DETAIL", "10");
		paramMaster.put("CREATE_LOC", "2");
		paramMaster.put("ITEM_STATUS", "1");
		paramMaster.put("BASIS_NUM", "");
		paramMaster.put("BASIS_SEQ", 0);
		paramMaster.put("BILL_TYPE", "*");
		paramMaster.put("SALE_TYPE", "*");
		paramMaster.put("SALE_C_YN", "N");
		paramMaster.put("SALE_DIV_CODE", "*");
		paramMaster.put("SALE_CUSTOM_CODE", "*");

		paramMaster.put("COMP_CODE", dto.getCompCode());
		paramMaster.put("DIV_CODE", dto.getDivCode());
		paramMaster.put("INOUT_CODE", dto.getCustomCode());
		paramMaster.put("ITEM_CODE", dto.getItemCode());
		paramMaster.put("INOUT_DATE", dto.getInoutDate());
		paramMaster.put("INOUT_PRSN", dto.getInoutPrsn());
		paramMaster.put("MONEY_UNIT", dto.getMoneyUnit() == null ? "KRW" : dto.getMoneyUnit());
		paramMaster.put("ORDER_NUM", dto.getOrderNum());
		paramMaster.put("ORDER_SEQ", dto.getOrderSeq());
		paramMaster.put("REMARK", dto.getRemark());
		paramMaster.put("PROJECT_NO", dto.getProjectNo());
		paramMaster.put("S_GUBUN_KD", dto.getsGubunKd());

		return paramMaster;
	}

	private Map<String, Object> buildParamDetails(LotDTO lot) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("WH_CODE", lot.getWhCode());
		paramDetails.put("WH_CELL_CODE", lot.getWhCellCode());
		paramDetails.put("LOT_NO", lot.getLotNo());
		paramDetails.put("ORDER_UNIT_Q", lot.getOrderUnitQ());

		return paramDetails;
	}

	private Map<String, Object> buildManufactureParamMaster(StockOutMaterialDTO material) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("COMP_CODE", material.getCompCode());
		paramMaster.put("DIV_CODE", material.getDivCode());
		paramMaster.put("CUSTOM_CODE", "");
		paramMaster.put("INOUT_NUM", "");
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

		return paramMaster;
	}
}
