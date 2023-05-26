package foren.unilite.modules.accnt.afb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("afb720skrService")
public class Afb720skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck1(Map param) throws Exception {
		return super.commonDao.select("afb720skrServiceImpl.selectCheck1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectbizGubunAll(Map param, LoginVO loginVO) throws Exception {	
		return  super.commonDao.list("afb720skrServiceImpl.selectbizGubunAll", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectbizGubun(Map param, LoginVO loginVO) throws Exception {	
		return  super.commonDao.list("afb720skrServiceImpl.selectbizGubun", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
//		super.commonDao.list("afb720skrServiceImpl.selectBudgName", param);
		
		
		
		
		
		
		
		
		return  super.commonDao.list("afb720skrServiceImpl.selectList", param);
	}
}
