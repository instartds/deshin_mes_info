package foren.unilite.modules.z_mit;

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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

@Service("s_agc760ukr_mitService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_agc760ukr_mitServiceImpl  extends TlabAbstractServiceImpl {

	
	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return    super.commonDao.list("s_agc760ukr_mitServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectNewList(Map param, LoginVO user) throws Exception {
		
		return super.commonDao.list("s_agc760ukr_mitServiceImpl.selectNewDataList", param); 
	}
	 
	
	/**
	 *  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data"); 
				}
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data"); 
				}
			}
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}


	/**
	 * 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		
		for(Map param :paramList) {
			if(ObjUtils.isEmpty(param.get("FR_DATE")))	{
				param.put("FR_DATE", "");
			}
			if(ObjUtils.isEmpty(param.get("TO_DATE")))	{
				param.put("TO_DATE", "");
			}
			super.commonDao.update("s_agc760ukr_mitServiceImpl.insertList", param);
		}
		return paramList;
	}

	/**
	 * 수정
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public List<Map> updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		
		for(Map param :paramList) {
			if(ObjUtils.isEmpty(param.get("FR_DATE")))	{
				param.put("FR_DATE", "");
			}
			if(ObjUtils.isEmpty(param.get("TO_DATE")))	{
				param.put("TO_DATE", "");
			}
			super.commonDao.update("s_agc760ukr_mitServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Map deleteAll(Map param,  LoginVO user) throws Exception {
		super.commonDao.delete("s_agc760ukr_mitServiceImpl.deleteAll", param);
		return param;
	}
}
