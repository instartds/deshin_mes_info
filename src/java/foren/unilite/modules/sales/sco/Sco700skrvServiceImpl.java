package foren.unilite.modules.sales.sco;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sco700skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Sco700skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미수금현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sco700skrvServiceImpl.selectList", param);
	}
}
