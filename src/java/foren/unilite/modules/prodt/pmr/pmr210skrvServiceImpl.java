package foren.unilite.modules.prodt.pmr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pmr210skrvService")
public class pmr210skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 월생산실적 조회 품목
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("pmr210skrvServiceImpl.selectList", param);
	}
	/**
	 * 월생산실적 조회 설비
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("pmr210skrvServiceImpl.selectList2", param);
	}
	/**
	 * 월생산실적 조회 금형
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		
		return  super.commonDao.list("pmr210skrvServiceImpl.selectList3", param);
	}
}
