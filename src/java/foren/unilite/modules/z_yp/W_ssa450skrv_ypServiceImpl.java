package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("w_ssa450skrv_ypService")
public class W_ssa450skrv_ypServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 매출현황- 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		
		return  super.commonDao.list("w_ssa450skrv_ypServiceImpl.selectList1", param);
	}
}
