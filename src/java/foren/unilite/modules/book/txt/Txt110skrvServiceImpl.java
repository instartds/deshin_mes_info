package foren.unilite.modules.book.txt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("txt110skrvService")
public class Txt110skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 제품별 판매현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "txt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("txt110skrvServiceImpl.selectList", param);

	}
	
	@ExtDirectMethod( group = "txt")
	public Object searchMenu(Map param, LoginVO user) throws Exception {

		List<Map<String,Object>> list = super.commonDao.list("txt110skrvServiceImpl.searchMenu", param);
		Map<String, Object> rv = new HashMap<String, Object>();

		rv.put("records", list);
		
		return rv;
	}
	/**
	 * 
	 * 교재도서조회 학기관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "txt", value = ExtDirectMethodType.STORE_READ)
	public Object  subCode1(Map param) throws Exception {	
		
		return  super.commonDao.select("txt110skrvServiceImpl.subCode1", param);
	}
	
}
