package foren.unilite.modules.z_kocis;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hrt506ukrService_KOCIS")
@SuppressWarnings({"unchecked", "rawtypes"})
public class S_Hrt506ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 사번으로 임원/직원 여부를 판단함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map checkRetroOTKind(Map param) throws Exception {
		return (Map) super.commonDao.queryForObject("s_hrt506ukrServiceImpl_KOCIS.checkRetroOTKind", param);
	}
	
	
	
	/**
	 * 폼데이터  조회(정산내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
	public Map<String, Object> selectFormData01(Map param, LoginVO user) throws Exception {
		String existYN	= "";											//기존 데이터 존재 확인 변수

		//기존 데이터 있는지 여부 확인
		existYN	= (String) super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.existYN", param);
		
		//조회 전 체크 데이터 param에 추가
		param.put("EXIST_YN", existYN);					//기존데이터 존재 여부
		
		if(existYN.equals("Y") || ObjUtils.isNotEmpty(param.get("SUPP_DATE"))) { 
			Map rv = null;
			rv = (Map) super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.selectFormData01", param);
			if(ObjUtils.isNotEmpty(rv)){
				String errorDesc = (String) rv.get("ERROR_DESC");
				if(!ObjUtils.isEmpty(errorDesc)){
					String[] messsage = errorDesc.split(";");
				    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				}
			} else {
				if (param.get("SUPP_TOT_I") != "Y") {
					throw new  UniDirectValidateException("조회된 데이터가 없습니다.");
				}
			}
			return rv;
		} else {
			throw new  UniDirectValidateException("지급일을 입력하세요.");
		}
	}
	
	/**
	 * (정산내역)폼 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hrt")
	public ExtDirectFormPostResult submitFormData01(S_Hrt506ukrModel_KOCIS s_hrt506ukrModel_KOCIS, LoginVO loginVO, BindingResult result) throws Exception {
		s_hrt506ukrModel_KOCIS.setS_COMP_CODE(loginVO.getCompCode());
		s_hrt506ukrModel_KOCIS.setS_USER_ID(loginVO.getUserID());
		super.commonDao.update("s_hrt506ukrServiceImpl_KOCIS.submitFormData01", s_hrt506ukrModel_KOCIS);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
	/**
	 * (정산내역)폼 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public int deleteFromData01 (Map param, LoginVO loginVO) throws Exception {
		try {
			super.commonDao.update("s_hrt506ukrServiceImpl_KOCIS.deleteFromData01", param);
		
		}catch(Exception e){
			throw new  UniDirectValidateException("삭제 중 오류가 발생했습니다.");
		}
		return 0;
	}


	
	
	
	/**
	 * 급여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList01(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList01", param);
	}
	
	/**
	 * 기타수당내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList02(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList02", param);
	}
	
	/**
	 * 상여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList03(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList03", param);
	}
	
	/**
	 * 년월차내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList04(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList04", param);
	}
	
	/**
	 * 년월차내역 : 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map> insertList04(List<Map> paramList, LoginVO loginVO) throws Exception {

		for(Map param : paramList ) {
			param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
			super.commonDao.insert("s_hrt506ukrServiceImpl_KOCIS.insertList04", param);
		}
		return paramList;
	}
	
	/**
	 * 년월차 내역 : 선택된 행 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> updateList04(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_hrt506ukrServiceImpl_KOCIS.updateList04", param);
		}
		return paramList;
	}


	
	
	
	
	
	/**
	 * 급여/기타수당/상여/년월차 변경시 퇴직급여 재계산 (일단 중지 ///////////////추후 진행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public Map<String, Object> fnRetireProcSTChangedPayment (Map param) throws Exception {
        Calendar cal = Calendar.getInstance();
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyyMMdd");
		
		//param 값을 변수에 입력
	    String	sCompCode			= (String) param.get("S_COMP_CODE"); 
	    String	sPersonNumb		= (String) param.get("PERSON_NUMB"); 
	    String	sRetrType			= (String) param.get("RETR_TYPE"); 
	    String	sRetrOtKind		= "ST";
	    String	sRCalcuEndDate	= (String) param.get("R_CALCU_END_DATE");
	    String	sRetrDate 			= (String) param.get("RETR_DATE");
	    int		dPayAmt			= (int) param.get("dAvgPay3");
	    int		dEtcAmt			= (int) param.get("dAvgEtc3");
		int		dAvgBonusI3		= (int) param.get("AVG_BONUS_I_3");
		int		dAvgYearI3			= (int) param.get("AVG_YEAR_I_3");
	    int		iRLongDays			= (int) param.get("LONG_TOT_DAY");
	    int		iRLongMonths		= (int) param.get("LONG_TOT_MONTH");
	    int		iRLongYears		= (int) param.get("LONG_YEARS");
	    int		iRLongMonth		= (int) param.get("LONG_MONTH");
	    int		iRLongDay			= (int) param.get("LONG_DAY");
	    int		iRDutyYyyy			= (int) param.get("DUTY_YYYY");

        
		Map retireBasicData = (Map) super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.fnGetRetireBasicData", param);
		
		String sDateFr = sRCalcuEndDate;	//최종분 기산일
		String sDateTo = sRetrDate;			//최종분 퇴사일
		
		//계산에 사용할 변수 선언
		String dCalcuDateTo	= "";
		String dToMonEndDay	= "";
		String dCalcuDateFr	= "";
		String dCalcuYearFr 	= "";
		String sCalcuDateFr	= ""; 
		String sCalcuDateTo	= ""; 
		String sCalcuYearFr	= ""; 
        String sToMonEndDay	= ""; 
		int year				= 0;
		int month				= 0;
		int day					= 0;
		int dayOfMonth			= 0;
		int year2				= 0;
		int month2				= 0;
		int dayOfMonth2		= 0;
		int lFrMonWorkDays	= 0;
		int lToMonWorkDays	= 0;
		int lFrMonthDays		= 0;
		int lToMonthDays		= 0;
		
		
		switch ((String) retireBasicData.get("AMT_RANGE")) {
			case "D":												//일자기준 (D)
				//3개월 종료일의 마지막날 (dCalcuDateTo)
				dCalcuDateTo = sDateTo;
				
				//3개월 종료월의 말일 (dToMonEndDay)
				year	= ObjUtils.parseInt(dCalcuDateTo.substring(0, 4));
				month	= ObjUtils.parseInt(dCalcuDateTo.substring(4, 6)) - 1;
				day		= ObjUtils.parseInt(dCalcuDateTo.substring(6, 8));
				cal.set(year, month, day+1);
				dayOfMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
				dToMonEndDay = dCalcuDateTo.substring(0, 6) + dayOfMonth;
				
				//3개월전 시작월의 시작일 (dCalcuDateFr)
				cal.add(Calendar.MONTH, -2);
				dCalcuDateFr = dateFormatter.format(cal.getTime());

				//1년 시작월 (dCalcuYearFr)
				cal.add(Calendar.MONTH, -9);
				dCalcuYearFr = dateFormatter.format(cal.getTime());
				
				//위에서 계산한 값 변수에 입력
	            sCalcuDateFr = dCalcuDateFr;
	            sCalcuDateTo = dCalcuDateTo;
	            sCalcuYearFr = dCalcuYearFr;
	            sToMonEndDay = dToMonEndDay;

	            
	            //3개월 시작월의 근무일수 (lFrMonWorkDays)
				year2			= ObjUtils.parseInt(dCalcuDateFr.substring(0, 4));
				month2			= ObjUtils.parseInt(dCalcuDateFr.substring(4, 6)) - 1;
				cal.set(year2, month2, 1);
				dayOfMonth2		= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
				lFrMonWorkDays	= dayOfMonth2 - ObjUtils.parseInt(dCalcuDateFr.substring(6, 8)) + 1;
				
				
				//3개월 종료월의 근무일수 (lToMonthDays)
				if (sRetrType.equals("M")) {				//정산끝달의 근무일수 계산
					lToMonWorkDays = ObjUtils.parseInt(dCalcuDateTo.substring(6, 8));
					
				} else {												//정산끝달의 달력일수 계산
					lToMonWorkDays = ObjUtils.parseInt(dToMonEndDay.substring(6, 8));
				}

				//3개월 시작월의 월일수 
				lFrMonthDays = dayOfMonth2;
				
				//3개월 종료월의 월일수
				lToMonthDays = dayOfMonth;
			break;
			
			
			case "B완료 - 사용 안 함":												//전월기준 (B)
				//3개월 종료일의 마지막날 (dCalcuDateTo)
				dCalcuDateTo = sDateTo;

				//3개월 종료월의 말일 (dToMonEndDay)
				year	= ObjUtils.parseInt(sDateTo.substring(0, 4));
				month	= ObjUtils.parseInt(sDateTo.substring(4, 6)) - 1;
//				day		= ObjUtils.parseInt(sDateTo.substring(6, 8));
				cal.set(year, month - 1, 1);
				dayOfMonth		= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
				dCalcuDateTo	= dateFormatter.format(cal.getTime()).substring(0,  6) + dayOfMonth;
				dToMonEndDay	= dateFormatter.format(cal.getTime()).substring(0,  6);
				
				//3개월전 시작월의 시작일 (dCalcuDateFr)
				cal.add(Calendar.MONTH, -2);
				dCalcuDateFr = dateFormatter.format(cal.getTime());

				//1년 시작월 (dCalcuYearFr)
				cal.add(Calendar.MONTH, -9);
				dCalcuYearFr = dateFormatter.format(cal.getTime());
				
				//위에서 계산한 값 변수에 입력
	            sCalcuDateFr = dCalcuDateFr;
	            sCalcuDateTo = dCalcuDateTo;
	            sCalcuYearFr = dCalcuYearFr;
	            sToMonEndDay = dToMonEndDay;						//로직 확인 필요//////////////////////////////////////////////////////////////

	            
	            //3개월 시작월의 근무일수 (lFrMonWorkDays)
				year2			= ObjUtils.parseInt(dCalcuDateFr.substring(0, 4));
				month2			= ObjUtils.parseInt(dCalcuDateFr.substring(4, 6)) - 1;
				cal.set(year2, month2, 1);
				dayOfMonth2		= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
				lFrMonWorkDays	= dayOfMonth2;
				
				
				//3개월 종료월의 근무일수 (lToMonthDays)
				lToMonWorkDays = dayOfMonth;

				//3개월 시작월의 월일수 
				lFrMonthDays = dayOfMonth2;
				
				//3개월 종료월의 월일수
				lToMonthDays = dayOfMonth;
			break;
		}
		
		
		//퇴직금 계산
		String	sCalcuState	= "";
		int		lDateTerm		= 0;
		
		List<Map> vRtnHRT000T = (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.vRtnHRT000T", param);
		for(Map hrt000TData :vRtnHRT000T ) {
			switch ((String) hrt000TData.get("TYPE")) {
				case "2":
//	                '001  3개월평균임금
//	                '007  3개월급여총액         008  3개월평균상여총액      009  3개월평균년월차총액
//	                '003  평균임금계산방식      005  근속기간계산방식
//	                '006  퇴직기준금            011  누진개월(율)           013  임원누진개월(율)
//	                '021  매월지급된퇴직금내역  023  연봉
//	                '031  총근속일수            032  총근속월수             033  총근속년수
//	                '034  근속년수              035  근속월수               036  근속일수
					//3개월 종료일의 마지막날 (dCalcuDateTo)
					switch ((String) hrt000TData.get("UNIQUE_CODE")) {
						case "001":											//3개월 평균임금
							sCalcuState = sCalcuState + "(" + ObjUtils.getSafeString(dPayAmt) + "+" + ObjUtils.getSafeString(dEtcAmt) + "+" + ObjUtils.getSafeString(dAvgBonusI3) + "+" + ObjUtils.getSafeString(dAvgYearI3) + ")";
						break;
						
						case "007":											//3개월 급여총액
							sCalcuState = sCalcuState + "(" + ObjUtils.getSafeString(dPayAmt) + "+" + ObjUtils.getSafeString(dEtcAmt) + ")";
						break;
						
						case "008":											//3개월 평균상여총액
							sCalcuState = sCalcuState + ObjUtils.getSafeString(dAvgBonusI3);
						break;
						
						case "009":											//3개월 평균년월차총액
							sCalcuState = sCalcuState + ObjUtils.getSafeString(dAvgYearI3);
						break;
						
						case "003":											//평균임금계산방식- D:일평균임금/M:월평균임금
							if(hrt000TData.get("AMT_CALCU").equals("D")) {
								Date beginDate	= dateFormatter.parse(dCalcuDateFr);
							    Date endDate	= dateFormatter.parse(dCalcuDateTo);
							 
							    long diff = endDate.getTime() - beginDate.getTime();
							    long diffDays = diff / (24 * 60 * 60 * 1000);
							    
							    lDateTerm = (int) diffDays;
							    		
							} else if (hrt000TData.get("AMT_CALCU").equals("M") ) {
								lDateTerm = 3;
							}
							sCalcuState = sCalcuState + lDateTerm;
						break;

						case "031":											//총근속월수
							sCalcuState = sCalcuState + iRLongDays;
						break;
					}
				break;
				
				default : 
					sCalcuState = sCalcuState + hrt000TData.get("SELECT_VALUE");
				break;
			}
		}
		System.out.println(sCalcuState);
		return (Map) super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.fnRetireProcSTChangedPayment", param);
	}
	
	/**
	 * 지급총액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> fnSuppTotI(Map param) throws Exception {
		return (Map) super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.fnSuppTotI", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}

	
	
	
	
	/* 사용 안 함 */
//	/**
//	 * 소득세계산내역 폼데이터  조회
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
//	public Object selectFormData02(Map param) throws Exception {
//		Object rv = super.commonDao.select("s_hrt506ukrServiceImpl_KOCIS.selectFormData02", param);
//		return rv;
//	}

//	/**
//	 * 산정내역(임원) 조회
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "hrt")
//	public List<Map<String, Object>> selectList05(Map param) throws Exception {
//		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList05", param);
//	}
//	
//	/**
//	 * 중간정산 내역 조회
//	 * @param param
//	 * @return
//	 * @throws Exception
//	 */
//	@ExtDirectMethod(group = "hrt")
//	public List<Map<String, Object>> selectList06(Map param) throws Exception {
//		return (List) super.commonDao.list("s_hrt506ukrServiceImpl_KOCIS.selectList06", param);
//	}
}
	
