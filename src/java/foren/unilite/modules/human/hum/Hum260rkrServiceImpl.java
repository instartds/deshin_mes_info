package foren.unilite.modules.human.hum;

import java.util.ArrayList;
import java.util.Collection;
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

@Service("hum260rkrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hum260rkrServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 20200806 추가 - CLIP REPORT 출력
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectClList(Map param) throws Exception {
		return super.commonDao.list("hum260rkrServiceImpl.PrintList1", param);
	}
}