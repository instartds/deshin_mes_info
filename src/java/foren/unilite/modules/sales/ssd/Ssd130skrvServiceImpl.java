package foren.unilite.modules.sales.ssd;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssd130skrvService")
public class Ssd130skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입조건별 매출현황 조회 (분류별 ssd110skrv )
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {	
		return  super.commonDao.list("ssd130skrvServiceImpl.selectList1", param);

	}
	
	/**
	 * 매입조건별 매출현황 조회 (제품별 ssd120skrv )
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		return  super.commonDao.list("ssd130skrvServiceImpl.selectList2", param);

	}
	
	/**
	 * 매입조건별 매출현황 조회 (매출처별 ssa760skrv )
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {	
		return  super.commonDao.list("ssd130skrvServiceImpl.selectList3", param);

	}
	
}
