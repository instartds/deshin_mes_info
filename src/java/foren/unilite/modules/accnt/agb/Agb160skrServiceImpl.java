package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("agb160skrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Agb160skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agb160skrServiceImpl.selectMasterList", param);
	}

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)		// 조회2
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("agb160skrServiceImpl.selectDetailList", param);
	}



	/**
	 * 미결현황출력 (agb160rkr) 출력관련 Method 추가 - 20200803
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnAgb160QRpt(Map param) throws Exception {
		return super.commonDao.list("agb160skrServiceImpl.fnAgb160QRpt", param);
	}
}