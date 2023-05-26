package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hat900skr_shService")
public class S_Hat900skr_shServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_sh")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_hat900skr_shServiceImpl.selectList", param);
	}

}
