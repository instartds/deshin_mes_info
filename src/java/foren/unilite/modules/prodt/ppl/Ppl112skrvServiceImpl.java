package foren.unilite.modules.prodt.ppl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ppl112skrvService")
public class Ppl112skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 생산계획 근거내역 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("ppl112skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("ppl112skrvServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
	
		return  super.commonDao.list("ppl112skrvServiceImpl.selectList3", param);
	}

}
