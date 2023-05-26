package api.foren.pda2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.clipsoft.org.apache.commons.lang.StringUtils;

import api.foren.pda2.dto.ItemDTO;
import api.foren.pda2.dto.StockInDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@SuppressWarnings("unchecked")
@Service("pdaStockInService")
public class PdaStockInServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PdaStockInServiceImpl.class);

	public Integer insertLog(Map<String, Object> param) throws Exception {
		logger.debug("insert data: {}", param);
		return super.commonDao.insert("pdaStockInService.insertLogData", param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveStockInMaterial(StockInDTO dto, LoginVO user) throws Exception {
		String keyValue = getLogKey();

		List<ItemDTO> itemList = dto.getItemList();
		int seq = 0;
		Map<String, Object> paramMaster = buildStockInParamMaster(dto);
		for (ItemDTO item : itemList) {
			Map<String, Object> paramDetails = buildStockInParamDetails(item);
			Map<String, Object> params = new HashMap<>();
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("S_USER_ID", user.getUserID());
			params.putAll(paramMaster);
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);
			super.commonDao.insert("pdaStockInService.insertMaterialLogData", params);
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockInService.spStockInMaterialProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveProductInstock(StockInDTO dto, LoginVO user) throws Exception {
		String keyValue = getLogKey();

		List<ItemDTO> itemList = dto.getItemList();
		int seq = 0;
		Map<String, Object> paramMaster = buildStockInParamMaster(dto);
		for (ItemDTO item : itemList) {
			Map<String, Object> paramDetails = buildStockInParamDetails(item);
			Map<String, Object> params = new HashMap<>();
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("S_USER_ID", user.getUserID());
			params.putAll(paramMaster);
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);
			super.commonDao.insert("pdaStockInService.insertProductLogMaster", params);
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockInService.spStockInProductProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}
	/**
	 * 제품입고 실적검색
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getSearchStockInProductSub1(Map<String,Object> params){
		return super.commonDao.list("pdaStockInService.getSearchStockInProductSub1",params);
	}

	/**
	 * 제품입고 요청번호 검색
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getSearchStockInProductReqNum(Map<String,Object> params){
		return super.commonDao.list("pdaStockInService.getSearchStockInProductReqNum",params);
	}
	
	public void saveMoveInstock(StockInDTO dto, LoginVO user) throws Exception {
		String keyValue = getLogKey();

		List<ItemDTO> itemList = dto.getItemList();
		int seq = 0;
		Map<String, Object> paramMaster = buildStockInParamMaster(dto);
		for (ItemDTO item : itemList) {
			Map<String, Object> paramDetails = buildStockInParamDetails(item);
			Map<String, Object> params = new HashMap<>();
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("S_USER_ID", user.getUserID());
			params.putAll(paramMaster);
			params.putAll(paramDetails);
			params.put("INOUT_SEQ", ++seq);

			params.put("INOUT_TYPE", "1");
			params.put("INOUT_METH", "3");
			params.put("INOUT_TYPE_DETAIL", "99");
			params.put("INOUT_CODE_TYPE", "2");
			params.put("TO_DIV_CODE", "01");

			params.put("INOUT_CODE", ""); // ???
			params.put("INOUT_CODE_DETAIL", "");
			params.put("ITEM_STATUS", "1");
			params.put("EXCHG_RATE_O", 1.0);
			params.put("MONEY_UNIT", "");

			params.put("INOUT_FOR_P", 0);
			params.put("INOUT_FOR_O", 0);
			params.put("INOUT_P", 0);
			params.put("INOUT_I", 0);

			params.put("BASIS_NUM", ""); // ???
			params.put("BASIS_SEQ", 0);

			params.put("CREATE_LOC", "4");
			params.put("SALE_C_YN", "N");
			params.put("SALE_DIV_CODE", "*");
			params.put("SALE_CUSTOM_CODE", "*");
			params.put("BILL_TYPE", "*");
			params.put("SALE_TYPE", "*");

			params.put("PROJECT_NO", "");
			params.put("REMARK", "");

			super.commonDao.insert("pdaStockInService.insertMoveLogMaster", params);
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pdaStockInService.spStockInMoveProcedure", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildStockInParamDetails(ItemDTO item) {
		Map<String, Object> paramDetails = new HashMap<>();
		paramDetails.put("ITEM_CODE", item.getItemCode());
		paramDetails.put("LOT_NO", item.getLotNo());
		paramDetails.put("INOUT_Q", item.getInoutQ());
		paramDetails.put("RECEIPT_NUM", item.getNum());
		if (StringUtils.isNotBlank(item.getSeq())) {
			paramDetails.put("RECEIPT_SEQ", Integer.parseInt(item.getSeq()));
		}
		paramDetails.put("PRODT_NUM", item.getNum());
		return paramDetails;
	}

	private Map<String, Object> buildStockInParamMaster(StockInDTO dto) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("COMP_CODE", dto.getCompCode());
		paramMaster.put("DIV_CODE", dto.getDivCode());
		paramMaster.put("WH_CODE", dto.getWhCode());
		paramMaster.put("WH_CELL_CODE", dto.getWhCellCode());
		paramMaster.put("INOUT_DATE", dto.getInoutDate());
		paramMaster.put("INOUT_PRSN", dto.getInoutPrsn());
		
		return paramMaster;
	}

	public Map<String, Object> getStockInItem(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaStockInService.getStockInItem", params);
	}

	public List<Map<String, Object>> getStockInOrderList(Map<String, Object> params) {
		return super.commonDao.list("pdaStockInService.getStockInOrderList", params);
	}

	public List<Map<String, Object>> getStockInListByOrder(Map<String, Object> params) {
		return super.commonDao.list("pdaStockInService.getStockInListByOrder", params);
	}

	public List<Map<String, Object>> getStockInListByItem(Map<String, Object> params) {
		return super.commonDao.list("pdaStockInService.getStockInListByItem", params);
	}

}
