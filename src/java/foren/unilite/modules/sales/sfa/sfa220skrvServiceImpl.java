package foren.unilite.modules.sales.sfa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sfa220skrvService")
public class sfa220skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sfa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("sfa220skrvServiceImpl.selectList", param);
	}
}
