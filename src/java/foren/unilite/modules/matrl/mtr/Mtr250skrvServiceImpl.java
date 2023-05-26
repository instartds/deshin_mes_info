package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr250skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Mtr250skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mtr")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("mtr250skrvServiceImpl.selectList", param);
	}

	/**
	 *
	 * label print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("mtr250skrvServiceImpl.printList", param);
	}
}
