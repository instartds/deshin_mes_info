package foren.unilite.modules.human.hrt;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hrt800ukrService")
public class Hrt800ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 퇴직소득 전산 매체 신고 파일 생성(2020년 귀속 연말정산 로직에 맞추어 변경)
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public FileDownloadInfo doBatch2020(Map param, LoginVO user) throws Exception {
		
		String filePrefix = "EA";
		String queryId = "hrt800ukrServiceImpl.selectList2020";
		if(param.get("CAL_YEAR").equals("2020")) {
			queryId = "hrt800ukrServiceImpl.selectList2020";
		}
		
		String companyNum = (String) super.commonDao.select("hrt800ukrServiceImpl.getCompanyNum", param);
		List<Map<String, Object>> list = super.commonDao.list(queryId, param);
		
		File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
		if(!dir.exists())  dir.mkdir();
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"), filePrefix + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());

		String errorDesc = "";
		if(ObjUtils.isNotEmpty(list)){
			errorDesc = ObjUtils.getSafeString(list.get(0).get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		String data = "";
		byte[] bytesArray = data.getBytes();
		
		for(Map<String, Object> mapData : list) {
			data = mapData.get("ROW_DATA").toString();
			data += "\n";
			bytesArray = data.getBytes("EUC_KR");
			fos.write(bytesArray);
		}
		
		fos.flush();
		fos.close(); 
		fInfo.setStream(fos);
		
		return fInfo;
	}
	
	/**
	 * 퇴직소득 전산 매체 신고 파일 생성
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public FileDownloadInfo doBatch(Map param) throws Exception {
		
		List<Map<String,Object>> listA = super.commonDao.list("hrt800ukrServiceImpl.selectDataA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hrt800ukrServiceImpl.selectDataB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hrt800ukrServiceImpl.selectDataC", param);
		
		Map<String, Object> mapA = listA.get(0);
		String companyNum = ObjUtils.getSafeString(mapA.get("COMPANY_NUM"));
		String submitter = "2";		//제출자구분('1':세무대리인, '2':법인)
		String sTaxAgentNo = ObjUtils.getSafeString(param.get("TAX_AGENT_NO"));
		if(ObjUtils.isNotEmpty(sTaxAgentNo))	{        //관리번호가 있으면 세무대리인 처리
			submitter = "1";
		}else {                            				//자료제출자가 세무대리인이 아닌 경우, 관리번호에 공백수록
			submitter = "2";
			sTaxAgentNo = "";
		}
		
		File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
		if(!dir.exists())  dir.mkdir(); 
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "EA" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    // A 레코드	 
	    data = "A25" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(param.get("SUBMIT_DATE"), 8) + 	// A4 : 제출연월일
		        this.cnformat(submitter, 1) + 					// A5 : 제출자 구분
		        this.csformat(sTaxAgentNo, 6) + 				// A6 : 세무대리인 관리번호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A7 : 홈택스 ID
		        "9000" + 										// A8 : 세무프로그램코드
		        this.csformat(mapA.get("COMPANY_NUM"), 10) + 	// A9 : 사업자등록번호
		        this.csformat(mapA.get("DIV_NAME"), 40) + 		// A10 : 법인명(상호)
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A11 : 담당자 부서
		        this.csformat(mapA.get("REPRE_NAME"), 30) + 	// A12 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 15) + 		// A13 : 담당자 전화번호
		        this.cnformat(mapA.get("SECT_CNT"), 5) + 			// A14 : 신고의무자 수
		        "101" + 										// A15 : 사용한글코드
		        this.csformat(mapA.get("A_SPACE"), 932);		// A16 : 공란 
	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
        logger.debug("A Record : "+String.valueOf(bytesArray.length));
        // B 레코드
        int bI = 1;	    
        for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	int cLen = 0;
	    	if(listC != null) {
	    		cLen = listC.size();
	    	}
	    	data = "B25" + 											// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 			// B3 : 세무서코드 X(3)
                    this.cnformat(bI, 6) + 							// B4 : 일련번호 9(6)
                    this.csformat(mapB.get("COMPANY_NUM"), 10) + 	// B5 : ③⑩사업자등록번호 X(10)
                    this.csformat(mapB.get("DIV_NAME"), 40) + 		// B6 : ①⑨법인명(상호) X(40)
                    this.csformat(mapB.get("REPRE_NAME"), 30) + 	// B7 : ③대표자(성명)-X(30)
                    this.csformat(mapB.get("REPRE_NO"), 13) + 		// B8 : ④주민(법인)등록번호-X(13)
                    this.cnformat(1, 1) + 							// B9 : 제출대상기간 코드-9(1)
                    this.cnformat(cLen, 7) + 						// B10 : 퇴직소득자 (C레코드)수-9(7)
                    this.csformat(mapB.get("B_SPACE1"), 7) + 		// B11 : 공란-X(7)
                    
                    this.cnformat(mapB.get("SUPP_TOTAL_I"), 14) +	// B12 : 정산-과세대상퇴직급여합계-9(14)
                    this.cnformat(mapB.get("IN_TAX_I_TYPE"), 1) + 	// B13 : 양수부호-9(1)
                    this.cnformat(mapB.get("IN_TAX_I"), 13) + 		// B13 : 신고대상세액 - 소득세 합계

                    this.cnformat(mapB.get("IN_TAX_I2"), 13) + 		// B14 : 이연퇴직소득세액합계-9(13)
                    this.cnformat(mapB.get("IN_TAX_I3_TYPE"), 1) + 	// B15 : 양수부호-9(1)
                    this.cnformat(mapB.get("IN_TAX_I3"), 13) + 		// B15 : 차감원천징수  소득세액 합계-9(13)
                    this.cnformat(mapB.get("LOCAL_TAX_I3_TYPE"), 1)+// B16 : 양수부호-9(1)
                    this.cnformat(mapB.get("LOCAL_TAX_I3"), 13) + 	// B16 : 지방소득세액 합계-9(13)
                    this.cnformat(mapB.get("SP_TAX_I3_TYPE"), 1) + 	// B17 : 양수부호-9(1)
                    this.cnformat(mapB.get("SP_TAX_I3"), 13) + 		// B17 : 농어촌특별세액 합계-9(13)
                    this.cnformat(mapB.get("SUM_TAX_I3_TYPE"), 1) + // B18 : 양수부호-9(1)
                    this.cnformat(mapB.get("SUM_TAX_I3"), 13) + 	// B18 : 합계-9(13)
                    this.csformat(mapB.get("B_SPACE2"), 893);		// B19 : 공란-X(893)
	    	data += "\n";
	    	bytesArray = data.getBytes();
	    	fos.write(bytesArray);
		    logger.debug("B Record : "+String.valueOf(bytesArray.length));
	    	bI++;
	    	
	    	// C 레코드
	    	List<Map<String,Object>> subListC = this.filterList(listC, "SECT_CODE", sectCode);	
	    	int cI = 1;
		    for(Map<String,Object> mapC : subListC)	{
		    	//자료관리번호
		    	StringBuffer sData = new StringBuffer();
		    	sData.append("C");                                          	//  C1.레코드구분
                sData.append("25");                                          	//  C2.자료구분
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );          	//  C3.세무서
                sData.append( this.cnformat(cI, 6) );                          	//  C4.일련번호

                //원천징수의무자
                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 10) );     //  C5 : 사업자등록번호
                sData.append( this.cnformat(1, 1) );     						//  C6 : 징수의무자구분	
                //
                

                //소득자(근로자)
                sData.append( this.cnformat(mapC.get("LIVE_GUBUN"), 1) );       //  C7 : 거주구분-9(1)
                sData.append( this.cnformat(mapC.get("FORIGN"), 1) );        		// C8 : 내외국인구분-9(1)
                sData.append( this.csformat(mapC.get("NATION_CODE"), 2) );      //  C9 : 거주지국코드-X(2)
                sData.append( this.csformat(mapC.get("NAME"), 30));     		// C10 : 성명X(30)
                sData.append( this.csformat(mapC.get("REPRE_NUM"), 13));		// C11 : 주민등록번호X(13)
                sData.append( this.cnformat(mapC.get("IMWON_YN"), 1));       // C12 : 임원여부9(1)
                sData.append( this.cnformat(mapC.get("RETR_ANN_JOIN_DATE"), 8));         // C13 : 확정급여형 퇴직연금제도 가입일 9(8)
                sData.append( this.cnformat(mapC.get("RETR_ANNU_I_20111231"), 11));          // C14 : 2011.12.31 퇴직금 9(11)
                sData.append( this.cnformat(mapC.get("RETR_DATE_FR"), 8));     // C15 : 귀속연도 시작연월일 9(8)
                sData.append( this.cnformat(mapC.get("RETR_DATE_TO"), 8));     // C16 : 귀속연도 종료연월일 9(8)
                sData.append( this.cnformat(mapC.get("RETR_RESN"), 1));	// C17 : 퇴직사유 9(1)
                
                
                //퇴직급여현황 - 중간지급
                sData.append( this.csformat(mapC.get("M_DIV_NAME"), 40));  // C18 : 근무처명 X(40)
                sData.append( this.csformat(mapC.get("M_COMPANY_NUM"), 10));    // C19 : 근무처사업자등록번호 X(10) 
                
                sData.append( this.cnformat(mapC.get("M_ANNU_TOTAL_I"), 11));  	// C20 : 퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("M_OUT_INCOME_I"), 11));     // C21 : 비과세퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("M_TAX_TOTAL_I"), 11));     // C22 : 과세대상퇴직급여 9(11) 
                
                //퇴직급여현황 - 최종분
                sData.append( this.csformat(mapC.get("R_DIV_NAME"), 40));         //C23 : 근무처명 X(40) 
                sData.append( this.csformat(mapC.get("R_COMPANY_NUM"), 10));        	// C24 : 근무처사업자등록번호 X(10) 
                sData.append( this.cnformat(mapC.get("R_ANNU_TOTAL_I"), 11));  		// C25 : 퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("R_OUT_INCOME_I"), 11));      // C26 : 비과세퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("R_TAX_TOTAL_I"), 11));  	// C27 : 과세대상퇴직급여 9(11)
                
                //퇴직급여현황 - 정산
                sData.append( this.cnformat(mapC.get("S_ANNU_TOTAL_I"), 11));   	// C28 : 퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("S_OUT_INCOME_I"), 11));  	// C29 : 비과세퇴직급여 9(11) 
                sData.append( this.cnformat(mapC.get("S_TAX_TOTAL_I"), 11));        	// C30 : 과세대상퇴직급여 9(11) 
                
                //근속연수 - 중간지급
                sData.append( this.cnformat(mapC.get("M_JOIN_DATE"), 8));  		// C31 : 입사일 9(8)
                sData.append( this.cnformat(mapC.get("M_CALCU_END_DATE"), 8));      // C32 : 기산일 9(8)
                sData.append( this.cnformat(mapC.get("M_RETR_DATE"), 8));  	// C33 : 퇴사일 9(8)
                sData.append( this.cnformat(mapC.get("M_SUPP_DATE"), 8));   	// C34 : 지급일 9(8)
                sData.append( this.cnformat(mapC.get("M_LONG_MONTHS"), 4));  	// C35 : 근속월수 9(4)
				sData.append( this.cnformat(mapC.get("M_EXEP_MONTHS"), 4));        	// C36 : 제외월수 9(4)
				sData.append( this.cnformat(mapC.get("M_ADD_MONTHS"), 4));  		// C37 : 가산월수 9(4)
				sData.append( this.cnformat(mapC.get("M_DUPLI_MONTHS"), 4));      // C38 : 중복월수 9(4)
				sData.append( this.cnformat(mapC.get("M_LONG_YEARS"), 4));  	// C39 : 근속연수 9(4)
				
				//근속연수 - 최종
				sData.append( this.cnformat(mapC.get("R_JOIN_DATE"), 8));   	// C40 : 입사일 9(8)
				sData.append( this.cnformat(mapC.get("R_CALCU_END_DATE"), 8));  	// C41 : 기산일 9(8)
				sData.append( this.cnformat(mapC.get("R_RETR_DATE"), 8));        	// C42 : 퇴사일 9(8)
				sData.append( this.cnformat(mapC.get("R_SUPP_DATE"), 8));  		// C43 : 지급일 9(8)
				sData.append( this.cnformat(mapC.get("R_LONG_MONTHS"), 4));      // C44 : 근속월수 9(4)
				sData.append( this.cnformat(mapC.get("R_EXEP_MONTHS"), 4));  	// C45 : 제외월수 9(4)
				sData.append( this.cnformat(mapC.get("R_ADD_MONTHS"), 4));   	// C46 : 가산월수 9(4)
				sData.append( this.cnformat(mapC.get("R_DUPLI_MONTHS"), 4));  	// C47 : 중복월수 9(4)
				sData.append( this.cnformat(mapC.get("R_LONG_YEARS"), 4));        	// C48 : 근속연수 9(4)
				
				//근속연수 - 정산
				sData.append( this.cnformat(mapC.get("S_JOIN_DATE"), 8));  		// C49 : 입사일 9(8)
				sData.append( this.cnformat(mapC.get("S_CALCU_END_DATE"), 8));      // C50 : 기산일 9(8)
				sData.append( this.cnformat(mapC.get("S_RETR_DATE"), 8));  	// C51 : 퇴사일 9(8)
				sData.append( this.cnformat(mapC.get("S_SUPP_DATE"), 8));   	// C52 : 지급일 9(8)
				sData.append( this.cnformat(mapC.get("S_LONG_MONTHS"), 4));  	// C53 : 근속월수 9(4)
				sData.append( this.cnformat(mapC.get("S_EXEP_MONTHS"), 4));        	// C54 : 제외월수 9(4)
				sData.append( this.cnformat(mapC.get("S_ADD_MONTHS"), 4));  		// C55 : 가산월수 9(4)
				sData.append( this.cnformat(mapC.get("S_DUPLI_MONTHS"), 4));      // C56 : 중복월수 9(4)
				sData.append( this.cnformat(mapC.get("S_LONG_YEARS"), 4));  	// C57 : 근속연수 9(4)
				
				//근속연수 - 안분_2012.12.31이전
				sData.append( this.cnformat(mapC.get("JOIN_DATE_BE13"), 8));   	// C58 : 입사일 9(8)
				sData.append( this.cnformat(mapC.get("CALCU_END_DATE_BE13"), 8));  	// C59 : 기산일 9(8)
				sData.append( this.cnformat(mapC.get("RETR_DATE_BE13"), 8));        	// C60 : 퇴사일 9(8)
				sData.append( this.cnformat(mapC.get("SUPP_DATE_BE13"), 8));  		// C61 : 지급일 9(8)
				sData.append( this.cnformat(mapC.get("LONG_MONTHS_BE13"), 4));      // C62 : 근속월수 9(4)
				sData.append( this.cnformat(mapC.get("EXEP_MONTHS_BE13"), 4));  	// C63 : 제외월수 9(4)
				sData.append( this.cnformat(mapC.get("ADD_MONTHS_BE13"), 4));   	// C64 : 가산월수 9(4)
				sData.append( this.cnformat(mapC.get("DUPLI_MONTHS_BE13"), 4));  	// C65 : 중복월수 9(4)
				sData.append( this.cnformat(mapC.get("LONG_YEARS_BE13"), 4));        	// C66 : 근속연수 9(4)
				
				//근속연수 - 안분_2013.01.01이후
				sData.append( this.cnformat(mapC.get("JOIN_DATE_AF13"), 8));  		// C67 : 입사일 9(8)
				sData.append( this.cnformat(mapC.get("CALCU_END_DATE_AF13"), 8));      // C68 : 기산일 9(8)
				sData.append( this.cnformat(mapC.get("RETR_DATE_AF13"), 8));  	// C69 : 퇴사일 9(8)
				sData.append( this.cnformat(mapC.get("SUPP_DATE_AE13"), 8));   	// C70 : 지급일 9(8)
				sData.append( this.cnformat(mapC.get("LONG_MONTHS_AF13"), 4));  	// C71 : 근속월수 9(4)
				sData.append( this.cnformat(mapC.get("EXEP_MONTHS_AF13"), 4));        	// C72 : 제외월수 9(4)
				sData.append( this.cnformat(mapC.get("ADD_MONTHS_AF13"), 4));  		// C73 : 가산월수 9(4)
				sData.append( this.cnformat(mapC.get("DUPLI_MONTHS_BE13"), 4));      // C74 : 중복월수 9(4)
				sData.append( this.cnformat(mapC.get("LONG_YEARS_AF13"), 4));  	// C75 : 근속연수 9(4)
				
				//개정규정에따른계산방법-과세표준계산
				sData.append( this.cnformat(mapC.get("S_TAX_TOTAL_I"), 11));   	// C76 : 퇴직소득() 9(11)
				sData.append( this.cnformat(mapC.get("INCOME_DED_I_16"), 11));  	// C77 : 근속연수공제 9(11)
				sData.append( this.cnformat(mapC.get("PAY_TOTAL_I_16"), 11));        	// C78 : 환산급여 [(-) X 12배 / 정산근속연수] 9(11)
				sData.append( this.cnformat(mapC.get("PAY_TOTAL_DED_I_16"), 11));  		// C79 : 환산급여별공제 9(11)
				sData.append( this.cnformat(mapC.get("TAX_STD_I_16"), 11));      // C80 : 퇴직소득과세표준(-) 9(11)
				
				//개정규정에따른계산방법-세액계산
				sData.append( this.cnformat(mapC.get("CHANGE_COMP_TAX_I_16"), 11));  	// C81 : 환산산출세액 (X세율) 9(11)
				sData.append( this.cnformat(mapC.get("COMP_TAX_I_16"), 11));   	// C82 : 산출세액( × 정산근속연수 / 12배) 9(11)
				
				//종전규정에따른계산방법-과세표준계산
				sData.append( this.cnformat(mapC.get("S_TAX_TOTAL_I"), 11));  	// C83 : 퇴직소득() 9(11) 
				sData.append( this.cnformat(mapC.get("SPEC_DED_I"), 11));        	// C84 : 퇴직소득정률공제 9(11) 
				sData.append( this.cnformat(mapC.get("INCOME_DED_I"), 11));  		// C85 : 근속연수공제 9(11)
				sData.append( this.cnformat(mapC.get("TAX_STD_I"), 11));      // C86 : 퇴직소득과세표준 (--) 9(11) 
				
				//종전규정에따른계산방법_세액계산 2012.12.31이전
				sData.append( this.cnformat(mapC.get("DIVI_TAX_STD_BE13"), 11));  	// C87 : 과세표준안분 (×각근속연수/정산근속연수) 9(11)
				sData.append( this.cnformat(mapC.get("AVG_TAX_STD_BE13"), 11));   	// C88 : 연평균과세표준 (/각근속연수) 9(11)
				sData.append( this.cnformat(mapC.get("EX_TAX_STD_BE13"), 11));  	// C89 : 환산과세표준 9(11)
				sData.append( this.cnformat(mapC.get("EX_COMP_TAX_BE13"), 11));        	// C90 : 환산산출세액 9(11)
				sData.append( this.cnformat(mapC.get("AVR_COMP_TAX_BE13"), 11));  		// C91 : 연평균산출세액 (×세율) 9(11)
				sData.append( this.cnformat(mapC.get("COMP_TAX_BE13"), 11));      // C92 : 산출세액 (×각근속연수) 9(11)
				
				//종전규정에따른계산방법_세액계산 2013.1.1이후
				sData.append( this.cnformat(mapC.get("DIVI_TAX_STD_AF13"), 11));  	// C93 : 과세표준안분 9(11)
				sData.append( this.cnformat(mapC.get("AVG_TAX_STD_AF13"), 11));   	// C94 : 연평균과세표준 (/각근속연수) 9(11)
				sData.append( this.cnformat(mapC.get("EX_TAX_STD_AF13"), 11));  	// C95 : 환산과세표준 (×5배) 9(11)
				sData.append( this.cnformat(mapC.get("EX_COMP_TAX_AF13"), 11));        	// C96 : 환산산출세액 (×세율) 9(11)
				sData.append( this.cnformat(mapC.get("AVR_COMP_TAX_AF13"), 11));  		// C97 : 연평균산출세액 (/5배) 9(11) 
				sData.append( this.cnformat(mapC.get("COMP_TAX_AF13"), 11));      // C98 : 산출세액 (×각근속연수) 9(11)
				
				//종전규정에따른계산방법_세액계산 합계
				sData.append( this.cnformat(mapC.get("DIVI_TAX_STD"), 11));  	// C99 : 과세표준안분 9(11)
				sData.append( this.cnformat(mapC.get("AVG_TAX_STD"), 11));   	// C100 : 연평균과세표준 9(11)
				sData.append( this.cnformat(mapC.get("EX_TAX_STD"), 11));  	// C101 : 환산과세표준 9(11)
				sData.append( this.cnformat(mapC.get("EX_COMP_TAX"), 11));        	// C102 : 환산산출세액 9(11)
				sData.append( this.cnformat(mapC.get("AVR_COMP_TAX"), 11));  		// C103 : 연평균산출세액 9(11)
				sData.append( this.cnformat(mapC.get("COMP_TAX"), 11));      // C104 : 산출세액 9(11)
				
				//퇴직소득세액계산
				sData.append( this.cnformat(mapC.get("CHANGE_TAX_YEAR_16"), 4));  	// C105 : 퇴직일이 속하는 과세연도 9(4)
				sData.append( this.cnformat(mapC.get("EXEMPTION_COMP_TAX_I_16"), 11));   	// C106 : 퇴직소득세 산출세액 (×퇴직연도별비율)+[×(100%-퇴직연도별비율)] 9(11)
				sData.append( this.cnformat(mapC.get("PAY_END_TAX"), 11));  	// C107 : 기납부(또는 기과세이연) 세액 9(11)
				sData.append( this.cnformat(mapC.get("DEF_TAX_I_TYPE"), 1));        	// C108 : 양수부호 (-) 9(1) 
				sData.append( this.cnformat(mapC.get("DEF_TAX_I"), 11));  		// C108 : 신고대상세액 (-) -9(11)
				
				//이연퇴직소득세액계산
				sData.append( this.cnformat(mapC.get("DEF_TAX_I_TYPE2"), 1));      // C109 : 양수부호 (-) 9(1) 
				sData.append( this.cnformat(mapC.get("DEF_TAX_I2"), 11));  	// C109 : 신고대상세액  9(11)
				sData.append( this.cnformat(mapC.get("TRANS_RETR_PAY"), 11));   	// C110 : 계좌입금금액_합계 9(11) 
				sData.append( this.cnformat(mapC.get("DEFER_TAX_TOTAL_I"), 11));  	// C111 : 퇴직급여() 9(11) 
				sData.append( this.cnformat(mapC.get("DEFER_TAX_I"), 11));        	// C112 : 이연퇴직소득세 9(11) 
				
				//납부명세_신고대상세액
				sData.append( this.cnformat(mapC.get("IN_TAX_I_TYPE1"), 1));  		// C113 : 양수부호 (-) 9(1) 
				sData.append( this.cnformat(mapC.get("IN_TAX_I1"), 11));      // C113 : 소득세() 9(11) 
				sData.append( this.cnformat(mapC.get("LOCAL_TAX_I_TYPE1"), 1));  	// C114 : 양수부호 (-) 9(1) 
				sData.append( this.cnformat(mapC.get("LOCAL_TAX_I1"), 11));   	// C114 : 지방소득세 9(11) 
				sData.append( this.cnformat(mapC.get("SP_TAX_I_TYPE1"), 1));  	// C115 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("SP_TAX_I1"), 11));  	// C115 : 농어촌특별세 9(11)
				sData.append( this.cnformat(mapC.get("SUM_TAX_I_TYPE1"), 1));  	// C116 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("SUM_TAX_I1"), 11));  	// C116 : 계  9(11)
				
				//납부명세_이연퇴직소득세
				sData.append( this.cnformat(mapC.get("IN_TAX_I2"), 11));  	// C117 : 소득세() 9(11)
				sData.append( this.cnformat(mapC.get("LOCAL_TAX_I2"), 11));  	// C118 : 지방소득세 9(11)
				sData.append( this.cnformat(mapC.get("SP_TAX_I2"), 11));  	// C119 : 농어촌특별세 9(11)
				sData.append( this.cnformat(mapC.get("SUM_TAX_I2"), 11));  	// C120 : 계 9(11) 

				//납부명세_차감원천징수세액
				sData.append( this.cnformat(mapC.get("IN_TAX_I_TYPE3"), 1));        	// C121 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("IN_TAX_I3"), 11));  		// C121 : 소득세(-) 9(11)
				sData.append( this.cnformat(mapC.get("LOCAL_TAX_I_TYPE3"), 1));      // C122 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("LOCAL_TAX_I3"), 11));  	// C122 : 지방소득세  9(11)
				sData.append( this.cnformat(mapC.get("SP_TAX_I_TYPE3"), 1));   	// C123 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("SP_TAX_I3"), 11));  	// C123 : 농어촌특별세 9(11)
				sData.append( this.cnformat(mapC.get("SUM_TAX_I_TYPE3"), 1));        	// C124 : 양수부호 (-) 9(1)
				sData.append( this.cnformat(mapC.get("SUM_TAX_I3"), 11));  		// C124 : 계 9(11)

                sData.append( this.csformat(mapC.get("C_SPACE"), 2));         // C125 : 공란 X(2)
                sData.append( "\n" );
                bytesArray = sData.toString().getBytes();
                logger.debug("C Record : "+String.valueOf(bytesArray.length));
                fos.write(bytesArray);
                if(!"0".equals(ObjUtils.getSafeString(mapC.get("RETR_ANN_JOIN_DATE"))) )	{
                	data = "D25" + 											// D1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                            this.csformat(mapC.get("SAFFER"), 3) + 			// D3 : 세무서 X(3)
                            this.cnformat(cI, 6) + 							// BD4 : 일련번호 9(6)
                            
                            //원천징수의무자
                            this.csformat(mapC.get("COMPANY_NUM"), 10) + 	// D5 : ①사업자등록번호 X(10)
                            this.csformat(mapC.get("D_SPACE1"), 50) + 		// D6 : 공란 X(50)
                            
                            //소득자
                            this.csformat(mapC.get("REPRE_NUM"), 13) +	// D7 : ⑦소득자주민등록번호 X(13)
                            
                            //연금계좌 입금명세
                            this.cnformat(1, 2) + 	// D8 : 연금계좌 일련번호 9(2)
                            this.csformat(mapC.get("COMP_NAME"), 30) + 		// D9 : 연금계좌취급자 X(30)
                            this.csformat(mapC.get("COMP_NUM"), 10) + 		// D10 : 사업자등록번호 X(10)
                            this.csformat(mapC.get("BANK_ACCOUNT"), 20) + 	// D11 : 계좌번호 X(20)
                            this.cnformat(mapC.get("DEPOSIT_DATE"), 8) + 		// D12 : 입금일 9(8)
                            this.cnformat(mapC.get("TRANS_RETR_PAY"), 11)+// D13 : 계좌입금금액 9(11)
                            this.csformat(mapC.get("D_SPACE2"), 944);		// D14 : 공란 X(944)
        	    	data += "\n";
        	    	bytesArray = data.getBytes();
        	    	fos.write(bytesArray);
        		    logger.debug("D Record : "+String.valueOf(bytesArray.length));
                	
                }
                cI++;
		    }
        }
	    fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
		
		return fInfo;
	}
	
	private List<Map<String, Object>> filterList(List<Map<String,Object>> list, String name, Object value)	{
		List<Map<String,Object>> rList = new ArrayList<Map<String,Object>>();
		for(Map<String, Object> map : list){
			if(map.get(name).equals(value))	{
				rList.add(map);
			}
		}
		return rList;
	}
	
	private List<Map<String, Object>> filterList(List<Map<String,Object>> list, Map<String, Object> fdata)	{
		List<Map<String,Object>> rList = new ArrayList<Map<String,Object>>();
		for(Map<String, Object> map : list){
			boolean chk=true;
			for (Map.Entry<String, Object> entry : fdata.entrySet()) {
		            if (!map.get(entry.getKey()).equals(entry.getValue())) {
		            	chk = false;
		            }
			}
			if(chk)	{
				rList.add(map);
			}
		}
		return rList;
	}
	
	private String csformat(Object obj, int leng)throws Exception 	{
		String str = ObjUtils.getSafeString(obj);
		//return GStringUtils.rPad(str, leng, " ");
		return this.strPad(str, leng, " ", false);
	}
	
	private String csformat(String str, int leng)throws Exception 	{
		//String str = ObjUtils.getSafeString(obj);
		String r = GStringUtils.rPad(str, leng, " ");
		//return GStringUtils.rPad(str, leng, " ");
		return this.strPad(str, leng, " ", false);
	}
	
	private String cnformat(Object obj, int leng)throws Exception 	{
		
		String str = ObjUtils.getSafeString(obj,"0");
		if(str.indexOf(".") >=0)	str= str.substring(0, str.indexOf("."));

		//return GStringUtils.lPad(str, leng, "0");
		return this.strPad(str, leng, "0", true);
	}
	
	private String strPad( String str, int size, String padStr, boolean where ) throws Exception {
        if (str == null) str = "";
        
        if (!where && str.getBytes("MS949").length > size && str.getBytes("MS949").length != str.length()) {
        	
        	byte[] bytes = str.getBytes("MS949");
        	String strbyte=null, strChar=null;
        	int j=0, k=0;
        	for(int i=0; (i < str.length() && j < size) ; i++)	{
        		byte[] tmpbyte = new byte[1];
        		k=j;	// 마지막 index 저장
        		
        		tmpbyte[0] = bytes[j];
        		strbyte = new String(tmpbyte);
        		strChar = str.substring(i, i+1);
        		
        		if(strChar.equals(strbyte))	{
        			//한글이 아님
        			j++;
        		}else {
        			//한글
        			j = j+2;
        		}
        	}
        	
        	int subLen = size;
        	// 마지막 byte 가 깨진 글자인지 검사
        	if(j-k == 2 && k == size-1)	{
        		subLen = subLen-1;
        	}
        	byte[] bytesSize = new byte[subLen];
        	System.arraycopy(bytes, 0, bytesSize, 0, subLen);
        	str = new String(bytesSize);
        	
        } else if (!where && str.getBytes("MS949").length == size ) {
        	return str;
        } else if (!where && str.getBytes("MS949").length > size  && str.getBytes("MS949").length == str.length() ) {
        	return str.substring(0,size);
        }
        
        if (where && str.length() >= size) {
        	return str;
        }
        String res = null;
        StringBuffer sb = new StringBuffer();
        String tmpStr = null;
        int tmpSize = size - str.getBytes("MS949").length;

        for (int i = 0; i < size; i = i + padStr.length()) {
            sb.append(padStr);
        }
        tmpStr = sb.toString().substring(0, tmpSize);
        
        if(where) res = tmpStr.concat(str);
        else res = str.concat(tmpStr);
        //res = str.concat(tmpStr);
        return res;
    }

	private int convertInt(Object obj)	{
		String str = ObjUtils.getSafeString(obj, "0");
		if(str.indexOf(".") >=0)	str= str.substring(0, str.indexOf("."));
		
		return ObjUtils.parseInt(str);
	}
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> checkData( Map param ) throws Exception {
        return super.commonDao.list("hrt800ukrServiceImpl.selectDataA", param);
    }
}
	
