package foren.unilite.modules.equip.eqt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("eqt210skrvService")
public class Eqt210skrvServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("eqt210skrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("eqt210skrvServiceImpl.selectList2", param);
	}

	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("eqt210skrvServiceImpl.selectList3", param);
	}
}
