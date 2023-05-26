package foren.unilite.modules.crm.popup;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.MapUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("cmPopupService")
public class CmPopupServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 영업기회 관리 목록
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>>  clientProjectList(Map param) throws Exception {
		if(ObjUtils.isEmpty(param.get("PROJECT_YN"))) {
			param.put("PROJECT_YN","Y");
		}
		if(ObjUtils.isEmpty(param.get("RDO"))) {
			param.put("RDO","1");
		}
		logger.debug("PARAM {}", param);
		
		return  super.commonDao.list("cmPopupServiceImpl.clientProjectPopup", param);
	}

	/**
	 * 고객정보 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup")
	public List<Map<String, Object>>  clientPopup(Map param) throws Exception {
		if(param.containsKey("TYPE")) {
			String type = ObjUtils.getSafeString(param.get("TYPE"));
			if("VALUE".equals(type)) {
				MapUtils.putIf(param, "RDO", "1");
			} else {
				MapUtils.putIf(param, "RDO", "2");
			}
		} else {
			MapUtils.putIf(param, "RDO", "1");
			String rdo = ObjUtils.getSafeString(param.get("RDO"));
			if("1".equals(rdo)) {
				param.put("CLIENT_ID", param.get("TXT_SEARCH"));
			} else {
				param.put("CLIENT_NAME", param.get("TXT_SEARCH"));
			}
		}
		param.put("SORT_STR", "1");
		logger.debug(ObjUtils.toJsonStr(param).toString());
		return  super.commonDao.list("cmPopupServiceImpl.clientPopup", param);
	}
	
	/**
	 * 경영정보
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Popup", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object>  customInfoPop(Map param) throws Exception {
		return  (Map<String, Object>)super.commonDao.select("cmPopupServiceImpl.customInfoPop", param);
	}


}
