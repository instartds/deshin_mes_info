package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("s_mms200skrv_shService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_mms200skrv_shServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 레포트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map<String, Object>> printList(Map param) throws Exception{
		return super.commonDao.list("s_mms200skrv_shServiceImpl.printList", param);
	}


}
