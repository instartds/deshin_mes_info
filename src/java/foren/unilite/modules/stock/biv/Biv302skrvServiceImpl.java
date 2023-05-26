package foren.unilite.modules.stock.biv;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv302skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv302skrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv302skrvServiceImpl.userWhcode", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		return  super.commonDao.list("biv302skrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		return  super.commonDao.list("biv302skrvServiceImpl.selectMasterList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster3(Map param) throws Exception {
		return  super.commonDao.list("biv302skrvServiceImpl.selectMasterList3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster4(Map param) throws Exception {
		return  super.commonDao.list("biv302skrvServiceImpl.selectMasterList4", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectMaster5(Map param) throws Exception {
		return  super.commonDao.list("biv302skrvServiceImpl.selectMasterList5", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getgsWHGroupYN(Map param) throws Exception {
		return super.commonDao.list("biv302skrvServiceImpl.getgsWHGroupYN", param);
	}
}
