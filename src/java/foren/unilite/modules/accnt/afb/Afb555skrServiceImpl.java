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

@Service("afb555skrService")
public class Afb555skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("afb555skrServiceImpl.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectDeptBudg(Map param) throws Exception {		
		super.commonDao.list("afb555skrServiceImpl.selectAmtPoint", param);
		return super.commonDao.select("afb555skrServiceImpl.selectDeptBudg", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// AMT_POINT 값
	public List<Map<String, Object>>  selectAmtPoint(Map param) throws Exception {	
		return  super.commonDao.list("afb555skrServiceImpl.selectAmtPoint", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		//super.commonDao.list("afb555skrServiceImpl.selectBudgName", param);
		return  super.commonDao.list("afb555skrServiceImpl.selectList", param);
	}

}
