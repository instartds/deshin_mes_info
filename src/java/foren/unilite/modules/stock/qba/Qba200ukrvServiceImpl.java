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

@Service("qba200ukrvService")
public class Qba200ukrvServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ) 
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qba200ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ) 
	public List<Map<String, Object>> selectEquipList(Map param) throws Exception {
		return super.commonDao.list("qba200ukrvServiceImpl.selectEquipList", param);
	}
	
	/**
	 * SaveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
            List<Map> saveAllList = null;
            for(Map dataListMap: paramList) {
            	saveAllList = (List<Map>)dataListMap.get("data");
            }
             this.SaveAllDetail(saveAllList, dataMaster, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	/**
	 * 입력
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> SaveAllDetail(List<Map> params, Map paramMaster, LoginVO user) throws Exception {
		for(Map param: params)		{
			param.put("ITEM_CODE", paramMaster.get("ITEM_CODE"));
			super.commonDao.insert("qba200ukrvServiceImpl.SaveAllDetail", param);
		}		
		return params;
	}
}
