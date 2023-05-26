package foren.unilite.modules.human.hat;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hat820rkrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hat820rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 20200812 추가: CLIP REPORT 출력 관련 (컬럼정보 가져오는 로직)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnHat820nQ(Map param) throws Exception {
		return super.commonDao.list("hat820rkrServiceImpl.fnHat820nQ", param);
	}

	/**
	 * 20200805 추가: CLIP REPORT 출력 관련 (data 가져오는 로직)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectToPrint(Map param) throws Exception {
		return super.commonDao.list("hat820rkrServiceImpl.selectToPrint", param);
	}
}