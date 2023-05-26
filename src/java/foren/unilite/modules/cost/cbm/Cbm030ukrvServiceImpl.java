package foren.unilite.modules.cost.cbm;

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

@Service("cbm030ukrvService")
public class Cbm030ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("cbm030ukrvServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail1(deleteList, user);
			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.insertDetail1", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.updateDetail1", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.deleteDetail1", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("cbm030ukrvServiceImpl.selectList2", param);
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.insertDetail2", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.updateDetail2", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm030ukrvServiceImpl.deleteDetail2", param);
		}
		return 0;
	}

}