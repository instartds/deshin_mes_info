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

@Service("cam310skrvService")
public class Cam310skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@Resource(name="cbm700ukrvService")
	private Cbm700ukrvServiceImpl cbm700ukrvService;
	
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
		return super.commonDao.list("cam310skrvServiceImpl.selectList", param);
	}
}
