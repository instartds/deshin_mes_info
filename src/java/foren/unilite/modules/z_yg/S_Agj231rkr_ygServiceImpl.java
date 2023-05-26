package foren.unilite.modules.z_yg;

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

@Service("s_agj231rkr_ygService")

public class S_Agj231rkr_ygServiceImpl extends TlabAbstractServiceImpl {
	
private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectPrintList1(Map param) throws Exception {
		
		return super.commonDao.list("s_agj231rkr_ygServiceImpl.PrintList1", param);
		
	}
}

