package test.example.simple;

import java.util.List;
import java.util.Map;

public interface BookManagerService {

	/**
	 * selectBookList
	 * 
	 * @return
	 */
	public List<Map<String, Object>> selectBookList(Map<String, Object> param)
			throws Exception;
}
