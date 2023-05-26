package foren.unilite.modules.accnt.afb;

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

@Service("afb550ukrService")
public class Afb550ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,group = "accnt")		// 실행
	public Object accntCorrectBudgetbl(Map param, LoginVO user) throws Exception {			// SP 로 실행
		//super.commonDao.update("afb550ukrServiceImpl.accntCorrectBudgetbl", param);
		
		super.commonDao.queryForObject("afb550ukrServiceImpl.accntCorrectBudgetbl", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}		
	}
}
