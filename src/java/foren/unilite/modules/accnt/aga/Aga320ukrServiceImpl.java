package foren.unilite.modules.accnt.aga;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("aga320ukrService")
public class Aga320ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("aga320ukrServiceImpl.selectList", param);
	}
	

	
	/** sync All
	 * 
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
					
				} /*else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
					
				}*/ else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}  
			}			
			//추가
			if(insertList != null) this.insertList(insertList, paramMaster, user);
			//삭제
			if(deleteList != null) this.deleteList(deleteList, paramMaster, user);
		}
	 	paramList.add(0, paramMaster);
				
	 	return  paramList;
	}

	/**
	 * 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map param :paramList )	{
			 super.commonDao.insert("aga320ukrServiceImpl.insertList", param);
		}	
		return;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map param :paramList )	{
			 super.commonDao.delete("aga320ukrServiceImpl.deleteList", param);
		}	
		return;
	}
}
