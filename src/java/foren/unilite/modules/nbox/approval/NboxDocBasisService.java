package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxDocBasisService {

	public Map selectByDoc(Map param) throws Exception;
	
	public boolean save(LoginVO user, String DocumentID, List<Map<String, Object>> DocBasisList) throws Exception;
}