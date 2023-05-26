package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sgp100skrv_kdService")
public class S_sgp100skrv_kdServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_sgp100skrv_kdService.selectList", param);
	}
}
