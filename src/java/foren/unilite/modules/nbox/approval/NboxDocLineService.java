package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxDocLineService {

	public Map selects(Map param) throws Exception;
	
	public boolean save(LoginVO user, String DocumentID, List<Map<String, Object>> DocLineList) throws Exception;
}