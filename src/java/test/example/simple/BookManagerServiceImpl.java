package test.example.simple;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import test.example.cmm.ExampleAbstractServiceImpl;


@Service("BookManagerServiceImpl")
public class BookManagerServiceImpl extends ExampleAbstractServiceImpl implements
		BookManagerService {
	Logger logger = LoggerFactory.getLogger(BookManagerServiceImpl.class);
	/**
	 * selectBookList
	 * 
	 * @return
	 */
	public List<Map<String, Object>> selectBookList(Map<String, Object> param)
			throws Exception {
		return (List<Map<String, Object>>) super.exampleDAO.list("BookManagerServiceImpl.selectBookList", param);
	}
}
