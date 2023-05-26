package foren.unilite.modules.stock.biv;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biv140skrvService")
public class Biv140skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매입처별 제품별 매입현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bid")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		if(param.get("COUNT_DATE") != null ) param.put("COUNT_DATE", ObjUtils.getSafeString( param.get("COUNT_DATE")).replaceAll("\\.", ""));
		return  super.commonDao.list("biv140skrvServiceImpl.selectList", param);
	}
	
	
	
}
