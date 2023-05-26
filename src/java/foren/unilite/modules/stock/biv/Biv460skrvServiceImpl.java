package foren.unilite.modules.stock.biv;

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

@Service("biv460skrvService")
public class Biv460skrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv460skrvServiceImpl.userWhcode", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("biv460skrvServiceImpl.selectList", param);
	}
	
}
