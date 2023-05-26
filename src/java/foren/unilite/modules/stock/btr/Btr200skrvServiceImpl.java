package foren.unilite.modules.stock.btr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("btr200skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Btr200skrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("btr200skrvServiceImpl.userWhcode", param);
	}

	/**
	 * 재고이동현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return super.commonDao.list("btr200skrvServiceImpl.selectList", param);
	}
}