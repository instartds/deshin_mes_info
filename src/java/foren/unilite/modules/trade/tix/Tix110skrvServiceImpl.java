package foren.unilite.modules.trade.tix;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("tix110skrvService")
public class Tix110skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("tix110skrvServiceImpl.selectList", param);
	}
}