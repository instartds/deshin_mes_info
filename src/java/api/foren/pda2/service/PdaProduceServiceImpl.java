package api.foren.pda2.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.foren.pda2.dto.WkordBadDTO;
import api.foren.pda2.dto.WkordDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@SuppressWarnings("unchecked")
@Service("pdaProduceService")
public class PdaProduceServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PdaProduceServiceImpl.class);

	public List<Map<String, Object>> searchWorkShop(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchWorkShop", params);
	}

	public List<Map<String, Object>> searchWkordList(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchWkordList", params);
	}

	public Map<String, Object> searchWkord(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaProduceService.searchWkord", params);
	}

	public Map<String, Object> searchWkordMgh(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaProduceService.searchWkordMgh", params);
	}

	public List<Map<String, Object>> searchWkordMghList(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchWkordMghList", params);
	}
	
	public List<Map<String, Object>> searchProcesses(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchProcesses", params);
	}

	public List<Map<String, Object>> searchResultsStatus(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchResultsStatus", params);
	}

	public List<Map<String, Object>> searchBadList(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchBadList", params);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public String getProdtNum(String compCode, String divCode) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		String dateGetString = new SimpleDateFormat("yyyyMMdd").format(new Date());
		spParam.put("COMP_CODE", compCode);
		spParam.put("DIV_CODE", divCode);
		spParam.put("TABLE_ID", "PMR100T");
		spParam.put("PREFIX", "P");
		spParam.put("BASIS_DATE", dateGetString);
		spParam.put("AUTO_TYPE", "1");

		super.commonDao.queryForObject("pdaProduceService.spAutoNum", spParam);

		return ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveWkord(WkordDTO wkord, LoginVO user) throws Exception {
		Map<String, Object> params = buildParams(wkord);

		params.put("S_USER_ID", user.getUserID());
		super.commonDao.insert("pdaProduceService.insertDetail", params);

		Map<String, Object> spParams = new HashMap<>();
		spParams.put("COMP_CODE", params.get("COMP_CODE"));
		spParams.put("DIV_CODE", params.get("DIV_CODE"));
		spParams.put("PRODT_NUM", params.get("PRODT_NUM"));
		spParams.put("WKORD_NUM", params.get("WKORD_NUM"));

		spParams.put("GOOD_WH_CODE", "");
		spParams.put("GOOD_WH_CELL_CODE", "");
		spParams.put("GOOD_PRSN", "");
		spParams.put("GOOD_Q", ObjUtils.parseDouble(params.get("GOOD_PRODT_Q")));

		spParams.put("BAD_WH_CODE", "");
		spParams.put("BAD_WH_CELL_CODE", "");
		spParams.put("BAD_PRSN", "");
		spParams.put("BAD_Q", ObjUtils.parseDouble(params.get("BAD_PRODT_Q")));

		spParams.put("CONTROL_STATUS", params.get("CONTROL_STATUS"));
		spParams.put("PRODT_TYPE", "2"); // (1: 공정별, 2: 작지별, 3: ......)
		spParams.put("STATUS", "N");
		spParams.put("USER_ID", user.getUserID());

		super.commonDao.update("pdaProduceService.spReceiving", spParams);

		List<WkordBadDTO> badList = wkord.getBadList();

		for (WkordBadDTO dto : badList) {
			Map<String, Object> badParams = new HashMap<>();
			badParams.put("COMP_CODE", dto.getCompCode());
			badParams.put("DIV_CODE", dto.getDivCode());
			badParams.put("WORK_SHOP_CODE", dto.getWorkShopCode());
//			badParams.put("PRODT_NUM", dto.getProdtNum());
			badParams.put("PRODT_NUM", wkord.getProdtNum());
			badParams.put("WKORD_NUM", dto.getWkordNum());
			badParams.put("PROG_WORK_CODE", dto.getProgWorkCode());
			badParams.put("ITEM_CODE", dto.getItemCode());
			badParams.put("PRODT_DATE", dto.getProdtDate());
			badParams.put("BAD_CODE", dto.getBadCode());
			badParams.put("BAD_Q", dto.getBadQ());
			badParams.put("REMARK", dto.getRemark());
			badParams.put("S_USER_ID", user.getUserID());

			super.commonDao.insert("pdaProduceService.saveBad", badParams);
		}

		String ErrorDesc = ObjUtils.getSafeString(spParams.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}

	private Map<String, Object> buildParams(WkordDTO dto) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", dto.getCompCode());
		params.put("DIV_CODE", dto.getDivCode());
		params.put("PRODT_NUM", dto.getProdtNum());
		params.put("WORK_SHOP_CODE", dto.getWorkShopCode());
		params.put("WKORD_NUM", dto.getWkordNum());
		params.put("ITEM_CODE", dto.getItemCode());
		params.put("PRODT_DATE", dto.getProdtDate());
		params.put("PRODT_Q", dto.getProdtQ());
		params.put("GOOD_PRODT_Q", dto.getGoodProdtQ());
		params.put("BAD_PRODT_Q", dto.getBadProdtQ());
		params.put("CONTROL_STATUS", dto.getControlStatus());
		params.put("MAN_HOUR", dto.getManHour());
		params.put("LOT_NO", dto.getLotNo());
		params.put("WORK_MAN", dto.getWorkMan());
		params.put("WORK_TIME", dto.getWorkTime());

		params.put("FR_SERIAL_NO", "");
		params.put("TO_SERIAL_NO", "");

		params.put("WORK_GROUP", null);
		params.put("WORK_TYPE", null);
		params.put("WORK_MODEL", null);
		params.put("EQU_CODE", null);

		params.put("PJT_CODE", null);
		params.put("PRODT_PRSN", null);
		params.put("PRODT_MACH", null);
		params.put("PRODT_TIME", null);
		params.put("DAY_NIGHT", null);
		params.put("PQC", null);

		params.put("FR_TIME", null);
		params.put("TO_TIME", null);
		return params;
	}

	public void saveBadList(List<WkordBadDTO> badList, LoginVO user) {
		for (WkordBadDTO dto : badList) {
			Map<String, Object> params = new HashMap<>();
			params.put("COMP_CODE", dto.getCompCode());
			params.put("DIV_CODE", dto.getDivCode());
			params.put("WORK_SHOP_CODE", dto.getWorkShopCode());
			params.put("PRODT_NUM", dto.getProdtNum());
			params.put("WKORD_NUM", dto.getWkordNum());
			params.put("PROG_WORK_CODE", dto.getProgWorkCode());
			params.put("ITEM_CODE", dto.getItemCode());
			params.put("PRODT_DATE", dto.getProdtDate());
			params.put("BAD_CODE", dto.getBadCode());
			params.put("BAD_Q", dto.getBadQ());
			params.put("REMARK", dto.getRemark());
			params.put("S_USER_ID", user.getUserID());

			super.commonDao.insert("pdaProduceService.saveBad", params);
		}
	}

	public void deleteBadList(List<WkordBadDTO> badList, LoginVO user) {
		for (WkordBadDTO dto : badList) {
			Map<String, Object> params = new HashMap<>();
			params.put("COMP_CODE", dto.getCompCode());
			params.put("DIV_CODE", dto.getDivCode());
			params.put("WKORD_NUM", dto.getWkordNum());
			params.put("PROG_WORK_CODE", dto.getProgWorkCode());
			params.put("PRODT_DATE", dto.getProdtDate());
			params.put("BAD_CODE", dto.getBadCode());

			super.commonDao.delete("pdaProduceService.deleteBad", params);
		}
	}

	public void mghPmrLink(WkordDTO wkord, LoginVO user) throws Exception {
		Map<String, Object> params = buildParams(wkord);
try{
		Map<String, Object> spParams = new HashMap<>();
		spParams.put("COMP_CODE", params.get("COMP_CODE"));
		spParams.put("DIV_CODE", params.get("DIV_CODE"));
		spParams.put("WKORD_NUM", params.get("WKORD_NUM"));

		super.commonDao.update("pdaProduceService.spMghPmrLink", spParams);
} catch(Exception e){
}
//		String ErrorDesc = ObjUtils.getSafeString(spParams.get("ErrorDesc"));
//		if (!ObjUtils.isEmpty(ErrorDesc)) {
//			throw new Exception(ErrorDesc);
//		}
	}
	
	

	public List<Map<String, Object>> searchWkordData(Map<String, Object> params) {
		return super.commonDao.list("pdaProduceService.searchWkordData", params);
	}

}
