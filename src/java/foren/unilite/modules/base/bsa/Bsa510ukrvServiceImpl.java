package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("bsa510ukrvService")
public class Bsa510ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "tlabMenuService")
	TlabMenuService tlabMenuService;
	
	@ExtDirectMethod(group = "Base")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("bsa510ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "Base")
	public Map  insert(Map param, LoginVO user) throws Exception {				
		super.commonDao.insert("bsa510ukrvService.insert", param);		
		tlabMenuService.reload();
		return  param;
	}	

	
	@ExtDirectMethod(group = "Base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	

}
