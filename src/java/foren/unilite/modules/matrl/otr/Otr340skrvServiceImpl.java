package foren.unilite.modules.matrl.otr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("otr340skrvService")
public class Otr340skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 외주생산자재 출고내역 그리드 조회 목록
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("otr340skrvServiceImpl.selectList", param);
	}	

}