package foren.unilite.modules.accnt.agc;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agc100rkrService")
public class Agc100rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 당월포함
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("agc100rkrServiceImpl.selectList", param);
	}
}
