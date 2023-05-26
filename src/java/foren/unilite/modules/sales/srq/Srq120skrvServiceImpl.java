package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq120skrvService")
public class Srq120skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 출하대비 미출고 현황
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("srq120skrvServiceImpl.selectList", param);
	}
}
