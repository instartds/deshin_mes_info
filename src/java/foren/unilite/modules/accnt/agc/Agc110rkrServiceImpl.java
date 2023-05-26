package foren.unilite.modules.accnt.agc;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agc110rkrService")
public class Agc110rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agc110rkrServiceImpl.selectList", param);
	}	

}
