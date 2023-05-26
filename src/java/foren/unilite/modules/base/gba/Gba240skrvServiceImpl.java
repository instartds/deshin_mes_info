package foren.unilite.modules.base.gba;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("gba240skrvService")
public class Gba240skrvServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "gba")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return super.commonDao.list("gba240skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "gba")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("gba240skrvServiceImpl.selectList2", param);
	}
}
