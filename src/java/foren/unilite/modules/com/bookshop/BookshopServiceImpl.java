package foren.unilite.modules.com.bookshop;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bookshopService")
public class BookshopServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 도서 검색
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList(Map param) throws Exception {
		return  super.commonDao.list("bookshopService.selectList", param);
	}
	
	protected  List<ComboItemModel> getDivList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("ComboServiceImpl.getDivList", param);
	}
	
	/**
	 * 교재 검색
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectRefList(Map param) throws Exception {
		return  super.commonDao.list("bookshopService.selectRefList", param);
	}
	
	/*품목 자동완성 기능 조회*/
	@ExtDirectMethod( group = "txt")
	public Object searchMenu(Map param) throws Exception {
		List<Map<String,Object>> list = super.commonDao.list("bookshopService.searchMenu", param);
		Map<String, Object> rv = new HashMap<String, Object>();
		rv.put("records", list);		
		return rv;
	}
	

}
