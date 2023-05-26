package foren.unilite.modules.z_kd;

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


@Service("s_equ210skrv_kdService")
public class S_equ210skrv_kdServiceImpl  extends TlabAbstractServiceImpl {
	@ExtDirectMethod(group = "equip", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("s_equ210skrv_kdServiceImpl.printList", param);		
	}
}
