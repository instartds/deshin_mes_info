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

@Service("afb520skrService")
public class Afb520skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("afb520skrServiceImpl.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectDeptBudg(Map param) throws Exception {		
		super.commonDao.list("afb520skrServiceImpl.selectAmtPoint", param);
		return super.commonDao.select("afb520skrServiceImpl.selectDeptBudg", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// AMT_POINT 값
	public List<Map<String, Object>>  selectAmtPoint(Map param) throws Exception {	
		return  super.commonDao.list("afb520skrServiceImpl.selectAmtPoint", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// REF_CODE1 값
	public List<Map<String, Object>>  selectRefCode1(Map param) throws Exception {	
		return  super.commonDao.list("afb520skrServiceImpl.selectRefCode1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		super.commonDao.list("afb520skrServiceImpl.selectBudgName", param);
		if(super.commonDao.list("afb520skrServiceImpl.selectAmtPoint", param).equals("1")) {
			param.put("sSqlAmtPoint", ", 0, 1)");
		} else if(super.commonDao.list("afb520skrServiceImpl.selectAmtPoint", param).equals("2")) {
			param.put("sSqlAmtPoint", "+0.0045, 0, 1)");
		} else {
			param.put("sSqlAmtPoint", ", 0)");
		}
		if(super.commonDao.list("afb520skrServiceImpl.selectRefCode1", param).equals("1")) {
			param.put("sSqlRefCode1", ", 2, 1)");
		} else if(super.commonDao.list("afb520skrServiceImpl.selectRefCode1", param).equals("2")) {
			param.put("sSqlRefCode1", "+0.0045, 2, 1)");
		} else {
			param.put("sSqlRefCode1", ", 2)");
		}
		return  super.commonDao.list("afb520skrServiceImpl.selectList", param);
	}

}
