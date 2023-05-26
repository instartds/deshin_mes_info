package foren.unilite.modules.human.hpc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpc950ukrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hpc950ukrServiceImpl extends TlabAbstractServiceImpl {
	public final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * get TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map selectDefaultTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("hpc950ukrServiceImpl.selectDefaultTaxYM", param);
	}

	/**
	 * get TaxYM
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map selectTaxYM(Map param) throws Exception {
		return (Map) super.commonDao.select("hpc950ukrServiceImpl.selectTaxYM", param);
	}
	
	/**
	 * 원천징수이행상황신고서 세부내역
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Map selectStatus(Map param) throws Exception {
		return (Map) super.commonDao.select("hpc950ukrServiceImpl.selectStatus", param);
	}
	
	/**
	 * 원천징수내역  / 납부세액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSearchList(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectSearchList", param);
	}
	
	/**
	 * 원천징수내역  / 납부세액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		
		
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("TAX_YYYYMM", taxYM.get("TAX_YYYYMM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectList1", param);
	}

	/**
	 * 환급액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1_2(Map param) throws Exception {
		
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectList1_2", param);
	}
	

	
	/**
	 * 부표-거주자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("TAX_YYYYMM", taxYM.get("TAX_YYYYMM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectList2", param);
	}

	/**
	 * 부표-비거주자 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("TAX_YYYYMM", taxYM.get("TAX_YYYYMM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectList3", param);
	}

	/**
	 * 부표-법인원천 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		
		Map taxYM = selectTaxYM(param);
		if(ObjUtils.isNotEmpty(taxYM)){
			param.put("TAX_YYYYMM", taxYM.get("TAX_YYYYMM"));
		}else{
			throw new  UniDirectValidateException("원천징수이행상황신고의 코드가 존재하지 않습니다.\n해당코드를 먼저 입력해 주십시오.");
		}
		return (List) super.commonDao.list("hpc950ukrServiceImpl.selectList4", param);
	}


	
	/**
	 * 자료를 생성함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public Map  createData(Map param, LoginVO user) throws Exception {

		if(ObjUtils.isEmpty(param.get("ALL_DIV_YN")))	{
			param.put("ALL_DIV_YN", "N");
		}
		Map r = (Map) super.commonDao.queryForObject("hpc950ukrServiceImpl.createData", param);
		if(!"".equals(ObjUtils.getSafeString(r.get("ERROR_DESC"))))	{
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(r.get("ERROR_DESC")), user));
		}
		return r;
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
	public void deleteList( Map param, LoginVO user) throws Exception{
		Object checkCloseYn = super.commonDao.select("hpc950ukrServiceImpl.checkCloseYn", param);
		//마감정보이 되지 않았을 때
		if (ObjUtils.isNotEmpty(checkCloseYn)) {
			throw new  UniDirectValidateException("이미 마감된 자료입니다.");
		}
		super.commonDao.update("hpc950ukrServiceImpl.deleteList", param);
		return;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		//마감여부 체크쿼리 호출
		Object checkCloseYn = super.commonDao.select("hpc950ukrServiceImpl.checkCloseYn", paramMaster);
		//마감정보이 되지 않았을 때
		if (ObjUtils.isNotEmpty(checkCloseYn)) {
			throw new  UniDirectValidateException("이미 마감된 자료입니다.");
		}
		for(Map param :paramList ) {
			if(ObjUtils.isEmpty(param.get("DEF_SP_TAX_I")))	{
				param.put("DEF_SP_TAX_I", 0);
			}
			super.commonDao.update("hpc950ukrServiceImpl.updateList", param);
		}
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
			super.commonDao.update("hpc950ukrServiceImpl.updateList1_2", param);
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
			
			if(paramData.get("method").equals("updateList"))
				this.updateList(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod( group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public Object updateClose( Map param, LoginVO user) throws Exception {
		super.commonDao.update("hpc950ukrServiceImpl.updateClose", param);
		return param;
	}
	/**
	 * 파일 생성전 validation 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public Map createFileExec(Map spParam, LoginVO user) throws Exception {
		
		String path = "";
		
		Map<String, Object> spResult = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		String errorDesc = "";
				
		spResult = (Map) super.commonDao.select("hpc950ukrServiceImpl.createFileExec", spParam);
		errorDesc = (String) spResult.get("ERROR_DESC");
		if(!ObjUtils.isEmpty(errorDesc)){			
			String[] messsage = errorDesc.split(";");
			String errMsg = "";
			if("55208".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서 내역이 없습니다.";
			}else if("55207".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서 HEADER 내역이 없습니다.";
			}else if("55209".equals(messsage[0])){
				errMsg = "원친징수이행상황신고서_부표 내역이 없습니다.";
			}else{
				errMsg = messsage[1];
			}
			
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + errMsg);
		}
		
		String rText = "";
		if(spResult.get("RETURN_TEXT") != null)
			rText = spResult.get("RETURN_TEXT").toString();
		
		result.put("RETURN_TEXT", rText);
		result.put("RETURN_VALUE", "1");
		
	    return result;
	}


	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(Main Data 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printMainData(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.printMainData", param);
	}

	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(원천징수 명세 및 납부세액 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.printDetailData", param);
	}

	/**
	 * 20200814 - CLIP REPORT 관련로직 추가(환급세액 데이터 조회)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> refundedAaxAmt(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.refundedAaxAmt", param);
	}

	/**
	 * 20200831 - CLIP REPORT 관련로직 추가(주민세 합계 계산)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> calResidentTax(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.calResidentTax", param);
	}
	
	/**
	 * 20210128 - CLIP REPORT 관련로직 추가(주민세 납부 신고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printResidentNapTax(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.printResidentNapTax", param);
	}
	
	/**
	 * 20210128 - CLIP REPORT 관련로직 추가(주민세 종업원분 신고)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> printResidentEmployee(Map param) throws Exception {
		return super.commonDao.list("hpc950ukrServiceImpl.printResidentEmployee", param);
	}
}