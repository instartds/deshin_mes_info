package foren.unilite.modules.human.hrt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.human.hpa.Hpa330ukrModel;


@Service("hrt502ukrService")
public class Hrt502ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 추가/데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
	public Object selectList(Map param) throws Exception {
		Object rv = super.commonDao.select("hrt502ukrServiceImpl.selectList", param);
		
		return rv;
	}
	
	/**
	 * 지급총액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	public Object fnSuppTotI(Map param) throws Exception {		
//		Object rv = null;
//		Map m = new HashMap();
//		m = (Map) super.commonDao.select("hrt502ukrServiceImpl.fnSuppTotI", param);
//		
//		String ERROR_CODE = m.get("ERROR_CODE").toString();
//		String RETURN_VALUE = m.get("RETURN_VALUE").toString();
//		
//		if(RETURN_VALUE.equals("1") && ERROR_CODE == null){
//			rv = super.commonDao.select("hrt502ukrServiceImpl.selectFormDataResult", param);
//		}else{
//			throw new Exception("");
//		}
//		
//		return rv;
//		
//	}
	public Map<String, Object> fnSuppTotI(Map param) throws Exception {		
		return (Map) super.commonDao.select("hrt502ukrServiceImpl.fnSuppTotI", param);
		
	}
	
	/**
	 * 중간지급-퇴직급여,비과세퇴직급여,과세대상퇴직급여 계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> fnDateChanged(Map param) throws Exception {
		String M_CALCU_END_DATE;
		String M_RETR_DATE;
		String R_CALCU_END_DATE;
		String R_RETR_DATE;
		
		if(!param.get("M_CALCU_END_DATE").equals("")){
			M_CALCU_END_DATE = ((String) param.get("M_CALCU_END_DATE")).replace("-", "").substring(0, 8);
			param.put("M_CALCU_END_DATE", M_CALCU_END_DATE);
		}
		if(!param.get("M_RETR_DATE").equals("")){
			M_RETR_DATE = ((String) param.get("M_RETR_DATE")).replace("-", "").substring(0, 8);
			param.put("M_RETR_DATE", M_RETR_DATE);
		}
		if(!param.get("R_CALCU_END_DATE").equals("")){
			R_CALCU_END_DATE = ((String) param.get("R_CALCU_END_DATE")).replace("-", "").substring(0, 8);
			param.put("R_CALCU_END_DATE", R_CALCU_END_DATE);
		}
		if(!param.get("R_RETR_DATE").equals("")){
			R_RETR_DATE = ((String) param.get("R_RETR_DATE")).replace("-", "").substring(0, 8);
			param.put("R_RETR_DATE", R_RETR_DATE);
		}			
		
		return (Map) super.commonDao.select("hrt502ukrServiceImpl.fnDateChanged", param);
		
	}
	
	
	/**
	 * 폼 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hrt")
	public ExtDirectFormPostResult form01Submit(Hrt502ukrModel hrt502ukrModel, LoginVO loginVO, BindingResult result) throws Exception {
		hrt502ukrModel.setS_COMP_CODE(loginVO.getCompCode());
		hrt502ukrModel.setS_USER_ID(loginVO.getUserID());	
		
		super.commonDao.update("hrt502ukrServiceImpl.form01update", hrt502ukrModel);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
}
	
