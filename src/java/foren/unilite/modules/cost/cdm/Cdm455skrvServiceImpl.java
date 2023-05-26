package foren.unilite.modules.cost.cdm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cdm455skrvService")
public class Cdm455skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("cdm455skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaxSeq(Map param) throws Exception {
		return  super.commonDao.select("cdm455skrvServiceImpl.selectMaxSeq", param);
	}
	
}
