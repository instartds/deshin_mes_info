package foren.unilite.modules.accnt.agc;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agc130rkrService")
public class Agc130rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {			// 재무상태표
		
		//param.put("DIVI", "10");
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}
		else {
//			List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130rkrServiceImpl.selectList", param);
//			String errorDesc ="";
//			if(ObjUtils.isNotEmpty(returnData)){
//				errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
//			}
//			if(ObjUtils.isNotEmpty(errorDesc)){
//				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
//			}else{
//				return returnData;
//			}
			return super.commonDao.list("agc130rkrServiceImpl.selectList", param);
		}
	}
}
