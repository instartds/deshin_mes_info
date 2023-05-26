package foren.unilite.modules.accnt.agd;

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

@Service("agd100ukrService")
public class Agd100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
 		super.commonDao.queryForObject("agd100ukrServiceImpl.USP_ACCNT_AutoSlip20", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
//		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }
		return true;
	}	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 취소
	public Object cancButton(Map param, LoginVO user) throws Exception {
        super.commonDao.queryForObject("agd100ukrServiceImpl.USP_ACCNT_AutoSlip20Cancel", param);
        String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
//      Map<String, Object> rMap = (Map<String, Object>) r;
        if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        return true;
    }
}
