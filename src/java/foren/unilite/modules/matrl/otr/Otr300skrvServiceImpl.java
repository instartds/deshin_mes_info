package foren.unilite.modules.matrl.otr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("otr300skrvService")
public class Otr300skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 판매단가/고객품목 그리드1 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("otr300skrvServiceImpl.selectList", param);
	}
	
	/**
	 * 판매단가/고객품목 그리드2 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("otr300skrvServiceImpl.selectList2", param);
	}
}