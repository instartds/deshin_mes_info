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


@Service("s_pmp130rkrv_jwService")
public class S_pmp130rkrv_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> printList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmp130rkrv_jwServiceImpl.printList1", param);
	}
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> printSubList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmp130rkrv_jwServiceImpl.printSubList1", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> printList2(Map param) throws Exception {
		return  super.commonDao.list("s_pmp130rkrv_jwServiceImpl.printList2", param);
	}

	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> subPrintList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmp130rkrv_jwServiceImpl.subPrintList1", param);
	}
}
	
