package foren.unilite.modules.crm.cmd;

import java.util.List;
import java.util.Map;

public interface Cmd140SkrvService {
	public List<Map<String, Object>> selectList(Map param) throws Exception;
	
//	/**
//	 * 거래처 검색용 
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	public List<Map<String, Object>> selectCustomList(Map param) throws Exception ;
}
