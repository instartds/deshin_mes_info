package foren.unilite.modules.z_kd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
@Service("s_pmr907skrv_kdService")
public class S_pmr907skrv_kdServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_pmr907skrv_kdServiceImpl.selectList", param);
    }
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_pmr907skrv_kdServiceImpl.selectList2", param);
    }
	
}
