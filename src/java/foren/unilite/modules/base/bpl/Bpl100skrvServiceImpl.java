package foren.unilite.modules.base.bpl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpl100skrvService")
public class Bpl100skrvServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bpl")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		
		return super.commonDao.list("bpl100skrvServiceImpl.selectDetailList", param);
	}
}
