package foren.unilite.modules.z_mit;

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

@Service("s_biv300skrv_mitService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Biv300skrv_mitServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("s_biv300skrv_mitServiceImpl.userWhcode", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		return  super.commonDao.list("s_biv300skrv_mitServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		return  super.commonDao.list("s_biv300skrv_mitServiceImpl.selectMasterList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster3(Map param) throws Exception {
		return  super.commonDao.list("s_biv300skrv_mitServiceImpl.selectMasterList3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster4(Map param) throws Exception {
		return  super.commonDao.list("s_biv300skrv_mitServiceImpl.selectMasterList4", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster5(Map param) throws Exception {
		return  super.commonDao.list("s_biv300skrv_mitServiceImpl.selectMasterList5", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getgsWHGroupYN(Map param) throws Exception {
		return super.commonDao.list("s_biv300skrv_mitServiceImpl.getgsWHGroupYN", param);
	}
}
