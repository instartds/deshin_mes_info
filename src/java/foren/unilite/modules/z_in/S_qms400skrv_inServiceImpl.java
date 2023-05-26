package foren.unilite.modules.z_in;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_qms400skrv_inService")
public class S_qms400skrv_inServiceImpl extends TlabAbstractServiceImpl{

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_in")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List rv = super.commonDao.list("s_qms400skrv_inServiceImpl.getDataList", param);
		return  rv;
	}	
}
