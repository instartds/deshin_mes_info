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

@Service("cam350ukrvService")
public class Cam350ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource( name = "cbm700ukrvService" )
    protected Cbm700ukrvServiceImpl cbm700ukrvService;
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		param.put("USE_YN", "Y");
		
		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		String[] COST_POOL_LIST = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			COST_POOL_LIST[i] = ObjUtils.getSafeString(costPool.get("COST_POOL_CODE"));
			i++;
		}
		param.put("COST_POOL_LIST", COST_POOL_LIST);
		return super.commonDao.list("cam350ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert(insertList, user);
			if(updateList != null) this.update(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insert(List<Map> paramList, LoginVO user) throws Exception {	
		this.update(paramList, user);
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer update(List<Map> paramList, LoginVO user) throws Exception {
		if(paramList != null && paramList.size() > 0 )	{
			List<Map<String,Object>> costPoolList = super.commonDao.list("cbm700ukrvServiceImpl.selectList2", paramList.get(0));
			int i = 0;
			String[] COST_POOL_LIST = new  String[costPoolList.size()];
			for(Map<String, Object> costPool : costPoolList){
				COST_POOL_LIST[i] = ObjUtils.getSafeString(costPool.get("COST_POOL_CODE"));
				i++;
			}
			for(Map param :paramList )	{	
				for(String costPool : COST_POOL_LIST)	{
					param.put("COST_POOL_CODE", costPool);
					param.put("AMT", param.get("COST_POOL_"+costPool));
					super.commonDao.update("cam350ukrvServiceImpl.update", param);
				}
			}
		}
		 return 0;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCompare(Map param) throws Exception {
		
		return super.commonDao.list("cam350ukrvServiceImpl.selectCompare", param);
	}

	@ExtDirectMethod(group = "cost")		// 실행
	public Object executeProcessAccntSum(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("cam350ukrvServiceImpl.processAccntSum", param);

		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

        if(!ObjUtils.isEmpty(errorDesc))	{
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}
	
}
