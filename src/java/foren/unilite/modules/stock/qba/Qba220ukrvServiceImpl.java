package foren.unilite.modules.stock.qba;

import java.util.ArrayList;
import java.util.HashMap;
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

@Service("qba220ukrvService")
public class Qba220ukrvServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getCntQba220t(Map param) throws Exception {
		return super.commonDao.list("qba220ukrvServiceImpl.getCntQba220t", param);
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qba220ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectTestList(Map param) throws Exception {
		return super.commonDao.list("qba220ukrvServiceImpl.selectTestList", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectTestListNew(Map param) throws Exception {
		return super.commonDao.list("qba220ukrvServiceImpl.selectTestListNew", param);
	}
	

	/**
	 * SaveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");


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
			param.put("ITEM_CODE", paramMaster.get("ITEM_CODE"));
			super.commonDao.update("qba220ukrvServiceImpl.insertAnUpdateDetail", param);
		}
		return params;
	}
	/**
	 * insert
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("qba220ukrvServiceImpl.insertDetail", param);
		}
		return params;
	}

	/**
	 * update
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("qba220ukrvServiceImpl.updateDetail", param);
		}
		return params;
	}
	/**
	 * delete
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			super.commonDao.delete("qba220ukrvServiceImpl.deleteDetail", param);
		}
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> copyAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String keyValue = ObjUtils.getSafeString(dataMaster.get("SEL_ITEM_CODE"));

		if(paramList != null)   {
            List<Map> insertList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("testcodeCopy")) {
                	insertList = (List<Map>)dataListMap.get("data");
                }
            } 
            if(insertList != null) this.testcodeCopy(keyValue, insertList, user);
        }
        paramList.add(0, paramMaster);

        return  paramList;
    }
	
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public void testcodeCopy(String keyValue, List<Map> params, LoginVO user) throws Exception {
		for(Map<String, Object> param : params)	{
			param.put("SEL_ITEM_CODE", keyValue);
			super.commonDao.delete("qba220ukrvServiceImpl.testcodeCopy", param);
		}
	}	

}
