package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_srq400skrv_shService")
public class S_srq400skrv_shServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 출하대기현황 조회 (완제품 납품)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_srq400skrv_shServiceImpl.selectList1", param);
	}

	/**
	 * 출하대기현황 조회 (임가공자제출고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("s_srq400skrv_shServiceImpl.selectList2", param);
	}
}