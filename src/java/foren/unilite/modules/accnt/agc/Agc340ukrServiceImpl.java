package foren.unilite.modules.accnt.agc;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("agc340ukrService")
public class Agc340ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * "손익형황" 그리드에서 "당기제품제조원가"항목을 찾지 못했을 경우 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object fnDispYN(Map param) throws Exception {
		return super.commonDao.select("agc340ukrServiceImpl.fnDispYN", param);
	}
	
	
	
	/**
	 * 
	 * 검색팝업 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRef1(Map param, LoginVO user) throws Exception {
		String reValue = "";
		reValue = param.get("DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		param.put("DIV_CODE", reValue);
		return super.commonDao.list("agc340ukrServiceImpl.selectRef1", param);
	}
	
	/**
	 * 원가대체정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object costInformation(Map param) throws Exception {
		String reValue = "";
		reValue = param.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		param.put("DIV_CODE", reValue);
		return super.commonDao.select("agc340ukrServiceImpl.costInformation", param);
	}
	
	
	/**
	 * 
	 * 손익현황 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param, LoginVO user) throws Exception {
		
		param.put("COST_PD", "2010"); // 용역원가의 '7000 당기용역원가'가 반영될 손익계산서의 '2010 용역매출원가' 항목코드
		
		if(param.get("SEARCH").equals("SEARCH")){
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200T");
			}else{
				param.put("sSrcTbl", "AGB100T");
			}
			
			//조회기간 셋팅
			DateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
			String sFrDate = param.get("FR_DATE")+"01";
			String sToDate = param.get("TO_DATE")+"01";
			
			Date td = null;
			td = transFormat.parse(sToDate);
			
			Calendar calcDate = Calendar.getInstance();
			calcDate.setTime(td);
			calcDate.add(Calendar.MONTH, 1);
			calcDate.add(Calendar.DATE,-1);
			
			sToDate = transFormat.format(calcDate.getTime());
			
			param.put("sFrDate", sFrDate);
			param.put("sToDate", sToDate);
			
			//손익현황
			param.put("sDivi","20");
	//		param.put("dAmt7000","0");
			param.put("sTblName", "##srcTbl"+param.get("sDivi"));
			
			List<Map> accntDivCodeList = new ArrayList<Map>();
			if(param.get("ACCNT_DIV_CODE").equals("")){
				param.put("sDivCode", "''");
			}else{
				accntDivCodeList = (List<Map>) param.get("ACCNT_DIV_CODE");
				param.put("sDivCode", accntDivCodeList.get(0));
			}
			//당월기초 데이터와 원본 table union 하여 temp table 생성
			super.commonDao.list("agc340ukrServiceImpl.fnCreateTable", param);
			
			//당기 데이터 조회하는 SQL문 생성
			param.put("sAccntCd", "");
			
			//최종 SQL 문 생성
			if(param.get("S_REF_ITEM").equals("1")){
				param.put("sItemNm", "ACCNT_NAME2");
				param.put("sAccntNm", "ACCNT_NAME2");
			}else if(param.get("S_REF_ITEM").equals("2")){
				param.put("sItemNm", "ACCNT_NAME3");
				param.put("sAccntNm", "ACCNT_NAME3");
			}else{
				param.put("sItemNm", "ACCNT_NAME");
				param.put("sAccntNm", "AC_FULL_NAME");
			}
			return super.commonDao.list("agc340ukrServiceImpl.fnMakeSQL", param);
		}else{
		
			//String sMatrl_YN = "";
	
			/*//회계기준설정으로부터 원가대체기준 설정내용 확인
			if(super.commonDao.list("agc340ukrServiceImpl.fnGetBaseInfo", param).size()==0){
				throw new  UniDirectValidateException(this.getMessage("54302", user));
			}else{
				List<Map> option1 = (List<Map>) super.commonDao.list("agc340ukrServiceImpl.fnGetBaseInfo", param);
				sMatrl_YN = (String) option1.get(0).get("MATRL_YN");
				param.put("sMatrl_YN", sMatrl_YN);
			}*/
			
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200T");
			}else{
				param.put("sSrcTbl", "AGB100T");
			}
			
			//조회기간 셋팅
			DateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
			String sFrDate = param.get("FR_DATE")+"01";
	//		param.get("FR_DATE")
			String sToDate = param.get("TO_DATE")+"01";
			
			Date td = null;
			td = transFormat.parse(sToDate);
			
			Calendar calcDate = Calendar.getInstance();
			calcDate.setTime(td);
			calcDate.add(Calendar.MONTH, 1);
			calcDate.add(Calendar.DATE,-1);
			
			sToDate = transFormat.format(calcDate.getTime());
			
			param.put("sFrDate", sFrDate);
			param.put("sToDate", sToDate);
			
			/*//원가대체기준이 "재고금액을 참조한다"라고 설정되었을 경우만 실행
			if(sMatrl_YN.equals("1")){
				super.commonDao.list("agc340ukrServiceImpl.fnRefMatrlTbl", param);
			}*/
			
			//손익현황
			param.put("sDivi","20");
	//		param.put("dAmt7000","0");
			param.put("sTblName", "##srcTbl"+param.get("sDivi"));
			
			List<Map> accntDivCodeList = new ArrayList<Map>();
			if(param.get("ACCNT_DIV_CODE").equals("")){
				param.put("sDivCode", "''");
			}else{
				accntDivCodeList = (List<Map>) param.get("ACCNT_DIV_CODE");
				param.put("sDivCode", accntDivCodeList.get(0));
			}
			//당월기초 데이터와 원본 table union 하여 temp table 생성
			super.commonDao.list("agc340ukrServiceImpl.fnCreateTable", param);
			
			//당기 데이터 조회하는 SQL문 생성
			param.put("sAccntCd", "");
			
			//최종 SQL 문 생성
			if(param.get("S_REF_ITEM").equals("1")){
				param.put("sItemNm", "ACCNT_NAME2");
				param.put("sAccntNm", "ACCNT_NAME2");
			}else if(param.get("S_REF_ITEM").equals("2")){
				param.put("sItemNm", "ACCNT_NAME3");
				param.put("sAccntNm", "ACCNT_NAME3");
			}else{
				param.put("sItemNm", "ACCNT_NAME");
				param.put("sAccntNm", "AC_FULL_NAME");
			}
			return super.commonDao.list("agc340ukrServiceImpl.fnMakeSQL", param);
		}
	}	
	
	/**
	 * 
	 * 용역원가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param, LoginVO user) throws Exception {
		if(param.get("SEARCH").equals("SEARCH")){
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200T");
			}else{
				param.put("sSrcTbl", "AGB100T");
			}
			
			//조회기간 셋팅
			DateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
			String sFrDate = param.get("FR_DATE")+"01";
	//		param.get("FR_DATE")
			String sToDate = param.get("TO_DATE")+"01";
			
			Date td = null;
			td = transFormat.parse(sToDate);
			
			Calendar calcDate = Calendar.getInstance();
			calcDate.setTime(td);
			calcDate.add(Calendar.MONTH, 1);
			calcDate.add(Calendar.DATE,-1);
			
			sToDate = transFormat.format(calcDate.getTime());
			
			param.put("sFrDate", sFrDate);
			param.put("sToDate", sToDate);
			
			//제조원가
			param.put("sDivi","31");
			param.put("dAmt7000","0");
			param.put("sTblName", "##srcTbl"+param.get("sDivi"));
			
			List<Map> accntDivCodeList = new ArrayList<Map>();
			if(param.get("ACCNT_DIV_CODE").equals("")){
				param.put("sDivCode", "''");
			}else{
				accntDivCodeList = (List<Map>) param.get("ACCNT_DIV_CODE");
				param.put("sDivCode", accntDivCodeList.get(0));
			}
			//당월기초 데이터와 원본 table union 하여 temp table 생성
			super.commonDao.list("agc340ukrServiceImpl.fnCreateTable", param);
			
			//당기 데이터 조회하는 SQL문 생성
			param.put("sAccntCd", "");
			
			//최종 SQL 문 생성
			if(param.get("S_REF_ITEM").equals("1")){
				param.put("sItemNm", "ACCNT_NAME2");
				param.put("sAccntNm", "ACCNT_NAME2");
			}else if(param.get("S_REF_ITEM").equals("2")){
				param.put("sItemNm", "ACCNT_NAME3");
				param.put("sAccntNm", "ACCNT_NAME3");
			}else{
				param.put("sItemNm", "ACCNT_NAME");
				param.put("sAccntNm", "AC_FULL_NAME");
			}
			return super.commonDao.list("agc340ukrServiceImpl.fnMakeSQL", param);
			
		}else{
		/*String sMatrl_YN = "";
			//회계기준설정으로부터 원가대체기준 설정내용 확인
			if(super.commonDao.list("agc340ukrServiceImpl.fnGetBaseInfo", param).size()==0){
				throw new  UniDirectValidateException(this.getMessage("54302", user));
			}else{
				List<Map> option1 = (List<Map>) super.commonDao.list("agc340ukrServiceImpl.fnGetBaseInfo", param);
				sMatrl_YN = (String) option1.get(0).get("MATRL_YN");
				param.put("sMatrl_YN", sMatrl_YN);
			}*/
			
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200T");
			}else{
				param.put("sSrcTbl", "AGB100T");
			}
			
			//조회기간 셋팅
			DateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
			String sFrDate = param.get("FR_DATE")+"01";
	//		param.get("FR_DATE")
			String sToDate = param.get("TO_DATE")+"01";
			
			Date td = null;
			td = transFormat.parse(sToDate);
			
			Calendar calcDate = Calendar.getInstance();
			calcDate.setTime(td);
			calcDate.add(Calendar.MONTH, 1);
			calcDate.add(Calendar.DATE,-1);
			
			sToDate = transFormat.format(calcDate.getTime());
			
			param.put("sFrDate", sFrDate);
			param.put("sToDate", sToDate);
			
			/*//원가대체기준이 "재고금액을 참조한다"라고 설정되었을 경우만 실행
			if(sMatrl_YN.equals("1")){
				super.commonDao.list("agc340ukrServiceImpl.fnRefMatrlTbl", param);
			}*/
			
			//용역원가
			param.put("sDivi","31");
			param.put("dAmt7000","0");
			param.put("sTblName", "##srcTbl"+param.get("sDivi"));
			
			List<Map> accntDivCodeList = new ArrayList<Map>();
			if(param.get("ACCNT_DIV_CODE").equals("")){
				param.put("sDivCode", "''");
			}else{
				accntDivCodeList = (List<Map>) param.get("ACCNT_DIV_CODE");
				param.put("sDivCode", accntDivCodeList.get(0));
			}
			//당월기초 데이터와 원본 table union 하여 temp table 생성
			super.commonDao.list("agc340ukrServiceImpl.fnCreateTable", param);
			
			//당기 데이터 조회하는 SQL문 생성
			param.put("sAccntCd", "");
			
			//최종 SQL 문 생성
			if(param.get("S_REF_ITEM").equals("1")){
				param.put("sItemNm", "ACCNT_NAME2");
				param.put("sAccntNm", "ACCNT_NAME2");
			}else if(param.get("S_REF_ITEM").equals("2")){
				param.put("sItemNm", "ACCNT_NAME3");
				param.put("sAccntNm", "ACCNT_NAME3");
			}else{
				param.put("sItemNm", "ACCNT_NAME");
				param.put("sAccntNm", "AC_FULL_NAME");
			}
			return super.commonDao.list("agc340ukrServiceImpl.fnMakeSQL", param);
			
		}
	}
	
	/**
	 * 
	 * 용역경비 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param, LoginVO user) throws Exception {
		// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
		if(!param.get("AC_PROJECT_CODE").equals("")){
			param.put("sSrcTbl", "AGB200T");
		}else{
			param.put("sSrcTbl", "AGB100T");
		}
		
		//조회기간 셋팅
		DateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
		String sFrDate = (String) param.get("FR_DATE");
//		param.get("FR_DATE")
		String sToDate = param.get("TO_DATE")+"01";
		
		Date td = null;
		td = transFormat.parse(sToDate);
		
		Calendar calcDate = Calendar.getInstance();
		calcDate.setTime(td);
		calcDate.add(Calendar.MONTH, 1);
		calcDate.add(Calendar.DATE,-1);
		
		sToDate = transFormat.format(calcDate.getTime());
		
		param.put("sFrDate", sFrDate);
		param.put("sToDate", sToDate);
			
		if(param.get("SEARCH").equals("SEARCH")){
			String reValue = "";
			reValue = param.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
			reValue = reValue.replaceAll("\\p{Z}", "");
			reValue = reValue.replaceAll("\\[", "");
			reValue = reValue.replaceAll("\\]", "");
			param.put("ACCNT_DIV_CODE", reValue);
			return super.commonDao.list("agc340ukrServiceImpl.produceBudgetSearch", param);
		}else{
			return super.commonDao.list("agc340ukrServiceImpl.produceBudget", param);
		}
	}
	
	
	
	/**
	 * cancSlipStore(기표취소 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public Integer  cancSlip(Map param, LoginVO user) throws Exception {
		String reValue = "";
		reValue = param.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		param.put("ACCNT_DIV_CODE", reValue);
		param.put("sGubun", "58");
		// Check UserId
		
		String errorCode ="";
		List<Map> errCheck = (List<Map>) super.commonDao.list("agc340ukrServiceImpl.fnagd058Canc", param);
		
		errorCode = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_CODE"));
		
		if(!ObjUtils.isEmpty(errorCode)){
			throw new  UniDirectValidateException(this.getMessage(errorCode, user));
		}
		
		return 0;
	}
	
	/**
	 * 손익현황 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail1")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail1")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail1(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail1(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail1(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 손익현황 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void  insertDetail1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String reValue = "";
		reValue = dataMaster.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		dataMaster.put("ACCNT_DIV_CODE", reValue);

		//전표생성여부, 승인여부 및 결재상신여부 확인
		if(super.commonDao.list("agc340ukrServiceImpl.beforeSaveCheck", dataMaster).size() > 0){
			
			String covExDate = "";
			String covApSts = "";
			String covDraftYn = "";
			
			String covExNumErr = "";
			String covExDateErr = "";
			
			List<Map> checkOption = (List<Map>) super.commonDao.list("agc340ukrServiceImpl.beforeSaveCheck", dataMaster);
			covExDate = (String) checkOption.get(0).get("EX_DATE");
			covApSts  = (String) checkOption.get(0).get("AP_STS");
			covDraftYn = (String) checkOption.get(0).get("DRAFT_YN");
			
			if(covExDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  covExDate.substring(0,4) +"-"+ covExDate.substring(4,6) +"-"+ covExDate.substring(6,8);
			}
			covExNumErr = checkOption.get(0).get("EX_NUM").toString();

			if(!covExDate.isEmpty()){
				throw new  UniDirectValidateException(this.getMessage("54362", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covApSts.equals("2")){
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covDraftYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55329", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}
		}
		
		//원가대체 마스터 삭제
		super.commonDao.delete("agc340ukrServiceImpl.deleteMaster", dataMaster);
		
		//원가대체 디테일 삭제
		super.commonDao.delete("agc340ukrServiceImpl.deleteDetail", dataMaster);
		
		//손익현황 저장
		Map<String, Object> dataList= new HashMap<String, Object>();
		dataList.put("S_COMP_CODE", user.getCompCode());
		dataList.put("S_USER_ID", user.getUserID());
		dataList.put("ST_DATE", dataMaster.get("ST_DATE"));
		dataList.put("FR_DATE", dataMaster.get("FR_DATE"));
		dataList.put("TO_DATE", dataMaster.get("TO_DATE"));
		dataList.put("ACCNT_DIV_CODE", reValue);
		dataList.put("AC_PROJECT_CODE", dataMaster.get("AC_PROJECT_CODE"));
		
		dataList.put("COST_PD", 0);
		dataList.put("COST_GD", 0);
		
		for(Map param :paramList )	{	
			if(param.get("ACCNT_CD").equals("2010")){
				dataList.put("COST_PD", param.get("AMT_I"));
			}
		}
		super.commonDao.update("agc340ukrServiceImpl.insertDetail1", dataList);

		return;
	}	
	
	/**
	 * 손익현황 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return;
	} 
	
	/**
	 * 손익현황 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail1(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 return;
	}
	
	
	
	/**
	 * 용역원가 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail2(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail2(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail2(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 용역원가 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void  insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String reValue = "";
		reValue = dataMaster.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		dataMaster.put("ACCNT_DIV_CODE", reValue);
		
		//제조원가 저장
		Map<String, Object> dataList= new HashMap<String, Object>();
		dataList.put("S_COMP_CODE", user.getCompCode());
		dataList.put("S_USER_ID", user.getUserID());
		dataList.put("ST_DATE", dataMaster.get("ST_DATE"));
		dataList.put("FR_DATE", dataMaster.get("FR_DATE"));
		dataList.put("TO_DATE", dataMaster.get("TO_DATE"));
		dataList.put("ACCNT_DIV_CODE", reValue);
		dataList.put("AC_PROJECT_CODE", dataMaster.get("AC_PROJECT_CODE"));
		
		
		dataList.put("COST_MT", 0);
		dataList.put("COST_SMT", 0);
		dataList.put("COST_ETCMT", 0);
		dataList.put("COST_HR", 0);
		dataList.put("COST_EX", 0);
		dataList.put("COST_PRPD", 0);
		
		for(Map param :paramList )	{/*	
			if(param.get("ACCNT_CD").equals("1100")){
				dataList.put("COST_MT", param.get("AMT_I"));
			}else if(param.get("ACCNT_CD").equals("1200")){
				dataList.put("COST_SMT", param.get("AMT_I"));
			}else if(param.get("ACCNT_CD").equals("1300")){
				dataList.put("COST_ETCMT", param.get("AMT_I"));
			}else if(param.get("ACCNT_CD").equals("2000")){
				dataList.put("COST_HR", param.get("AMT_I"));
			}else if(param.get("ACCNT_CD").equals("3000")){
				dataList.put("COST_EX", param.get("AMT_I"));
			}else */if(param.get("ACCNT_CD").equals("7000")){
				dataList.put("COST_PRPD", param.get("AMT_I"));
			}
		}
		super.commonDao.update("agc340ukrServiceImpl.insertDetail2", dataList);
		
	return;
	}	
	
	/**
	 * 용역원가 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 return;
	} 
	
	/**
	 * 용역원가 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return;
	}
	
	/**
	 * 용역경비 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail3")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail3")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail3(deleteList, user, paramMaster);
			if(insertList != null) this.insertDetail3(insertList, user);
			if(updateList != null) this.updateDetail3(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 용역경비 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		return;
	}	
	
	/**
	 * 용역경비 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail3(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String reValue = "";
		reValue = dataMaster.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		dataMaster.put("ACCNT_DIV_CODE", reValue);
		
		//제조원가 저장
		for(Map param :paramList )	{	
			param.put("S_COMP_CODE", user.getCompCode());
			param.put("S_USER_ID", user.getUserID());
			param.put("ST_DATE", dataMaster.get("ST_DATE"));
			param.put("FR_DATE", dataMaster.get("FR_DATE"));
			param.put("TO_DATE", dataMaster.get("TO_DATE"));
			param.put("ACCNT_DIV_CODE", reValue);
			param.put("AC_PROJECT_CODE", dataMaster.get("AC_PROJECT_CODE"));
			super.commonDao.update("agc340ukrServiceImpl.updateDetail3", param);
		}
		 return;
	} 
	
	/**
	 * 용역경비 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail3(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public void agc340ukrDelA (Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String reValue = "";
		reValue = dataMaster.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		dataMaster.put("ACCNT_DIV_CODE", reValue);

		//전표생성여부, 승인여부 및 결재상신여부 확인
		if(super.commonDao.list("agc340ukrServiceImpl.beforeSaveCheck", dataMaster).size() > 0){
			
			String covExDate = "";
			String covApSts = "";
			String covDraftYn = "";
			
			String covExNumErr = "";
			String covExDateErr = "";
			
			List<Map> checkOption = (List<Map>) super.commonDao.list("agc340ukrServiceImpl.beforeSaveCheck", dataMaster);
			covExDate = (String) checkOption.get(0).get("EX_DATE");
			covApSts  = (String) checkOption.get(0).get("AP_STS");
			covDraftYn = (String) checkOption.get(0).get("DRAFT_YN");
			
			if(covExDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  covExDate.substring(0,4) +"-"+ covExDate.substring(4,6) +"-"+ covExDate.substring(6,8);
			}
			covExNumErr = checkOption.get(0).get("EX_NUM").toString();

			if(!covExDate.isEmpty()){
				throw new  UniDirectValidateException(this.getMessage("54362", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covApSts.equals("2")){
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covDraftYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55329", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}
		}
		
		//원가대체 마스터 삭제
		super.commonDao.delete("agc340ukrServiceImpl.deleteMaster", dataMaster);
		
		//원가대체 디테일 삭제
		super.commonDao.delete("agc340ukrServiceImpl.deleteDetail", dataMaster);
	}
}
