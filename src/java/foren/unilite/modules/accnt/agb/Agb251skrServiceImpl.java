package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agb251skrService")
public class Agb251skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agb251skrServiceImpl.selectList", param);
	}
}
