package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sfa100skrv_kdService")
public class S_sfa100skrv_kdServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 *거래처원장조회-일별 : 그리드 조회 목록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {

		return  super.commonDao.list("s_sfa100skrv_kdServiceImpl.selectList1", param);
	}
}