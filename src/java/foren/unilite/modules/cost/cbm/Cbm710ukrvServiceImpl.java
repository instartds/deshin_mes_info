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

@Service("cbm710ukrvService")
public class Cbm710ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isEmpty(param.get("DIV_CODE")))	{
			param.put("DIV_CODE", user.getDivCode());
		}
		return super.commonDao.list("cbm710ukrvServiceImpl.selectList1", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDeptList1(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isEmpty(param.get("DIV_CODE")))	{
			param.put("DIV_CODE", user.getDivCode());
		}
		return super.commonDao.list("cbm710ukrvServiceImpl.selectDeptList1", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAllDept1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDept1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}	
			if(updateList != null) {
				this.updateDept1(updateList, user);				
			}
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDept1(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.queryForObject("cbm710ukrvServiceImpl.updateDept1", param);
		}
		 return 0;
	} 

	

}