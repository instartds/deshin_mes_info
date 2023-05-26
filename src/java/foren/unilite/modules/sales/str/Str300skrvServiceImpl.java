package foren.unilite.modules.sales.str;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("str300skrvService")
public class Str300skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 출고현황조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
	
		return  super.commonDao.list("str300skrvServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("str300skrvServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("str300skrvServiceImpl.userWhcode", param);
	}
}
