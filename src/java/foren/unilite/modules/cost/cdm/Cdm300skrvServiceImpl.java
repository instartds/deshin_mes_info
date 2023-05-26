package foren.unilite.modules.cost.cdm;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("cdm300skrvService")
public class Cdm300skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("cdm300skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public Object selectFlag(Map param) throws Exception {
		return super.commonDao.select("cdm300skrvServiceImpl.selectFlag", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public Object selectMaxSeq(Map param) throws Exception {
		return super.commonDao.select("cdm300skrvServiceImpl.selectMaxSeq", param);
	}
}