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
import foren.unilite.modules.nbox.approval.model.NboxDocUserLeaveConfigModel;

@Service("nboxDocUserLeaveConfigService")
public class NboxDocUserLeaveConfigServiceImpl extends TlabAbstractServiceImpl  {
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
		List list =super.commonDao.list("nboxDocUserLeaveConfigService.selects", param);
		
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
		Map details = (Map)super.commonDao.select("nboxDocUserLeaveConfigService.select", param);

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
			NboxDocUserLeaveConfigModel _docuserleaveconfig, 
			LoginVO user) throws Exception {
		
		logger.debug("\n save NboxDocUserLeaveConfigModel : {}", _docuserleaveconfig );
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		_docuserleaveconfig.setS_USER_ID(user.getUserID());
		_docuserleaveconfig.setS_COMP_CODE(user.getCompCode());
		_docuserleaveconfig.setS_LANG_CODE(user.getLanguage());
		
		if( _docuserleaveconfig.getLeaveID().isEmpty() || _docuserleaveconfig.getLeaveID().equals(null) ){
			Map Object = (Map)super.commonDao.select("nboxDocUserLeaveConfigService.createLeaveID",_docuserleaveconfig);
			_docuserleaveconfig.setLeaveID((String)Object.get("LeaveID"));
			
			super.commonDao.insert("nboxDocUserLeaveConfigService.insert", _docuserleaveconfig);
		}else
			super.commonDao.update("nboxDocUserLeaveConfigService.update", _docuserleaveconfig);
		
			
		resp.addResultProperty("DocumentID", _docuserleaveconfig.getLeaveID());
		return resp; 
	}		
	
	/**
	 *  삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int delete(Map param) throws Exception {
		logger.debug("\n delete: {}", param );
		return (int)super.commonDao.delete("nboxDocUserLeaveConfigService.delete", param);
	}
}
