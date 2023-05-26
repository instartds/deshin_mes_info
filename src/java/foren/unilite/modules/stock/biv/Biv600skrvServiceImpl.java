package foren.unilite.modules.stock.biv;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv600skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biv600skrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("biv600skrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("biv600skrvServiceImpl.selectList1", param);
	}
}