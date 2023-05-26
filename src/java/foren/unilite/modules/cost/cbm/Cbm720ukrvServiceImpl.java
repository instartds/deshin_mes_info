package foren.unilite.modules.cost.cbm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cbm720ukrvService")
public class Cbm720ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isEmpty(param.get("DIV_CODE")))	{
			param.put("DIV_CODE", user.getDivCode());
		}
		return super.commonDao.list("cbm720ukrvServiceImpl.selectList2", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList2(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isEmpty(param.get("DIV_CODE")))	{
			param.put("DIV_CODE", user.getDivCode());
		}
		return super.commonDao.list("cbm720ukrvServiceImpl.selectRefList2", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAllRef2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateRef2")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}	
			if(updateList != null) {
				this.updateRef2(updateList, user);				
			}
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateRef2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.queryForObject("cbm720ukrvServiceImpl.updateRef2", param);
		}
		 return 0;
	} 

}