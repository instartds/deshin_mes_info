package foren.unilite.modules.prodt.pmp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmp150skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Pmp150skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList(Map param,LoginVO user) throws Exception {
		param.put("S_USER_ID", user.getUserID());
		param.put("S_COMP_CODE", user.getCompCode());
		return  super.commonDao.list("pmp150skrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectDetailList(Map param,LoginVO user) throws Exception {
		param.put("S_USER_ID", user.getUserID());
		param.put("S_COMP_CODE", user.getCompCode());
		return  super.commonDao.list("pmp150skrvServiceImpl.selectDetailList", param);
	}
}