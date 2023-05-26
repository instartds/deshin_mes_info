package foren.unilite.modules.human.had;

import java.util.ArrayList;
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

@Service("had950ukrService") 
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Had950ukrServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return  (List<Map<String, Object>>) super.commonDao.list("had950ukrServiceImpl.selectList", param);
	}

	/**
	 * 분납일괄계산
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "human")
	public Map selectInstallment(Map param) throws Exception {
		return  (Map) super.commonDao.select("had950ukrServiceImpl.selectInstallment", param);
	}
	
	/**
	 *  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			param.put("FLAG", "");
			super.commonDao.update("had950ukrServiceImpl.insertList", param);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			if("신규".equals(ObjUtils.getSafeString(param.get("OPR_FLAG"))))	{
				param.put("OPR_FLAG", "");
				super.commonDao.update("had950ukrServiceImpl.insertList", param);
			} else {
				param.put("OPR_FLAG", "");
				super.commonDao.update("had950ukrServiceImpl.updateList", param);
			}
		}
		return paramList;
	}

	/**
	 * 삭제
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("had950ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public Map deleteAll(Map param,  LoginVO user) throws Exception {
		super.commonDao.delete("had950ukrServiceImpl.deleteAll", param);
		return param;
	}
}
