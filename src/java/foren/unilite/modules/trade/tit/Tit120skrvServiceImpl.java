package foren.unilite.modules.trade.tit;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("tit120skrvService")
public class Tit120skrvServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("tit120skrvServiceImpl.selectList", param);
	}
}