package foren.unilite.modules.nbox.link;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxLinkCommonService")
public class NboxLinkCommonServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * o조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "nbox")
	public Map selectLinkComboList(Map param, LoginVO user) throws Exception {
		logger.debug("\n nboxLinkCommonService.selectLinkComboList: {}", param );
		
		String dbms = ConfigUtil.getString("common.dbms", "");
		
		Map rv = new HashMap();
		Map param1 = new HashMap();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				
		list = super.commonDao.list("nboxLinkCommonService.selectLinkComboList", param);
        
		rv.put("records", list);
		
		return rv;
	}	
	
}
