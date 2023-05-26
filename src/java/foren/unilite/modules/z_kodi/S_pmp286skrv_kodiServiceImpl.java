package foren.unilite.modules.z_kodi;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmp286skrv_kodiService")
public class S_pmp286skrv_kodiServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmp286skrv_kodiServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("s_pmp286skrv_kodiServiceImpl.selectList2", param);
	}

}
