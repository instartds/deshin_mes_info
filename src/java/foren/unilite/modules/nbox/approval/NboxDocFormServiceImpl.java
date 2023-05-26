package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocFormModel;

@Service("nboxDocFormService")
public class NboxDocFormServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n selects: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocFormService.selects", param);
		
		int totalCount = 0;
		if(list.size() > 0 ) {
			Map rec = (Map) list.get(0);
			totalCount = (Integer)rec.get("TOTALCOUNT");
		}
		
		rv.put("records", list);
		rv.put("total", totalCount);
		
		return rv;
	}
	
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
		Map details = (Map)super.commonDao.select("nboxDocFormService.select", param);

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
	public ExtDirectFormPostResult save( NboxDocFormModel _docForm, LoginVO user) throws Exception {
		logger.debug("\n save NboxDocFormModel: {}", _docForm );
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		_docForm.setS_USER_ID(user.getUserID());
		_docForm.setS_COMP_CODE(user.getCompCode());

		switch (_docForm.getActionType()){
		case "C":
			Map Object = (Map)super.commonDao.select("nboxDocFormService.createFormID", _docForm);
			logger.debug("\n save FormID: {}", (String)Object.get("FormID") );
			_docForm.setFormID((String)Object.get("FormID"));
			
			super.commonDao.insert("nboxDocFormService.insert", _docForm);
			
			break;
		case "U":
			super.commonDao.update("nboxDocFormService.update", _docForm);
			break;
		case "D":
			super.commonDao.delete("nboxDocFormService.delete", _docForm);
			break;
		default:
			break;
		}
		
		resp.addResultProperty("FormID", _docForm.getFormID());
		
		return resp; 
	}
}
