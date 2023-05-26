package api.foren.pda2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import api.foren.pda2.dto.kodiDto.Kodi_LotDTO;
import api.foren.pda2.dto.kodiDto.Pdm200ukrvDTO;
import api.foren.pda2.dto.kodiDto.Pdp300ukrvDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
 
@SuppressWarnings("unchecked")
@Service("pdaKodiService")
public class PdaKodiServiceImpl extends TlabAbstractServiceImpl {
	/*
	public List<Map<String, Object>> searchListPdm100ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaKodiService.searchListPdm100ukrvSub1",params);
	}
	public List<Map<String, Object>> searchListPdm100ukrvSub2(Map<String,Object> params){
		return super.commonDao.list("pdaKodiService.searchListPdm100ukrvSub2",params);
	}
	*/

	public Map<String, Object> searchStockQ(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaKodiService.searchStockQ",params);
	}
	
	public Map<String, Object> selectWkordCheck(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaKodiService.selectWkordCheck", params);
	}

	public List<Map<String, Object>> searchListPdm200ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaKodiService.searchListPdm200ukrvMain",params);
	}
	
	
	public List<Map<String, Object>> searchListPdp300ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaKodiService.searchListPdp300ukrvMain",params);
	}
	
	public void savePdm200ukrv(List<Pdm200ukrvDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (Pdm200ukrvDTO material : dtos) {
			List<Kodi_LotDTO> lotList = material.getLotList();

			for (Kodi_LotDTO lot : lotList) {
				Map<String, Object> paramMaster = buildParamMaster(material);
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
				super.commonDao.insert("pdaKodiService.insertPdm200", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);

		super.commonDao.queryForObject("pdaKodiService.uspMatrlMtr200ukr", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	
	public void savePdp300ukrv(List<Pdp300ukrvDTO> dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int seq = 0;
		for (Pdp300ukrvDTO material : dtos) {
			List<Kodi_LotDTO> lotList = material.getLotList();

			for (Kodi_LotDTO lot : lotList) {
				Map<String, Object> paramMaster = buildParamMaster(material);
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
				super.commonDao.insert("pdaKodiService.insertPdp300", params);
			}
		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);

		super.commonDao.queryForObject("pdaKodiService.uspMatrlMtr200ukr", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	private Map<String, Object> buildParamDetails(Kodi_LotDTO lot) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("WH_CODE", lot.getWhCode());
		paramDetails.put("WH_CELL_CODE", lot.getWhCellCode());
		paramDetails.put("LOT_NO", lot.getLotNo());
		paramDetails.put("ORDER_UNIT_Q", lot.getOrderUnitQ());

		return paramDetails;
	}
	private Map<String, Object> buildParamMaster(Pdm200ukrvDTO material) {
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
	
	private Map<String, Object> buildParamMaster(Pdp300ukrvDTO material) {
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
		
		
		paramMaster.put("WORK_SHOP_CODE", material.getWorkShopCode());		
		
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
	
	/*
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdp300ukrv(Pdp300ukrvDTO pdp300ukrvDTO, LoginVO user) throws Exception {
		Map<String, Object> params = buildParams(pdp300ukrvDTO);

		params.put("S_USER_ID", user.getUserID());
		if(params.get("SAVE_FLAG").equals("N")){
			super.commonDao.insert("pdaKodiService.insertPdp300ukrv", params);
		}else if(params.get("SAVE_FLAG").equals("D")) {
			super.commonDao.delete("pdaKodiService.deletePdp300ukrv", params);
		}
		

//		
//
//		String ErrorDesc = ObjUtils.getSafeString(spParams.get("ErrorDesc"));
//		if (!ObjUtils.isEmpty(ErrorDesc)) {
//			throw new Exception(ErrorDesc);
//		}
	}
	private Map<String, Object> buildParams(Pdp300ukrvDTO pdp300ukrvDTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pdp300ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdp300ukrvDTO.getDivCode());
		
		params.put("WORK_SHOP_CODE", pdp100ukrvDTO.getWorkShopCode());
		params.put("CHECK_DATE", pdp100ukrvDTO.getInspectionDate());
		params.put("FR_TIME", pdp100ukrvDTO.getFrTime());
		params.put("TO_TIME", pdp100ukrvDTO.getToTime());
		params.put("WORKER", pdp100ukrvDTO.getWorkPerson());
		params.put("CHECK_DESC", pdp100ukrvDTO.getInspectionRemark());
		params.put("NEXT_DAY_FLAG", pdp100ukrvDTO.getNextDayFlag());
		
		params.put("SAVE_FLAG", pdp100ukrvDTO.getSaveFlag());
		
		return params;
	}*/
}
