package foren.unilite.modules.matrl.opo;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("opo310skrvService")
public class Opo310skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 판매단가/고객품목 그리드1 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("opo310skrvServiceImpl.selectList", param);
	}
	
	/**
	 * 판매단가/고객품목 그리드2 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("opo310skrvServiceImpl.selectList2", param);
	}
}