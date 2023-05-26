package foren.unilite.modules.accnt.aisc;

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

@Service("aisc100ukrvService")
public class Aisc100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Map procButton(Map param, LoginVO user) throws Exception {
		Map errorMap = (Map) super.commonDao.select("aisc100ukrvServiceImpl.fnAisc101Proc", param);
    	
		if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
			String errorDesc = (String) errorMap.get("ERROR_DESC");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
			
		
		return param;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Map cancButton(Map param, LoginVO user) throws Exception {
		String errorDesc = "";
		//감가상각계산 취소
		Map errorMap = (Map) super.commonDao.select("aisc100ukrvServiceImpl.fnAisc101Canc", param);

		if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
			errorDesc = (String) errorMap.get("ERROR_DESC");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
			
		
		return param;
	}
}
