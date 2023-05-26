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

@Service("bsa950ukrvService")
public class Bsa950ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("bsa950ukrvService.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("bsa950ukrvService.selectDetailList", param);
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map> update(List<Map> paramList, LoginVO user ) throws Exception {
		for(Map param :paramList )	{			
			param.put("S_USER_ID", user.getUserID());
			super.commonDao.update("bsa950ukrvService.update", param);
		}
		 return paramList;
	}
		
	@ExtDirectMethod(group = "base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	

}
