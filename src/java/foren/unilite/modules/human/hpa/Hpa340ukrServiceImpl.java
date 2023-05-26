package foren.unilite.modules.human.hpa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa340ukrService")
@SuppressWarnings("unchecked")
public class Hpa340ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/* 급여계산 SP 호출  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int spCalcPay(Map param, LoginVO user) throws Exception {
        param.put("LANG_TYPE", user.getLanguage());
        
        Map errorMap = (Map) super.commonDao.queryForObject("hpa340ukrServiceImpl.spCalcPay", param);
        String errorDesc = ObjUtils.getSafeString(errorMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));

		} else {
			return 0;
		}
	}
	
	/* 급여계산취소 SP 호출  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int spCalcCancel(Map param, LoginVO user) throws Exception {
        param.put("LANG_TYPE", user.getLanguage());
        
        Map errorMap = (Map) super.commonDao.queryForObject("hpa340ukrServiceImpl.spCalcCancel", param);
        String errorDesc = ObjUtils.getSafeString(errorMap.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));

		} else {
			return 0;
		}
	}
	
	
}
