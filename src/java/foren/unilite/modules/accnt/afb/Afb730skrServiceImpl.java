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

@Service("afb730skrService")
public class Afb730skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectCheck(Map param) throws Exception {	
		return  super.commonDao.list("afb730skrServiceImpl.selectCheck", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		
		String lAccDeptUse = "";
		String lChargeGubun = "";
		String lDeptCode = "";
		
		List<Map> selectCheck = (List<Map>) super.commonDao.list("afb730skrServiceImpl.selectCheck", param);
		lAccDeptUse = (String) selectCheck.get(0).get("ACCDEPT_GUBUN");
		lChargeGubun = (String) selectCheck.get(0).get("CHARGE_GUBUN");
		lDeptCode = (String) selectCheck.get(0).get("DEPT_CODE");
		
		param.put("lAccDeptUse", lAccDeptUse);
		param.put("lChargeGubun", lChargeGubun);
		param.put("lDeptCode", lDeptCode);
		
		return super.commonDao.list("afb730skrServiceImpl.selectList", param);
		
	}
}
