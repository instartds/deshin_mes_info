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

@Service("cdm437skrvService")
public class Cdm437skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> costCenters = this.selectCostCenterList(param);
		List<Map<String, Object>> costPools = this.selectCostPoolList(param);

		// Cost Center 합계
		String costCenterSql = "";
		
		for (Map<String, Object> ccMap:costCenters)	{
			costCenterSql += ", SUM(CASE WHEN A.COST_CENTER_CODE = '" + ccMap.get("COST_CENTER_CODE") + "' THEN A.AMT ELSE 0 END) AS COST_CENTER_" + ccMap.get("COST_CENTER_CODE") ;
		}
		param.put("costCenters", costCenterSql);

		// Cost Pool 합계
		String costPoolSql = "";
		
		for (Map<String, Object> ccMap:costPools)	{
			costPoolSql += ", SUM(CASE WHEN A.COST_POOL_CODE = '" + ccMap.get("COST_POOL_CODE") + "' THEN A.AMT ELSE 0 END) AS COST_POOL_" + ccMap.get("COST_POOL_CODE") ;
		}
		param.put("costPools", costPoolSql);

		// Cost Pool 직과배부합계
		String costPoolDirectSql = "";
		
		for (Map<String, Object> ccMap:costPools)	{
			costPoolDirectSql += ", SUM(CASE WHEN A.COST_POOL_CODE = '" + ccMap.get("COST_POOL_CODE") + "' THEN A.AMT_DIRECT ELSE 0 END) AS COST_DIRECT_" + ccMap.get("COST_POOL_CODE") ;
		}
		param.put("costPoolsDirect", costPoolDirectSql);

		// Cost Pool 공통배부합계
		String costPoolDistrSql = "";
		
		for (Map<String, Object> ccMap:costPools)	{
			costPoolDistrSql += ", SUM(CASE WHEN A.COST_POOL_CODE = '" + ccMap.get("COST_POOL_CODE") + "' THEN A.AMT_DISTR ELSE 0 END) AS COST_DISTR_" + ccMap.get("COST_POOL_CODE") ;
		}
		param.put("costPoolsDistr", costPoolDistrSql);

		return super.commonDao.list("cdm437skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public List<Map<String, Object>> selectCostCenterList(Map param) throws Exception {
		return super.commonDao.list("cdm437skrvServiceImpl.selectCostCenterList", param);
	}

	@ExtDirectMethod(group = "cost")
	public List<Map<String, Object>> selectCostPoolList(Map param) throws Exception {
		return super.commonDao.list("cdm437skrvServiceImpl.selectCostPoolList", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object  selectMaxSeq(Map param) throws Exception {
		return  super.commonDao.select("cdm437skrvServiceImpl.selectMaxSeq", param);
	}
	
}