package foren.unilite.modules.pos.pos;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pos300skrvService")
public class Pos300skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("pos300skrvServiceImpl.selectList", param);
	}
}
