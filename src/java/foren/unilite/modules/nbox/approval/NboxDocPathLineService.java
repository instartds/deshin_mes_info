package foren.unilite.modules.nbox.approval;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import foren.framework.model.LoginVO;

public interface NboxDocPathLineService {

	public Map selects(Map param, HttpServletRequest request) throws Exception;
	
	public boolean save( LoginVO user, String PathID, String LineType, List<Map<String, Object>> dataList) throws Exception;
}