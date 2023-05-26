package foren.unilite.modules.z_mek;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_qms500ukrv_mekService")
public class S_qms500ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 유효기간 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectExpirationdate(Map param) throws Exception {
		return super.commonDao.select("s_qms500ukrv_mekServiceImpl.selectExpirationdate", param);
	}
	
	/**
	 * 검사등록 -> 검사내역조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_qms500ukrv_mekServiceImpl.selectList1", param);
	}
	
	/**
	 * 검사등록 -> 불량내역조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_qms500ukrv_mekServiceImpl.selectList2", param);
	}
	
	/**
	 * 검사등록->접수참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptList(Map param) throws Exception {
		return super.commonDao.list("s_qms500ukrv_mekServiceImpl.selectreceiptList", param);
	}
	
	/**
	 * 검사등록->검사내역검색
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_qms500ukrv_mekServiceImpl.selectreceiptNumMasterList", param);
	}
	
	/**
	 * 검사등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {

		List<Map> insertList = null;
		List<Map> updateList = null;
		List<Map> deleteList = null;
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		String inspecNum = "";
		
		for(Map dataListMap : paramList) {
			if(dataListMap.get("method").equals("deleteMaster")) {
				deleteList = (List<Map>)dataListMap.get("data");
			} else if(dataListMap.get("method").equals("insertMaster")) {
				insertList = (List<Map>)dataListMap.get("data");
			} else if(dataListMap.get("method").equals("updateMaster")) {
				updateList = (List<Map>)dataListMap.get("data");
			}
			
			if(dataMaster.get("INSPEC_NUM") == null || "".equals(dataMaster.get("INSPEC_NUM"))) {
				Map<String, Object> spParam = new HashMap<String, Object>();

				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				spParam.put("TABLE_ID", "QMS200T");
				spParam.put("PREFIX", "Q");
				spParam.put("BASIS_DATE", dataMaster.get("INSPEC_DATE"));
				spParam.put("AUTO_TYPE", "1");
				
				super.commonDao.queryForObject("s_qms500ukrv_mekServiceImpl.spSP_GetAutoNumComp", spParam);
				
				inspecNum = ObjUtils.getSafeString(spParam.get("INSPEC_NUM"));
			}
			else {
				inspecNum = dataMaster.get("INSPEC_NUM").toString();
			}
			
			if(deleteList != null) this.deleteMaster(deleteList, user);
			if(insertList != null) this.insertMaster(insertList, inspecNum, user);
			if(updateList != null) this.updateMaster(updateList, user);
		}
		
		dataMaster.put("INSPEC_NUM", inspecNum);
		paramList.add(0, paramMaster);
		
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// INSERT
	public Integer insertMaster(List<Map> paramList, String inspecNum, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			if(param.get("INSPEC_NUM") == null || "".equals(param.get("INSPEC_NUM"))) {
				param.put("INSPEC_NUM", inspecNum);
			}
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.insertMaster", param);
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateBTR100T_inspecNum", param);
			
			if(!(param.get("ORI_LOT_NO")).equals(param.get("LOT_NO"))) {
				String inoutDate = (String)super.commonDao.select("s_qms500ukrv_mekServiceImpl.selectBTR100T_inoutDate", param);
				
				super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateBTR100T_lotNo", param);
				
				Map<String, Object> spParam = new HashMap<String, Object>();
				
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", param.get("DIV_CODE"));
				spParam.put("START_MONTH", inoutDate.substring(0, 6));
				spParam.put("END_MONTH", inoutDate.substring(0, 6));
				spParam.put("ITEM_CODE", param.get("ITEM_CODE"));
				spParam.put("USER_ID", user.getUserID());
				
				super.commonDao.queryForObject("s_qms500ukrv_mekServiceImpl.spSP_STOCK_PeriodicAverageClosing4Div_ITEM", spParam);
			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer updateMaster(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateMaster", param);
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateBTR100T_inspecNum", param);
			
			if(!(param.get("ORI_LOT_NO")).equals(param.get("LOT_NO"))) {
				String inoutDate = (String)super.commonDao.select("s_qms500ukrv_mekServiceImpl.selectBTR100T_inoutDate", param);
				
				super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateBTR100T_lotNo", param);
				
				Map<String, Object> spParam = new HashMap<String, Object>();
				
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", param.get("DIV_CODE"));
				spParam.put("START_MONTH", inoutDate.substring(0, 6));
				spParam.put("END_MONTH", inoutDate.substring(0, 6));
				spParam.put("ITEM_CODE", param.get("ITEM_CODE"));
				spParam.put("USER_ID", user.getUserID());
				
				super.commonDao.queryForObject("s_qms500ukrv_mekServiceImpl.spSP_STOCK_PeriodicAverageClosing4Div_ITEM", spParam);
			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer deleteMaster(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			Map<String, Object> spParam = new HashMap<String, Object>();
			
			spParam.put("S_COMP_CODE", user.getCompCode());
			spParam.put("DIV_CODE", param.get("DIV_CODE"));
			spParam.put("INOUT_NUM", param.get("INOUT_NUM"));
			spParam.put("INOUT_SEQ", param.get("INOUT_SEQ"));
			spParam.put("INSPEC_NUM", null);
			spParam.put("INSPEC_SEQ", null);
			spParam.put("INSPEC_Q", param.get("ORI_INSPEC_Q"));
			
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateBTR100T_inspecNum", spParam);
			
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.deleteMaster", param);
		}
		return 0;
	}

	/**
	 * 검사등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllBad(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			String sInspecNum = "";
			dataList = (List<Map>) paramData.get("data");
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			for(Map param:  dataList) {
				if(param.get("INSPEC_NUM") == null || StringUtils.isBlank((String) param.get("INSPEC_NUM"))){
					// 신규건에 대한 처리
					param.put("INSPEC_NUM", dataMaster.get("INSPEC_NUM"));
					param.put("INSPEC_SEQ", dataMaster.get("INSPEC_SEQ"));
					param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					super.commonDao.insert("s_qms500ukrv_mekServiceImpl.insertQms210", param);
					
				}else{
					//수정건에 대한 처리
    				super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateQms210", param);
					sInspecNum = (String) param.get("INSPEC_NUM");
					
					//불량리스트는 불량건수에 대해서만 기록을 유지하는데
					//불량검사량을 0 으로 수정할 경우가 존재 하므로
					//이럴 경우를 대비해서 0으로 UPDATE 진행 후 삭제
					super.commonDao.delete("s_qms500ukrv_mekServiceImpl.deleteQms210", param);
				}
				//불량수량저장시 MPO200T의BAD_RETURN_Q수량을 증감하여 업데이트토록수정
				List<Map<String, Object>> resultList = commonDao.list("s_qms500ukrv_mekServiceImpl.selectQMS200", param);
				
				if(resultList == null || resultList.size() == 0){
					throw new UniDirectValidateException(this.getMessage("55306", user));
				}else{
					for(Map<String, Object> result: resultList){
						// 발주내역 불량검사량 업데이트
						param.put("ORDER_NUM", result.get("ORDER_NUM"));
						param.put("ORDER_SEQ", result.get("ORDER_SEQ"));
						super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateMpo200", param);
					}
				}
			}
			//불량내역 등록과 동시에 검사내역에 합격수량과(양품검사량-불량) 불량수량에 반영
			super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateQms200", dataMaster);
			//샘플검사에 해당
			//검사내역의 양품검사량,불량검사량 업데이트
			//검사내역의 접수량을 접수내역의 검사량에 업데이트
			if(StringUtils.isNotBlank(sInspecNum)){
				dataMaster.put("S_INSPEC_NUM", sInspecNum);
				super.commonDao.update("s_qms500ukrv_mekServiceImpl.updateQms200AndQms100", dataMaster);
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertBad(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateBad(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteBad(List<Map> params, LoginVO user) throws Exception {
		return;
	}
	
	/**
	 * 검사량이 있는지 점검
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  inspecQtyCheck(Map param) throws Exception {
		return  super.commonDao.list("s_qms500ukrv_mekServiceImpl.inspecQtyCheck", param);
	}
	
	/**
	 * 시험성적서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_qms500ukrv_mekServiceImpl.mainReport", param);
	}
	
	/**
	 * 시험성적서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("s_qms500ukrv_mekServiceImpl.subReport", param);
	}
}
