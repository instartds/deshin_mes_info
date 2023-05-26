package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmp900rkrv_inService")
public class S_pmp900rkrv_inServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param 오토라벨러 출력
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pmp900rkrv_inServiceImpl.getDataList", param);
	}
}
