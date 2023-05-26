package foren.unilite.modules.z_hs;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_agb160skr_hsService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Agb160skr_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_agb160skr_hsServiceImpl.selectMasterList", param);
	}

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("s_agb160skr_hsServiceImpl.selectDetailList", param);
	}

	/**
	 * 미결현황출력 (agb160rkr)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnAgb160QRpt(Map param) throws Exception {
		return super.commonDao.list("s_agb160skr_hsServiceImpl.fnAgb160QRpt", param);
	}
}
