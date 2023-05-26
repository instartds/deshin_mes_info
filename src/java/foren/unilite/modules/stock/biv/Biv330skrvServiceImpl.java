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

@Service("biv330skrvService")
public class Biv330skrvServiceImpl  extends TlabAbstractServiceImpl {

	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv330skrvServiceImpl.userWhcode", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		
		return  super.commonDao.list("biv330skrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		
		return  super.commonDao.list("biv330skrvServiceImpl.selectMasterList2", param);
	}
	
}
