package foren.unilite.modules.sales.stma;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("stma310skrvService")
public class Stma310skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 거래처 원장 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {		

		return  super.commonDao.list("stma310skrvServiceImpl.selectList1", param);
	}	
	
 
}
