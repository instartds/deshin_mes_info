package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa626skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Ssa626skrvServiceImpl  extends TlabAbstractServiceImpl {

	/** 거래처원장조회(매출/매입) : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("ssa626skrvServiceImpl.selectList1", param);
	}

	/** 20210429 추가: 거래처원장조회(매출/매입) : 상세 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("ssa626skrvServiceImpl.selectList2", param);
	}


	/**
	 * 상세정보 조회 쿼리 - 20210512 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailInfo(Map param) throws Exception {
		return super.commonDao.list("ssa626skrvServiceImpl.selectDetailInfo", param);
	}
}