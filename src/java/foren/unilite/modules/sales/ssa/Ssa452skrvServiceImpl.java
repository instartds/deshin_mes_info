package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("ssa452skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ssa452skrvServiceImpl  extends TlabAbstractServiceImpl {

	
	
	/**
	 * 매출현황- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("ssa452skrvServiceImpl.selectList1", param);
	}
}
