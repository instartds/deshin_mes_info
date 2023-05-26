package foren.unilite.modules.vmi;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ord100skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ord100skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 주문현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("S_USER_ID"	, user.getUserID());
		param.put("S_COMP_CODE"	, user.getCompCode());
		return  super.commonDao.list("ord100skrvServiceImpl.selectList", param);
	}
}
