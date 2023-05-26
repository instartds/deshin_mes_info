package foren.unilite.modules.cost.cdm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cdm400ukrvService")
public class Cdm400ukrvServiceImpl extends TlabAbstractServiceImpl {
    //에러메세지 처리
    String errorDesc = "";
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("cdm400ukrvServiceImpl.processCosting", param);

		errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

        if(!ObjUtils.isEmpty(errorDesc))	{
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectRefConfig(Map param) throws Exception {
		return super.commonDao.select("cdm400ukrvServiceImpl.selectRefConfig", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaxSeq(Map param) throws Exception {
		return super.commonDao.select("cdm400ukrvServiceImpl.selectMaxSeq", param);
	}
	
}
