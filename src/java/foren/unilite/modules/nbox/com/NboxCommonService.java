package foren.unilite.modules.nbox.com;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface NboxCommonService {

	
	public Map selectCommonCode(Map param) throws Exception;
	
	public Map selectUserInfo(Map param) throws Exception;
	
}