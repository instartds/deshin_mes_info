package foren.unilite.modules.z_kocis;

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
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_hbs920ukrService_KOCIS")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Hbs920ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")		
	public List<Map<String, Object>>  selectCloseyymm(Map param) throws Exception {	
		return  super.commonDao.list("s_hbs920ukrServiceImpl_KOCIS.selectCloseyymm", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")		
	public List<Map<String, Object>>  personalCloseYn(Map param) throws Exception {	
		return  super.commonDao.list("s_hbs920ukrServiceImpl_KOCIS.personalCloseYn", param);
	}


	
//	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param, LoginVO user) throws Exception {
//		logger.debug("param    ::::="+ param);
		try {
			super.commonDao.update("s_hbs920ukrServiceImpl_KOCIS.doBatch", param);
			
		} catch (Exception e){
			throw new  UniDirectValidateException("마감작업 중 오류가 발생했습니다.");
		}
		
		return 0;
	}
}