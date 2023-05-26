package foren.unilite.modules.matrl.otr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("otr320skrvService")
public class Otr320skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 검색항목
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("otr320skrvServiceImpl.selectList", param);
	}
	
	/**
	 * 검색항목2
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("otr320skrvServiceImpl.selectList2", param);
	}
}