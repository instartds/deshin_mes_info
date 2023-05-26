package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("S_agb210skr_mitService")
public class S_agb210skr_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "z_mit")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("S_agb210skr_mitServiceImpl.selectList", param);
	}
}
