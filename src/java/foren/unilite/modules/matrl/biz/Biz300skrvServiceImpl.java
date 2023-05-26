package foren.unilite.modules.matrl.biz;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biz300skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Biz300skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 외주현재고 현황 조회(품목별)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return super.commonDao.list("biz300skrvServiceImpl.selectList", param);
	}

	/**
	 * 외주현재고 현황 조회(외주처별)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList2( Map param, LoginVO user ) throws Exception {
		return super.commonDao.list("biz300skrvServiceImpl.selectList", param);
	}
}