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

@Service("cdm420skrvService")
public class Cdm420skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> costCenters = this.selectCostCenterList(param);

		// Cost Center 합계
		String costCenterSql = "";
		
		for (Map<String, Object> ccMap:costCenters)	{
			costCenterSql += ", SUM(CASE WHEN A.COST_CENTER_CODE = '" + ccMap.get("COST_CENTER_CODE") + "' THEN A.AMT ELSE 0 END) AS COST_CENTER_" + ccMap.get("COST_CENTER_CODE") ;
		}
		param.put("costCenters", costCenterSql);

		return super.commonDao.list("cdm420skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public List<Map<String, Object>> selectCostCenterList(Map param) throws Exception {
		return super.commonDao.list("cdm420skrvServiceImpl.selectCostCenterList", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaxSeq(Map param) throws Exception {
		return  super.commonDao.select("cdm420skrvServiceImpl.selectMaxSeq", param);
	}
	
}
