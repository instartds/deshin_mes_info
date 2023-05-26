package foren.unilite.modules.accnt.afd;

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

@Service("afd650ukrService")
public class Afd650ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param) throws Exception {
		return (int)super.commonDao.update("afd650ukrServiceImpl.doBatch", param);
		
	}
	
	@Transactional(readOnly = true)
    @ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
    public int donBatch(Map param) throws Exception {
        return (int)super.commonDao.update("afd650ukrServiceImpl.donBatch", param);
        
    }
}
