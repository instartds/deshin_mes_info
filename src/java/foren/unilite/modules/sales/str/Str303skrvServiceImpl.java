package foren.unilite.modules.sales.str;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("str303skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Str303skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 입고현황조회(집계) (str303skrv)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("str303skrvServiceImpl.selectList1", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object userWhcode(Map param) throws Exception {
		return super.commonDao.select("str303skrvServiceImpl.userWhcode", param);
	}
}
