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

@Service("cbm130ukrvService")
public class Cbm130ukrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("cbm130ukrvServiceImpl.selectList1", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCopy1(Map param) throws Exception {
		return super.commonDao.list("cbm130ukrvServiceImpl.selectCopy1", param);
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
			Map paramMasterData =(Map) paramMaster.get("data");
			if(paramMasterData != null && "Y".equals(paramMasterData.get("isCopy")))	{
				this.deleteCopyDetail1(paramMasterData);
			}

			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}	

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// INSERT
	public Integer insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{	
			super.commonDao.update("cbm130ukrvServiceImpl.insertDetail1", param);
		}
		return 0;
	}	
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.update("cbm130ukrvServiceImpl.updateDetail1", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteDetail1(Map param) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// DELETE
	public Integer deleteCopyDetail1(Map param) throws Exception {
		super.commonDao.update("cbm130ukrvServiceImpl.deleteCopyDetail1", param);
		return 0;
	}
	

}