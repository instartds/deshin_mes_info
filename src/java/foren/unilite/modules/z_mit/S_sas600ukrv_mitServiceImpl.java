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
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_sas600ukrv_mitService")
public class S_sas600ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "externalDAO_MIT" )
    protected ExternalDAO_MIT externalDAO;
	
	/**
	 * 정산데이터 조회
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_sas600ukrv_mitServiceImpl.selectList", param);
	}

	/**
	 * 저장
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
			}
		}
		
		if(deleteList != null)	this.delete(deleteList, user, paramMasterData, keyValue);
			

		// Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		spParam.put("KeyValue", keyValue);

	    super.commonDao.queryForObject("s_sas600ukrv_mitServiceImpl.spStock_s_sas600ukrv_mit", spParam);

		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!ObjUtils.isEmpty(ErrorDesc)){
			String[] messsage = ErrorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} 
		
		
		StringBuilder errorMessage = new StringBuilder("");
		if(deleteList != null)	{
			
			for(Map param: deleteList)		{
				param.put("SCM_FLAG_YN", "N");
				int r  = externalDAO.update("s_sas600ukrv_mitServiceImpl.updateScmFlag", param, errorMessage);
		    	if(ObjUtils.isNotEmpty(errorMessage))	{
		    		throw new	UniDirectValidateException(errorMessage.toString());
		    	}
			}
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_MODIFY)
	public void delete(List<Map> params, LoginVO user, Map<String, Object> paramMasterData, String keyValue) throws Exception {
		for(Map<String, Object> param : params)	{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", "D");
			super.commonDao.update("s_sas600ukrv_mitServiceImpl.insertLog", param);
		}
	}

	/**
	 * 출고정산
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_MODIFY)
	public Map<String, Object> execExtInout(Map<String, Object> paramMasterData, LoginVO user) throws Exception {
		
		//대리점 서버 출고 데이터 조회
		StringBuilder errorMessage = new StringBuilder("");
		
		List<Map<String, Object>> params  = externalDAO.list("s_sas600ukrv_mitServiceImpl.selectListOut", paramMasterData, errorMessage);
    	if(ObjUtils.isNotEmpty(errorMessage))	{
    		throw new	UniDirectValidateException(errorMessage.toString());
    	}
    	if(params != null)	{
    		String keyValue = getLogKey();
    		//출고 데이터 로드테이블에 저장
    		int i = 1;
    		for(Map param: params)		{
    			param.put("KEY_VALUE", keyValue);
    			param.put("S_USER_ID", user.getUserID());
    			param.put("OPR_FLAG", "N");
    			param.put("INOUT_SEQ", i++);
    			super.commonDao.insert("s_sas600ukrv_mitServiceImpl.insertLog", param);
    		}
    		
    		//출고 sp 호출
    		Map<String, Object> spParam = new HashMap<String, Object>();
    		spParam.put("KeyValue", keyValue);

    	    super.commonDao.queryForObject("s_sas600ukrv_mitServiceImpl.spStock_s_sas600ukrv_mit", spParam);

    		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

    		if(!ObjUtils.isEmpty(ErrorDesc)){
    			String[] messsage = ErrorDesc.split(";");
    		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
    		} 
    		
    		// 대리점서버 출고 flage 저장
    		for(Map param: params)		{
    			param.put("SCM_FLAG_YN", "Y");
	    		externalDAO.update("s_sas600ukrv_mitServiceImpl.updateScmFlag", param, errorMessage);
	        	if(ObjUtils.isNotEmpty(errorMessage))	{
	        		throw new	UniDirectValidateException(errorMessage.toString());
	        	}
    		}
    	}
    	return paramMasterData;
	}

}
