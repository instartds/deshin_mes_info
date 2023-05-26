package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa620skrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Ssa620skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *거래처원장조회-세금계산서 : main 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("ssa620skrvServiceImpl.selectList1", param);
	}

	/**
	 *거래처원장조회-세금계산서 : detail 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("ssa620skrvServiceImpl.selectList2", param);
	}
}
