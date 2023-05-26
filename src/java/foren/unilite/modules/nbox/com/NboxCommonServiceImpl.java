package foren.unilite.modules.nbox.com;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxCommonService")
public class NboxCommonServiceImpl extends TlabAbstractServiceImpl implements NboxCommonService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	/**
	 * 공통코드 List 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "nbox")
	public Map selectCommonCode(Map param) throws Exception {
		logger.debug("\n nboxCommonService.selectCommonCode: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxCommonService.selectCommonCode", param);
		rv.put("records", list);
		
		return rv;
	}	
	
	@ExtDirectMethod(group = "nbox")
	public Map selectUserInfo(Map param) throws Exception {
		logger.debug("\n selectUserInfo: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxCommonService.selectUserInfo", param);
		rv.put("records", list);

		return rv;
	}
	
	
	@ExtDirectMethod(group = "nbox")
	public Map selectDivInfo(Map param) throws Exception {
		logger.debug("\n selectDivInfo: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxCommonService.selectDivInfo", param);
		rv.put("records", list);

		return rv;
	}
	
	
}
