package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq400skrvService")
public class Srq400skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 출하대기현황 조회 (완제품 납품)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("srq400skrvServiceImpl.selectList1", param);
	}

	/**
	 * 출하대기현황 조회 (임가공자제출고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("srq400skrvServiceImpl.selectList2", param);
	}
}