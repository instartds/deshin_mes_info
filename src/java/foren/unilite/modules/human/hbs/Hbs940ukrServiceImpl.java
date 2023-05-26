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

@Service("hbs940ukrService")
public class Hbs940ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param) throws Exception {
		return (int)super.commonDao.update("hbs940ukrServiceImpl.doBatch", param);
		
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectCloseyymm(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("hbs940ukrServiceImpl.selectCloseyymm", param);
	}
	/*@Transactional(readOnly = true)
		@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
		public String doBatch(Map param) throws Exception {
			return super.commonDao.update("hbs910ukrServiceImpl.doBatch", param)+"";
			
		}*/
}
