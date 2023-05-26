package foren.unilite.modules.sales.sfa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sfa100skrvService")
public class Sfa100skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *거래처원장조회-일별 : 그리드 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		
		return  super.commonDao.list("sfa100skrvServiceImpl.selectList1", param);
	}
}