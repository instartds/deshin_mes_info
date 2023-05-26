package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa630skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa630skrvServiceImpl  extends TlabAbstractServiceImpl {

	/** 채권채무현황 (ssa630skrv): 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("ssa630skrvServiceImpl.selectList1", param);
	}
}