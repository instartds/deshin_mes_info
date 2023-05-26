package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp141skrvService")
public class Pmp141skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		return  super.commonDao.list("pmp141skrvServiceImpl.selectList", param);
	}
	
}
