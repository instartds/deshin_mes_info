package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.owasp.esapi.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr150skrvService")
public class Mtr150skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mtr")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("mtr150skrvServiceImpl.selectList", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mtr")
	public List<Map<String, Object>>  selectList2(Map param,LoginVO user) throws Exception {
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		param.put("LANGUAGE", user.getLanguage());
		return  super.commonDao.list("mtr150skrvServiceImpl.selectList2", param);
	}
}
