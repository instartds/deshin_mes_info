package foren.unilite.modules.sales.ssd;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssd100skrvService")
public class Ssd100skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 제품별 판매현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("ssd100skrvServiceImpl.selectList", param);

	}
	
}
