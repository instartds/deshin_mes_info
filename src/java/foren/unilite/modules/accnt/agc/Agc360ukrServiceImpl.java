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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("agc360ukrService")
public class Agc360ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * "손익형황" 그리드에서 "당기제품제조원가"항목을 찾지 못했을 경우 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object fnDispYN(Map param) throws Exception {
		return super.commonDao.select("agc360ukrServiceImpl.fnDispYN", param);
	}

	
	/**
	 * 
	 * 손익현황 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> profitStatus(Map param, LoginVO user) throws Exception {
		
		if(param.get("SEARCH").equals("SEARCH")){
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200TV");
			}else{
				param.put("sSrcTbl", "AGB100TV");
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
			super.commonDao.list("agc360ukrServiceImpl.fnCreateTable", param);
			
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
			return super.commonDao.list("agc360ukrServiceImpl.fnMakeSQL", param);
		}else{
		
			String sMatrl_YN = "";
	
			//회계기준설정으로부터 원가대체기준 설정내용 확인
			if(super.commonDao.list("agc360ukrServiceImpl.fnGetBaseInfo", param).size()==0){
				throw new  UniDirectValidateException(this.getMessage("54302", user));
			}else{
				List<Map> option1 = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.fnGetBaseInfo", param);
				sMatrl_YN = (String) option1.get(0).get("MATRL_YN");
				param.put("sMatrl_YN", sMatrl_YN);
			}
			
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200TV");
			}else{
				param.put("sSrcTbl", "AGB100TV");
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
			
			//원가대체기준이 "재고금액을 참조한다"라고 설정되었을 경우만 실행
			if(sMatrl_YN.equals("1")){
				super.commonDao.list("agc360ukrServiceImpl.fnRefMatrlTbl", param);
			}
			
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
			super.commonDao.list("agc360ukrServiceImpl.fnCreateTable", param);
			
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
			return super.commonDao.list("agc360ukrServiceImpl.fnMakeSQL", param);
		}
	}	
	/**
	 * 
	 * 제조원가 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> produceCost(Map param, LoginVO user) throws Exception {
		if(param.get("SEARCH").equals("SEARCH")){
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200TV");
			}else{
				param.put("sSrcTbl", "AGB100TV");
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
			//param.put("sDivi","31");
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
			super.commonDao.list("agc360ukrServiceImpl.fnCreateTable", param);
			
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
			return super.commonDao.list("agc360ukrServiceImpl.fnMakeSQL", param);
			
		}else{
		String sMatrl_YN = "";
			//회계기준설정으로부터 원가대체기준 설정내용 확인
			if(super.commonDao.list("agc360ukrServiceImpl.fnGetBaseInfo", param).size()==0){
				throw new  UniDirectValidateException(this.getMessage("54302", user));
			}else{
				List<Map> option1 = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.fnGetBaseInfo", param);
				sMatrl_YN = (String) option1.get(0).get("MATRL_YN");
				param.put("sMatrl_YN", sMatrl_YN);
			}
			
			// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
			if(!param.get("AC_PROJECT_CODE").equals("")){
				param.put("sSrcTbl", "AGB200TV");
			}else{
				param.put("sSrcTbl", "AGB100TV");
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
			
			//원가대체기준이 "재고금액을 참조한다"라고 설정되었을 경우만 실행
			if(sMatrl_YN.equals("1")){
				super.commonDao.list("agc360ukrServiceImpl.fnRefMatrlTbl", param);
			}
			
			//도급원가
			//param.put("sDivi","31");
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
			super.commonDao.list("agc360ukrServiceImpl.fnCreateTable", param);
			
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
			return super.commonDao.list("agc360ukrServiceImpl.fnMakeSQL", param);
			
		}
	}
	/**
	 * 
	 * 제조경비 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> produceBudget(Map param, LoginVO user) throws Exception {
		// 관리항목(프로젝트) 존재여부에 따라 사용할 테이블 결정
		if(!param.get("AC_PROJECT_CODE").equals("")){
			param.put("sSrcTbl", "AGB200TV");
		}else{
			param.put("sSrcTbl", "AGB100TV");
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
			return super.commonDao.list("agc360ukrServiceImpl.produceBudgetSearch", param);
		}else{
			return super.commonDao.list("agc360ukrServiceImpl.produceBudget", param);
		}
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
		return super.commonDao.list("agc360ukrServiceImpl.selectRef1", param);
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
		return super.commonDao.select("agc360ukrServiceImpl.costInformation", param);
	}
	
	
	/**
	 * cancSlipStore(기표취소 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public void  cancSlip(Map param, LoginVO user) throws Exception {
		String reValue = "";
		reValue = param.get("ACCNT_DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		param.put("ACCNT_DIV_CODE", reValue);
		// Check UserId
		if(super.commonDao.list("agc360ukrServiceImpl.cancSlipCheck1", param).size()==0){ 
			throw new  UniDirectValidateException(this.getMessage("54363", user));
		}
		
		// Check Accept, Draft
		
		List<Map> cancSlipCheck2 = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.cancSlipCheck2", param);
		
		if(cancSlipCheck2.size() ==0){
			throw new  UniDirectValidateException(this.getMessage("54359", user));
		}else{
			
			String covExDate = "";
			
			String covExNumErr = "";
			String covExDateErr = "";
			
			covExDate = (String) cancSlipCheck2.get(0).get("EX_DATE");
			
			if(covExDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  covExDate.substring(0,4) +"-"+ covExDate.substring(4,6) +"-"+ covExDate.substring(6,8);
			}
			covExNumErr = cancSlipCheck2.get(0).get("EX_NUM").toString();
			
			if(cancSlipCheck2.get(0).get("AGREE_YN").equals("Y")){
//				 dicMsg("A0038") & " : " & Format(rsCost("EX_DATE"), "0000-00-00") & vbCrLf & _
//               dicMsg("A0039") & " : " & rsCost("EX_NUM")
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
				
			}
			
			if(cancSlipCheck2.get(0).get("DRAFT_YN").equals("Y")){
//				 dicMsg("A0038") & " : " & Format(rsCost("EX_DATE"), "0000-00-00") & vbCrLf & _
//               dicMsg("A0039") & " : " & rsCost("EX_NUM")
				throw new  UniDirectValidateException(this.getMessage("55329", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
				
			}
			param.put("rsCost_EX_DATE", cancSlipCheck2.get(0).get("EX_DATE"));
			param.put("rsCost_EX_NUM", cancSlipCheck2.get(0).get("EX_NUM"));
		}
		
		
		String checkCloseDate = "";
		
		checkCloseDate = (String) cancSlipCheck2.get(0).get("EX_DATE");
		
		param.put("rsCost_COMP_CODE", cancSlipCheck2.get(0).get("COMP_CODE"));
		param.put("rsCost_CLOSE_DATE", checkCloseDate.substring(0, 6));
		
		List<Map> cancSlipCheck3 = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.cancSlipCheck3", param);
		
		if(cancSlipCheck3.size() ==0){
			throw new  UniDirectValidateException(this.getMessage("54331", user));
		}else{
			
			
			String covExDateErr = "";
			
			if(checkCloseDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  checkCloseDate.substring(0,4) +"-"+ checkCloseDate.substring(4,6) +"-"+ checkCloseDate.substring(6,8);
			}
			
			String covExCloseFgErr = "";
			String covExCloseDate = "";
			String covExCloseDateErr = "";
			
			covExCloseFgErr = (String) cancSlipCheck3.get(0).get("EX_CLOSE_FG");
			covExCloseDate = (String) cancSlipCheck3.get(0).get("EX_CLOSE_DATE");
			
			if(covExCloseDate.isEmpty()){
				covExCloseDateErr = "";
			}else{
				covExCloseDateErr =  covExCloseDate.substring(0,4) +"-"+ covExCloseDate.substring(4,6) +"-"+ covExCloseDate.substring(6,8);
			}
			
			String paramInputDate = "";
			paramInputDate = (String) param.get("INPUT_DATE");
			String paramInputDateErr = "";
			if(paramInputDate.isEmpty()){
				paramInputDateErr = "";
			}else{
				paramInputDateErr =  paramInputDate.substring(0,4) +"-"+ paramInputDate.substring(4,6) +"-"+ paramInputDate.substring(6,8);
			}
			if(cancSlipCheck3.get(0).get("EX_CLOSE_FG").equals("Y")){
//				dicMsg("A0106") & " : " & oRs("EX_CLOSE_FG") & vbCrLf & _
//              dicMsg("A0043") & " : " & Format(oRs("EX_CLOSE_DATE"), "0000-00-00") & vbCrLf & _
//              dicMsg("A0034") & " : " & Format(sExDate, "0000-00-00")
				throw new  UniDirectValidateException(this.getMessage("54332", user)+"\r\n"+"마감구분: "+ covExCloseFgErr+"\r\n"+"마감일자: "+covExCloseDateErr+"\r\n"+"전표일자: "+covExDateErr);
				
			}
			
			if(Integer.parseInt(covExCloseDate) < Integer.parseInt(paramInputDate)){
//				dicMsg("A0106") & " : " & oRs("EX_CLOSE_FG") & vbCrLf & _
//              dicMsg("A0043") & " : " & Format(oRs("EX_CLOSE_DATE"), "0000-00-00") & vbCrLf & _
//              dicMsg("A0107") & " : " & Format(sInputDate, "0000-00-00")
				throw new  UniDirectValidateException(this.getMessage("54332", user)+"\r\n"+"마감구분: "+ covExCloseFgErr+"\r\n"+"마감일자: "+covExCloseDateErr+"\r\n"+"작업일자: "+paramInputDateErr);
				
			}
			
		}
		
		
		List<Map> cancSlipCheck4 = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.cancSlipCheck4", param);
		
		String check2ExDate = "";
		String check2ExNumErr = "";
		String check2ExDateErr = "";
		
		
		check2ExDate = (String) cancSlipCheck2.get(0).get("EX_DATE");
		
		if(check2ExDate.isEmpty()){
			check2ExDateErr = "";
		}else{
			check2ExDateErr =  check2ExDate.substring(0,4) +"-"+ check2ExDate.substring(4,6) +"-"+check2ExDate.substring(6,8);
		}
		check2ExNumErr = cancSlipCheck2.get(0).get("EX_NUM").toString();
		
		if(cancSlipCheck4.size() ==0){
//			dicMsg("A0034") & " : " & Format(rsCost("EX_DATE"), "0000-00-00") & vbCrLf & _
//          dicMsg("A0035") & " : " & rsCost("EX_NUM")
			throw new  UniDirectValidateException(this.getMessage("54313", user)+"\r\n"+"전표일자: "+ check2ExDateErr+"\r\n"+"전표번호: "+check2ExNumErr);
		}else{
			if(cancSlipCheck4.get(0).get("AP_STS").equals("2")){
	//			dicMsg("A0034") & " : " & Format(rsCost("EX_DATE"), "0000-00-00") & vbCrLf & _
	//	        dicMsg("A0035") & " : " & rsCost("EX_NUM")
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"전표일자: "+ check2ExDateErr+"\r\n"+"전표번호: "+check2ExNumErr);
			}
			
		}
		
		super.commonDao.update("agc360ukrServiceImpl.UpdateAGJ110T", param);
		super.commonDao.update("agc360ukrServiceImpl.UpdateAGC360T", param);
		
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
	 * Detail 입력
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
		if(super.commonDao.list("agc360ukrServiceImpl.beforeSaveCheck", dataMaster).size() > 0){
			
			String covExDate = "";
			String covAgreeYn = "";
			String covDraftYn = "";
			
			String covExNumErr = "";
			String covExDateErr = "";
			
			List<Map> checkOption = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.beforeSaveCheck", dataMaster);
			covExDate = (String) checkOption.get(0).get("EX_DATE");
			covAgreeYn = (String) checkOption.get(0).get("AGREE_YN");
			covDraftYn = (String) checkOption.get(0).get("DRAFT_YN");
			
			if(covExDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  covExDate.substring(0,4) +"-"+ covExDate.substring(4,6) +"-"+ covExDate.substring(6,8);
			}
			covExNumErr = checkOption.get(0).get("EX_NUM").toString();

			if(!covExDate.isEmpty()){
				throw new  UniDirectValidateException(this.getMessage("54362", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covAgreeYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covDraftYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55329", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}
		}
		
		//원가대체 마스터 삭제
		super.commonDao.delete("agc360ukrServiceImpl.deleteMaster", dataMaster);
		
		//원가대체 디테일 삭제
		super.commonDao.delete("agc360ukrServiceImpl.deleteDetail", dataMaster);
		
		//손익현황 저장
		Map<String, Object> dataList= new HashMap<String, Object>();
		dataList.put("S_COMP_CODE", user.getCompCode());
		dataList.put("S_USER_ID", user.getUserID());
		dataList.put("ST_DATE", dataMaster.get("ST_DATE"));
		dataList.put("FR_DATE", dataMaster.get("FR_DATE"));
		dataList.put("TO_DATE", dataMaster.get("TO_DATE"));
		dataList.put("ACCNT_DIV_CODE", reValue);
		dataList.put("AC_PROJECT_CODE", dataMaster.get("AC_PROJECT_CODE"));
		
		dataList.put("COST_CD", 0);
		
		for(Map param :paramList )	{	
			if(param.get("ACCNT_CD").equals("2280")){
				dataList.put("COST_CD", param.get("AMT_I"));
			}
		}
		super.commonDao.update("agc360ukrServiceImpl.insertDetail1", dataList);

		 return;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail1(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 return;
	}
	
	/**
	 * 제조원가 저장
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
	 * Detail 입력
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
		dataList.put("COST_HR", 0);
		dataList.put("COST_EX", 0);
		dataList.put("COST_OS", 0);
		dataList.put("COST_HT", 0);
		dataList.put("COST_PRCD", 0);
		
		for(Map param :paramList )	{	
			if(param.get("ACCNT_CD").equals("1000")){
				dataList.put("COST_MT", param.get("AMT_I"));
				
			}else if(param.get("ACCNT_CD").equals("2000")){
				dataList.put("COST_HR", param.get("AMT_I"));
				
			}else if(param.get("ACCNT_CD").equals("3000")){
				dataList.put("COST_EX", param.get("AMT_I"));
				
			}else if(param.get("ACCNT_CD").equals("2800")){
				dataList.put("COST_OS", param.get("AMT_I"));
				
			}else if(param.get("ACCNT_CD").equals("2900")){
				dataList.put("COST_HT", param.get("AMT_I"));
				
			}else if(param.get("ACCNT_CD").equals("7000")){
				dataList.put("COST_PRCD", param.get("AMT_I"));
			}
		}
		super.commonDao.update("agc360ukrServiceImpl.insertDetail2", dataList);
		
	return;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 return;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return;
	}
	
	
	/**
	 * 제조경비 저장
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
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		return;
	}	
	
	/**
	 * Detail 수정
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
			super.commonDao.update("agc360ukrServiceImpl.updateDetail3", param);
		}
		 return;
	} 
	
	/**
	 * Detail 삭제
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
	public void agc360ukrDelA (Map paramMaster, LoginVO user) throws Exception {
		
		
		String reValue = ObjUtils.getSafeString(paramMaster.get("ACCNT_DIV_CODE"));
		reValue = reValue.toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		paramMaster.put("ACCNT_DIV_CODE", reValue);

		//전표생성여부, 승인여부 및 결재상신여부 확인
		if(super.commonDao.list("agc360ukrServiceImpl.beforeSaveCheck", paramMaster).size() > 0){
			
			String covExDate = "";
			String covAgreeYn = "";
			String covDraftYn = "";
			
			String covExNumErr = "";
			String covExDateErr = "";
			
			List<Map> checkOption = (List<Map>) super.commonDao.list("agc360ukrServiceImpl.beforeSaveCheck", paramMaster);
			covExDate = (String) checkOption.get(0).get("EX_DATE");
			covAgreeYn = (String) checkOption.get(0).get("AGREE_YN");
			covDraftYn = (String) checkOption.get(0).get("DRAFT_YN");
			
			if(covExDate.isEmpty()){
				covExDateErr = "";
			}else{
				covExDateErr =  covExDate.substring(0,4) +"-"+ covExDate.substring(4,6) +"-"+ covExDate.substring(6,8);
			}
			covExNumErr = checkOption.get(0).get("EX_NUM").toString();

			if(!covExDate.isEmpty()){
				throw new  UniDirectValidateException(this.getMessage("54362", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covAgreeYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("54341", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}else if(covDraftYn.equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55329", user)+"\r\n"+"결의전표일자: "+ covExDateErr+"\r\n"+"결의전표번호: "+covExNumErr);
			}
		}
		
		//원가대체 마스터 삭제
		super.commonDao.delete("agc360ukrServiceImpl.deleteMaster", paramMaster);
		
		//원가대체 디테일 삭제
		super.commonDao.delete("agc360ukrServiceImpl.deleteDetail", paramMaster);
	}
	
	
}
