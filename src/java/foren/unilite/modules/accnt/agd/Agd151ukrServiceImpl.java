package foren.unilite.modules.accnt.agd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@SuppressWarnings({"rawtypes", "unchecked"})
@Service("agd151ukrService")
public class Agd151ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")			// 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("agd151ukrServiceImpl.selectList", param);
	}

	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("runProcedure")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.runProcedure(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		//작업 구분 (N:자동기표, D:기표취소)
		String oprFlag	= (String)dataMaster.get("OPR_FLAG");
		//language type
		String langType	= (String)dataMaster.get("LANG_TYPE");
		String sysDate	= (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		String procDate	= (String) dataMaster.get("PROC_DATE");
		//에러메세지 처리
		String errorDesc= "";
		
		//1.로그테이블에서 사용할 Key 생성	  
		//String keyValue = getLogKey(); 
		
		//2.로그테이블에 KEY_VALUE 업데이트
		for(Map param: paramList)	  {

			//1.로그테이블에서 사용할 Key 생성	  
			String keyValue = getLogKey(); 
			
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			//param.put("PROC_DATE", procDate);
			param.put("PROC_DATE", param.get("EX_DATE"));

			super.commonDao.insert("agd151ukrServiceImpl.insertLogTable", param);

			//SP에서 작성한 변수에 맞추기
			//SP 호출시 넘길 MAP 정의
			Map<String, Object> spParam = new HashMap<String, Object>();
			if("D".equals(oprFlag))	{
				spParam.put("S_COMP_CODE"	, user.getCompCode());
				spParam.put("KEY_VALUE"		, keyValue);
				//spParam.put("PROC_DATE"		, dataMaster.get("PROC_DATE"));
				spParam.put("PROC_DATE"		, param.get("EX_DATE"));
				spParam.put("INPUT_DATE"	, sysDate);
				spParam.put("S_USER_ID"		, user.getUserID());
				spParam.put("S_LANG_CODE"	, user.getLanguage());
				spParam.put("CALL_PATH"		, "LIST");
				super.commonDao.queryForObject("agd151ukrServiceImpl.cancelSlip", spParam);
			} else {
				spParam.put("S_COMP_CODE"	, user.getCompCode());
				spParam.put("KEY_VALUE"		, keyValue);
				//spParam.put("PROC_DATE"		, dataMaster.get("PROC_DATE"));
				spParam.put("PROC_DATE"		, param.get("EX_DATE"));
				spParam.put("INPUT_DATE"	, sysDate);
				spParam.put("S_USER_ID"		, user.getUserID());
				spParam.put("S_LANG_CODE"	, user.getLanguage());
				spParam.put("CALL_PATH"		, "LIST");
				super.commonDao.queryForObject("agd151ukrServiceImpl.runAutoSlip", spParam);
			}
			errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
			if (!ObjUtils.isEmpty(errorDesc)) {
				throw new UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
	
//		//SP에서 작성한 변수에 맞추기
//		//SP 호출시 넘길 MAP 정의
//		Map<String, Object> spParam = new HashMap<String, Object>();
//		if("D".equals(oprFlag))	{
//			spParam.put("S_COMP_CODE"	, user.getCompCode());
//			spParam.put("KEY_VALUE"		, keyValue);
//			spParam.put("PROC_DATE"		, dataMaster.get("PROC_DATE"));
//			spParam.put("INPUT_DATE"	, sysDate);
//			spParam.put("S_USER_ID"		, user.getUserID());
//			spParam.put("S_LANG_CODE"	, user.getLanguage());
//			spParam.put("CALL_PATH"		, "LIST");
//			super.commonDao.queryForObject("agd151ukrServiceImpl.cancelSlip", spParam);
//		} else {
//			spParam.put("S_COMP_CODE"	, user.getCompCode());
//			spParam.put("KEY_VALUE"		, keyValue);
//			spParam.put("PROC_DATE"		, dataMaster.get("PROC_DATE"));
//			spParam.put("INPUT_DATE"	, sysDate);
//			spParam.put("S_USER_ID"		, user.getUserID());
//			spParam.put("S_LANG_CODE"	, user.getLanguage());
//			spParam.put("CALL_PATH"		, "LIST");
//			super.commonDao.queryForObject("agd151ukrServiceImpl.runAutoSlip", spParam);
//		}
//		errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
//		if (!ObjUtils.isEmpty(errorDesc)) {
//			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
//		}
		return;
	}
}