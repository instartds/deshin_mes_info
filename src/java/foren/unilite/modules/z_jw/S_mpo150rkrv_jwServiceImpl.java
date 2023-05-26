package foren.unilite.modules.z_jw;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_mpo150rkrv_jwService")
public class S_mpo150rkrv_jwServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_jw")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_mpo150rkrv_jwServiceImpl.mainReport", param);
	}
}
