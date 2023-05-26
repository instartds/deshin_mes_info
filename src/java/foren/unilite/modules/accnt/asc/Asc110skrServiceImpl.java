package foren.unilite.modules.accnt.asc;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("asc110skrService")
public class Asc110skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("asc110skrServiceImpl.selectList", param);
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getDetail(Map param) throws Exception {
		return (List) super.commonDao.list("asc110skrServiceImpl.getDetail", param);
	}
}

