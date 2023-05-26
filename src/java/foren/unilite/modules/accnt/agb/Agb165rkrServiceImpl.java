package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("agb165rkrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Agb165rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agb165rkrServiceImpl.selectPrintList", param);
	}

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> fnAgb165Init(Map param, LoginVO loginVO) throws Exception {
		return super.commonDao.list("agb165rkrServiceImpl.fnAgb165Init", param);
	}



	/**
	 * CLIP REPORT 출력 - 20200804 추가
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectClList(Map param) throws Exception {
		return super.commonDao.list("agb165rkrServiceImpl.selectClList", param);
	}
}