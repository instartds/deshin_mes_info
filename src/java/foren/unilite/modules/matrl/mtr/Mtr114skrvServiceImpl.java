package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr114skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mtr114skrvServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		List<Map<String, Object>> selectList = super.commonDao.list("mtr114skrvServiceImpl.selectList", param);
		return selectList;
	}

	/**
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("mtr114skrvServiceImpl.userWhcode", param);
	}
}