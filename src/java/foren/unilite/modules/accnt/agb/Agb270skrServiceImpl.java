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


@Service("agb270skrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Agb270skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 선택계정 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getAccntInfo(Map param) throws Exception {
		return (List)super.commonDao.list("agb270skrServiceImpl.selectQuery" ,param);
	}

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> unSelectQuery(Map param) throws Exception {
		return (List) super.commonDao.list("agb270skrServiceImpl.unSelectQuery", param);
	}

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectQuery(Map param) throws Exception {
		return (List) super.commonDao.list("agb270skrServiceImpl.selectQuery", param);
	}

	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agb270skrServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getAccntName(Map param) throws Exception {
		return (List) super.commonDao.list("agb270skrServiceImpl.getAccntName", param);
	}
}