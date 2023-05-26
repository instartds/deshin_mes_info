package foren.unilite.modules.stock.bid;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bid200skrvService")
public class Bid200skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매입처별 제품별 매입현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bid")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("bid200skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("bid200skrvServiceImpl.userWhcode", param);
	}
	
}
