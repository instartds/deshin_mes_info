package foren.unilite.modules.z_mek;

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

@Service("s_qbs400ukrv_mekService")
public class S_qbs400ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수리요청 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_qbs400ukrv_mekServiceImpl.selectList1", param);
	}

	/**
	 * 수리정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
				else if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.update(updateList, user);
			if(deleteList != null) this.delete(deleteList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer update(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.update", param);
			
			if("9".equals(param.get("STATUS").toString())) {
				param.put("INSPECT_STATUS", "RC");
				super.commonDao.update("s_qbs400ukrv_mekServiceImpl.updateInspect", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer delete(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.deleteRepPartAll", param);
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.deleteBadAll", param);
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.delete", param);
			
			param.put("INSPECT_STATUS", "QY");
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.updateInspect", param);
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
		if((Integer)super.commonDao.select("s_qbs400ukrv_mekServiceImpl.checkBad", param) < 1) {
			return super.commonDao.list("s_qbs400ukrv_mekServiceImpl.selectListBadInspect", param);
		}
		else {
			return super.commonDao.list("s_qbs400ukrv_mekServiceImpl.selectListBadRepair", param);
		}
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
					
					for(Map param : dataList)	{
						if("N".equals(param.get("OPR_FLAG"))) {
							super.commonDao.update("s_qbs400ukrv_mekServiceImpl.insertBad", param);
						}
						else {
							super.commonDao.update("s_qbs400ukrv_mekServiceImpl.updateBad", param);
						}
						super.commonDao.update("s_qbs400ukrv_mekServiceImpl.deleteBad", param);
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
	 * 주요변경파트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListRepPart(Map param) throws Exception {
		return super.commonDao.list("s_qbs400ukrv_mekServiceImpl.selectListRepPart", param);
	}

	/**
	 * 주요변경파트 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllRepPart(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateRepPart")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
				else if(dataListMap.get("method").equals("insertRepPart")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateRepPart(updateList, user);
			if(insertList != null) this.insertRepPart(insertList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer insertRepPart(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			param.put("USE_YN"	, this.getCheckboxValueYN(param.get("USE_YN")));
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.insertRepPart", param);
			param.put("USE_YN"	, this.getCheckboxValueTF(param.get("USE_YN")));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer updateRepPart(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			param.put("USE_YN"	, this.getCheckboxValueYN(param.get("USE_YN")));
			super.commonDao.update("s_qbs400ukrv_mekServiceImpl.updateRepPart", param);
			param.put("USE_YN"	, this.getCheckboxValueTF(param.get("USE_YN")));
		}
		return 0;
	}

	/**
	 * 체크박스  
	 * @param obj
	 * @return Y or N 
	 */
	private String getCheckboxValueYN(Object obj)	{
		String rValue = "N";
		if(obj != null && "true".equals(ObjUtils.getSafeString(obj).toLowerCase())) {
			rValue = "Y";
		}
		return rValue;
	}
	
	private boolean getCheckboxValueTF(Object obj)	{
		boolean rValue = false;
		if(obj != null && "Y".equals(ObjUtils.getSafeString(obj).toUpperCase())) {
			rValue = true;
		}
		return rValue;
	}
}
