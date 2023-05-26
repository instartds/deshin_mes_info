package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa990ukrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hpa990ukrServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * get TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map selectDefaultTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("hpa990ukrServiceImpl.selectDefaultTaxYM", param);
	}

	/**
	 * get TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map selectTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("hpa990ukrServiceImpl.selectTaxYM", param);
	}

	/**
	 * 원천징수내역  / 납부세액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("sTaxYM", taxYM.get("sTaxYM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpa990ukrServiceImpl.selectList1", param);
	}

	/**
	 * 환급액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1_2(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		return (List) super.commonDao.list("hpa990ukrServiceImpl.selectList1_2", param);
	}

	/**
	 * 부표-거주자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("sTaxYM", taxYM.get("sTaxYM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpa990ukrServiceImpl.selectList2", param);
	}

	/**
	 * 부표-비거주자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("sTaxYM", taxYM.get("sTaxYM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpa990ukrServiceImpl.selectList3", param);
	}

	/**
	 * 부표-법인원천 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("sTaxYM", taxYM.get("sTaxYM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpa990ukrServiceImpl.selectList4", param);
	}


	
	/**
	 * 자료를 생성함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")	
	public List<Map<String, Object>> createData(Map param, LoginVO user) throws Exception {
//		// 통합신고 체크-> '%' 언체크->신고사업장
//		if (param.get("TAX_DIV_CODE") == null || param.get("TAX_DIV_CODE").equals("")) {
//			param.put("TAX_DIV_CODE", param.get("DIV_CODE"));
//		} else {
//			param.put("TAX_DIV_CODE", "%");
//		}
		// 연말정산포함여부 포함:Y/포함안함:1
		if (param.get("YEAR_TAX_FLAG") == null || param.get("YEAR_TAX_FLAG").equals("")) {
			param.put("YEAR_TAX_FLAG", "1");
		} else {
			param.put("YEAR_TAX_FLAG", "Y");
		}
		return super.commonDao.list("hpa990ukrServiceImpl.createData", param);
	}

	/**
	 * 다시 자료를 생성함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")	
	public List<Map<String, Object>> reCreateData(Map param, LoginVO user) throws Exception {
/*		// 통합신고 체크-> '%' 언체크->신고사업장
		if (param.get("TAX_DIV_CODE") == null || param.get("TAX_DIV_CODE").equals("")) {
			param.put("TAX_DIV_CODE", param.get("DIV_CODE"));
		} else {
			param.put("TAX_DIV_CODE", "%");
		}*/
		// 연말정산포함여부 포함:Y/포함안함:1
		if (param.get("YEAR_TAX_FLAG") == null || param.get("YEAR_TAX_FLAG").equals("")) {
			param.put("YEAR_TAX_FLAG", "1");
		} else {
			param.put("YEAR_TAX_FLAG", "Y");
		}
		
		String errorDesc ="";
		List<Map> errCheck = super.commonDao.list("hpa990ukrServiceImpl.reCreateData", param);
		errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return super.commonDao.list("hpa990ukrServiceImpl.reCreateData", param);
		}
	}

	/**
	 * 원천징수내역
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			if(paramData.get("method").equals("updateList")){
				this.updateList(dataList, dataMaster, user);
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		//마감여부 체크쿼리 호출
		Object checkCloseYn = super.commonDao.select("hpa990ukrServiceImpl.checkCloseYn", paramMaster);
		//마감정보이 되지 않았을 때
		if (ObjUtils.isNotEmpty(checkCloseYn)) {
			throw new  UniDirectValidateException("이미 마감된 자료입니다.");
		}
		for(Map param :paramList ) {
			super.commonDao.update("hpa990ukrServiceImpl.updateList", param);
		}
		return;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		//마감여부 체크쿼리 호출
		Object checkCloseYn = super.commonDao.select("hpa990ukrServiceImpl.checkCloseYn", paramMaster);
		//마감정보이 되지 않았을 때
		if (ObjUtils.isNotEmpty(checkCloseYn)) {
			throw new  UniDirectValidateException("이미 마감된 자료입니다.");
		}
		for(Map param :paramList ) {
			super.commonDao.update("hpa990ukrServiceImpl.insertList", param);
		}
		return;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteList( Map param, LoginVO user) throws Exception{
		if(param.get("STATE_TYPE") == null || param.get("STATE_TYPE").equals("")){
			param.put("STATE_TYPE", "1");
		} else {
			param.put("STATE_TYPE", "Y");
		}
		super.commonDao.update("hpa990ukrServiceImpl.deleteList", param);
		return;
	}



	/**
	 * 원천징수내역_2
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			if(paramData.get("method").equals("updateList1_2"))	
				this.updateList1_2(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateList1_2(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList ) {
			super.commonDao.update("hpa990ukrServiceImpl.updateList1_2", param);
		}
		return;
	}

	/**
	 * 부표-거주자
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");

			if(paramData.get("method").equals("insertList"))
				this.insertList(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateList"))
				this.updateList(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * 부표-비거주자
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertList"))
				this.insertList(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateList"))
				this.updateList(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * 부표-법인원천
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			
			if(paramData.get("method").equals("insertList"))
				this.insertList(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateList"))
				this.updateList(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}




	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(Main Data 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printMainData(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.printMainData", param);
	}

	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(원천징수 명세 및 납부세액 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.printDetailData", param);
	}

	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(환급세액 데이터 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> refundedAaxAmt(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.refundedAaxAmt", param);
	}

	/**
	 * 20200831 - CLIP REPORT 관련로직 추가(주민세 합계 계산)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> calResidentTax(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.calResidentTax", param);
	}

	/**
	 * 20210128 - CLIP REPORT 관련로직 추가(주민세 납부 신고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printResidentNapTax(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.printResidentNapTax", param);
	}

	/**
	 * 20210128 - CLIP REPORT 관련로직 추가(주민세 종업원분 신고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printResidentEmployee(Map param) throws Exception {
		return super.commonDao.list("hpa990ukrServiceImpl.printResidentEmployee", param);
	}
}