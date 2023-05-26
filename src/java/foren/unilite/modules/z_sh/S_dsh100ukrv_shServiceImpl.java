package foren.unilite.modules.z_sh;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 
@SuppressWarnings("unchecked")
@Service("s_dsh100ukrv_shService")
public class S_dsh100ukrv_shServiceImpl extends TlabAbstractServiceImpl {
	
	
	/**
	 * 설비코드 선택 리스트 (대시보드 메뉴)
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getEquipCodeDashMenu(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getEquipCodeDashMenu",params);
	}
	
	/**
	 * 각 호기당 ACT_SHOT_CNT
	 *	,ACT_CYCLE_TIME
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getEquipInfo(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getEquipInfo",params);
	}
	
	/**
	 * 온습도정보
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getTemperature(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getTemperature",params);
	}
	
	/**
	 * 대시보드 운영상태 차트 
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getOperatingStatus(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getOperatingStatus",params);
	}
	
	/**
	 * 대시보드 그리드 표현 
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getOpsearch(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getOpsearch",params);
	}
	
	
	
	/**
	 * 작업자 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getInspecPrsn(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getInspecPrsn",params);
	}
	
	/**
	 * 설비코드리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getEquipCode(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getEquipCode",params);
	}
	
	/**
	 * 작지데이터 리스트 세팅
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getWkordNum2(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getWkordNum2",params);
	}
	
	/**
	 * 불량유형 리스트 세팅 
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getBadInspecCode(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getBadInspecCode",params);
	}
	
	/**
	 * 해당작업지시에 대한 불량코드별 불량수량 합 세팅
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getBadInspecQList(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getBadInspecQList",params);
	}
	
	/**
	 * 각 작지데이터 시작 정보 check
	 * @param params
	 * @return
	 */
	public Map<String, Object> getStartInfo(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("s_dsh100ukrv_shService.getStartInfo",params);
	}
	
	/**
	 * 각 작지데이터 시작 정보 insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, Object> startSave(Map<String, Object> param) throws Exception {

		
		super.commonDao.insert("s_dsh100ukrv_shService.insertStart", param);
		
		return param;
	}
	
	/**
	 * 불량코드별 불량수량 정보 insert
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, Object> badInspecQSave(Map<String, Object> param) throws Exception {

		super.commonDao.insert("s_dsh100ukrv_shService.insertBadInspecQ", param);
		
		return param;
	}
	

	/**
	 * 각 작지데이터의 원료 투입량 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String, Object> itemMtrlSave(Map<String, Object> param) throws Exception {

		super.commonDao.update("s_dsh100ukrv_shService.updateItemMtrl", param);
		
		return param;
	}
	
	/**
	 * 설비 setup 정보
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getSetup(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getSetup",params);
	}
	
	/**
	 * 비밀번호 확인
	 * @param params
	 * @return
	 */
	public Map<String, Object> getEquipPassword(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("s_dsh100ukrv_shService.getEquipPassword",params);
	}
	
	/**
	 * 해당 사출기 제조사확인
	 * @param params
	 * @return
	 */
	public Map<String, Object> getEquipManufacturer(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("s_dsh100ukrv_shService.getEquipManufacturer",params);
	}
	
	
	
	
	
	/**
	 * 작업지시번호 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getWkordNum(Map<String,Object> params){
		return super.commonDao.list("s_dsh100ukrv_shService.getWkordNum",params);
	}
	
	/**
	 * 작업지시정보
	 * @param params
	 * @return
	 */
	public Map<String, Object> getWkordNumInfo(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("s_dsh100ukrv_shService.getWkordNumInfo",params);
	}
	
}
