package foren.unilite.modules.matrl.mpo;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mpo170skrvService")
public class Mpo170skrvServiceImpl extends TlabAbstractServiceImpl{
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("mpo170skrvServiceImpl.selectList", param);
	}
}
