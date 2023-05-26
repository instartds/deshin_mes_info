package foren.unilite.modules.matrl.map;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("map070skrvService")
public class Map070skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처 지불예정 명세서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("map070skrvServiceImpl.selectList", param);

	}
	
}
