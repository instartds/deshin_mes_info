package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa520skrvService")
public class Ssa520skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 부도어음현황 조회 : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		
		return  super.commonDao.list("ssa520skrvServiceImpl.selectList1", param);
	}

	


	
}
