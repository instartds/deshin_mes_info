package foren.unilite.modules.base.bsa;

import java.io.Console;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("bsa900skrvService")
public class Bsa900skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 사용자별 권한조회 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	

	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("bsa900skrvServiceImpl.selectList", param);
	}
			
}
