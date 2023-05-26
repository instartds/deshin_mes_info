package foren.unilite.modules.vmi;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("vmiCommonService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class VmiCommonServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 외부사용자정보 사용자레벨 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "vmi", value = ExtDirectMethodType.STORE_READ)
	public Object getVmiUserLevel(Map param) throws Exception {	

		return super.commonDao.select("vmiCommonServiceImpl.getVmiUserLevel", param);
	}


}
