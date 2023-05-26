package foren.unilite.modules.matrl.biz;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biz140skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biz140skrvServiceImpl  extends TlabAbstractServiceImpl {

	/** 외주실사선별품목 조회 (biz140skrv)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("biz140skrvServiceImpl.selectList", param);
	}
}