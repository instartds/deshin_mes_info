package foren.unilite.modules.human.had;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("had850rkrService")
public class Had850rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "had")			// 조회
	public List<Map<String, Object>> selectList2020Clip(Map param) throws Exception {
		return  super.commonDao.list("had850rkrServiceImpl.selectlist2020Clip", param);	
	}
}
