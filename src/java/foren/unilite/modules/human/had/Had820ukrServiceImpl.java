package foren.unilite.modules.human.had;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had820ukrService")
public class Had820ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "hum")
	public FileDownloadInfo doBatch2020(Map param, LoginVO user) throws Exception {
		
		String filePrefix = "C";
		if(param.get("BATCH_TYPE").equals("M")) {
			filePrefix = "CA";
		}
		String queryId = "had820ukrServiceImpl.selectList2020";
		if(param.get("CAL_YEAR").equals("2020")) {
			queryId = "had820ukrServiceImpl.selectList2020";
		}
		
		String companyNum = (String) super.commonDao.select("had820ukrServiceImpl.getCompanyNum", param);
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
	
	@ExtDirectMethod(group = "hum")
	public FileDownloadInfo doBatch(Map param) throws Exception {
		
		super.commonDao.update("had820ukrServiceImpl.updateEduCode", param); 
		List<Map<String,Object>> listA = super.commonDao.list("had820ukrServiceImpl.getSelectA", param);
		List<Map<String,Object>> listB = super.commonDao.list("had820ukrServiceImpl.getSelectB", param);
		List<Map<String,Object>> listC = super.commonDao.list("had820ukrServiceImpl.getSelectC", param);
		List<Map<String,Object>> listD = super.commonDao.list("had820ukrServiceImpl.getSelectD", param);
		List<Map<String,Object>> listE = super.commonDao.list("had820ukrServiceImpl.getSelectE", param);
		List<Map<String,Object>> listF = super.commonDao.list("had820ukrServiceImpl.getSelectF", param);
		List<Map<String,Object>> listG = super.commonDao.list("had820ukrServiceImpl.getSelectG", param);
		List<Map<String,Object>> listH = super.commonDao.list("had820ukrServiceImpl.getSelectH", param);
		List<Map<String,Object>> listI = super.commonDao.list("had820ukrServiceImpl.getSelectI", param);
		
		Map<String, Object> mapA = listA.get(0);
		String companyNum = ObjUtils.getSafeString(mapA.get("COMPANY_NUM"));
		String submitter = "2";		//제출자구분('1':세무대리인, '2':법인)
		
		File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
		if(!dir.exists())  dir.mkdir(); 
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "C" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    
	    // A 레코드
	   
	    data = "A20" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(param.get("SUBMIT_DATE"), 8) + 	// A4 : 제출연월일
		        this.cnformat(submitter, 1) + 					// A5 : 제출자 구분
		        this.csformat(param.get("TAX_AGENT_NO"), 6) + 	// A6 : 세무대리인 관리번호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A7 : 홈택스 ID
		        "9000" + 										// A8 : 세무프로그램코드
		        this.csformat(mapA.get("COMPANY_NUM"), 10) + 	// A9 : 사업자등록번호
		        this.csformat(mapA.get("DIV_NAME"), 60) + 		// A10 : 법인명(상호)
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A11 : 담당자 부서
		        this.csformat(mapA.get("REPRE_NAME"), 30) + 	// A12 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 15) + 		// A13 : 담당자 전화번호
		        this.csformat(param.get("CAL_YEAR"), 4) + 		// A14 : 귀속연도							>>>>>>>>>>>>>>>>>>> 추가
		        this.cnformat(mapA.get("CNT"), 5) + 			// A15 : 신고의무자 수
		        "101" + 										// A16 : 사용한글코드
		        this.csformat(mapA.get("A_SPACE"), 1880);		// A17 : 공란 
	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
	    logger.debug("A Record : "+String.valueOf(bytesArray.length));
	    //사업장목록
	    int bI = 1;
	    for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	int strDef = convertInt(mapB.get("DEF_IN_TAX_I")) + convertInt(mapB.get("DEF_LOCAL_TAX_I")) + convertInt(mapB.get("DEF_SP_TAX_I"));
	    	
	    	data = "B20" + 											// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 			// B3 : 세무서코드 X(3)
                    this.cnformat(bI, 6) + 							// B4 : 일련번호 9(6)
                    this.csformat(mapB.get("COMPANY_NUM"), 10) + 	// B5 : ③⑩사업자등록번호 X(10)
                    this.csformat(mapB.get("DIV_NAME"), 60) + 		// B6 : ①⑨법인명(상호) X(60)
                    this.csformat(mapB.get("REPRE_NAME"), 30) + 	// B7 : ②대표자(성명) X(30)
                    this.csformat(mapB.get("REPRE_NO"), 13) + 		// B8 : ④주민(법인)등록번호 X(13)
                    this.csformat(param.get("CAL_YEAR"), 4) + 		// B9 : 귀속연도 X(4)					>>>>>>>>>>>>>>>>>>> 추가
                    this.cnformat(mapB.get("NOW_CNT"), 7) + 		// B10 : 주(현)근무처 (C레코드)수 9(7)
                    this.cnformat(mapB.get("BEFORE_CNT"), 7) + 		// B11 : 종(전)근무처 (D레코드)수 9(7)
                    this.cnformat(mapB.get("EARN_INCOME_I"), 14) + 	// B12 : 총급여 총계 9(14)
                    this.cnformat(mapB.get("DEF_IN_TAX_I"), 13) + 	// B13 : 결정세액(소득세) 총계 9(13)
                    this.cnformat(mapB.get("DEF_LOCAL_TAX_I"), 13) + //B14 : 결정세액(지방소득세) 총계 9(13)
                    this.cnformat(mapB.get("DEF_SP_TAX_I"), 13) + 	// B15 : 결정세액(농특세)총계 9(13)
                    this.cnformat(strDef, 13) + 					// B16 : 결정세액 총계 9(13)
                    this.cnformat(param.get("SUBMIT_FLAG"), 1) + 	// B17 : 제출대상기간 코드 9(1)
                    this.csformat(mapB.get("B_SPACE"), 1872);		// B18 : 공란 X(1872)
	    	data += "\n";
	    	bytesArray = data.getBytes();
	    	fos.write(bytesArray);
		    logger.debug("B Record : "+String.valueOf(bytesArray.length));
	    	bI++;
	    	
	    	//C 레코드 - 사원목록
	    	List<Map<String,Object>> subListC = this.filterList(listC, "SECT_CODE", sectCode);	
	    	int cI = 1;
		    for(Map<String,Object> mapC : subListC)	{
		    	//자료관리번호
		    	StringBuffer sData = new StringBuffer();
		    	sData.append("C");                                                      //  1.레코드구분
                sData.append( "20" );                                                   //  2.자료구분
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );                   //  3.세무서
                sData.append( this.cnformat(cI, 6) );                                   //  4.일련번호

                //원천징수의무자
                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 10) );             //  5.사업자등록번호
                
                //소득자(근로자)
                sData.append( this.cnformat(mapC.get("BEFORE_CNT"), 2) );               //  6.종(전)근무처수
                sData.append( this.cnformat(mapC.get("LIVE_GUBUN"), 1) );               //  7.거주자구분코드
                sData.append( this.csformat(mapC.get("LIVE_CODE"), 2) );                //  8.거주지국코드
                sData.append( this.cnformat(mapC.get("FORE_SINGLE_YN"), 1));            //  9.외국인단일세율적용
                sData.append( this.cnformat(mapC.get("FOREIGN_DISPATCH_YN"), 1));       // 10.외국법인소속판견근로자여부
                sData.append( this.csformat(mapC.get("NAME"), 30));                     // 11.성명
                sData.append( this.cnformat(mapC.get("FORIGN"), 1));                    // 12.내외국인구분코드
                sData.append( this.csformat(mapC.get("REPRE_NUM"), 13));                // 13.주민등록번호
                sData.append( this.csformat(mapC.get("NATION_CODE"), 2));               // 14.국적코드
                sData.append( this.csformat(mapC.get("HOUSEHOLDER_YN"), 1));            // 15.세대주여부
                sData.append( this.csformat(mapC.get("HALFWAY_TYPE"), 1));              // 16.연말정산구분
                
                sData.append( this.csformat(mapC.get("SUB_DIV_YN"), 1));                // 17.사업자단위과세자여부
                sData.append( this.csformat(mapC.get("SUB_DIV_NUM"), 4));               // 18.종사업장 일련번호  				
                sData.append( this.csformat(mapC.get("RELIGION_YN"), 1));               // 19.종교관련종사자 여부				>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
                                      
                //근무처별 소득명세- 주(현)근무처
                sData.append( this.csformat(mapC.get("COMPANY_NUM_NOW"), 10));          // 20.주현근무처-사업자등록번호
                sData.append( this.csformat(mapC.get("DIV_NAME_NOW"), 60));             // 21.주현근무처-근무처명
                sData.append( this.cnformat(mapC.get("STRT_DATE"), 8));                 // 22.근무기간시작연월일
                sData.append( this.cnformat(mapC.get("END_DATE"), 8));                  // 23.근무기간종료연월일
                sData.append( this.cnformat(mapC.get("NONTAX_FR"), 8));                 // 24.감면기간시작연월일
                sData.append( this.cnformat(mapC.get("NONTAX_TO"), 8));                 // 25.감면기간종료연월일
                sData.append( this.cnformat(mapC.get("PAY_TOTAL_I"), 11));              // 26.급여총액
                sData.append( this.cnformat(mapC.get("BONUS_TOTAL_I"), 11));            // 27.상여총액
                sData.append( this.cnformat(mapC.get("ADD_BONUS_TOTAL_I"), 11));        // 28.인정상여
                sData.append( this.cnformat(mapC.get("NOW_STOCK_PROFIT_I"), 11));       // 29.주식매수선택권행사이익
                sData.append( this.cnformat(mapC.get("NOW_OWNER_STOCK_DRAW_I"), 11));   // 30.우리사주조합인출금
                sData.append( this.cnformat(mapC.get("NOW_OF_RETR_OVER_I"), 11));       // 31.임원퇴직소득한도초과액
                sData.append( this.cnformat(mapC.get("NOW_TAX_INVENTION_I"), 11));      // 32.직무발명보상금 - 비과세일괄적용 로직 확인 후 수정
                sData.append( this.cnformat("0", 21));                                  // 33.공란
                sData.append( this.cnformat(mapC.get("NOW_INCOME_TOTAL"), 11));         // 34.주현소득계
                             
                //주(현)근무처 비과세 및 감면소득
                sData.append( this.cnformat(mapC.get("G01_I"), 10));                    // 35.비과세학자금
                sData.append( this.cnformat(mapC.get("H01_I"), 10));                    // 36.무보수위원수당
                sData.append( this.cnformat(mapC.get("H05_I"), 10));                    // 37.경호승선수당
                sData.append( this.cnformat(mapC.get("H06_I"), 10));                    // 38.유아초중등
                sData.append( this.cnformat(mapC.get("H07_I"), 10));                    // 39.고등교육법
                sData.append( this.cnformat(mapC.get("H08_I"), 10));                    // 40.특별법
                sData.append( this.cnformat(mapC.get("H09_I"), 10));                    // 41.연구기관등
                sData.append( this.cnformat(mapC.get("H10_I"), 10));                    // 42.기업부설연구소
                sData.append( this.cnformat(mapC.get("H14_I"), 10));                    // 43.보육교사근무환경개선비
                sData.append( this.cnformat(mapC.get("H15_I"), 10));                    // 44.사립유치원수석교사교사의인건비
                sData.append( this.cnformat(mapC.get("H11_I"), 10));                    // 45.취재수당
                sData.append( this.cnformat(mapC.get("H12_I"), 10));                    // 46.벽지수당
                sData.append( this.cnformat(mapC.get("H13_I"), 10));                    // 47.재해관련급여
                sData.append( this.cnformat(mapC.get("H16_I"), 10));                    // 48.정부공공기관지방이전기관종사자이주수당
                sData.append( this.cnformat(mapC.get("H17_I"), 10));                    // 49.종교활동비
                sData.append( this.cnformat(mapC.get("I01_I"), 10));                    // 50.외국정부등근무자
                sData.append( this.cnformat(mapC.get("K01_I"), 10));                    // 51.외국주둔군인등
                sData.append( this.cnformat(mapC.get("M01_I"), 10));                    // 52.국외근로100만원
                sData.append( this.cnformat(mapC.get("M02_I"), 10));                    // 53.국외근로200만원(300만원)
                sData.append( this.cnformat(mapC.get("M03_I"), 10));                    // 54.국외근로
                sData.append( this.cnformat(mapC.get("O01_I"), 10));                    // 55.야간근로수당
                sData.append( this.cnformat(mapC.get("Q01_I"), 10));                    // 56.출산보육수당
                sData.append( this.cnformat(mapC.get("R10_I"), 10));                    // 57.근로장학금
                sData.append( this.cnformat(mapC.get("R11_I"), 10));                    // 58.직무발명보상금
                sData.append( this.cnformat(mapC.get("S01_I"), 10));                    // 59.주식매수선택권
                sData.append( this.cnformat(mapC.get("U01_I"), 10));                    // 60.벤처기업주식매수선택권
                sData.append( this.cnformat(mapC.get("Y02_I"), 10));                    // 61-a.우리사주조합인출금50%
                sData.append( this.cnformat(mapC.get("Y03_I"), 10));                    // 61-b.우리사주조합인출금75%
                sData.append( this.cnformat(mapC.get("Y04_I"), 10));                    // 61-c.우리사주조합인출금100%
                sData.append( this.cnformat(mapC.get("Y22_I"), 10));                    // 62.전공의수련보조수당
                sData.append( this.cnformat(mapC.get("T01_I"), 10));                    // 63.외국인기술자
                
                sData.append( this.cnformat(mapC.get("T30_I"), 10));                   	// 64-33 T30-성과공유 중소기업 경영성과급	>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
                sData.append( this.cnformat(mapC.get("T40_I"), 10));                   	// 65-34 T40-중소기업 핵심인력 성과보상기금 소득세 감면 >>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
                
                sData.append( this.cnformat(mapC.get("T11_1"), 10));                    // 66-a.중소기업취업청년소득세감면(50%)
                sData.append( this.cnformat(mapC.get("T12_1"), 10));                    // 66-b.중소기업취업청년소득세감면(70%)
                sData.append( this.cnformat(mapC.get("T13_1"), 10));                    // 66-c.중소기업취업청년소득세감면(90%)
                sData.append( this.cnformat(mapC.get("T20_1"), 10));                    // 67.조세조약상교직자감면삭
                sData.append( this.cnformat(mapC.get("NON_TAX_TOTAL"), 10));            // 68.비과세계
                sData.append( this.cnformat(mapC.get("NON_TAX_PAY_TOTAL"), 10));        // 69.감면소득계
                             
                //정산명세
                sData.append( this.cnformat(mapC.get("TAX_SUM"), 11));                  // 70.총급여
                sData.append( this.cnformat(mapC.get("INCOME_DED_I"), 10));             // 71.근로소득공제
                sData.append( this.cnformat(mapC.get("EARN_INCOME_I"), 11));            // 72.근로소득금액
                                      
                //기본공제
                sData.append( this.cnformat(mapC.get("PER_DED_I"), 8));                 // 73.본인공제금액
                sData.append( this.cnformat(mapC.get("SPOUSE_DED_I"), 8));              // 74.배우자공제금액
                sData.append( this.cnformat(mapC.get("SUPP_NUM"), 2));                  // 75-a.부양가족공제인원
                sData.append( this.cnformat(mapC.get("SUPP_SUB_I"), 8));                // 75-b.부양가족공제금액
                             
                //추가공제
                sData.append( this.cnformat(mapC.get("AGED_NUM"), 2));                  // 76-a.경로우대공제인원
                sData.append( this.cnformat(mapC.get("AGED_DED_I"), 8));                // 76-b.경로우대공제금액
                sData.append( this.cnformat(mapC.get("DEFORM_NUM"), 2));                // 77-a.장애인공제인원
                sData.append( this.cnformat(mapC.get("DEFORM_DED_I"), 8));              // 77-b.장애인공제금액
                sData.append( this.cnformat(mapC.get("WOMAN_DED_I"), 8));               // 78.부녀자공제금액
                sData.append( this.cnformat(mapC.get("ONE_PARENT_DED_I"), 10));         // 79.한부모가족공제금액
                                      
                //연금보험료공제
                sData.append( this.cnformat(mapC.get("ANU_I"), 10));                	// 80-a.국민연금보험료공제_대상금액
                sData.append( this.cnformat(mapC.get("ANU_DED_I"), 10));                // 80-b.국민연금보험료공제_공제금액
                sData.append( this.cnformat(mapC.get("PUBLIC_PENS_I"), 10));            // 81-a.기타연금보험료공제-공무원연금_대상금액
                sData.append( this.cnformat(mapC.get("PUBLIC_PENS_DED_I"), 10));        // 81-b.기타연금보험료공제-공무원연금_공제금액
                sData.append( this.cnformat(mapC.get("SOLDIER_PENS_I"), 10));           // 82-a.기타연금보험료공제-군인연금_대상금액
                sData.append( this.cnformat(mapC.get("SOLDIER_PENS_DED_I"), 10));       // 82-b.기타연금보험료공제-군인연금_공제금액
                sData.append( this.cnformat(mapC.get("SCH_PENS_I"), 10));               // 83-a.기타연금보험료공제-사립학교교직원연금_대상금액
                sData.append( this.cnformat(mapC.get("SCH_PENS_DED_I"), 10));           // 83-b.기타연금보험료공제-사립학교교직원연금_공제금액
                sData.append( this.cnformat(mapC.get("POST_PENS_I"), 10));              // 84-a.기타연금보험료공제-별정우체국연금_대상금액
                sData.append( this.cnformat(mapC.get("POST_PENS_DED_I"), 10));          // 84-b.기타연금보험료공제-별정우체국연금_공제금액
                
                //특별공제
                sData.append( this.cnformat(mapC.get("MED_PREMINM_I"), 10));            // 85-a.보험료-건강보험료_대상금액
                sData.append( this.cnformat(mapC.get("MED_PREMINM_DED_I"), 10));        // 85-b.보험료-건강보험료_공제금액
                sData.append( this.cnformat(mapC.get("HIRE_INSUR_I"), 10));             // 86-a.보험료-고용보험료_대상금액
                sData.append( this.cnformat(mapC.get("HIRE_INSUR_DED_I"), 10));         // 86-b.보험료-고용보험료_공제금액
                sData.append( this.cnformat(mapC.get("HOUS_AMOUNT_I"), 8));             // 87-a.주택임차차입금원리금상환액_대출기관
                sData.append( this.cnformat(mapC.get("HOUS_AMOUNT_I_2"), 8));           // 87-b.주택임차차입금원리금상환액_거주자
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_2"), 8));       // 88-a.장기주택저당차입금_15년미만
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I"), 8));         // 88-b.장기주택저당차입금이자상환액_15년~29년
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_3"), 8));       // 88-c.장기주택저당차입금이자상환액_30년이상
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_5"), 8));       // 89-a.고정금리비거치식상환대출
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_4"), 8));       // 89-b.기타대출
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_6"), 8));       // 90-a.2015년15년이상(고정금리& 비거치식)
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_7"), 8));       // 90-b.2015년15년이상(고정금리OR비거치식)
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_8"), 8));       // 90-c.2015년15년이상(그밖의대출)
                sData.append( this.cnformat(mapC.get("MORTGAGE_RETURN_I_9"), 8));       // 90-d.2015년10년이상(고정금리OR비거치식)
                sData.append( this.cnformat(mapC.get("GIFT_DED_I"), 11));               // 91.기부금(이월분)
                sData.append( this.cnformat("0", 11));                                  // 92.공란
                sData.append( this.cnformat("0", 11));                                  // 93.공란
                sData.append( this.cnformat(mapC.get("SP_DED_TOTAL"), 11));             // 94.특별소득공제계
                sData.append( this.cnformat(mapC.get("DED_INCOME_I"), 11));             // 95.차감소득금액
                //그밖의소득공제
                sData.append( this.cnformat(mapC.get("PRIV_PENS_I"), 8));               // 96.개인연금저축소득공제
                sData.append( this.cnformat(mapC.get("COMP_PREMINUM_DED_I"), 10));      // 97.소기업공제부금소득공제
                sData.append( this.cnformat(mapC.get("HOUS_BU_AMT"), 10));              // 98.청약저축
                sData.append( this.cnformat(mapC.get("HOUS_BU_AMOUNT_I"), 10));         // 99.주택청약종합저축
                sData.append( this.cnformat(mapC.get("HOUS_WORK_AMT"), 10));            //100.근로자주택마련저축
                sData.append( this.cnformat(mapC.get("INVESTMENT_DED_I"), 10));         //101.투자조합출자등소득공제
                sData.append( this.cnformat(mapC.get("CARD_DED_I"), 8));                //102.신용카드등소득공제
                sData.append( this.cnformat(mapC.get("STAFF_STOCK_DED_I"), 10));        //103.우리사주조합소득공제
                sData.append( this.cnformat(mapC.get("EMPLOY_WORKER_DED_I"), 10));      //104.고용유지중소기업근로자소득금액
                sData.append( this.cnformat(mapC.get("LONG_INVEST_STOCK_DED_I"), 10));  //105.장기집합투자증권저축
                sData.append( this.cnformat("0", 10));                                  //106.공란
                sData.append( this.cnformat("0", 10));                                  //107.공란
                sData.append( this.cnformat(mapC.get("ETC_DED_I"), 11));                //108.그밖의소득공제계
                sData.append( this.cnformat(mapC.get("OVER_INCOME_DED_LMT"), 11));      //109.특별공제종합한도초과액
                sData.append( this.cnformat(mapC.get("TAX_STD_I"), 11));                //110.종합소득과세표준
                sData.append( this.cnformat(mapC.get("COMP_TAX_I"), 10));               //111.산출세액
                
                //세액감면
                sData.append( this.cnformat(mapC.get("INCOME_REDU_I"), 10));            //112.소득세법
                sData.append( this.cnformat(mapC.get("SKILL_DED_I"), 10));              //113.조특법
                sData.append( this.cnformat(mapC.get("YOUTH_DED_I"), 10));              //114.조특법 제30조
                sData.append( this.cnformat(mapC.get("TAXES_REDU_I"), 10));             //115.조세조약
                sData.append( this.cnformat("0", 10));                                  //116.공란
                sData.append( this.cnformat("0", 10));                                  //117.공란
                sData.append( this.cnformat(mapC.get("REDU_TAX_SUM_I"), 10));           //118.세액감면계
                                      
                //세액공제
                sData.append( this.cnformat(mapC.get("IN_TAX_DED_I"), 10));             //119.근로소득세액공제
                sData.append( this.cnformat(mapC.get("MANY_CHILD_NUM"), 2));            //120-a.자녀세액공제인원
                sData.append( this.cnformat(mapC.get("CHILD_TAX_DED_I"), 10));          //120-b.자녀세액공제
                sData.append( this.cnformat(mapC.get("BIRTH_ADOPT_NUM"), 2));           //121-a.출산입양세액공제인원
                sData.append( this.cnformat(mapC.get("BIRTH_ADOPT_I"), 10));            //121-b.출산입양세액공제
                sData.append( this.cnformat(mapC.get("SCI_DEDUC_I"), 10));              //122-a.과학기술인공제대상
                sData.append( this.cnformat(mapC.get("SCI_TAX_DED_I"), 10));            //122-b.과학기술인세액공제
                sData.append( this.cnformat(mapC.get("RETIRE_PENS_I"), 10));            //123-a.근로자퇴직급여공제대상
                sData.append( this.cnformat(mapC.get("RETIRE_TAX_DED_I"), 10));         //123-b.근로자퇴직급여세액공제
                sData.append( this.cnformat(mapC.get("PENS_I"), 10));                   //124-a.연금저축공제대상
                sData.append( this.cnformat(mapC.get("PENS_TAX_DED_I"), 10));           //124-b.연금저축세액공제
                sData.append( this.cnformat(mapC.get("ETC_INSUR_I"), 10));              //125-a.특별세액공제-보장성보험공제대상
                sData.append( this.cnformat(mapC.get("ETC_INSUR_TAX_DED_I"), 10));      //125-b.특별세액공제-보장성보험세액공제
                sData.append( this.cnformat(mapC.get("DEFORM_INSUR_I"), 10));           //126-a.특별세액공제-장애인전용보험료_공제대상
                sData.append( this.cnformat(mapC.get("DEFORM_INSUR_TAX_DED_I"), 10));   //126-b.특별세액공제-장애인전용보험료_세액공제액
                sData.append( this.cnformat(mapC.get("MED_DED_I"), 10));                //127-a.특별세액공제-의료비공제대상
                sData.append( this.cnformat(mapC.get("MED_TAX_DED_I"), 10));            //127-b.특별세액공제-의료비세액공제
                sData.append( this.cnformat(mapC.get("EDUC_DED_I"), 10));               //128-a.특별세액공제-교육비공제대상
                sData.append( this.cnformat(mapC.get("EDUC_TAX_DED_I"), 10));           //128-b.특별세액공제-교육비세액공제
                sData.append( this.cnformat(mapC.get("POLICY_INDED_DED_AMT"), 10));     //129-a.특별세액공제-정치자금10만원이하공제대상
                sData.append( this.cnformat(mapC.get("POLICY_INDED_TAX_DED_I"), 10));   //129-b.특별세액공제-정치자금10만원이하세액공제
                sData.append( this.cnformat(mapC.get("POLICY_GIFT_DED_AMT"), 11));      //130-a.특별세액공제-정치자금10만원초과공제대상
                sData.append( this.cnformat(mapC.get("POLICY_GIFT_TAX_DED_I"), 10));    //130-b.특별세액공제-정치자금10만원초과세액공제
                sData.append( this.cnformat(mapC.get("LEGAL_DED_AMT"), 11));            //131-a.특별세액공제-법정기부금공제대상
                sData.append( this.cnformat(mapC.get("LEGAL_GIFT_TAX_DED_I"), 10));     //131-b.특별세액공제-법정기부금세액공제
                sData.append( this.cnformat(mapC.get("STAFF_DED_AMT"), 11));            //132-a.특별세액공제-우리사주조합기부금공제대상
                sData.append( this.cnformat(mapC.get("STAFF_GIFT_TAX_DED_I"), 10));     //132-b.특별세액공제-우리사주조합기부금세액공제
                sData.append( this.cnformat(mapC.get("APPOINT_DED_AMT"), 11));          //133-a.특별세액공제-지정기부금공제대상(종교단체외)
                sData.append( this.cnformat(mapC.get("APPOINT_TAX_DED_I"), 10));        //133-b.특별세액공제-지정기부금세액공제(종교단체외)
                sData.append( this.cnformat(mapC.get("ASS_DED_AMT"), 11));              //134-a.특별세액공제-지정기부금공제대상(종교단체)
                sData.append( this.cnformat(mapC.get("ASS_TAX_DED_I"), 10));            //134-b.특별세액공제-지정기부금세액공제(종교단체)
                sData.append( this.cnformat("0", 11));                                  //135.공란
                sData.append( this.cnformat("0", 11));                                  //136.공란
                sData.append( this.cnformat(mapC.get("SPECIAL_TAX_DED_I"), 10));        //137.특별세액공제계
                sData.append( this.cnformat(mapC.get("STD_TAX_DED_I"), 10));            //138.표준세액공제
                sData.append( this.cnformat(mapC.get("NAP_TAX_DED_I"), 10));            //139.납세조합공제
                sData.append( this.cnformat(mapC.get("HOUS_INTER_I"), 10));             //140.주택차입금
                sData.append( this.cnformat(mapC.get("OUTSIDE_INCOME_I"), 10));         //141.외국납부
                sData.append( this.cnformat(mapC.get("MON_RENT_I"), 10));               //142-a.월세액공제대상
                sData.append( this.cnformat(mapC.get("MON_RENT_TAX_DED_I"), 8));        //142-b.월세세액공제
                sData.append( this.cnformat("0", 10));                                  //143.공란
                sData.append( this.cnformat("0", 10));                                  //144.공란
                sData.append( this.cnformat(mapC.get("TAX_DED_SUM_I"), 10));            //145.세액공제계
                                      
                //결정세액
                sData.append( this.cnformat(mapC.get("DEF_IN_TAX_I"), 10));             //146-a.소득세
                sData.append( this.cnformat(mapC.get("DEF_LOCAL_TAX_I"), 10));          //146-b.지방소득세
                sData.append( this.cnformat(mapC.get("DEF_SP_TAX_I"), 10));             //146-c.농특세
                             
                             
                //기납부세액 - 주(현)근무지
                sData.append( this.cnformat(mapC.get("NOW_IN_TAX_I"), 10));             //147-a.소득세
                sData.append( this.cnformat(mapC.get("NOW_LOCAL_TAX_I"), 10));          //147-b.지방소득세
                sData.append( this.cnformat(mapC.get("NOW_SP_TAX_I"), 10));             //147-c.농특세

                //납부특례세액
                sData.append( this.cnformat(mapC.get("SPEC_IN_TAX_I"), 10));            //148-a.소득세
                sData.append( this.cnformat(mapC.get("SPEC_LOCAL_TAX_I"), 10));         //148-b.지방소득세
                sData.append( this.cnformat(mapC.get("SPEC_SP_TAX_I"), 10));            //148-c.농특세

                //차감징수세액 [주(현)근무지 기납부세액 + 종(전)근무지 기납부세액의 합]
                sData.append( this.csformat(mapC.get("IN_TAX_TYPE"), 1));               //149-a.소득세타입   
                sData.append( this.cnformat(mapC.get("IN_TAX_I"), 10));                 //149-a.소득세
                sData.append( this.csformat(mapC.get("LOCAL_TAX_TYPE"), 1));            //149-b.지방소득세타입
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_I"), 10));              //149-b.지방소득세
                sData.append( this.csformat(mapC.get("SP_TAX_TYPE"), 1));               //149-c.농특세타입
                sData.append( this.cnformat(mapC.get("SP_TAX_I"), 10));                 //149-c.농특세
                sData.append( this.csformat(mapC.get("C_SPACE"), 248));                  //150.공란
                sData.append( "\n" );
                bytesArray = sData.toString().getBytes();
                fos.write(bytesArray);

    		    logger.debug("C Record : "+String.valueOf(bytesArray.length));
		    	//D 레코드
			    Map<String, Object> pFilterParam = new HashMap();
			    
			    pFilterParam.put("SECT_CODE",mapC.get("SECT_CODE"));
			    pFilterParam.put("PERSON_NUMB",mapC.get("PERSON_NUMB"));
		    	/*List<Map<String,Object>> subListD = this.filterList(listD, pFilterParam);	
		    	List<Map<String,Object>> subListE = this.filterList(listE, pFilterParam);	
		    	List<Map<String,Object>> subListF = this.filterList(listF, pFilterParam);	
		    	List<Map<String,Object>> subListG = this.filterList(listG, pFilterParam);	
		    	List<Map<String,Object>> subListH = this.filterList(listH, pFilterParam);	
		    	List<Map<String,Object>> subListI = this.filterList(listI, pFilterParam);	*/
		    	
			    List<Map<String,Object>> subListD = this.filterList(listD, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	List<Map<String,Object>> subListE = this.filterList(listE, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	List<Map<String,Object>> subListF = this.filterList(listF, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	List<Map<String,Object>> subListG = this.filterList(listG, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	List<Map<String,Object>> subListH = this.filterList(listH, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	List<Map<String,Object>> subListI = this.filterList(listI, "PERSON_NUMB", mapC.get("PERSON_NUMB"));	
		    	
		    	
		    	int dI = 1;
			    for(Map<String,Object> mapD : subListD)	{
			    	sData = new StringBuffer();
			    	//자료관리번호
			    	sData.append( "D" );                                                    // 1.레코드구분
                    sData.append( "20");                                                    // 2.자료구분
                    sData.append( this.csformat(mapD.get("SAFFER"), 3));                    // 3.세무서코드
                    sData.append( this.cnformat(cI, 6));                                    // 4.일련번호

                    //원천징수의무자
                    sData.append( this.csformat(mapD.get("COMPANY_NUM"), 10));              // 5.사업자등록번호
                    //sData.append( this.csformat("", 50));                                   // 6.
                                          
                    //소득자
                    sData.append( this.csformat(mapD.get("REPRE_NUM"), 13));                // 6.소득자주민등록번호
                                          
                    //근무처별 소득명세- 종(전)근무처
                    sData.append( this.csformat(mapD.get("P_GUBUN"), 1));                   // 7.납세조합여부
                    sData.append( this.csformat(mapD.get("P_COMPANY_NAME"), 60));           // 8.법인명
                    sData.append( this.csformat(mapD.get("P_COMPANY_NUM"), 10));            // 9.종(전)근무지 사업자등록번호
                    sData.append( this.cnformat(mapD.get("STRT_DATE"), 8));                 //10.근무기간 시작 년월일
                    sData.append( this.cnformat(mapD.get("END_DATE"), 8));                  //11.근무기간 종료 년월일
                    sData.append( this.cnformat(mapD.get("P_NONTAX_FR"), 8));               //12.감면기간 시작 년월일
                    sData.append( this.cnformat(mapD.get("P_NONTAX_TO"), 8));               //13.감면기간 종료 년월일
                    sData.append( this.cnformat(mapD.get("P_PAY_TOTAL_I"), 11));            //14.급여
                    sData.append( this.cnformat(mapD.get("P_BONUS_I_TOTAL_I"), 11));        //15.상여
                    sData.append( this.cnformat(mapD.get("P_ADD_BONUS_I"), 11));            //16.인정상여
                    sData.append( this.cnformat(mapD.get("P_STOCK_BUY_PROFIT_I"), 11));     //17.주식매수선택권행사이익
                    sData.append( this.cnformat(mapD.get("P_OWNER_STOCK_DRAW_I"), 11));     //18.우리사주조합인출금
                    sData.append( this.cnformat(mapD.get("P_OF_RETR_OVER_I"), 11));         //19.임원퇴직소득한도 초과액
                    sData.append( this.cnformat(mapD.get("P_TAX_INVENTION_I"), 11));        //20.직무발명보상금 (한도 초과액)
                    sData.append( this.cnformat("0", 22));                                  //21.공란
                    sData.append( this.cnformat(mapD.get("TOTAL_I"), 11));                  //23.계
                    
                    //종(전)근무처 비과세 및 감면소득
                    sData.append( this.cnformat(mapD.get("G01_I"), 10));                    //24.비과세학자금
                    sData.append( this.cnformat(mapD.get("H01_I"), 10));                    //25.무보수위원수당
                    sData.append( this.cnformat(mapD.get("H05_I"), 10));                    //26.경호/승선수당
                    sData.append( this.cnformat(mapD.get("H06_I"), 10));                    //27.유아,초,중등
                    sData.append( this.cnformat(mapD.get("H07_I"), 10));                    //28.고등교육법
                    sData.append( this.cnformat(mapD.get("H08_I"), 10));                    //29.특별법
                    sData.append( this.cnformat(mapD.get("H09_I"), 10));                    //30.연구기관
                    sData.append( this.cnformat(mapD.get("H10_I"), 10));                    //31.기업부설연구소
                    sData.append( this.cnformat(mapD.get("H14_I"), 10));                    //32.보육교사 근무환경 개선비
                    sData.append( this.cnformat(mapD.get("H15_I"), 10));                    //33.사립유치원 (수석)교사인건비
                    sData.append( this.cnformat(mapD.get("H11_I"), 10));                    //34.취재수당
                    sData.append( this.cnformat(mapD.get("H12_I"), 10));                    //35.벽지수당
                    sData.append( this.cnformat(mapD.get("H13_I"), 10));                    //36.재해관련급여
                    sData.append( this.cnformat(mapD.get("H16_I"), 10));                    //37.정부,공공기관 지방 이전기관 종사자 이주수당
                    sData.append( this.cnformat(mapD.get("H17_I"), 10));                    //38.종교활동비
                    sData.append( this.cnformat(mapD.get("I01_I"), 10));                    //39.외국정부 등 근무자
                    sData.append( this.cnformat(mapD.get("K01_I"), 10));                    //40.외국주둔군인 등
                    sData.append( this.cnformat(mapD.get("M01_I"), 10));                    //41.국외근로 100만원
                    sData.append( this.cnformat(mapD.get("M02_I"), 10));                    //42.국외근로 300만원
                    sData.append( this.cnformat(mapD.get("M03_I"), 10));                    //43.국외근로
                    sData.append( this.cnformat(mapD.get("O01_I"), 10));                    //44.야간근로수당
                    sData.append( this.cnformat(mapD.get("Q01_I"), 10));                    //45.출산보육수당
                    sData.append( this.cnformat(mapD.get("R10_I"), 10));                    //46.근로장학금
                    sData.append( this.cnformat(mapD.get("R11_I"), 10));                    //47.R11-직무발명보상금
                    sData.append( this.cnformat(mapD.get("S01_I"), 10));                    //48.주식매수선택권
                    sData.append( this.cnformat(mapD.get("U01_I"), 10));                    //49.벤처기업 주식매수선택권
                    sData.append( this.cnformat(mapD.get("Y02_I"), 10));                    //50-a.우리사주조합인출금(50%)
                    sData.append( this.cnformat(mapD.get("Y03_I"), 10));                    //50-b.우리사주조합인출금(75%)
                    sData.append( this.cnformat(mapD.get("Y04_I"), 10));                    //50-c.우리사주조합인출금(100%)
                    sData.append( this.cnformat(mapD.get("Y22_I"), 10));                    //51.전공의 수련 보조수당
                    sData.append( this.cnformat(mapD.get("T01_I"), 10));                    //52.외국인 기술자
                    sData.append( this.cnformat(mapD.get("T30_I"), 10));					//53.-33 T30-성과공유 중소기업 경영성과급     >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
                    sData.append( this.cnformat(mapD.get("T40_I"), 10));					//54.-34 T40-중소기업 핵심인력 성과보상기금 수령액  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
                    sData.append( this.cnformat(mapD.get("T11_I"), 10));                    //55-a.중소기업취업청년 소득세감면( 50%)
                    sData.append( this.cnformat(mapD.get("T12_I"), 10));                    //55-b.중소기업취업청년 소득세감면( 70%)
                    sData.append( this.cnformat(mapD.get("T13_I"), 10));                    //55-c.중소기업취업청년 소득세감면( 90%)
                    sData.append( this.cnformat(mapD.get("T20_I"), 10));                    //56.조세조약상 교직자 감면
                    sData.append( this.cnformat(mapD.get("NON_TAX_TOTAL"), 10));            //57.비과세 계
                    sData.append( this.cnformat(mapD.get("NON_TAX_REDU_TOTAL"), 10));        //58.감면소득 계
                    
                    //기납부세액 - 종(전)근무지
                    sData.append( this.cnformat(mapD.get("P_IN_TAX_I"), 10));               //59-a.소득세
                    sData.append( this.cnformat(mapD.get("P_LOCAL_TAX_I"), 10));            //59-b.지방소득세
                    sData.append( this.cnformat(mapD.get("P_SP_TAX_I"), 10));               //59-c.농특세
                    sData.append( this.cnformat(dI, 2));                                    //60.종(전)근무처 일련번호
                    sData.append( this.csformat(mapD.get("D_SPACE"), 1412));                //61.공란
                    sData.append( "\n" );
                    
                    bytesArray = sData.toString().getBytes();
                    fos.write(bytesArray);

        		    logger.debug("D Record : "+String.valueOf(bytesArray.length));
			    	dI++;
			    }
    			    //E 레코드
    			    int remainder = 0;
    			    int eI=0 ;
    			    int lineNum = 1;
    			    Map<String, Object> mapE = null;
    			    if(subListE != null && subListE.size() > 0)	{
	    			    for( eI=0 ;eI < subListE.size() ; eI++)	{
	    			    	mapE = subListE.get(eI);
	    			    	remainder = eI % 5;
	    			    	if(remainder == 0)	{	
		    			    	sData = new StringBuffer();
		    			    	//자료관리번호
		        			    sData.append( "E" );                                                // 1.레코드구분
		                        sData.append( "20" );                                               // 2.자료구분
		                        sData.append( this.csformat(mapE.get("SAFFER"), 3));                // 3.세무서
		                        sData.append( this.cnformat(cI, 6));                                // 4.일련번호
		                                              
		                        //원천징수의무자
		                        sData.append( this.csformat(mapE.get("COMPANY_NUM"), 10));          // 5.사업자등록번호
		                                              
		                        // 소득자
		                        sData.append( this.csformat(mapE.get("REPRE_NUM"), 13));            // 6.소득자주민등록번호
		    			    }
	    			    
	                        //소득공제명세1의 인적사항
	                        sData.append( this.csformat(mapE.get("REL_CODE"), 1));              // 7.관계
	                        sData.append( this.csformat(mapE.get("IN_FORE"), 1));               // 8.내외국인구분코드
	                        sData.append( this.csformat(mapE.get("FAMILY_NAME"), 30));          // 9.성명
	                        sData.append( this.csformat(mapE.get("FAMILY_REPRE_NUM"), 13));     //10.주민등록번호
	                        sData.append( this.csformat(mapE.get("DEFAULT_DED_YN"), 1));        //11.기본공제
	                        sData.append( this.csformat(mapE.get("DEFORM_KIND_CODE"), 1));      //12.장애인공제
	                        sData.append( this.csformat(mapE.get("WOMAN_DED_YN"), 1));          //13.부녀자공제
	                        sData.append( this.csformat(mapE.get("OLD_DED_YN"), 1));            //14.경로우대공제
	                        sData.append( this.csformat(mapE.get("ONE_PARENT_DED_YN"), 1));     //15.한부모
	                        sData.append( this.csformat(mapE.get("BIRTH_ADOPT_DED_YN"), 1));    //16.출산입양
	                        sData.append( this.csformat(mapE.get("BRING_CHILD_DED_YN"), 1));    //17.자녀
	                        sData.append( this.csformat(mapE.get("EDU_CODE"), 1));              //18.교육비공제
	                            
	                        //소득공제명세1의 국세청 자료
	                        sData.append( this.cnformat(mapE.get("MED_PREMINM_I"), 10));        //19.보험료_건강보험
	                        sData.append( this.cnformat(mapE.get("HIRE_INSUR_I"), 10));         //20.보험료_고용보험
	                        sData.append( this.cnformat(mapE.get("INSUR_USE_I"), 10));          //21.보험료_보장성
	                        sData.append( this.cnformat(mapE.get("DEFORM_USE_I"), 10));         //22.보험료_장애인전용보장성
	                        sData.append( this.cnformat(mapE.get("MED_USE_I"), 10));            //23.의료비
	                        sData.append( this.cnformat(mapE.get("SURGERY_MED_I"), 10));        //24.의료비(난임)
	                        sData.append( this.cnformat(mapE.get("SERIOUS_SICK_MED_I"), 10));   //25.의료비(건강보험산정특례자)
	                        sData.append( this.cnformat(mapE.get("REAL_LOSS_MED_INSUR_I"), 10));//26.의료비_실손의료보험금		>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  추가
	                        sData.append( this.cnformat(mapE.get("EDU_USE_I"), 10));            //27.교육비
	                        sData.append( this.cnformat(mapE.get("EDU_DEFORM_USE_I"), 10));     //28.교육비_장애인
	                        sData.append( this.cnformat(mapE.get("CARD_USE_I"), 10));           //29.신용카드(전통시장대중교통비제외)
	                        sData.append( this.cnformat(mapE.get("DEBIT_CARD_USE_I"), 10));     //30.직불선불카드(전통시장대중교통비제외)
	                        sData.append( this.cnformat(mapE.get("CASH_USE_I"), 10));           //31.현금영수증(전통시작대중교통비제외)
	                        sData.append( this.cnformat(mapE.get("BOOK_CONCERT_USE_I"), 10));   //32.도서공연사용분
	                        sData.append( this.cnformat(0, 10));								//33.공란						>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
	                        sData.append( this.cnformat(mapE.get("TRA_MARKET_USE_I"), 10));     //34.전통시장사용액
	                        sData.append( this.cnformat(mapE.get("TRAFFIC_USE_I"), 10));        //35.대중교통이용액				>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 변경 (제로페이 사용금액 포함)
	                        sData.append( this.cnformat(mapE.get("GIFT_USE_I"), 13));           //36.기부금
	
	                        //소득공제명세1의 기타자료
	                        sData.append( this.cnformat(mapE.get("MED_PREMINM_I1"), 10));       //37.보험료_건강보험
	                        sData.append( this.cnformat(mapE.get("HIRE_INSUR_I1"), 10));        //38.보험료_고용보험
	                        sData.append( this.cnformat(mapE.get("INSUR_USE_I1"), 10));         //39.보험료외 보장성보험
	                        sData.append( this.cnformat(mapE.get("DEFORM_USE_I1"), 10));        //40.보험료외 장애인 전용보장성
	                        sData.append( this.cnformat(mapE.get("MED_USE_I1"), 10));           //41.의료비 - 일반				>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 확인필요
	                        sData.append( this.cnformat(mapE.get("SURGERY_MED_I1"), 10));       //42.의료비(난임)
	                        sData.append( this.cnformat(mapE.get("SERIOUS_SICK_MED_I1"), 10));  //43.의료비(건강보험산정특례자)
	                        sData.append( this.cnformat(mapE.get("REAL_LOSS_MED_INSUR_I1"), 10));//44.의료비_실손의료보험금		>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
	                        sData.append( this.cnformat(mapE.get("EDU_USE_I1"), 10));           //45.교육비 일반 			>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 확인필요
	                        sData.append( this.cnformat(mapE.get("EDU_DEFORM_USE_I1"), 10));    //46.교육비_장애인
	                        sData.append( this.cnformat(mapE.get("CARD_USE_I1"), 10));          //47.신용카드 외(전통시장대중교통비제외)
	                        sData.append( this.cnformat(mapE.get("DEBIT_CARD_USE_I1"), 10));    //48.직불선불카드 외(전통시장대중교통비제외)
	                        sData.append( this.cnformat(mapE.get("BOOK_CONCERT_USE_I1"), 10));  //49.도서공연사용분 외
	                        sData.append( this.cnformat(0, 10));								//50.공란						>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 추가
	                        sData.append( this.cnformat(mapE.get("TRA_MARKET_USE_I1"), 10));    //51.전통시작사용액 외
	                        sData.append( this.cnformat(mapE.get("TRAFFIC_USE_I1"), 10));       //52.대중교통이용액 외			>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 변경 (제로페이 사용금액 포함)
	                        sData.append( this.cnformat(mapE.get("GIFT_USE_I1"), 13));          //53.기부금 외
	      
	                        	
	                        if(remainder == 4)	{
	                        	sData.append( this.cnformat(lineNum, 2));                       //242.부양가족레코드일련번호
	            	            //sData.append( this.csformat(mapE.get("E_SPACE"), 288));         //168.공란

		                        //logger.debug("부양가족레코드일련번호 : "+String.valueOf(lineNum)+"  length : "+sData.toString().length());
	            	            sData.append( "\n" );
	            	            lineNum++;
	                            bytesArray = sData.toString().getBytes();
	                            fos.write(bytesArray);
	                            logger.debug("E Record : "+String.valueOf(bytesArray.length));
	                        }
	    			    }
	    			    for(int chkRemainder = remainder+1; chkRemainder < 5 ;chkRemainder++)	{
	                        sData.append( this.csformat("",53));
	                        sData.append( this.cnformat(0,356));
	                        
	                    }
	    			    if( remainder < 4 )	{
	    			    	sData.append( this.cnformat(lineNum, 2));                           //242.부양가족레코드일련번호
	        	            //sData.append( this.csformat(mapE.get("E_SPACE"), 288));             //168.공란
	    			    	//logger.debug("부양가족레코드일련번호 : "+String.valueOf(lineNum)+"  length : "+sData.toString().length());
	        	            sData.append( "\n" );
	        	            bytesArray = sData.toString().getBytes();
	        	            fos.write(bytesArray);
	        	            logger.debug("E Record : "+String.valueOf(bytesArray.length));
	    			    }
    			    }
                    
    			    //F 레코드
    			    remainder = 0;
    			    int fI=0 ;
    			    lineNum = 1;
    			    Map<String, Object> mapF = null;
    			    if(subListF != null && subListF.size() > 0)	{
	    			    for( ;fI < subListF.size() ; fI++)	{
	    			    	mapF = subListF.get(fI);
	    			    	remainder = fI % 15;
	    			    	if(remainder == 0)	{	
		    			    	sData = new StringBuffer();
		    			    	//자료관리번호
		        			    sData.append( "F" );                                            // 1.레코드구분
		                        sData.append( "20" );                                           // 2.자료구분
		                        sData.append( this.csformat(mapF.get("SAFFER"), 3));            // 3.세무서
		                        sData.append( this.cnformat(cI, 6));                            // 4.일련번호
		                                              
		                        //원천징수의무자
		                        sData.append( this.csformat(mapF.get("COMPANY_NUM"), 10));      // 5.사업자등록번호
		                                              
		                        // 소득자
		                        sData.append( this.csformat(mapF.get("REPRE_NUM"), 13));        // 6.소득자주민등록번호
		    			    }
	    			    
	                        //연금·저축등 소득공제명세
				    		sData.append( this.csformat(mapF.get("INCM_DDUC_CD"), 2));          // 7.소득공제구분
				    		sData.append( this.csformat(mapF.get("BANK_CODE"), 3));             // 8.금융기관코드
				    		sData.append( this.csformat(mapF.get("BANK_NAME"), 60));            // 9.금융기관상호
				    		sData.append( this.csformat(mapF.get("BANK_ACCOUNT"), 20));         //10.계좌번호(또는 중권번호)
				    		sData.append( this.cnformat(mapF.get("PAY_I"), 10));                //11.납입금액
				    		sData.append( this.cnformat(mapF.get("PENS_I"), 10));               //12.소득,세액공제금액
				    		sData.append( this.cnformat(mapF.get("INVEST_YEAR"), 4));           //13.투자연도    		>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  변경
				    		sData.append( this.csformat(mapF.get("INVEST_TYPE"), 1));           //14.투자구분			>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  변경
				    		
	                        if(remainder == 14)	{
	                        	sData.append( this.cnformat(lineNum, 2));                      //127.연금,저축레코드 일련번호
	                        	sData.append( this.csformat(mapF.get("F_SPACE"), 395));         //128.공란
	                        	lineNum++;
	            	            sData.append( "\n" );
	                            
	                            bytesArray = sData.toString().getBytes();
	                            fos.write(bytesArray);

		        	            logger.debug("F Record : "+String.valueOf(bytesArray.length));
	                        }
	    			    }
	    			    for(int chkRemainder = remainder+1; chkRemainder < 15 ;chkRemainder++)	{
	                        sData.append( this.csformat("",85));
	                        sData.append( this.cnformat(0,24));
	                        sData.append( this.csformat("",1));
	                    }
	    			    if( remainder < 14 )	{
                        	sData.append( this.cnformat(lineNum, 2));                          //127.연금,저축레코드 일련번호
	    			    	sData.append( this.csformat(mapF.get("F_SPACE"), 395));             //128.공란
	        	            sData.append( "\n" );
	                        bytesArray = sData.toString().getBytes();
	                        fos.write(bytesArray);

	        	            logger.debug("F Record : "+String.valueOf(bytesArray.length));
	    			    }
    			    }
                    
    			    //G 레코드
    			    remainder = 0;
    			    int gI=0 ;
    			    lineNum = 1;
    			    Map<String, Object> mapG = null;
			    	if(subListG != null && subListG.size() > 0)	{
	    			    for( ;gI < subListG.size() ; gI++)	{
	    			    	mapG = subListG.get(gI);
	    			    	remainder = gI % 3;
	    			    	if(remainder == 0)	{	
		    			    	sData = new StringBuffer();
		    			    	//자료관리번호
		        			    sData.append( "G" );                                                // 1.레코드구분
		                        sData.append( "20" );                                               // 2.자료구분
		                        sData.append( this.csformat(mapG.get("SAFFER_TAX"), 3));            // 3.세무서
		                        sData.append( this.cnformat(cI, 6));                                // 4.일련번호
		                                              
		                        //원천징수의무자
		                        sData.append( this.csformat(mapG.get("COMPANY_NUM"), 10));          // 5.사업자등록번호
		                                              
		                        // 소득자
		                        sData.append( this.csformat(mapG.get("REPRE_NUM"), 13));            // 6.소득자주민등록번호
		    			    }
	    			    	
	                        //월세액 소득공제 명세서
	                        sData.append( this.csformat(mapG.get("LEAS_NAME"), 60));                // 7.임대인 성명(상호)
	                        sData.append( this.csformat(mapG.get("LEAS_REPRE_NUM"), 13));           // 8.임대인 주민등록번호(사업자등록번호)
	                        sData.append( this.csformat(mapG.get("HOUSE_TYPE"), 1));                // 9.유형
	                        sData.append( this.cnformat(mapG.get("HOUSE_AREA"), 5));                //10.(월세)계약면적
	                        sData.append( this.csformat(mapG.get("LEAS_ADDR"), 100));               //11.임대차계약서상 주소지
	                        sData.append( this.cnformat(mapG.get("LEAS_BGN_DATE"), 8));             //12.임대차계약기간 개시일
	                        sData.append( this.cnformat(mapG.get("LEAS_END_DATE"), 8));             //13.임대차계약기간 종료일
	                        sData.append( this.cnformat(mapG.get("DDUC_OBJ_I"), 10));               //14.연간월세액(원)
	                        sData.append( this.cnformat(mapG.get("MON_RENT_I"), 10));               //15.세액공제금액(원)
	                                              
	                        //거주자간 주택임차차입금 원리금 상환액-금전소비대차계약
	                        sData.append( this.csformat(mapG.get("LEAS_NAME2"), 60));               //16.대주 성명
	                        sData.append( this.csformat(mapG.get("LEAS_REPRE_NUM2"), 13));          //17.대주 주민등록번호
	                        sData.append( this.cnformat(mapG.get("LEAS_BGN_DATE2"), 8));            //18.금전소비대차 계약기간 개시일
	                        sData.append( this.cnformat(mapG.get("LEAS_END_DATE2"), 8));            //19.금전소비대차 계약기간 종료일
	                        sData.append( this.cnformat(mapG.get("LEAS_RATE"), 4));                 //20.차입금 이자율
	                        sData.append( this.cnformat(mapG.get("LEAS_RETURN_I"), 10));            //21.원리금 상환액 계
	                        sData.append( this.cnformat(mapG.get("LEAS_ORI_I"), 10));               //22.원금
	                        sData.append( this.cnformat(mapG.get("LEAS_INTEREST_I"), 10));          //23.이자
	                        sData.append( this.cnformat(mapG.get("LEAS_DED_I"), 10));               //24.공제금액
	                                              
	                       //거주자간 주택임차차입금 원리금 상환액-임대차 계약
	                        sData.append( this.csformat(mapG.get("LEAS_NAME3"), 60));               //25.임대인 성명(상호)
	                        sData.append( this.csformat(mapG.get("LEAS_REPRE_NUM3"), 13));          //26.임대인 주민등록번호(사업자등록번호)
	                        sData.append( this.csformat(mapG.get("LEAS_HOUSE_TYPE"), 1));           //27.유형
	                        sData.append( this.cnformat(mapG.get("LEAS_HOUSE_AREA"), 5));           //28.(임대차)계약면적
	                        sData.append( this.csformat(mapG.get("LEAS_ADDR3"), 100));              //29.임대차계약서상 주소지
	                        sData.append( this.cnformat(mapG.get("LEAS_BGN_DATE3"), 8));            //30.임대차계약기간 개시일
	                        sData.append( this.cnformat(mapG.get("LEAS_END_DATE3"), 8));            //31.임대차계약기간 종료일
	                        sData.append( this.cnformat(mapG.get("YEAR_RENT_I"), 10));              //32.전세보증금(원)
	                        
	                        if(remainder == 2)	{
	                        	sData.append( this.cnformat(lineNum, 2));
	            	            sData.append( this.csformat(mapG.get("G_SPACE"), 186));             //86.공란
	            	            sData.append( "\n" );
	            	            lineNum++;
	                            bytesArray = sData.toString().getBytes();
	                            fos.write(bytesArray);

		        	            logger.debug("G Record : "+String.valueOf(bytesArray.length));
	                        }
	    			    }

	    			    for(int chkRemainder = remainder+1; chkRemainder < 3 ;chkRemainder++)	{
	                        sData.append( this.csformat("",74)+this.cnformat(0,5)+this.csformat("",100)+this.cnformat(0,36)); //7.~15.
	                        sData.append( this.csformat("",73)+this.cnformat(0,60)); //16.~24.
	                        sData.append( this.csformat("",74)+this.cnformat(0,5)+this.csformat("",100)+this.cnformat(0,26)); //25.~32.
	                    }
	    			    if( remainder < 2 )	{
	    			    	sData.append( this.cnformat(lineNum, 2));
	        	            sData.append( this.csformat(mapG.get("G_SPACE"), 386));                    //97.공란
	    			    	sData.append( "\n" );
	    			    	bytesArray = sData.toString().getBytes();
	    			    	fos.write(bytesArray);

	        	            logger.debug("G Record : "+String.valueOf(bytesArray.length));
	    			    }
    			    }
			    	
    			    //H 레코드
    			    int hI=0;
    			    for(Map<String, Object> mapH : subListH)	{
    			    	sData = new StringBuffer();
    			    	//자료관리번호
    			    	sData.append( "H" );                                                    // 1.레코드구분
                        sData.append( "20");                                                    // 2.자료구분
                        sData.append( this.csformat(mapH.get("SAFFER"), 3));					// 3.세무서
                        sData.append( this.cnformat(cI, 6));                                    // 4.소득자 일련번호

                        //원천징수의무자
                        sData.append( this.csformat(mapH.get("COMPANY_NUM"), 10));              // 5.사업자등록번호
                                              
                        //소득자(연말정산신청자)
                        sData.append( this.csformat(mapH.get("REPRE_NUM"), 13));                // 6.주민등록번호
                        sData.append( this.csformat(mapH.get("FORIGN"), 1));                    // 7.내외국인 구분코드
                        sData.append( this.csformat(mapH.get("NAME"), 30));                     // 8.성명
                        sData.append( this.csformat(mapH.get("GIFT_CODE"), 2));                 // 9.유형코드
                        sData.append( this.csformat(mapH.get("GIFT_YYYY"), 4));                 //10.기부연도
                        sData.append( this.cnformat(mapH.get("GIFT_AMOUNT_I"), 13));            //11.기부금액
                        sData.append( this.cnformat(mapH.get("BF_DDUC_I"), 13));                //12.전년까지 공제된 금액
                        sData.append( this.cnformat(mapH.get("DDUC_OBJ_I"), 13));               //13.공제대상금액
                        sData.append( this.cnformat(0, 13));                   					//14.해당연도 공제금액 필요경비           
                        sData.append( this.cnformat(mapH.get("PRP_DDUC_I"), 13));               //15.해당연도 공제금액 세액(소득)공제
                        sData.append( this.cnformat(mapH.get("PRP_LAPSE_I"), 13));              //16.해당연도에 공제받지 못한금액_소멸금액
                        sData.append( this.cnformat(mapH.get("PRP_OVER_I"), 13));               //17.해당연도에 공제받지 못한금액_이월금액
                        sData.append( this.cnformat(hI+1, 5));                                  //18.기부금조정명세일련번호
                        sData.append( this.csformat(mapH.get("H_SPACE"), 1914));                //19.공란
                        sData.append( "\n" );
    			    	bytesArray = sData.toString().getBytes();
    			    	fos.write(bytesArray);

        	            logger.debug("H Record : "+String.valueOf(bytesArray.length));
                        hI++;
    			    }
    			    
    			    //I레코드
    			    int iI=0;
    			    for(Map<String, Object> mapI : subListI)	{
    			    	sData = new StringBuffer();
    			    	//자료관리번호
    			    	sData.append( "I" );                                                    // 1.레코드구분
                        sData.append( "20");                                                    // 2.자료구분
                        sData.append( this.csformat(mapI.get("SAFFER"), 3));                    // 3.세무서
                        sData.append( this.cnformat(cI, 6));                                    // 4.소득자 일련번호

                        //원천징수의무자
                        sData.append( this.csformat(mapI.get("COMPANY_NUM"), 10));              // 5.사업자등록번호
                                              
                        //소득자(연말정산신청자)
                        sData.append( this.csformat(mapI.get("REPRE_NUM"), 13));                // 6.주민등록번호
                        
                        //기부유형코드
                        sData.append( this.csformat(mapI.get("GIFT_CODE"), 2));                 // 7.유형코드
                        sData.append( this.csformat("1", 1));                                   // 8.기부내용
                        
                        //기부처
                        sData.append( this.csformat(mapI.get("GIFT_COMPANY_NUM"), 13));         // 9.사업자(주민)등록번호
                        sData.append( this.csformat(mapI.get("GIFT_COMPANY_NAME"), 60));        //10.상호(법인명)
                        sData.append( this.csformat(mapI.get("REL_CODE"), 1));                  //11.관계코드
                        sData.append( this.cnformat(mapI.get("FORIGN"), 1));                    //12.내외국인구분코드
                        sData.append( this.csformat(mapI.get("GIFT_NAME"), 30));                //13.성명
                        sData.append( this.csformat(mapI.get("GIFT_REPRE_NUM"), 13));           //14.주민등록번호
                        
                        //기부내역
                        sData.append( this.cnformat(mapI.get("GIFT_COUNT"), 5));                //15.건수
                        sData.append( this.cnformat(mapI.get("GIFT_AMOUNT_I_SUM"), 13) );       //16.기부금합계금액
                        sData.append( this.cnformat(mapI.get("GIFT_AMOUNT_I"), 13));            //17.공제대상기부금액
                        sData.append( this.cnformat(mapI.get("SBDY_APLN_SUM"), 13));            //18.기부장려금신청금액
                        sData.append( this.cnformat(0, 13));                                    //19.기타
                        sData.append( this.cnformat(iI+1, 5));                                  //20.해당연도 기부명세 일련번호
                        sData.append( this.csformat(mapI.get("I_SPACE"), 1864));                //21.공란
                        sData.append( "\n" );
    			    	bytesArray = sData.toString().getBytes();
    			    	fos.write(bytesArray);

        	            logger.debug("I Record : "+String.valueOf(bytesArray.length));
                        iI++;
    			    }
			    
			    cI++;
		    }

	    }
	    fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
		return fInfo;
		
	}
	
	@ExtDirectMethod(group = "hum")
	public FileDownloadInfo doMedicalBatch(Map param) throws Exception {
		String sTaxAgentNo = ObjUtils.getSafeString(param.get("TAX_AGENT_NO"));
		String sSubmitter = "";
		FileDownloadInfo fInfo = null;
		
		
		if(ObjUtils.isNotEmpty(sTaxAgentNo))	{        //관리번호가 있으면 세무대리인 처리
	        sSubmitter = "1";
		}else {                            				//자료제출자가 세무대리인이 아닌 경우, 관리번호에 공백수록
	        sSubmitter = "2";
	        sTaxAgentNo = "";
		}

		List<Map<String,Object>> listA = super.commonDao.list("had820ukrServiceImpl.getSelectMedical", param);
		
		if(listA != null && listA.size() > 0)	{
			Map<String, Object> map = listA.get(0);
			String companyNum = ObjUtils.getSafeString(map.get("COMPANY_NUM"));
			
			
			File dir = new File(ConfigUtil.getUploadBasePath("hometaxAuto"));
			if(!dir.exists())  dir.mkdir(); 
			fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "CA" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
			logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(fInfo.getFile());
			
		    String data = "";
		    byte[] bytesArray = data.getBytes();
		    int i=1;
		    for(Map<String, Object> mapA : listA) {
		    			//【자료관리번호】
			    data = "A26" + 												//1 + 2 :레코드 구분X(1) + 자료구분9(2)
		                this.csformat(mapA.get("SAFFER"), 3) +				//3 : 세무서 X(3)
		                this.cnformat(i, 6) +								//4 : 일련번호 9(6)
		                this.csformat(param.get("SUBMIT_DATE"), 8) +		//5 : 제출년월일 9(8)
		                //【제출자】
		                this.csformat(mapA.get("COMPANY_NUM"), 10) +		//6 : 사업자등록번호 X(10) 
		                this.csformat(param.get("HOME_TAX_ID"), 20) +		//7 : 홈택스ID X(20)
		                "9000" +											//8 : 세무프로그램코드 X(4)
		                //【귀속연도】
		                this.csformat(param.get("CAL_YEAR"), 4) +			//9 : 귀속연도 X(4)
		                //【원천징수의무자】
		                this.csformat(mapA.get("COMPANY_NUM"), 10) +		//10 : ④사업자등록번호 X(10)
		                this.csformat(mapA.get("DIV_NAME"), 40) +			//11 : ③상호 X(40)
		                //【소득자(연말정산 신청자)】
		                this.csformat(mapA.get("REPRE_NUM"), 13) +			//12 : ②소득자주민등록번호 X(13)
		                this.csformat(mapA.get("IN_FORE"), 1) +				//13 : 내･외국인 코드9(1)
		                this.csformat(mapA.get("NAME"), 30) +				//14 : ①성명 X(30)
		                //【지급처】
		                this.csformat(mapA.get("MED_COMPANY_NUM"), 10) +	//15 : ⑦지급처 사업자등록번호 X(10)
		                this.csformat(mapA.get("MED_COMPANY_NAME"), 40) +	//16 : ⑧지급처 상호 X(40)
		                this.csformat(mapA.get("MED_PROOF_CODE"), 1) +		//17 : ⑨의료증빙코드 X(1)
		                //【지급명세】
		                this.cnformat(mapA.get("SEND_NUM"), 5) +			//18 : ⑩건수 9(5)
		                this.cnformat(mapA.get("SEND_USE_I"), 11) +			//19 : ⑪금액 9(11)
		                this.csformat(mapA.get("SURGERY_CODE"), 1) +		//20 : ⑫난임시술비 해당 여부 X(1)
		                //【의료비 공제 대상자】
		                this.csformat(mapA.get("MED_REPRE_NUM"), 13) +		//21 : ⑤주민등록번호 X(13)
		                this.csformat(mapA.get("IN_FORE_SUPP"), 1) +		//22 : 내･외국인 코드 9(1)
		                this.csformat(mapA.get("MED_CODE"), 1) +			//23 : ⑥본인 등 해당여부 9(1)
		                this.csformat(param.get("SUBMIT_FLAG"), 1) ;		//24 : 제출대상기간코드 9(1)
			    data += "\n";
				bytesArray = data.getBytes();
			    fos.write(bytesArray);

	            logger.debug("A Record : "+String.valueOf(bytesArray.length));
			    i++;
		    }
		    fos.flush();
		    fos.close(); 
		    fInfo.setStream(fos);
		}
		return fInfo;
	}
	
	@ExtDirectMethod( group = "human")			
	public Map<String, Object>  getBillDiv(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("had820ukrServiceImpl.getBillDiv", param);	
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
		String encType = "EUC-KR";	//	MS949
        if (str == null) str = "";
        
        if (!where && str.getBytes(encType).length > size && str.getBytes(encType).length != str.length()) {
        	
        	byte[] bytes = str.getBytes(encType);
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
        	
        } else if (!where && str.getBytes(encType).length == size ) {
        	return str;
        } else if (!where && str.getBytes(encType).length > size  && str.getBytes(encType).length == str.length() ) {
        	return str.substring(0,size);
        }
        
        if (where && str.length() >= size) {
        	return str;
        }
        String res = null;
        StringBuffer sb = new StringBuffer();
        String tmpStr = null;
        int tmpSize = size - str.getBytes(encType).length;

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
}
