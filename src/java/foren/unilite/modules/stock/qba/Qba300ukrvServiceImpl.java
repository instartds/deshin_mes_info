package foren.unilite.modules.stock.qba;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("qba300ukrvService")
public class Qba300ukrvServiceImpl extends TlabAbstractServiceImpl {

private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ) 
	public List<Map<String, Object>> getCntQba300t(Map param) throws Exception {
		return super.commonDao.list("qba300ukrvServiceImpl.getCntQba300t", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ) 
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qba300ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ) 
	public List<Map<String, Object>> selectTestList(Map param) throws Exception {
		return super.commonDao.list("qba300ukrvServiceImpl.selectTestList", param);
	}
	
	/**
	 * SaveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		/*if(paramList != null)   {
            List<Map> insertAnUpdateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
            	 if(dataListMap.get("method").equals("deleteDetail")) {
                     deleteList = (List<Map>)dataListMap.get("data");
                 } else if(dataListMap.get("method").equals("insertAnUpdateDetail")) {
                	 insertAnUpdateList = (List<Map>)dataListMap.get("data");
                 }
            }
            if(deleteList != null) this.deleteDetail(deleteList, user);
            if(insertAnUpdateList != null) this.insertAnUpdateDetail(insertAnUpdateList, dataMaster, user);             
        }*/
		
		if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                }
            }
            if(deleteList != null) this.deleteDetail(deleteList, user);
            if(insertList != null) this.insertDetail(insertList, user);
            if(updateList != null) this.updateDetail(updateList, user);             
        }
		
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	
	/**
	 * insert & update
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertAnUpdateDetail(List<Map> params, Map paramMaster, LoginVO user) throws Exception {
		for(Map param: params)		{
			//param.put("ITEM_CODE", paramMaster.get("ITEM_CODE"));
			super.commonDao.update("qba300ukrvServiceImpl.insertAnUpdateDetail", param);
		}		
		return params;
	}
	/**
	 * insert
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("qba300ukrvServiceImpl.insertDetail", param);
		}		
		return params;
	}
	
	/**
	 * update
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("qba300ukrvServiceImpl.updateDetail", param);
		}		
		return params;
	}
	/**
	 * delete
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			super.commonDao.delete("qba300ukrvServiceImpl.deleteDetail", param);
		}
	}
}
