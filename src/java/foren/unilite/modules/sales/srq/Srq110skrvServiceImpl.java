package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq110skrvService")
public class Srq110skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 출하지시미등록 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("srq110skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		return  super.commonDao.list("srq110skrvServiceImpl.printList", param);
	}
}
