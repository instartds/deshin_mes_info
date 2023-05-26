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

@Service("agd260ukrService")
public class Agd260ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
		Object r = super.commonDao.queryForObject("agd260ukrServiceImpl.agd260ukrDo", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object cancButton(Map param, LoginVO user) throws Exception {
		Object r = super.commonDao.queryForObject("agd260ukrServiceImpl.agd260ukrCancel", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}
}
