package foren.unilite.modules.human.hat;

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


@Service("hat540rkrService")
public class Hat540rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectHBS400T(Map param) throws Exception {
		return (List) super.commonDao.list("hat540rkrServiceImpl.selectHBS400T", param);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectDutyCode(Map param) throws Exception {
		return (List) super.commonDao.list("hat540rkrServiceImpl.selectDutyCode", param);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectToPrint(Map param) throws Exception {
		return (List) super.commonDao.list("hat540rkrServiceImpl.selectToPrint", param);
	}
	
	
	
}
