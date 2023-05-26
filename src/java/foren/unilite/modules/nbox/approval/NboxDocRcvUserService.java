package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxDocRcvUserService {

	public Map selects(Map param) throws Exception;
	
	public boolean save(LoginVO user, String DocumentID, String RcvType, List<Map<String, Object>> RcvUserList) throws Exception;
}