package foren.unilite.modules.human.hpb;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "hpb500ukrService" )
public class Hpb500ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "human")
	public FileDownloadInfo doBatchResidentBusiness(Map param) throws Exception {
		
		List<Map<String,Object>> listA = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentBusinessA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentBusinessB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentBusinessC", param);
		
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
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "F" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    // A 레코드	 
	    data = "A24" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(param.get("SUBMIT_DATE"), 8) + 	// A4 : 제출연월일
		        this.cnformat(submitter, 1) + 					// A5 : 제출자 구분
		        this.csformat(sTaxAgentNo, 6) + 				// A6 : 세무대리인 관리번호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A7 : 홈택스 ID
		        "9000" + 										// A8 : 세무프로그램코드
		        this.csformat(mapA.get("COMPANY_NUM"), 10) + 	// A9 : 사업자등록번호
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A10 : 법인명(상호)
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A11 : 담당자 부서
		        this.csformat(mapA.get("REPRE_NAME"), 30) + 	// A12 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 15) + 		// A13 : 담당자 전화번호
		        this.cnformat(mapA.get("CNT"), 5) + 			// A14 : 신고의무자 수
		        this.csformat(mapA.get("A_SPACE"), 25);		// A15 : 공란 
	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
        logger.debug("A Record : "+String.valueOf(bytesArray.length));
        // B 레코드
        int bI = 1;	    
        for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	data = "B24" + 											// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 			// B3 : 세무서코드 X(3)
                    this.cnformat(bI, 6) + 							// B4 : 일련번호 9(6)
                    this.csformat(mapB.get("COMPANY_NUM"), 10) + 	// B5 : ③⑩사업자등록번호 X(10)
                    this.csformat(mapB.get("DIV_NAME"), 30) + 		// B6 : ①⑨법인명(상호) X(60)
                    this.cnformat(mapB.get("PERSON_CNT"), 6) + 		// B7 : 연간소득인원 - 9(6))
                    this.cnformat(mapB.get("SUPP_CNT"), 10) + 		// B8 : 연간총지급건수 - 9(10)
                    this.cnformat(mapB.get("PAY_AMOUNT_I"), 15) + 	// B9 : 연간총지급액계 - 9(15)
                    this.cnformat(mapB.get("IN_TAX_I"), 15) + 		// B10 : 소득세 합계 - 9(15)
                    this.cnformat(mapB.get("LOCAL_TAX_I"), 15) + 	// B11 : 지방소득세 합계 - 9(15)
                    this.cnformat(mapB.get("TOTAL_TAX_I"), 15) + 	// B12 : 원천징수액합계 - 9(15)
                    this.cnformat(0, 10) + 							// B13 : 소액부징수 연간건수 합계 - 9(10)
                    this.cnformat(0, 15) + 							// B14 : 소액부징수 연간지급액 합계 - 9(15)
                    this.cnformat(mapB.get("SUBMIT_CODE"), 1) + 	// B15 : 제출대상기간코드 - 9(1)
                    this.csformat(mapB.get("B_SPACE"), 36);			// B16 : 공란 - X(36)
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
		    	sData.append("C");                                                      //  C1.레코드구분
                sData.append( "24" );                                                   //  C2.자료구분
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );                   //  C3.세무서
                sData.append( this.cnformat(cI, 7) );                                   //  C4.일련번호

                //원천징수의무자
                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 10) );             //  C5.사업자등록번호
                
                //소득자(근로자)
                sData.append( this.csformat(mapC.get("REPRE_NUM"), 13) );               //  C6 : 주민등록번호 - - X(13)
                sData.append( this.csformat(mapC.get("NAME"), 30) );               //  C7 : 소득자 성명- X(30)
                sData.append( this.csformat(mapC.get("COMP_NUM"), 10) );                //  C8 : 사업자등록번호- X(10)
                sData.append( this.csformat(mapC.get("COMP_KOR_NAME"), 30));            //  C9 : 상호- X(30)
                sData.append( this.cnformat(mapC.get("DWELLING_YN"), 1));       // C10 : 거주자구분 - 9(1)
                sData.append( this.cnformat(mapC.get("FOREIGN_YN"), 1));                     // C11 : 내외국인구분 - 9(1)
                sData.append( this.cnformat(mapC.get("DED_CODE"), 6));                    // C12 : 업종구분코드- 9(6)
                
                //소득지급명세
                sData.append( this.csformat(mapC.get("BELONG_YEAR"), 4));                // C13 : 소득귀속연도 - X(4)
                sData.append( this.csformat(mapC.get("SUPP_YEAR"), 4));               // C14 : 소득지급연도- X(4)
                sData.append( this.cnformat(mapC.get("SUPP_CNT"), 8));            // C15 : 지급건수- 9(8)
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_NV"), 1));              // C16 : 음수표시- 9(1)
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_I"), 13));              // C16 : 연간지급총액- 9(13)
                
                sData.append( this.cnformat(mapC.get("PERCENT_I"), 2));                // C17 : 세율- 9(2)
                
                //원천징수액
                sData.append( this.cnformat(mapC.get("IN_TAX_NV"), 1));               // C18 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("IN_TAX_I"), 13));  				// C18 : 소득세- 9(13)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_NV"), 1));               // C19 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_I"), 13));  				// C19 : 지방소득세- 9(13)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_NV"), 1));          // C20 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_I"), 13));  				// C20 :  계- 9(13)
                sData.append( this.csformat(mapC.get("C_SPACE"), 2));                 // C21 : 공란- X(2)

                sData.append( "\n" );
                bytesArray = sData.toString().getBytes();
                fos.write(bytesArray);
                logger.debug("C Record : "+String.valueOf(bytesArray.length));
                cI++;
		    }
        }
	    fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
		
		return fInfo;
	}
	/**
	 *  거주 기타 소득 자료 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public FileDownloadInfo doBatchResidentEtc(Map param) throws Exception {
		
		List<Map<String,Object>> listA = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentEtcA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentEtcB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentEtcC", param);
		
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
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "G" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    // A 레코드	 
	    data = "A23" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(param.get("SUBMIT_DATE"), 8) + 	// A4 : 제출연월일
		        this.cnformat(submitter, 1) + 					// A5 : 제출자 구분
		        this.csformat(sTaxAgentNo, 6) + 				// A6 : 세무대리인 관리번호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A7 : 홈택스 ID
		        "9000" + 										// A8 : 세무프로그램코드
		        this.csformat(mapA.get("COMPANY_NUM"), 10) + 	// A9 : 사업자등록번호
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A10 : 법인명(상호)
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A11 : 담당자 부서
		        this.csformat(mapA.get("REPRE_NAME"), 30) + 	// A12 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 15) + 		// A13 : 담당자 전화번호
		        this.cnformat(mapA.get("CNT"), 5) + 			// A14 : 신고의무자 수
		        this.csformat(mapA.get("A_SPACE"), 135);		// A15 : 공란 
	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
        logger.debug("A Record : "+String.valueOf(bytesArray.length));
        // B 레코드
        int bI = 1;	    
        for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	data = "B23" + 											// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 			// B3 : 세무서코드 X(3)
                    this.cnformat(bI, 6) + 							// B4 : 일련번호 9(6)
                    this.csformat(mapB.get("COMPANY_NUM"), 10) + 	// B5 : ③⑩사업자등록번호 X(10)
                    this.csformat(mapB.get("DIV_NAME"), 30) + 		// B6 : ①⑨법인명(상호) X(60)
                    this.cnformat(mapB.get("PERSON_CNT"), 6) + 		// B7 : 연간소득인원 - 9(6))
                    this.cnformat(mapB.get("SUPP_CNT"), 10) + 		// B8 : 연간총지급건수 - 9(10)
                    this.cnformat(mapB.get("PAY_AMOUNT_I"), 15) + 	// B9 : 연간총지급액계 - 9(15)
                    
                    this.cnformat(mapB.get("TAX_EXEMPTION_I"), 15) +// B10 : 비과세 소득-9(15)
                    this.cnformat(mapB.get("SUPP_TOTAL_I"), 15) + 	// B11 : ⑧연간소득금액합계-9(15)
                    this.cnformat(mapB.get("IN_TAX_I"), 15) + 		// B12 : 소득세 합계-9(15)
                    this.cnformat(mapB.get("LOCAL_TAX_I"), 15) + 	// B13 : ⑪지방소득세 합계-9(15)
                    this.cnformat(mapB.get("TOTAL_TAX_I"), 15) + 	// B14 : ⑬원천징수액합계-9(15)
                    this.cnformat(mapB.get("SUBMIT_CODE"), 1) + 	// B15 : 제출대상기간코드-9(1)
                    this.csformat(mapB.get("B_SPACE"), 141);		// B16 : 공란-X(141)
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
                sData.append("23");                                          	//  C2.자료구분
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );          	//  C3.세무서
                sData.append( this.cnformat(cI, 6) );                          	//  C4.일련번호

                //원천징수의무자
                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 10) );     //  C5.사업자등록번호
                
                //소득자(근로자)
                sData.append( this.csformat(mapC.get("REPRE_NUM"), 13) );       //  C6 : 주민등록번호 - - X(13)
                sData.append( this.csformat(mapC.get("NAME"), 30) );        	//  C7 : 소득자 성명- X(30)
                sData.append( this.cnformat(mapC.get("DWELLING_YN"), 1) );      //  C8 : 거주구분-9(1)
                sData.append( this.cnformat(mapC.get("FOREIGN_YN"), 1));     	//  C9 : 내․외국인구분-9(1)
                sData.append( this.cnformat(mapC.get("DED_CODE"), 2));			// C10 : 소득구분코드-9(2)

                //소득지급명세
                sData.append( this.csformat(mapC.get("BELONG_YEAR"), 4));       // C11 : 소득귀속연도 -X(4)
                sData.append( this.csformat(mapC.get("SUPP_YEAR"), 4));         // C12 : 지급연도-X(4)
                sData.append( this.cnformat(mapC.get("SUPP_CNT"), 4));          // C13 : 지급건수-9(4)
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_NV"), 1));     // C14 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_I"), 13));     // C14 : 연간지급총액-9(13)
                sData.append( this.cnformat(mapC.get("TAX_EXEMPTION_NV"), 1));	// C15 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("TAX_EXEMPTION_I"), 13));  // C15 :비과세소득-9(13)
                sData.append( this.cnformat(mapC.get("EXPS_AMOUNT_NV"), 1));    // C16 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("EXPS_AMOUNT_I"), 13));  	// C16 : 필요경비-9(13)
                sData.append( this.cnformat(mapC.get("SUPP_TOTAL_NV"), 1));     // C17 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("SUPP_TOTAL_I"), 13));     // C17 : 소득금액-9(13)
                sData.append( this.cnformat(mapC.get("PERCENT_I"), 2));         //C18 : 세율-9(2)
                
                //원천징수액
                sData.append( this.cnformat(mapC.get("IN_TAX_NV"), 1));        	// C19 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("IN_TAX_I"), 13));  		// C19 : 소득세- 9(13)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_NV"), 1));      // C20 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_I"), 13));  	// C20 : 지방소득세- 9(13)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_NV"), 1));   	// C21 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_I"), 13));  	// C21 :  계- 9(13)
                sData.append( this.csformat(mapC.get("C_SPACE"), 119));         // C22 : 공란- X(119)
                sData.append( "\n" );
                bytesArray = sData.toString().getBytes();
                logger.debug("C Record : "+String.valueOf(bytesArray.length));
                fos.write(bytesArray);
                cI++;
		    }
        }
	    fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
		
		return fInfo;
	}

	/**
	 *  비거주  사업기타 소득 자료 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public FileDownloadInfo doBatchNonResidentBusinesEtc(Map param) throws Exception {
		
		List<Map<String,Object>> listA = super.commonDao.list("hpb500ukrServiceImpl.getSelectNonResidentBusinessEtcA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpb500ukrServiceImpl.getSelectNonResidentBusinessEtcB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpb500ukrServiceImpl.getSelectNonResidentBusinessEtcC", param);
		
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
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "BI" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    // A 레코드	 
	    data = "A50" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(param.get("SUBMIT_DATE"), 8) + 	// A4 : 제출연월일
		        this.cnformat(submitter, 1) + 					// A5 : 제출자 구분
		        this.csformat(sTaxAgentNo, 6) + 				// A6 : 세무대리인 관리번호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A7 : 홈택스 ID
		        "9000" + 										// A8 : 세무프로그램코드
		        this.csformat(mapA.get("COMPANY_NUM"), 10) + 	// A9 : 사업자등록번호
		        this.csformat(mapA.get("DIV_NAME"), 40) + 		// A10 : 법인명(상호)
		        this.csformat(mapA.get("DIV_NAME"), 30) + 		// A11 : 담당자 부서  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  확인필요
		        this.csformat(mapA.get("REPRE_NAME"), 30) + 	// A12 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 15) + 		// A13 : 담당자 전화번호
		        this.cnformat(mapA.get("CNT"), 5) + 			// A14 : 신고의무자 수
		        this.csformat(mapA.get("A_SPACE"), 185);		// A15 : 공란 
	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
        logger.debug("A Record : "+String.valueOf(bytesArray.length));
        // B 레코드
        int bI = 1;	    
        for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	data = "B50" + 											// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 			// B3 : 세무서코드 X(3)
                    this.cnformat(bI, 6) + 							// B4 : 일련번호 9(6)
                    this.csformat(mapB.get("COMPANY_NUM"), 10) + 	// B5 : ③⑩사업자등록번호 X(10)
                    this.csformat(mapB.get("COMP_ENG_NAME"), 50) + 		// B6 : ①⑨법인명(상호) X(60)
                    
                    this.csformat(mapB.get("ENG_ADDR"), 140) +		// B7 : 소재지(주소)-X(140)
                    this.cnformat(mapB.get("PERSON_CNT"), 6) + 		// B8 : 연간소득인원-9(6)
                    this.cnformat(mapB.get("SUPP_CNT"), 6) + 		// B9 : 연간총지급건수-9(6)
                    this.cnformat(mapB.get("PAY_AMOUNT_I"), 15) + 	// B10 : 연간총지급액계-9(15)
                    
                    this.cnformat(mapB.get("SUPP_TOTAL_I"), 15) + 	// B11 : 연간소득금액합계-9(15)
                    this.cnformat(mapB.get("IN_TAX_I"), 15) + 		// B12 : 소득세 합계-9(15)
                    this.cnformat(mapB.get("CP_TAX_I"), 15) + 		// B13 : 법인세 합계-9(15)
                    this.cnformat(mapB.get("LOCAL_TAX_I"), 15) + 	// B14 : 지방소득세 합계-9(15)
                    this.cnformat(mapB.get("SP_TAX_I"), 15) + 		//B15 : 농특세 합계-9(15)
                    this.cnformat(mapB.get("TOTAL_TAX_I"), 15) + 	// B16 : 원천징수액 합계-9(15)
                    this.cnformat(mapB.get("SUBMIT_CODE"), 1) + 	// B17 : 제출대상기간코드-9(1)
                    this.csformat(mapB.get("B_SPACE"), 30);			// B18 : 공란-X(30)
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
                sData.append("50");                                          	//  C2.자료구분
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );          	//  C3.세무서
                sData.append( this.cnformat(cI, 6) );                          	//  C4.일련번호

                //원천징수의무자
                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 10) );     //  C5.사업자등록번호
                
                //소득자
                sData.append( this.csformat(mapC.get("RECOGN_NUM"), 20) );      //  C6 : 주민(사업자)등록번호 - - X(20)
                sData.append( this.csformat(mapC.get("ENG_NAME"), 30) );        //  C7 : 소득자성명(상호)- X(30)
                
                sData.append( this.csformat(mapC.get("ENG_ADDR"), 140) );      	//  C8 : 소득자주소-X(140)
                sData.append( this.csformat(mapC.get("NATION_CODE"), 2) );      // C9 : 거주지국코드-X(2)
                sData.append( this.cnformat(mapC.get("FOREIGN_YN"), 1));     	// C10 : 내외국인구분-9(1)
                sData.append( this.cnformat(mapC.get("DED_CODE"), 2));			// C11 : 소득구분코드-9(2)
                sData.append( this.cnformat(mapC.get("BELONG_YEAR"), 4));       // C12 : 소득귀속연도-9(4)
                sData.append( this.cnformat(mapC.get("SUPP_YEAR"), 4));         // C13 : 지급연도-9(4)
                sData.append( this.cnformat(mapC.get("SUPP_DATE"), 8));          // C14 : 지급일자-9(8)
                
                //소득지급명세
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_NV"), 1));		// C15 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("PAY_AMOUNT_I"), 13));  	// C15 : 지급총액-9(13)
                sData.append( this.cnformat(mapC.get("EXPS_AMOUNT_NV"), 1));    // C16 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("EXPS_AMOUNT_I"), 13));  	// C16 :필요경비-9(13)
                sData.append( this.cnformat(mapC.get("SUPP_TOTAL_NV"), 1));     // C17 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("SUPP_TOTAL_I"), 13));     // C17 : 소득금액-9(13)
                sData.append( this.cnformat(mapC.get("PERCENT_I"), 2));         // C18 : 세율-9(2)
                
                //원천징수액
                sData.append( this.cnformat(mapC.get("IN_TAX_NV"), 1));        	// C19 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("IN_TAX_I"), 13));  		// C19 : 소득세- 9(13)
                sData.append( this.cnformat(mapC.get("CP_TAX_NV"), 1));        	// C20 : 양수표시-9(1)
                sData.append( this.cnformat(mapC.get("CP_TAX_I"), 13));  		// C20 : 법인세-9(13)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_NV"), 1));      // C21 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_I"), 13));  	// C21 : 지방소득세- 9(13)
                sData.append( this.cnformat(mapC.get("SP_TAX_NV"), 1));      	// C22 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("SP_TAX_I"), 13));  		// C22 : 농특세-9(13)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_NV"), 1));   	// C23 : 양수표시- 9(1)
                sData.append( this.cnformat(mapC.get("TOTAL_TAX_I"), 13));  	// C23 :  계- 9(13)
                sData.append( this.csformat(mapC.get("C_SPACE"), 13));         	// C24 : 공란-X(13)        
                sData.append( "\n" );
                bytesArray = sData.toString().getBytes();
                logger.debug("C Record : "+String.valueOf(bytesArray.length));
                fos.write(bytesArray);
                cI++;
		    }
        }
	    fos.flush();
	    fos.close(); 
	    fInfo.setStream(fos);
		
		return fInfo;
	}
	/**
	 *  이자배당 소득 자료 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public FileDownloadInfo doBatchInterest(Map param) throws Exception {
		
		List<Map<String,Object>> listA = super.commonDao.list("hpb500ukrServiceImpl.getSelectInterestA", param);
		List<Map<String,Object>> listB = super.commonDao.list("hpb500ukrServiceImpl.getSelectInterestB", param);
		List<Map<String,Object>> listC = super.commonDao.list("hpb500ukrServiceImpl.getSelectInterestC", param);
		
		
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
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("hometaxAuto"),  "B" + GStringUtils.left(companyNum, 7) + "." + GStringUtils.right(companyNum, 3));
		logger.debug(">>>>>>>>>>>>>>>   dir : "+ dir.getAbsolutePath());
		FileOutputStream fos = new FileOutputStream(fInfo.getFile());
		
	    String data = "";
	    byte[] bytesArray = data.getBytes();
	    // A 레코드	 
	    data = "A40" + 											// A1 + A2  :	자료구분 + 레코드 구분
		        this.csformat(mapA.get("SAFFER"), 3) + 			// A3 : 세무서코드
		        this.cnformat(ObjUtils.getSafeString(param.get("SUBMIT_DATE")).substring(0,6), 6) + 	// A4 : 제출연월
		        this.csformat(mapA.get("COMPANY_NUM"), 13) + 	// A5 : 사업자등록번호
		        this.csformat(param.get("A_SPACE1"), 22) + 		// A6 : 공란
		        this.csformat(mapA.get("COMP_NAME"), 40) + 		// A7 : 법인명(상호
		        this.csformat(param.get("HOME_TAX_ID"), 20) + 	// A8 : 홈택스 ID
		        "9000" + 										// A9 : 세무프로그램코드
		        this.csformat(mapA.get("DIV_NAME"), 20) + 		// A10 : 담당자 부서  
		        this.csformat(mapA.get("REPRE_NAME"), 20) + 	// A11 : 담당자 성명
		        this.csformat(mapA.get("TELEPHON"), 20) + 		// A12 : 담당자 전화번호
		        
		        //제출기관 통보내역
		        this.cnformat(mapA.get("CNT"), 5) + 			// A13 : 원천징수의무자수
		        this.cnformat(mapA.get("SUPP_CNT"), 10) + 		// A14 : 총제출건수
		        this.cnformat(mapA.get("SUPP_TOTAL_I"), 16) + 	// A15 : 소득금액합계
		        this.cnformat(mapA.get("IN_TAX_I"), 15) + 		// A16 : 소득세액합계 수
		        this.cnformat(mapA.get("CP_TAX_I"), 15) + 		// A17 : 법인세액합계
		        
		        this.cnformat(mapA.get("NEW_SUPP_CNT"), 10) + 	// A18 : 2018귀속 당초 제출건수-9(10)
		        this.cnformat(mapA.get("NEW_SUPP_TOTAL_I"), 16)+// A19 : 2018귀속 당초 소득금액 합계-9(16)
		        this.cnformat(mapA.get("DEL_SUPP_CNT"), 10) + 	// A20 : 2018귀속 삭제 제출건수-9(10)
		        this.cnformat(mapA.get("DEL_SUPP_TOTAL_I"), 16)+// A21 : 2018귀속 삭제 소득금액 합계-9(16)
		        this.cnformat(mapA.get("UPD_SUPP_CNT"), 10) + 	// A22 : 2018귀속 수정 제출건수-9(10)
		        this.cnformat(mapA.get("UPD_SUPP_TOTAL_I"), 16)+// A23 : 2018귀속 수정 소득금액 합계-9(16)
		        this.csformat(mapA.get("A_SPACE2"), 170);		// A24 : 공란-X(170)

	    data += "\n";
		bytesArray = data.getBytes();
	    fos.write(bytesArray);
	   
        logger.debug("A Record : "+String.valueOf(bytesArray.length));
        // B 레코드
        int bI = 1;	    
        for(Map<String,Object> mapB : listB)	{
	    	String sectCode = ObjUtils.getSafeString(mapB.get("SECT_CODE"));
	    	data = "B40" + 												// B1 + B2 : 레코드 구분 X(1) + 자료구분 9(2)
                    this.csformat(mapB.get("SAFFER"), 3) + 				// B3 : 세무서코드 X(3)
                    this.cnformat(ObjUtils.getSafeString(param.get("SUBMIT_DATE")).substring(0,6), 6) + 		// B4 : 제출연월-9(06)
                    this.csformat(mapB.get("COMPANY_NUM"), 13) + 		// B5 : 본점(제출자) 사업자등록번호-X(13)
                    this.csformat(mapB.get("COMPANY_NUM2"), 13) + 		// B6 : 지점(원천징수의무자) 사업자등록번호-X(13)
                    
                    this.csformat(mapB.get("B_SPACE1"), 12) +			// B7 : 공란-X(12)
                    this.csformat(mapB.get("DIV_NAME"), 40) + 			// B8 : 지점명칭-한글명-X(40)
                    this.csformat(mapB.get("COMP_ENG_NAME"), 70) + 		// B9 : 지점명칭-영문명-X(70)
                    this.csformat(mapB.get("ADDR"), 140) + 				// B10 : 지점 소재지-X(140)
                    
                    this.cnformat(mapB.get("SUPP_CNT"), 10) + 			// B11 : 지점의 제출건수-9(10)
                    this.cnformat(mapB.get("SUPP_TOTAL_I"), 16) + 		// B12 : 지점의 소득금액합계-9(16)
                    this.cnformat(mapB.get("IN_TAX_I"), 15) + 			// B13 : 지점의 소득세액합계-9(15)
                    this.cnformat(mapB.get("CP_TAX_I"), 15) + 			// B14 : 지점의 법인세액합계-9(15)
                    this.cnformat(mapB.get("NEW_SUPP_CNT"), 10) + 		// B15 : 지점의 2018귀속 당초  제출건수-9(10)
                    this.cnformat(mapB.get("NEW_SUPP_TOTAL_I"), 16) + 	// B16 : 지점의 2018귀속 당초 소득금액 합계-9(16)
                    this.cnformat(mapB.get("DEL_SUPP_CNT"), 10) + 		// B17 : 지점의 2018귀속 삭제 제출건수-9(10)
                    this.cnformat(mapB.get("DEL_SUPP_TOTAL_I"), 16) + 	// B18 : 지점의 2018귀속 삭제 소득금액 합계-9(16)
                    this.cnformat(mapB.get("UPD_SUPP_CNT"), 10) + 		// B19 : 지점의 2018귀속 수정 제출건수-9(10)
                    this.cnformat(mapB.get("UPD_SUPP_TOTAL_I"), 16) + 	// B20 : 지점의 2018귀속 수정 소득금액 합계-9(16)
                    this.csformat(mapB.get("B_SPACE2"), 45) + 			// B21 : 공란-X(45)
                    this.cnformat(mapB.get("SUBMIT_CODE"), 1) ; 		// B22 : 제출대상기간코드-9(01)
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
		    	sData.append("C");                                          	//  C1 : 레코드 구분코드-X(01)
                sData.append("40");                                          	//  C2 : 자료구분-9(02)
                sData.append( this.csformat(mapC.get("SAFFER"), 3) );          	//  C3 : 세무서-X(03)
                sData.append( this.csformat(ObjUtils.getSafeString(param.get("SUBMIT_DATE")).substring(0,6), 6) );     //  C4 : 제출연월-X(06)

                sData.append( this.csformat(mapC.get("COMPANY_NUM"), 13) );     //  C5 : 본점(제출자) 사업자등록번호-X(13)         
                sData.append( this.csformat(mapC.get("COMPANY_NUM2"), 13) );      //  C6 : 징수의무자  사업자등록번호-X(13)
                
                //소득자 기본사항
                sData.append( this.cnformat(cI, 8) );        // C7 : 자료일련번호-9(08)
                sData.append( this.csformat(mapC.get("NAME"), 70) );      	// C8 : 성명(상호)-X(70)
                sData.append( this.csformat(mapC.get("REPRE_NUM"), 20) );      // C9 : 주민(사업자)  등록번호 -X(20)
                sData.append( this.csformat(mapC.get("BIRTH"), 8));     	// C10 : 비거주자 생년월일-X(08)
                sData.append( this.cnformat(mapC.get("DED_CODE"), 3));			// C11 : 소득자 구분코드-9(03)
                sData.append( this.csformat(mapC.get("ADDR"), 140));       // C12 : 주소-X(140)
                sData.append( this.cnformat(mapC.get("DWELLING_YN"), 1));         // C13 : 거주구분-9(01)
                sData.append( this.csformat(mapC.get("NATION_CODE"), 2));          // C14 : 거주지국코드-X(02)
                
                
                //기타관리항목
                sData.append( this.csformat(mapC.get("BANK_ACCOUNT"), 20));		// C15 : 계좌번호  (발행번호)-X(20)
                sData.append( this.csformat(mapC.get("TRUST_PROFIT_YN"), 1));  	// C16 : 신탁이익여부-X(1)
                
                //소득지급내역
                sData.append( this.csformat(mapC.get("SUPP_DATE"), 8));    // C17 : 지급일-X(08)
                sData.append( this.csformat(mapC.get("PAY_YYYYMM"), 6));  	// C18 : 귀속연월-X(06)
                
                
                sData.append( this.csformat(mapC.get("TAX_GUBN"), 3));     // C19 : 과세구분-X(03)
                sData.append( this.csformat(mapC.get("INCOME_KIND"), 2));     // C20 : 소득의 종류-X(2)
                sData.append( this.csformat(mapC.get("TAX_EXCEPTION"), 2));         // C21 : 조세특례등-X(2)
                
                //원천징수액
                sData.append( this.csformat(mapC.get("PRIZE_CODE"), 3));        	// C22 : 금융상품코드-X(03)
                sData.append( this.csformat(mapC.get("WERT_PAPER_CODE"), 12));  		// C23 : 유가증권 표준코드  (유가증권발행사업자등록번호)-X(12)
                sData.append( this.csformat(mapC.get("CLAIM_INTER_GUBN"), 2));        	// C24 : 채권이자구분-X(02)
                sData.append( this.csformat(mapC.get("SUPP_PERIOD"), 16));  		// C25 : 지급대상 기간-X(16)
                sData.append( this.cnformat(mapC.get("INTER_RATE"), 10));      // C26 : 이자율 등-9(10)
                sData.append( this.cnformat(mapC.get("SUPP_TOTAL_I"), 13));  	// C27 : 지급액(소득금액)-9(13)
                sData.append( this.cnformat(mapC.get("PERCENT_I"), 6));      	// C28 : 세율(%)-9(06)
                
                //원천징수내역
                sData.append( this.cnformat(mapC.get("IN_TAX_I"), 13));  		// C29 : 소득세-9(13)
                sData.append( this.cnformat(mapC.get("CP_TAX_I"), 13));   	// C30 : 법인세-9(13)
                sData.append( this.cnformat(mapC.get("LOCAL_TAX_I"), 13));  	// C31 : 지방소득세-9(13)
                sData.append( this.cnformat(mapC.get("SP_TAX_I"), 13));  	// C32 : 농어촌특별세-9(13)
                sData.append( this.csformat(mapC.get("C_SPACE"), 33));      	// C33 : 공란-X(33)
                sData.append( this.cnformat(mapC.get("CHANGE_GUBN"), 1));  		// C34 : 변동자료구분 코드-9(01)   
                sData.append( "\n" );
                
                bytesArray = sData.toString().getBytes();
                logger.debug("C Record : "+String.valueOf(bytesArray.length));
                fos.write(bytesArray);
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
    
    /**
     * 접속한 user 사업장의 홈택스 id 가져오기
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public Map<String, Object> getHometaxId( Map param ) throws Exception {
        return (Map<String, Object>)super.commonDao.select("hpb500ukrServiceImpl.getHometaxId", param);
    }
    
    /**
     * 거주 사업 데이터 유무 확인
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> checkResidentBusiness( Map param ) throws Exception {
        return super.commonDao.list("hpb500ukrServiceImpl.getHometaxId", param);
    }
    
    /**
     * 거주 사업장 기타 데이터 유무 확인
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> checkResidentEtc( Map param ) throws Exception {
        return super.commonDao.list("hpb500ukrServiceImpl.getSelectResidentEtcA", param);
    }
    /**
     * 비거주 사업, 기타 데이터 유무 확인
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> checkNonResidentBusinessEtc( Map param ) throws Exception {
        return super.commonDao.list("hpb500ukrServiceImpl.getSelectNonResidentBusinessEtcA", param);
    }
    /**
     *  이자.배당 데이터 유무 확인
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> checkInterest( Map param ) throws Exception {
        return super.commonDao.list("hpb500ukrServiceImpl.getSelectInterestA", param);
    }
}
