package foren.unilite.modules.accnt.agd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("agd210ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Agd210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")			// 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("agd210ukrServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
		Object r = super.commonDao.queryForObject("agd210ukrServiceImpl.agd210ukrDo", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE"))) {
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL,  group = "accnt")		// 실행
	public Object saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		String keyValue = getLogKey();

		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");

		if(paramMasterData != null && ObjUtils.isNotEmpty(paramMasterData.get("KeyValue"))) {
			keyValue = ObjUtils.getSafeString(paramMasterData.get("KeyValue"));
		}

		Map<String, Object> autoNum = (Map<String, Object>) super.commonDao.select("agd210ukrServiceImpl.getMaxAutoNum", paramMasterData);
		int i=  Integer.parseInt(autoNum.get("MAX_AUTO_NUM").toString());

		List<Map> dataList = new ArrayList<Map>();

		if(paramList != null) {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agd210ukrServiceImpl.insertLog", paramData);
					i++;
				}
			}
		}

		Map sParam = new HashMap();
		sParam = paramMasterData;
		sParam.put("KEY_VALUE", keyValue);
		sParam.put("S_LANG_CODE", user.getLanguage());
		Map<String, Object> r;

		if("1".equals(paramMasterData.get("WORK_DIVI"))) {
			// 자동기표
			r = (Map<String, Object>)super.commonDao.queryForObject("agd210ukrServiceImpl.agd210ukrAllDo", sParam);
		} else {
			// 기표취소
			r = (Map<String, Object>)super.commonDao.queryForObject("agd210ukrServiceImpl.agd210ukrCancel", sParam);
		}
		String errDesc =  ObjUtils.getSafeString(sParam.get("ERROR_DESC"));
		if(errDesc != null && !"".equals(errDesc)) {
			throw new UniDirectValidateException(this.getMessage(errDesc, user));
		}
		paramMaster.put("data", paramMasterData);
		paramList.add(0, paramMaster);
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 취소
	public void cancButton(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("agd210ukrServiceImpl.agd210ukrCancel", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		if(!"".equals(errorDesc)) {
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 취소
	public int insert(Map param)	throws Exception {
		return 0;
	}
}