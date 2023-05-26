package foren.unilite.modules.z_mek;

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
import foren.unilite.com.tags.ComboItemModel;

@Service("s_qbs200ukrv_mekService")
public class S_qbs200ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 작업장리스트
	 * @param param
	 * @param compCode
	 * @param mainCode
	 * @param includeNotInUsed
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getWsList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("s_qbs200ukrv_mekServiceImpl.getWsList", param);

	}
	
	/**
	 * 생산/검사실적 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_qbs200ukrv_mekServiceImpl.selectList1", param);
	}

	/**
	 * 계측기정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListMach(Map param) throws Exception {
		return super.commonDao.list("s_qbs200ukrv_mekServiceImpl.selectListMach", param);
	}
	
	/**
	 * 계측기정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllMach(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMach")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertMach")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteMach(deleteList, user);
			if(insertList != null) this.insertMach(insertList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// INSERT
	public Integer insertMach(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs200ukrv_mekServiceImpl.insertMach", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer updateMach(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateMach", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer deleteMach(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs200ukrv_mekServiceImpl.deleteMach", param);
		}
		return 0;
	}

	/**
	 * 불량정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListBad(Map param) throws Exception {
		return super.commonDao.list("s_qbs200ukrv_mekServiceImpl.selectListBad", param);
	}
	
	/**
	 * 불량정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllBad(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> dataList = null;
			Map<String, Object> masterParam = (Map<String, Object>) paramMaster.get("data");
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateBad")) {
					dataList = (List<Map>)dataListMap.get("data");
					
					for(Map param : dataList )	{
						if(param.get("INSPECT_NO") == null || StringUtils.isBlank((String) param.get("INSPECT_NO"))) {
							param.put("DIV_CODE", masterParam.get("DIV_CODE"));
							param.put("INSPECT_NO", masterParam.get("INSPECT_NO"));
							param.put("INSPECT_DATE", masterParam.get("WORK_DATE"));
							
							super.commonDao.update("s_qbs200ukrv_mekServiceImpl.insertBad", param);
						}
						else {
							super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateBad", param);
						}
						super.commonDao.update("s_qbs200ukrv_mekServiceImpl.deleteBad", param);
					}
				}
			}
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer updateBad(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList )	{
//			super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateBad", param);
//		}
		return 0;
	}
	
	/**
	 * 계측결과 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListResult(Map param) throws Exception {
		return super.commonDao.list("s_qbs200ukrv_mekServiceImpl.selectListResult", param);
	}
	
	/**
	 * 계측결과 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllResult(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> dataList = null;
			Map<String, Object> masterParam = (Map<String, Object>) paramMaster.get("data");
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateResultDetail")) {
					dataList = (List<Map>)dataListMap.get("data");
					
					for(Map param : dataList )	{
						if(param.get("INSPECT_NO") == null || StringUtils.isBlank((String) param.get("INSPECT_NO"))) {
							param.put("DIV_CODE"	, masterParam.get("DIV_CODE"));
							param.put("INSPECT_NO"	, masterParam.get("INSPECT_NO"));
							param.put("MODEL"		, masterParam.get("MODEL"));
							param.put("REV_NO"		, masterParam.get("REV_NO"));
							
							super.commonDao.update("s_qbs200ukrv_mekServiceImpl.insertResultDetail", param);
						}
						else {
							super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateResultDetail", param);
						}
					}
					
					if((int)super.commonDao.select("s_qbs200ukrv_mekServiceImpl.checkResultMaster", masterParam) < 1) {
						super.commonDao.update("s_qbs200ukrv_mekServiceImpl.insertResultMaster", masterParam);
					}
				}
			}
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer updateResultDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList )	{
//			super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateResult", param);
//		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer deleteResult(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_qbs200ukrv_mekServiceImpl.deleteResultDetail", param);
		super.commonDao.update("s_qbs200ukrv_mekServiceImpl.deleteResultMaster", param);
		
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Map<String, Object> checkRepair(Map param, LoginVO user) throws Exception {
		if((int)super.commonDao.select("s_qbs200ukrv_mekServiceImpl.checkResultMaster", param) < 1) {
			param.put("CHECK_RESULT", "검사결과가 등록되지 않았습니다.");
		}
		else {
			if((int)super.commonDao.select("s_qbs200ukrv_mekServiceImpl.checkRepair", param) > 0) {
				param.put("CHECK_RESULT", "이미 수리요청이 등록되었습니다.");
			}
			else {
				Map<String, Object> spParam = new HashMap<String, Object>();
				
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", param.get("DIV_CODE"));
				spParam.put("TABLE_ID", "S_QBS300T_MEK");
				spParam.put("PREFIX", "R");
				spParam.put("BASIS_DATE", param.get("REQ_DATE"));
				spParam.put("AUTO_TYPE", "1");
				
				super.commonDao.queryForObject("s_qbs200ukrv_mekServiceImpl.spSP_GetAutoNumComp", spParam);
				
				String repairNum = ObjUtils.getSafeString(spParam.get("REPAIR_NUM"));
				
				param.put("REPAIR_NUM", repairNum);
				param.put("CHECK_RESULT", "Y");
				
				try {
					super.commonDao.update("s_qbs200ukrv_mekServiceImpl.insertRepair", param);
					super.commonDao.update("s_qbs200ukrv_mekServiceImpl.updateResultStatus", param);
				}
				catch (Exception e) {
					param.put("CHECK_RESULT", e.getMessage());
				}
				
			}
		}
		
		return param;
	}

}
