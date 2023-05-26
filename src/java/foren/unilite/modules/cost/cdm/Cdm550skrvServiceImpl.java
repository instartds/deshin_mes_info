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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cdm550skrvService")
public class Cdm550skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> costCenters = this.selectCostCenterList(param);

		return super.commonDao.list("cdm550skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public List<Map<String, Object>> selectCostCenterList(Map param) throws Exception {
		return super.commonDao.list("cdm550skrvServiceImpl.selectCostCenterList", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object  selectMaxSeq(Map param) throws Exception {
		return  super.commonDao.select("cdm550skrvServiceImpl.selectMaxSeq", param);
	}
	
}