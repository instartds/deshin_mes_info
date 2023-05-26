package foren.unilite.modules.sales.ssa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("ssa720skrvService")
public class Ssa720skrvServiceImpl  extends TlabAbstractServiceImpl {


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		
		return  super.commonDao.list("ssa720skrvServiceImpl.selectMaster", param);
	}
}
