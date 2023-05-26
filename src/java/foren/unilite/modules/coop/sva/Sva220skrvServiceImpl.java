package foren.unilite.modules.coop.sva;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("Sva220skrvService")
public class Sva220skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 일자별 투입 현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("Sva220skrvService.selectList", param);
	}
	
	
}
