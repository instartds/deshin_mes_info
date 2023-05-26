package foren.unilite.modules.z_kocis;

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

@Service("s_afb540skrService_KOCIS")
public class S_Afb540skrServiceImpl_KOCIS  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 집계구분 셋팅
	public List<Map<String, Object>>  selectChargeGubun(Map param) throws Exception {	
		return  super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectChargeGubun", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectDeptBudg(Map param) throws Exception {		
		super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectAmtPoint", param);
		return super.commonDao.select("s_afb540skrServiceImpl_KOCIS.selectDeptBudg", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// AMT_POINT 값
	public List<Map<String, Object>>  selectAmtPoint(Map param) throws Exception {	
		return  super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectAmtPoint", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 메인
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectBudgName", param);
		String AMT_POINT = "";
		String BUDG_BASE = "";
		List<Map> selectAmtPointBudgBase = (List<Map>) super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectAmtPoint", param);
		AMT_POINT = (String) selectAmtPointBudgBase.get(0).get("AMT_POINT");
		BUDG_BASE = (String) selectAmtPointBudgBase.get(0).get("BUDG_BASE");
		param.put("sSqlAmtPoint", AMT_POINT);
		param.put("sSqlBudgBase", BUDG_BASE);
		
		if(AMT_POINT.equals("1")) {
			param.put("sSqlAmtPoint", ", 0, 1)");
		} else if(AMT_POINT.equals("2")) {
			param.put("sSqlAmtPoint", "+0.0045, 0, 1)");
		} else {
			param.put("sSqlAmtPoint", ", 0)");
		}

		return  super.commonDao.list("s_afb540skrServiceImpl_KOCIS.selectList", param);
	}

}
