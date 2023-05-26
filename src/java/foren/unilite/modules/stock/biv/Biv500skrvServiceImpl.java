package foren.unilite.modules.stock.biv;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv500skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv500skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * Aging Report (기간별) 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "biv")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("biv500skrvServiceImpl.selectList", param);
	}

	/**
	 * Aging Report (월별) 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "biv")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("biv500skrvServiceImpl.selectList2", param);
	}
}
