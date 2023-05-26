package foren.unilite.modules.accnt.agc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@SuppressWarnings("rawtypes")
@Service("agc330ukrService")
public class Agc330ukrServiceImpl extends TlabAbstractServiceImpl {
//	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //에러메세지 처리할 변수 선언
        String errorDesc = "";
        
		spParam.put("S_COMP_CODE"	, user.getCompCode());
		spParam.put("S_FR_DATE"		, param.get("DVRY_DATE_FR"));
		spParam.put("S_TO_DATE"		, param.get("DVRY_DATE_TO"));
		spParam.put("S_WORK_SLIP"	, param.get("rdoSelect"));
		spParam.put("S_LANG_TYPE"	, param.get("LANG_TYPE"));
		spParam.put("S_LOGIN_ID"	, user.getUserID());
		spParam.put("S_RET_FR_DATE"	, "");
		spParam.put("S_RET_TO_DATE"	, "");
		spParam.put("ERROR_DESC"	, "");

		super.commonDao.queryForObject("agc330ukrServiceImpl.fnClose", spParam);

        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
		return spParam;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 취소
	public Object cancButton(Map param, LoginVO user) throws Exception {
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //에러메세지 처리할 변수 선언
        String errorDesc = "";
        
		spParam.put("S_COMP_CODE"	, user.getCompCode());
		spParam.put("S_FR_DATE"		, param.get("DVRY_DATE_FR"));
		spParam.put("S_TO_DATE"		, param.get("DVRY_DATE_TO"));
		spParam.put("S_WORK_SLIP"	, param.get("rdoSelect"));
		spParam.put("S_LANG_TYPE"	, param.get("LANG_TYPE"));
		spParam.put("S_LOGIN_ID"	, user.getUserID());
		spParam.put("S_RET_FR_DATE"	, "");
		spParam.put("S_RET_TO_DATE"	, "");
		spParam.put("ERROR_DESC"	, "");

		super.commonDao.queryForObject("agc330ukrServiceImpl.fnCancel", spParam);

        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
		return spParam;
	}
}
