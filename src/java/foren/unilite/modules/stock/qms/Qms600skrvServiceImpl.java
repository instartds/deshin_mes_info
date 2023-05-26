package foren.unilite.modules.stock.qms;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("qms600skrvService")
public class Qms600skrvServiceImpl extends TlabAbstractServiceImpl{

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("qms600skrvServiceImpl.getDataList", param);
	}
	
}
