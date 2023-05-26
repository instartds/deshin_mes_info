package api.foren.pda2.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import api.foren.pda2.dto.hspDto.Pds200ukrvSub1DTO;
import api.foren.pda2.dto.mitDto.Pdp200ukrvDTO;
import api.foren.pda2.dto.mitDto.Pdp200ukrvSub1DTO;
import api.foren.pda2.dto.mitDto.Pdv100ukrvDTO;
import api.foren.pda2.dto.wmDto.Pdp400ukrvDetailDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
 
@SuppressWarnings("unchecked")
@Service("pdaMitService")
public class PdaMitServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 생산실적 불량입력 불량유형 데이터
	 * @param params
	 * @return
	 */
	public List<Map> getBadTypeCodeList(Map<String, Object> params) {
		return super.commonDao.list("pdaMitService.getBadTypeCodeList", params);
	}
	/**
	 * 생산실적 불량입력 팝업
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdp200ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaMitService.searchListPdp200ukrvSub1",params);
	}
	/**
	 * 생산실적 메인조회
	 * @param params
	 * @return
	 */

	public Map<String, Object> searchPdp200ukrvMain(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaMitService.searchPdp200ukrvMain",params);
	}
	
	/**
	 * 생산실적 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	public void savePdp200ukrv(Pdp200ukrvDTO dtos, LoginVO user) throws Exception {
		
		Map<String, Object> params = buildParams(dtos);

		Map<String, Object> spParam1 = new HashMap<String, Object>();

		String dateGetString = new SimpleDateFormat("yyyyMMdd").format(new Date());
		spParam1.put("COMP_CODE", params.get("COMP_CODE"));
		spParam1.put("DIV_CODE", params.get("DIV_CODE"));
		spParam1.put("TABLE_ID", "PMR100T");
		spParam1.put("PREFIX", "P");
		spParam1.put("BASIS_DATE", dateGetString);
		spParam1.put("AUTO_TYPE", "1");

		super.commonDao.queryForObject("pdaMitService.spAutoNum", spParam1);

		params.put("PRODT_NUM",	ObjUtils.getSafeString(spParam1.get("KEY_NUMBER")));
		params.put("S_USER_ID", user.getUserID());
		super.commonDao.insert("pdaMitService.insertPdp200ukrv", params);
		
		Map<String, Object> spParam2 = new HashMap<>();

		spParam2.put("COMP_CODE", params.get("COMP_CODE"));
		spParam2.put("DIV_CODE", params.get("DIV_CODE"));
		spParam2.put("PRODT_NUM", params.get("PRODT_NUM"));
		spParam2.put("WKORD_NUM", params.get("WKORD_NUM"));

		spParam2.put("CONTROL_STATUS", params.get("CONTROL_STATUS"));

		spParam2.put("GOOD_Q", ObjUtils.parseDouble(params.get("GOOD_WORK_Q")));
		spParam2.put("BAD_Q", ObjUtils.parseDouble(params.get("BAD_WORK_Q")));

		spParam2.put("PRODT_TYPE", "1"); // (1: 공정별, 2: 작지별, 3: ......)
		spParam2.put("STATUS", "N");
		spParam2.put("USER_ID", user.getUserID());
		
		Map<String, Object> selectWhCode = null;
		
		selectWhCode = (Map<String, Object>) super.commonDao.select("pdaMitService.selectWhCode", params);
	
		spParam2.put("GOOD_WH_CODE", selectWhCode.get("GOOD_WH_CODE"));
		spParam2.put("GOOD_WH_CELL_CODE", selectWhCode.get("GOOD_WH_CELL_CODE"));
		spParam2.put("GOOD_PRSN", selectWhCode.get("GOOD_PRSN"));
		spParam2.put("BAD_WH_CODE", selectWhCode.get("BAD_WH_CODE"));
		spParam2.put("BAD_WH_CELL_CODE", selectWhCode.get("BAD_WH_CELL_CODE"));
		spParam2.put("BAD_PRSN",selectWhCode.get("BAD_PRSN"));
		

		super.commonDao.queryForObject("pdaMitService.spProductionResult", spParam2);

		List<Pdp200ukrvSub1DTO> badList = dtos.getSub1List();

		for (Pdp200ukrvSub1DTO dto : badList) {
			Map<String, Object> badParams = new HashMap<>();
			badParams.put("COMP_CODE", dto.getCompCode());
			badParams.put("DIV_CODE", dto.getDivCode());
			badParams.put("WORK_SHOP_CODE", dto.getWorkShopCode());
//			badParams.put("PRODT_NUM", dto.getProdtNum());
			badParams.put("PRODT_NUM", params.get("PRODT_NUM"));
			badParams.put("WKORD_NUM", dto.getWkordNum());
			badParams.put("PROG_WORK_CODE", dto.getProgWorkCode());
			badParams.put("ITEM_CODE", dto.getItemCode());
			badParams.put("PRODT_DATE", dto.getProdtDate());
			badParams.put("BAD_CODE", dto.getBadCode());
			badParams.put("BAD_Q", dto.getBadQ());
			badParams.put("REMARK", dto.getRemark());
			badParams.put("S_USER_ID", user.getUserID());

			super.commonDao.insert("pdaMitService.saveBad", badParams);
		}

		String ErrorDesc = ObjUtils.getSafeString(spParam2.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	
	private Map<String, Object> buildParams(Pdp200ukrvDTO dto) {
		Map<String, Object> params = new HashMap<>();
		
		params.put("COMP_CODE",dto.getCompCode());
		params.put("DIV_CODE",dto.getDivCode());
		params.put("PRODT_NUM",dto.getProdtNum());
		params.put("PRODT_DATE",dto.getProdtDate());
		params.put("PROG_WORK_CODE",dto.getProgWorkCode());
		params.put("WKORD_Q",dto.getWkordQ());
		params.put("GOOD_WORK_Q",dto.getGoodWorkQ());
		params.put("BAD_WORK_Q",dto.getBadWorkQ());
		params.put("WKORD_NUM",dto.getWkordNum());
		params.put("WK_PLAN_NUM",dto.getWkPlanNum());
		params.put("CONTROL_STATUS",dto.getControlStatus());
		params.put("MAN_HOUR",dto.getManHour());
		params.put("REMARK",dto.getRemark());
		params.put("LOT_NO",dto.getLotNo());
		params.put("EQUIP_CODE",dto.getEquipCode());
		params.put("PRODT_PRSN",dto.getProdtPrsn());
		params.put("EXPIRATION_DATE",dto.getExpirationDate());
		
		return params;
	}
	
	/**
	 * 자재재고이동 바코드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> searchPdv102ukrvBarcodeData(Map<String,Object> params) throws Exception {
		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaMitService.pdv100ukrvSearchData",params);
		if(ObjUtils.isNotEmpty(checkMap)){
			if(checkMap.get("ITEM_CODE").equals("")){
				throw new Exception("바코드 정보 데이터가 없습니다.");
				//바코드를 인식하지 못했습니다.
			}
		}else{
			throw new Exception("바코드 정보 데이터가 없습니다.");
		}
		return checkMap;
	}
	
	
	/**
	 * 제품/자재 재고이동 메인조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdv100ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaMitService.searchListPdv100ukrvMain",params);
	}
	
	
	/**
	 * 제품/자재 재고이동 log 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdv100ukrvLog(Pdv100ukrvDTO pdv100ukrvDTO, LoginVO user) throws Exception {

		Map<String, Object> params = buildParams(pdv100ukrvDTO);
		params.put("S_USER_ID", user.getUserID());

		if(params.get("SAVE_FLAG").equals("N")){
			if(params.get("GUBUN").equals("10")){
				Map<String, Object> dataMap = (Map<String, Object>) super.commonDao.select("pdaMitService.pdv100ukrvSearchData",params);
				if(ObjUtils.isNotEmpty(dataMap)){
					params.put("ITEM_CODE",dataMap.get("ITEM_CODE"));
					params.put("LOT_NO",dataMap.get("ITEM_LOT_NO"));
		//			params.put("LOT_NO",dataMap.get("LOT_NO"));
					params.put("QTY",dataMap.get("QTY"));
				}else{
					throw new Exception("바코드 정보 데이터가 없습니다.");
				}
			}
			Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaMitService.pdv100ukrvCheckScanData",params);
			if(ObjUtils.isNotEmpty(checkMap)){
				throw new Exception("이미 스캔한 바코드 입니다.");
			}
			super.commonDao.insert("pdaMitService.insertPdv100ukrvLog", params);
		}else if(params.get("SAVE_FLAG").equals("D")) {
//			if(params.get("DELETE_FLAG").equals("ALL")) {
//				super.commonDao.delete("pdaHspService.deletePds200ukrv_log_all", params);
//			}else{
				super.commonDao.delete("pdaMitService.deletePdv100ukrvLog", params);
//			}
		}

		
	}
	
	/**
	 * 제품/자재 재고이동 메인 저장
	 * @param dtos
	 * @param user
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdv100ukrvMain(Pdv100ukrvDTO pdv100ukrvDTO, LoginVO user) throws Exception {

		Map<String, Object> params = buildParams(pdv100ukrvDTO);
		params.put("S_USER_ID", user.getUserID());
		
		String keyValue = getLogKey();
		params.put("KEY_VALUE", keyValue);
		params.put("OPR_FLAG", "N");

		super.commonDao.insert("pdaMitService.insertPdv100ukrvMain", params);
		super.commonDao.update("pdaMitService.updatePdv100ukrvLog", params);

		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		super.commonDao.queryForObject("pdaMitService.spCallPdv100ukrv", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
	
	private Map<String, Object> buildParams(Pdv100ukrvDTO dto) {
		Map<String, Object> params = new HashMap<>();
		
		params.put("COMP_CODE",dto.getCompCode());
		params.put("DIV_CODE",dto.getDivCode());
		params.put("GUBUN",dto.getGubun());
		params.put("OUT_WH_CODE",dto.getOutWhCode());
		params.put("OUT_WH_CELL_CODE",dto.getOutWhCellCode());
		params.put("IN_WH_CODE",dto.getInWhCode());
		params.put("IN_WH_CELL_CODE",dto.getInWhCellCode());
		params.put("SAVE_FLAG",dto.getSaveFlag());

		params.put("INOUT_DATE",dto.getInoutDate());
		params.put("INOUT_PRSN",dto.getInoutPrsn());
		params.put("ITEM_CODE",dto.getItemCode());
		params.put("LOT_NO",dto.getLotNo());
		params.put("BARCODE",dto.getBarCode());

		params.put("QTY",dto.getQty());
		
		params.put("REMARK", dto.getRemark());
		
		params.put("SEQ", dto.getSeq());
		
		return params;
	}
	

	/**
	 * 생산 재고이동 유형 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdv103ukrvType(Map<String,Object> params){
		return super.commonDao.list("pdaMitService.searchListPdv103ukrvType",params);
	}
	/**
	 * 생산재고이동 바코드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> searchPdv103ukrvBarcodeData(Map<String,Object> params) throws Exception {
		Map<String, Object> checkMap = (Map<String, Object>) super.commonDao.select("pdaMitService.pdv100ukrvSearchData",params);
		if(ObjUtils.isNotEmpty(checkMap)){
			if(checkMap.get("ITEM_CODE").equals("")){
				throw new Exception("바코드 정보 데이터가 없습니다.");
				//바코드를 인식하지 못했습니다.
			}
		}else{
			throw new Exception("바코드 정보 데이터가 없습니다.");
		}
		return checkMap;
	}
	

	/**
	 * 재고이동 조회  
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdv104ukrvMain(Map<String,Object> params){
		return super.commonDao.list("pdaMitService.searchListPdv104ukrvMain",params);
	}

	/**
	 * 재고이동 이동번호 검색 팝업
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> searchListPdv104ukrvSub1(Map<String,Object> params){
		return super.commonDao.list("pdaMitService.searchListPdv104ukrvSub1",params);
	}	

	/**
	 * 이동출고 저장  
	 * @param params
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void savePdv104ukrvMain(Map<String,Object> params, LoginVO user) throws Exception{

		//Map<String, Object> params = buildParams(pdv100ukrvDTO);
		params.put("S_USER_ID", user.getUserID());
		
		String keyValue = getLogKey();
		params.put("KEY_VALUE", keyValue);
//		params.put("OPR_FLAG", "N");

		super.commonDao.insert("pdaMitService.savePdv104ukrvMain", params);
//		super.commonDao.update("pdaMitService.updatePdv100ukrvLog", params);

		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		super.commonDao.queryForObject("pdaMitService.spCallPdv104ukrv", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(ErrorDesc)) {
			throw new UniDirectValidateException(this.getMessage(ErrorDesc, user).substring(this.getMessage(ErrorDesc, user).indexOf("||")+2));
//			throw new Exception(ErrorDesc);
		}
	}
}
