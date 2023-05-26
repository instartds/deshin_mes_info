package foren.unilite.modules.sales.sof;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sof210skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Sof210skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주별BOM정보조회 (sof210skrv)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return super.commonDao.list("sof210skrvServiceImpl.selectList", param);
	}
}