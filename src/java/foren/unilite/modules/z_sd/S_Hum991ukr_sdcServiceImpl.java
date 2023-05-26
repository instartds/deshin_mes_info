package foren.unilite.modules.z_sd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hum991ukr_sdcService")
public class S_Hum991ukr_sdcServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_hum991ukr_sdcService.selectList", param);
	}

	/**
	 * 현원 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public Map selectCurPersonCnt(Map param) throws Exception {
		return (Map)super.commonDao.select("s_hum991ukr_sdcService.selectCurPersonCnt", param);
    }

	/**
	 * 마스터데이터 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpe")
	public List<Map> syncAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");
				}
			}
			if(deleteList != null) {
				this.delete(deleteList);
			}
			if(insertList != null) {
				this.insert(insertList);
			}
			if(updateList != null) {
				this.update(updateList);
			}
		}
		paramList.add(0, paramMaster);
				
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("PROC_TYPE", "D");
			super.commonDao.update("s_hum991ukr_sdcService.save", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("PROC_TYPE", "I");
			super.commonDao.update("s_hum991ukr_sdcService.save", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("PROC_TYPE", "U");
			super.commonDao.update("s_hum991ukr_sdcService.save", param);
		}
		return paramList;
	}

	/**
	 * 이력조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectHistList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_hum991ukr_sdcService.selectHistList", param);
	}

}
