package foren.unilite.modules.cost.cam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.cost.cbm.Cbm700ukrvServiceImpl;

@Service("cam100ukrvService")
public class Cam100ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource( name = "cbm700ukrvService" )
    protected Cbm700ukrvServiceImpl cbm700ukrvService;
	
	@ExtDirectMethod(group = "cost")		// 실행
	public Object executeProcessCost(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("cam100ukrvServiceImpl.processCosting", param);

		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

        if(!ObjUtils.isEmpty(errorDesc))	{
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}	
	
	@ExtDirectMethod(group = "cost")		// 실행
	public Object executeCloseCost(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("cam100ukrvServiceImpl.closeCosting", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

        if(!ObjUtils.isEmpty(errorDesc))	{
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String,Object>> selectIDGb(Map param) throws Exception {
		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		String[] COST_POOL_LIST = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			COST_POOL_LIST[i] = ObjUtils.getSafeString(costPool.get("COST_POOL_CODE"));
			i++;
		}
		param.put("COST_POOL_LIST", COST_POOL_LIST);
		return super.commonDao.list("cam100ukrvServiceImpl.selectIDGb", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String,Object>> selectCostGb(Map param) throws Exception {
		return super.commonDao.list("cam100ukrvServiceImpl.selectCostGb", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String,Object>> selectProdItem(Map param) throws Exception {
		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		String[] COST_POOL_LIST = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			COST_POOL_LIST[i] = ObjUtils.getSafeString(costPool.get("COST_POOL_CODE"));
			i++;
		}
		param.put("COST_POOL_LIST", COST_POOL_LIST);
		return super.commonDao.list("cam100ukrvServiceImpl.selectProdItem", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public Object selectLastWorkInfo(Map param) throws Exception {
		return super.commonDao.select("cam100ukrvServiceImpl.selectLastWorkInfo", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public Object selectLastCloseInfo(Map param) throws Exception {
		return super.commonDao.select("cam100ukrvServiceImpl.selectLastCloseInfo", param);
	}
	
	@ExtDirectMethod(group = "cost")
	public List<Map<String,Object>> selectStatusList(Map param) throws Exception {
		
		return super.commonDao.list("cam100ukrvServiceImpl.selectStatusList", param);
	}
	
	/*
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaxSeq(Map param) throws Exception {
		return super.commonDao.select("cam100ukrvServiceImpl.selectMaxSeq", param);
	}*/
	
}
