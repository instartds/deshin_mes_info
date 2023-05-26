package foren.unilite.modules.z_mek;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_qbs100ukrv_mekService")
public class S_qbs100ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 그리드 헤더 컬럼 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> selectColumnList(Map param) throws Exception {
		return (Map<String, Object>)super.commonDao.select("s_qbs100ukrv_mekServiceImpl.selectColumnList", param);
	}

	/**
	 * 시험성적서 양식 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.selectList1", param);
	}

	/**
	 * 시험성적서 결과 등록여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkResult(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.checkResult", param);
	}

	/**
	 * 시험성적서 결과 등록여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkResultAll(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.checkResultAll", param);
	}
	
	/**
	 * 시험성적서 양식 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete(deleteList, user);
			if(insertList != null) this.insert(insertList, user);
			if(updateList != null) this.update(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// INSERT
	public Integer insert(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			Map<String, Object> itemNoMap = (Map<String, Object>)super.commonDao.select("s_qbs100ukrv_mekServiceImpl.selectMaxItemNo", param);
			
			param.put("ITEM_NO", itemNoMap.get("NEW_ITEM_NO"));
			
			super.commonDao.update("s_qbs100ukrv_mekServiceImpl.insert", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// UPDATE
	public Integer update(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs100ukrv_mekServiceImpl.update", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer delete(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs100ukrv_mekServiceImpl.delete", param);
		}
		return 0;
	}

	/**
	 * 시험성적서 리비전 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRevHistory(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.selectRevHistory", param);
	}

	/**
	 * 시험성적서 양식 등록여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkForm(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.checkForm", param);
	}
	
	/**
	 * 시험성적서 리비전 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mek")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllRev(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteRev")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertRev")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteRev(deleteList, user);
			if(insertList != null) this.insertRev(insertList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// INSERT
	public Integer insertRev(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs100ukrv_mekServiceImpl.insertRev", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mek")		// DELETE
	public Integer deleteRev(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList )	{
			super.commonDao.update("s_qbs100ukrv_mekServiceImpl.deleteRev", param);
		}
		return 0;
	}

	/**
	 * 시험성적서 양식 등록여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public Integer copyForm(Map param) throws Exception {
		Map<String, Object> chkParam = new HashMap<String, Object>();

		chkParam.put("S_COMP_CODE"	, param.get("COMP_CODE"));
		chkParam.put("MODEL"		, param.get("MODEL_CODE_TO"));
		chkParam.put("REV_NO"		, param.get("REV_NO_TO"));
		
		List<Map<String, Object>> chkMap = checkForm(chkParam);
		if(Integer.parseInt(chkMap.get(0).get("CNT_RESULT").toString()) > 0) {
			throw new Exception("대상 모델/리비전으로 이미 등록된 양식이 있습니다.");
		}
		super.commonDao.update("s_qbs100ukrv_mekServiceImpl.copyForm", param);
		
		return 0;
	}

	/**
	 * 시험성적서 양식 내용 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mek", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRemarkList(Map param) throws Exception {
		return super.commonDao.list("s_qbs100ukrv_mekServiceImpl.selectRemarkList", param);
	}
	
}
