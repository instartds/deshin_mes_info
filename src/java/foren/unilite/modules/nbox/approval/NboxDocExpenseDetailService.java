package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;

public interface NboxDocExpenseDetailService {

	public boolean insert(LoginVO user, String DocumentID, List<Map<String, Object>> DocExpenseDetailList) throws Exception ;
	
	public boolean update(LoginVO user, List<Map<String, Object>> DocExpenseDetailList) throws Exception ;
	
	public boolean delete(LoginVO user, List<Map<String, Object>> DocExpenseDetailList) throws Exception ;
	
	
}