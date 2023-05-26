package foren.unilite.modules.human.hrt;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hrt501ukrService")
public class Hrt501ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 사번으로 임원/직원 여부를 판단함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map checkRetroOTKind(Map param) throws Exception {
		return (Map) super.commonDao.queryForObject("hrt501ukrServiceImpl.checkRetroOTKind", param);
	}
	
	/**
	 * 폼데이터  조회(정산내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "human")
	public Object selectFormData01(Map param) throws Exception {
		Object rv = null;
		// 이하 미사용 - 프로시져에 포함
//		String retrDate = super.commonDao.select("hrt501ukrServiceImpl.checkRetrDate", param).toString();
//		String retrType = param.get("RETR_TYPE").toString();
//		if (retrType.equals("R") && retrDate.equals("00000000") || retrType.equals("M") && !retrDate.equals("00000000")) {
//			throw new Exception("퇴직금계산은 퇴직자만 가능합니다.");
//		}
//		// 정산내역이 있는지 확인함
//		int hrtCnt = (int) super.commonDao.select("hrt501ukrServiceImpl.checkHrtCnt", param);
//		if (hrtCnt > 0) {
//			rv = super.commonDao.select("hrt501ukrServiceImpl.selectFormData01CNT", param);
//		} else {
//			
//		}
		
		String ERROR_CODE = "";
		String RETURN_VALUE = "";
		String reload = param.get("RELOAD").toString();
		
		if (reload.equals("N")) {
			Map result = (Map) super.commonDao.select("hrt501ukrServiceImpl.selectFormData01", param);
			ERROR_CODE = result.get("ERROR_CODE") == null ? null : result.get("ERROR_CODE").toString();
			RETURN_VALUE = result.get("RETURN_VALUE") == null ? null : result.get("RETURN_VALUE").toString();
		} else {
			// reload인 경우 무조건 temp테이블을 조회함
			ERROR_CODE = null;
			RETURN_VALUE = "1";
		}
		
		if (RETURN_VALUE.equals("1") && ERROR_CODE == null) {
			rv = super.commonDao.select("hrt501ukrServiceImpl.selectFormDataResult", param);
		} else {
			throw new Exception("");
		}
		return rv;
	}
	
	/**
	 * (정산내역)폼 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hrt")
	public ExtDirectFormPostResult submitFormData01(Hrt501ukrModel hrt501ukrModel, LoginVO loginVO, BindingResult result) throws Exception {
		hrt501ukrModel.setS_COMP_CODE(loginVO.getCompCode());
		hrt501ukrModel.setS_USER_ID(loginVO.getUserID());
		super.commonDao.update("hrt501ukrServiceImpl.submitFormData01", hrt501ukrModel);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
	
	/**
	 * 폼데이터  조회(근속내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
	public Object selectFormData02(Map param) throws Exception {
		Object rv = super.commonDao.select("hrt501ukrServiceImpl.selectFormData02", param);
		return rv;
	}
	
	/**
	 * 급여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList01(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList01", param);
	}
	
	/**
	 * 기타수당내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList02(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList02", param);
	}
	
	/**
	 * 상여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList03(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList03", param);
	}
	
	/**
	 * 년월차내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList04(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList04", param);
	}
	
	/**
	 * 년월차내역 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map> insertList04(List<Map> paramList, LoginVO loginVO) throws Exception {

		for(Map param : paramList ) {
			param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
			super.commonDao.insert("hrt501ukrServiceImpl.insertList04", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함(년월차 내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> updateList04(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hrt501ukrServiceImpl.updateList04", param);
		}
		return paramList;
	}
	
	/**
	 * 산정내역(임원) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList05(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList05", param);
	}
	
	/**
	 * 중간정산 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList06(Map param) throws Exception {
		return (List) super.commonDao.list("hrt501ukrServiceImpl.selectList06", param);
	}
	
	/**
	 * 지급총액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> fnSuppTotI(Map param) throws Exception {
		return (Map) super.commonDao.select("hrt501ukrServiceImpl.fnSuppTotI", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	
}
	
