package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agb320skrService")
public class Agb320skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectAcCodes(Map param) throws Exception {
		return (List) super.commonDao.list("agb320skrServiceImpl.selectAcCodes", param);
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agb320skrServiceImpl.selectList", param);
	}
	
}
