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


@Service("s_hat531rkr_ygService")
public class S_Hat531rkr_ygServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectHBS400T(Map param) throws Exception {
		return (List) super.commonDao.list("s_hat531rkr_ygServiceImpl.selectHBS400T", param);
	}
	
	
	
}
