package foren.unilite.modules.matrl.mad;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("madtest001skrvService")
public class Madtest001skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 매입재고현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("madtest001skrvServiceImpl.selectList", param);

	}
	
}
