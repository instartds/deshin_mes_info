package foren.unilite.modules.human.hum;

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

@Service("hum980rkrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hum980rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 20200805 추가: CLIP REPORT 출력 관련 (main data)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectHumMasterData(Map param) throws Exception {
		return super.commonDao.list("hum980rkrServiceImpl.selectHumMasterData", param);
	}

	/**
	 * 20200805 추가: CLIP REPORT 출력 관련 (detail data)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectHumDetailData(Map param) throws Exception {
		return super.commonDao.list("hum980rkrServiceImpl.selectHumDetailData", param);
	}
}