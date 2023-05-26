package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocUserConfigModel;

@Service("nboxDocUserConfigService")
public class NboxDocUserConfigServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 상세 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map select(Map param, HttpServletRequest request) throws Exception {
		logger.debug("\n select: {}", param );
		
		/* Main Info */
		Map rv = new HashMap();
		Map details = (Map)super.commonDao.select("nboxDocUserConfigService.select", param);

		rv.put("records", details);
		return rv;
	}
	
	/**
	 * 저장(추가,수정)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "nbox")
	public ExtDirectFormPostResult save(
			NboxDocUserConfigModel _docuserconfig, 
			LoginVO user) throws Exception {
		
		logger.debug("\n save NboxDocUserConfigModel : {}", _docuserconfig );
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		_docuserconfig.setS_USER_ID(user.getUserID());
		_docuserconfig.setS_COMP_CODE(user.getCompCode());
		_docuserconfig.setS_LANG_CODE(user.getLanguage());
		
		int r = super.commonDao.update("nboxDocUserConfigService.update", _docuserconfig);
		if(r == 0)
			super.commonDao.insert("nboxDocUserConfigService.insert", _docuserconfig);

		resp.addResultProperty("DocumentID", _docuserconfig.getS_USER_ID());
		return resp; 
	}	
	
	
	
}
