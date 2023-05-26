package foren.unilite.modules.accnt.aigd;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("aigd330ukrvService")
public class Aigd330ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 감가상각계산 및 자동기표
	 * 'A146'의 REF_CODE1, REF_CODE2 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getRefCode(Map param) throws Exception {
		return super.commonDao.list("aigd330ukrvServiceImpl.getRefCode", param);
	}	


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Map procButton(Map param, LoginVO user) throws Exception {
		Map errorMap = null;
		String errorDesc = "";
		
		errorMap = (Map) super.commonDao.select("aigd330ukrvServiceImpl.spAutoSlip55", param);

		if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
		
			errorDesc = (String) errorMap.get("ERROR_DESC");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		
		return param;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Map cancButton(Map param, LoginVO user) throws Exception {
		Map errorMap = null;
		String errorDesc = "";
		errorMap = (Map) super.commonDao.select("aigd330ukrvServiceImpl.spAutoSlip55Cancel", param);

		if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
			errorDesc = (String) errorMap.get("ERROR_DESC");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		
		return param;
	}
}
