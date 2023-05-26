package foren.unilite.modules.nbox.link;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxLinkDataCodeByApprovalService {

	public Map selects(Map param) throws Exception;
	
	public boolean save( LoginVO user, String DocumentID, List<Map<String, Object>> LinkDataList) throws Exception;
}