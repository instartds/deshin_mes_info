package foren.unilite.modules.base.bcm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("bcm190ukrvService")
public class Bcm190ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  existCheck(Map param) throws Exception {
		return  super.commonDao.list("bcm190ukrvServiceImpl.existCheck", param);
	}

	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  changeData(Map param, LoginVO user) throws Exception {		
		super.commonDao.update("bcm190ukrvServiceImpl.changeCustomCode", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)) {
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}
	
}
