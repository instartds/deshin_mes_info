package foren.unilite.modules.human.ham;

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

@Service("ham802ukrService")
public class Ham802ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일용직급여등록 조회(마스터)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return (List) super.commonDao.list("ham802ukrService.selectMasterList", param);
	}

	/**
	 * 일용직급여등록 조회(디테일)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ham")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return (List) super.commonDao.list("ham802ukrService.selectDetailList", param);
	}

	/**
	 * 일용직급여등록 저장(디테일)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "ham")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");
				}
			}
			Map<String,Object> param = new HashMap<String,Object>();
			if(updateList != null) {
				this.updateDetail(updateList);
				param = updateList.get(0);
				this.updateMonthlyRecord(param);
			}
		}
		paramList.add(0, paramMaster);
				
		return paramList;
	}

	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> updateDetail(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("ham802ukrService.updateDetail", param);
		}
		return paramList;		
	}

	@ExtDirectMethod(group = "ham", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateMonthlyRecord(Map<String, Object> param) throws Exception {
		String keyValue = getLogKey();
		param.put("KEY_VALUE", keyValue);
		super.commonDao.update("ham802ukrService.updateMonthlyRecord", param);
	}

}
