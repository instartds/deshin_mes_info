package foren.unilite.modules.coop.cpa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("cpa110skrvService")
public class cpa110skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "cpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
	
		return  super.commonDao.list("cpa110skrvServiceImpl.selectList", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "cpa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("cpa110skrvServiceImpl.selectList2", param);
	}
}
