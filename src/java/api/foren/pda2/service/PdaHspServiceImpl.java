package api.foren.pda2.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.foren.pda2.dto.hspDto.Hsp_LotDTO;
import api.foren.pda2.dto.hspDto.Pdm100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdm100ukrvDetailDTO;
import api.foren.pda2.dto.hspDto.Pdm101ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp100ukrvDTO;
import api.foren.pda2.dto.hspDto.Pdp200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvDetailDTO;
import api.foren.pda2.dto.hspDto.Pds200ukrvSub1DTO;
import api.foren.pda2.dto.hspDto.Pdv200ukrvDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
 
@SuppressWarnings("unchecked")
@Service("pdaHspService")
public class PdaHspServiceImpl extends TlabAbstractServiceImpl {
	
	public List<Map<String, Object>> searchListPdm100ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPdm100ukrvSub1",params);
	}
	public List<Map<String, Object>> searchListPdm100ukrvSub2(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPdm100ukrvSub2",params);
	}
	

	public List<Map<String, Object>> searchListPdp100ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPdp100ukrvMain",params);
	}

	public Map<String, Object> searchPdp200ukrvMain(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaHspService.searchPdp200ukrvMain",params);
	}

	public Map<String, Object> searchPdp200ukrvLogCheck(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaHspService.searchPdp200ukrvLogCheck",params);
	}
	
	public Map<String, Object> selectWkordCheck(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaHspService.selectWkordCheck", params);
	}
	public List<Map<String, Object>> searchListPds200ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPds200ukrvMain",params);
	}
	public List<Map<String, Object>> searchListPds200ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPds200ukrvSub1",params);
	}

	public List<Map<String, Object>> searchListPds200ukrvSub2(Map<String,Object> params){
		return super.commonDao.list("pdaHspService.searchListPds200ukrvSub2",params);
	}
/*	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdm100ukrv(Pdm100ukrvDTO pdm100ukrvDTO, LoginVO user) throws Exception {
		Map<String, Object> params = buildParams(pdm100ukrvDTO);

		params.put("S_USER_ID", user.getUserID());
		if(params.get("SAVE_FLAG").equals("N")){
			super.commonDao.insert("pdaHspService.insertPdp100ukrv", params);
		}else if(params.get("SAVE_FLAG").equals("D")) {
			super.commonDao.delete("pdaHspService.deletePdp100ukrv", params);
		}
	}*/
	
	
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
				super.commonDao.insert("pdaHspService.insertPdm100ukrv", params);
			}
//		}

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", "KR");
		spParam.put("CreateType", "2");

		super.commonDao.queryForObject("pdaHspService.spReceiving", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdm101ukrv(Pdm101ukrvDTO pdm101ukrvDTO, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		
		Map<String, Object> params = buildParams(pdm101ukrvDTO);

		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");
		params.put("INOUT_SEQ", 1);
		params.put("S_USER_ID", user.getUserID());
		
		super.commonDao.insert("pdaHspService.insertPdm101ukrv", params);

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", "KR");
		spParam.put("CreateType", "2");

		super.commonDao.queryForObject("pdaHspService.spReceiving", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}
	
		
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdp100ukrv(Pdp100ukrvDTO pdp100ukrvDTO, LoginVO user) throws Exception {
		Map<String, Object> params = buildParams(pdp100ukrvDTO);

		params.put("S_USER_ID", user.getUserID());
		if(params.get("SAVE_FLAG").equals("N")){
			super.commonDao.insert("pdaHspService.insertPdp100ukrv", params);
		}else if(params.get("SAVE_FLAG").equals("D")) {
			super.commonDao.delete("pdaHspService.deletePdp100ukrv", params);
		}
		
	}

	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdp200ukrv(Pdp200ukrvDTO pdp200ukrvDTO, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		
		Map<String, Object> params = buildParams(pdp200ukrvDTO);

		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaHspService.searchPdp200ukrvLogCheck",params);
		if(ObjUtils.isNotEmpty(checkMap)){
			throw new Exception("이미 생산입고처리되었습니다.");
		}
		
		SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
		Date dateGet = new Date ();
		String dateGetString = dateFormat.format(dateGet);

		params.put("TABLE_ID","PMR100T");
		params.put("PREFIX", "P");
		params.put("BASIS_DATE", dateGetString);
		params.put("AUTO_TYPE", "1");
		params.put("S_USER_ID", user.getUserID());
		
		super.commonDao.queryForObject("pdaHspService.spAutoNumPdp200ukrv", params);
		params.put("PRODT_NUM",	ObjUtils.getSafeString(params.get("KEY_NUMBER")));
		
		
		super.commonDao.insert("pdaHspService.insertPdp200ukrv_log", params);
		
		super.commonDao.insert("pdaHspService.insertPdp200ukrv", params);

//		Map<String, Object> spParam = new HashMap<String, Object>();
		params.put("GOOD_WH_CELL_CODE","");
		params.put("GOOD_PRSN","");
		params.put("BAD_WH_CELL_CODE","");
		params.put("BAD_PRSN","");
		params.put("PRODT_TYPE",	"2");	// (1: 공정별, 2: 작지별, 3: ......)
		params.put("STATUS",	"N");
		
		super.commonDao.queryForObject("pdaHspService.spCallPdp200ukrv", params);

		String ErrorDesc = ObjUtils.getSafeString(params.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}

	/**
	 * 제품출고 lot출고 화면 총 작업수량 값 관련
	 * @param params
	 * @return
	 */
	public Map<String, Object> searchPds200ukrvSub1WorkTot(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaHspService.searchPds200ukrvSub1WorkTot",params);
	}
	/**
	 * 제품출고lot log
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePds200ukrvSub1(Pds200ukrvSub1DTO pds200ukrvSub1DTO, LoginVO user) throws Exception {

		Map<String, Object> params = buildParams(pds200ukrvSub1DTO);
		params.put("S_USER_ID", user.getUserID());
		
		if(params.get("SAVE_FLAG").equals("N")){
			Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaHspService.searchPds200ukrvLogCheck",params);
			if(ObjUtils.isNotEmpty(checkMap)){
				throw new Exception("이미 출고스캔한 제품입니다.");
			}
			
			Map<String, Object> checkMap2 = (Map<String, Object>) super.commonDao.select("pdaHspService.searchPds200ukrvSub1WorkTot",params);
			if(ObjUtils.isNotEmpty(checkMap2)){
				if(ObjUtils.parseDouble(checkMap2.get("CHECK_Q")) - ObjUtils.parseDouble(params.get("OUT_Q")) < 0){
					throw new Exception("작업지시량을 초과하였습니다.");
				}
			}
			
			super.commonDao.insert("pdaHspService.insertPds200ukrv_log", params);
		}else if(params.get("SAVE_FLAG").equals("D")) {
			if(params.get("DELETE_FLAG").equals("ALL")) {
				super.commonDao.delete("pdaHspService.deletePds200ukrv_log_all", params);
			}else{
				super.commonDao.delete("pdaHspService.deletePds200ukrv_log", params);
			}
		}

		
	}
	
	/**
	 * 제품출고
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	
	public void savePds200ukrv(Pds200ukrvDTO dtos, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		List<Pds200ukrvDetailDTO> detailList = dtos.getDetailList();

		for (Pds200ukrvDetailDTO detailData : detailList) {
			Map<String, Object> paramMaster = buildParamMaster(dtos);
			Map<String, Object> paramDetails = buildParamDetails(detailData);
			Map<String, Object> params = new HashMap<>();
			params.put("KEY_VALUE", keyValue);
			params.put("OPR_FLAG", "N");
			params.put("S_USER_ID", user.getUserID());
			params.putAll(paramMaster);
			params.putAll(paramDetails);
			super.commonDao.insert("pdaHspService.insertPds200ukrv", params);
			super.commonDao.update("pdaHspService.updatePds200ukrvLog", params);
		}

		
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);

		super.commonDao.queryForObject("pdaHspService.spCallPds200ukrv", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdv200ukrv(Pdv200ukrvDTO pdv200ukrvDTO, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		
		Map<String, Object> params = buildParams(pdv200ukrvDTO);

		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");
		params.put("INOUT_SEQ", 1);
		params.put("S_USER_ID", user.getUserID());
		
		super.commonDao.insert("pdaHspService.insertPdm101ukrv", params);

		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", "KR");
		spParam.put("CreateType", "2");

		super.commonDao.queryForObject("pdaHspService.spReceiving", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new Exception(ErrorDesc);
		}
	}*/
	
	/**
	 * 재고대체
	 * @param params
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> savePdv200ukrv(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaHspService.savePdv200ukrv", params);
	}
	
	
	private Map<String, Object> buildParams(Pdp100ukrvDTO pdp100ukrvDTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pdp100ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdp100ukrvDTO.getDivCode());
		
		params.put("WORK_SHOP_CODE", pdp100ukrvDTO.getWorkShopCode());
		params.put("CHECK_DATE", pdp100ukrvDTO.getInspectionDate());
		params.put("FR_TIME", pdp100ukrvDTO.getFrTime());
		params.put("TO_TIME", pdp100ukrvDTO.getToTime());
		params.put("WORKER", pdp100ukrvDTO.getWorkPerson());
		params.put("CHECK_DESC", pdp100ukrvDTO.getInspectionRemark());
		params.put("NEXT_DAY_FLAG", pdp100ukrvDTO.getNextDayFlag());
		
		params.put("SAVE_FLAG", pdp100ukrvDTO.getSaveFlag());
		
		return params;
	}
	
	private Map<String, Object> buildParams(Pdp200ukrvDTO pdp200ukrvDTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pdp200ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdp200ukrvDTO.getDivCode());
		params.put("WORK_SHOP_CODE", pdp200ukrvDTO.getWorkShopCode());
		params.put("WKORD_NUM", pdp200ukrvDTO.getWkordNum());
		params.put("ITEM_CODE", pdp200ukrvDTO.getItemCode());
		params.put("PRODT_DATE", pdp200ukrvDTO.getProdtDate());
		params.put("PRODT_Q", pdp200ukrvDTO.getProdtQ());
		params.put("GOOD_PRODT_Q", pdp200ukrvDTO.getGoodProdtQ());
		params.put("BAD_PRODT_Q", pdp200ukrvDTO.getBadProdtQ());
		params.put("CONTROL_STATUS", pdp200ukrvDTO.getControlStatus());
		params.put("MAN_HOUR", pdp200ukrvDTO.getManHour());
		params.put("LOT_NO", pdp200ukrvDTO.getLotNo());
		params.put("LOT_SN", pdp200ukrvDTO.getLotSn());
		params.put("FR_TIME", pdp200ukrvDTO.getFrTime());
		params.put("TO_TIME", pdp200ukrvDTO.getToTime());
		params.put("WH_CODE", pdp200ukrvDTO.getWhCode());
		params.put("PRODT_PRSN", pdp200ukrvDTO.getProdtPrsn());
		
		return params;
	}
	
	
	
	
	private Map<String, Object> buildParamDetails(Pdm100ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();
		
	    paramDetails.put("ITEM_CODE", detail.getItemCode());
	    paramDetails.put("ITEM_NAME", detail.getItemName());
	    paramDetails.put("SPEC", detail.getSpec());
	    paramDetails.put("ORDER_UNIT", detail.getOrderUnit());
	    paramDetails.put("INOUT_Q", detail.getInoutQ());
	    paramDetails.put("ITEM_P", detail.getItemP());

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
	private Map<String, Object> buildParams(Pdm101ukrvDTO pdm101ukrvDTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pdm101ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdm101ukrvDTO.getDivCode());
		
		params.put("WH_CODE", pdm101ukrvDTO.getWhCode());
		params.put("INOUT_DATE", pdm101ukrvDTO.getInoutDate());
		params.put("INOUT_PRSN", pdm101ukrvDTO.getInoutPrsn());
		params.put("CUSTOM_CODE", pdm101ukrvDTO.getCustomCode());
		params.put("ITEM_CODE", pdm101ukrvDTO.getItemCode());
		params.put("INOUT_Q", pdm101ukrvDTO.getInoutQ());
		
		
		
		return params;
	}
	
	private Map<String, Object> buildParams(Pds200ukrvSub1DTO pds200ukrvSub1DTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pds200ukrvSub1DTO.getCompCode());
		params.put("DIV_CODE", pds200ukrvSub1DTO.getDivCode());
		params.put("ISSUE_REQ_NUM", pds200ukrvSub1DTO.getIssueReqNum());
		params.put("ISSUE_REQ_SEQ", pds200ukrvSub1DTO.getIssueReqSeq());
		params.put("CUSTOM_CODE", pds200ukrvSub1DTO.getCustomCode());
		params.put("ITEM_CODE", pds200ukrvSub1DTO.getItemCode());
		params.put("LOT_NO", pds200ukrvSub1DTO.getLotNo());
		params.put("LOT_SN", pds200ukrvSub1DTO.getLotSn());
		params.put("OUT_Q", pds200ukrvSub1DTO.getOutQ());
		params.put("APPLY_YN", pds200ukrvSub1DTO.getApplyYn());
		params.put("WH_CODE", pds200ukrvSub1DTO.getWhCode());

		params.put("SAVE_FLAG", pds200ukrvSub1DTO.getSaveFlag());
		params.put("DELETE_FLAG", pds200ukrvSub1DTO.getDeleteFlag());
		return params;
	}
	private Map<String, Object> buildParamMaster(Pds200ukrvDTO master) {
		Map<String, Object> paramMaster = new HashMap<>();
		paramMaster.put("COMP_CODE", master.getCompCode());
		paramMaster.put("DIV_CODE", master.getDivCode());
		paramMaster.put("CUSTOM_CODE", master.getCustomCode());
		paramMaster.put("INOUT_DATE", master.getInoutDate());
		paramMaster.put("INOUT_PRSN", master.getInoutPrsn());
		return paramMaster;
	}
	
	private Map<String, Object> buildParamDetails(Pds200ukrvDetailDTO detail) {
		Map<String, Object> paramDetails = new HashMap<>();

		paramDetails.put("ISSUE_REQ_NUM", detail.getIssueReqNum());
		paramDetails.put("ISSUE_REQ_SEQ", detail.getIssueReqSeq());
		paramDetails.put("ITEM_CODE", detail.getItemCode());

		paramDetails.put("ORDER_NUM", detail.getOrderNum());
		paramDetails.put("ORDER_SEQ", detail.getOrderSeq());
		return paramDetails;
	}
	
/*	private Map<String, Object> buildParams(Pdv200ukrvDTO pdv200ukrvDTO) {
		Map<String, Object> params = new HashMap<>();
		params.put("COMP_CODE", pdv200ukrvDTO.getCompCode());
		params.put("DIV_CODE", pdv200ukrvDTO.getDivCode());
		
		params.put("WH_CODE", pdv200ukrvDTO.getWhCode());
		params.put("INOUT_DATE", pdv200ukrvDTO.getInoutDate());
		params.put("INOUT_PRSN", pdv200ukrvDTO.getInoutPrsn());
		params.put("CUSTOM_CODE", pdv200ukrvDTO.getCustomCode());
		params.put("ITEM_CODE", pdv200ukrvDTO.getItemCode());
		params.put("INOUT_Q", pdv200ukrvDTO.getInoutQ());
		
		
		
		return params;
	}*/
}
