package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa600skrvService")
public class Ssa600skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *미수채권조회 현황 : 매출채권별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		
		return  super.commonDao.list("ssa600skrvServiceImpl.selectList1", param);
	}
	
	
	/**
	 *미수채권조회 현황 : 계산서발행별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("ssa600skrvServiceImpl.selectList2", param);
	}


	/**
	 *미수채권조회 현황 : 수금예정일 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		
		return  super.commonDao.list("ssa600skrvServiceImpl.selectList3", param);
	}
}
