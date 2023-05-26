package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("ssa461skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ssa461skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매출집계현황II- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("ssa461skrvServiceImpl.selectList", param);
	}
}