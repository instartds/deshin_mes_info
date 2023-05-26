package foren.unilite.modules.sales.sof;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sof320skrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sof320skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 영업진행현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("sof320skrvServiceImpl.selectList", param);
	}
	
	/**
	 * 영업진행현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("sof320skrvServiceImpl.selectList2", param);
	}
	
}
