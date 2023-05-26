package foren.unilite.modules.base.bpl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
@Service("bpl110skrvService")
public class Bpl110skrvServiceImpl extends TlabAbstractServiceImpl{	
	
	private final Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return super.commonDao.list("bpl110skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("bpl110skrvServiceImpl.selectList2", param);
	}
}
