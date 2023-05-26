package foren.unilite.modules.z_mit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

@Service("s_sas500ukrv_mitService")
public class S_sas500ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;
	
	/**
	 * 대리점 거래처 코드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public Object selectCustomCode(Map param) throws Exception {
		return super.commonDao.select("s_sas500ukrv_mitServiceImpl.selectCustomCode", param);
	}
	/**
	 * 입고대기 조회
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		String scmFlagYn = ObjUtils.getSafeString(param.get("SCM_FLAG_YN"));
		List<Map<String, Object>> rList = null;
		
		if("N".equals(scmFlagYn))	{
			//입고대기
			
			String customCode = (String)super.commonDao.select("s_sas500ukrv_mitServiceImpl.selectCustomCode", param);
			param.put("CUSTOM_CODE", customCode);
			
			StringBuilder errorMessage = new StringBuilder("");
			
			rList  = externalDAO.list("s_sas500ukrv_mitServiceImpl.selectListIn", param, errorMessage);
	    	if(ObjUtils.isNotEmpty(errorMessage))	{
	    		throw new	UniDirectValidateException(errorMessage.toString());
	    	}
		} else {
			//입고완료
			rList = super.commonDao.list("s_sas500ukrv_mitServiceImpl.selectList", param);
		}
		return rList;
	}

	
	
	/**
	 * 입고 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
			
		List<Map> updateList = null;
		List<Map> deleteList = null;
		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
		
		
		for(Map dataListMap: paramList) {
			if(dataListMap.get("method").equals("delete")) {
				deleteList = (List<Map>)dataListMap.get("data");
			}else if(dataListMap.get("method").equals("update")) {
				updateList = (List<Map>)dataListMap.get("data");	
			}
		}
		
		if(deleteList != null)	this.delete(deleteList, user, paramMasterData, keyValue);
		if(updateList != null)	this.update(updateList, user, paramMasterData, keyValue);
			

		// Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		spParam.put("KeyValue", keyValue);

	    super.commonDao.queryForObject("s_sas500ukrv_mitServiceImpl.spStock_s_sas500ukrv_mit", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(ErrorDesc)){
			String[] messsage = ErrorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} 
		
		
		StringBuilder errorMessage = new StringBuilder("");
		if(updateList != null)	{
			for(Map param: updateList)		{
				param.put("SCM_FLAG_YN", "Y");
				int r  = externalDAO.update("s_sas500ukrv_mitServiceImpl.updateScmFlag", param, errorMessage);
		    	if(ObjUtils.isNotEmpty(errorMessage))	{
		    		throw new	UniDirectValidateException(errorMessage.toString());
		    	}
			}
		}
		if(deleteList != null)	{
			for(Map param: deleteList)		{
				param.put("SCM_FLAG_YN", "N");
				int r  = externalDAO.update("s_sas500ukrv_mitServiceImpl.updateScmFlag", param, errorMessage);
		    	if(ObjUtils.isNotEmpty(errorMessage))	{
		    		throw new	UniDirectValidateException(errorMessage.toString());
		    	}
			}
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 입고(대기)저장
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_MODIFY)
	public void update(List<Map> params, LoginVO user, Map<String, Object> paramMasterData, String keyValue) throws Exception {
		int i = 1;
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("DIV_CODE", paramMasterData.get("DIV_CODE"));
			param.put("WH_CODE", paramMasterData.get("WH_CODE"));
			param.put("WH_CELL_CODE", paramMasterData.get("WH_CELL_CODE"));
			param.put("INOUT_DATE", paramMasterData.get("INOUT_DATE"));
			param.put("INOUT_SEQ", i++);
			param.put("OPR_FLAG", "N");
			super.commonDao.insert("s_sas500ukrv_mitServiceImpl.insertLog", param);
		}
	}

	/**
	 * 입고취소
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_MODIFY)
	public void delete(List<Map> params, LoginVO user, Map<String, Object> paramMasterData, String keyValue) throws Exception {
		for(Map<String, Object> param : params)	{
			param.put("KEY_VALUE", keyValue);
			param.put("DIV_CODE", paramMasterData.get("DIV_CODE"));
			param.put("WH_CODE", paramMasterData.get("WH_CODE"));
			param.put("WH_CELL_CODE", paramMasterData.get("WH_CELL_CODE"));
			param.put("INOUT_DATE", paramMasterData.get("INOUT_DATE"));
			param.put("OPR_FLAG", "D");
			super.commonDao.update("s_sas500ukrv_mitServiceImpl.insertLog", param);
		}
	}

}
