package foren.unilite.modules.sales.ssa;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa820skrvService")
public class Ssa820skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 당월 매출조회- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {		
		return  super.commonDao.list("ssa820skrvServiceImpl.selectList1", param);
	}
	
	/**
	 * 월별 위탁수수료 현황- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {		
		return  super.commonDao.list("ssa820skrvServiceImpl.selectList2", param);
	}
	
	/**
	 * 주말 이용현황- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {		
		return  super.commonDao.list("ssa820skrvServiceImpl.selectList3", param);
	}
	
	/**
	 * 매출 상세조회- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return  super.commonDao.list("ssa820skrvServiceImpl.selectList4", param);
	}
	
}
