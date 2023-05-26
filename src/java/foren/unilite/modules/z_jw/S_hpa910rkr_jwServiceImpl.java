package foren.unilite.modules.z_jw;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("S_hpa910rkr_jwService")
public class S_hpa910rkr_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		logger.debug("S_hpa910rkr_jwServiceImpl.selectList1");
		return (List) super.commonDao.list("S_hpa910rkr_jwServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		logger.debug("S_hpa910rkr_jwServiceImpl.selectList2");
		return (List) super.commonDao.list("S_hpa910rkr_jwServiceImpl.selectList2", param);
	}
		
}
	
