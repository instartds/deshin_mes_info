package foren.unilite.modules.matrl.map;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("map150skrvService")
public class Map150skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별기간별잔액현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("map150skrvServiceImpl.selectList", param);

	}
	
}
