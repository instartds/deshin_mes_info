package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_biv330skrv_inService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_biv330skrv_inServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미수금현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_biv330skrv_inServiceImpl.selectList", param);
	}
}
