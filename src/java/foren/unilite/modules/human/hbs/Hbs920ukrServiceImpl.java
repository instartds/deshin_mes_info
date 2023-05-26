package foren.unilite.modules.human.hbs;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hbs920ukrService")
public class Hbs920ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param) throws Exception {
		return (int)super.commonDao.update("hbs920ukrServiceImpl.doBatch", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")		
	public List<Map<String, Object>>  selectCloseyymm(Map param) throws Exception {	
		return  super.commonDao.list("hbs920ukrServiceImpl.selectCloseyymm", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")		
	public List<Map<String, Object>>  personalCloseYn(Map param) throws Exception {	
		return  super.commonDao.list("hbs920ukrServiceImpl.personalCloseYn", param);
	}

/*	public String (Map param, LoginVO user) throws Exception {
		return super.commonDao.queryForObject("hbs920ukrServiceImpl.selectCloseyymm", param).toString();
	}
*/	
/*@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public String doBatch(Map param) throws Exception {
		return super.commonDao.update("hbs910ukrServiceImpl.doBatch", param)+"";
		
	}*/
}
