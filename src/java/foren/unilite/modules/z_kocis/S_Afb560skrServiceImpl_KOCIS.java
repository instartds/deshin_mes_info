package foren.unilite.modules.z_kocis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_afb560skrService_KOCIS")
public class S_Afb560skrServiceImpl_KOCIS  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// REF_CODE1 값
	public List<Map<String, Object>>  selectRefCode1(Map param) throws Exception {	
		return  super.commonDao.list("s_afb560skrServiceImpl_KOCIS.selectRefCode1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_afb560skrServiceImpl_KOCIS.selectList", param);
	}

}
