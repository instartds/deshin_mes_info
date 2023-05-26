package foren.unilite.modules.human.hrt;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.DevFreeUtils;
import net.sf.json.JSONArray;

import org.apache.poi.hssf.util.HSSFColor;

@Service( "hrtExcelService" )
public class HrtExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "hrt716rkrService" )
    private Hrt716rkrServiceImpl hrt716rkrService;
    
    public Workbook makeExcel( Map param ) throws Exception {
        /*FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "gba210skrv-201711.xlsx"));*/
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "hrt716rkr.xlsx"));
        
        //Get the workbook instance for XLS file 
        Workbook workbook = new XSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
           
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        
/*        Row headerRow = null;
        DataFormat format = workbook.createDataFormat();*/
        
        int A = 0;
        int B = 1;
        int C = 2;
        int D = 3;
        int E = 4;
        int F = 5;
        int G = 6;
        int H = 7;
        int I = 8;
        int J = 9;
        int K = 10;
        int L = 11;
        int M = 12;
        int N = 13;
        int O = 14;
        int P = 15;
        int Q = 16;
        int R = 17;
        int S = 18;
        int T = 19;
        int U = 20;
        int V = 21;
        int W = 22;
        int X = 23;
        int Y = 24;
        int Z = 25;
        int AA = 26;
        
        int row1 = 0;
        int row2 = 0;
        int row3 = 0;
        int row4 = 0;
        int row5 = 0;
        int row6 = 0;
        int row7 = 0;      

        List<Map> list1 = super.commonDao.list("hrt716rkrServiceImpl.selectList", param);
        for(int i = 0; i < list1.size(); i++) {
        	
       
        	String docKind = param.get("DOC_KIND").toString();
        	String liveGubun = list1.get(i).get("LIVE_GUBUN").toString();
        	String nationCode = list1.get(i).get("NATION_CODE").toString();
        	String retrKind = list1.get(i).get("RETR_OT_KIND").toString();
        	String retrResn = list1.get(i).get("RETR_RESN").toString();
        	String bankAccount = list1.get(i).get("BANK_ACCOUNT").toString();
        	      	
                	
        	
        	if (liveGubun.equals("1")) {
        		sheet1.getRow(2).getCell(W).setCellValue("거주자 ① / 비거주자 2");
        	} else {
        		sheet1.getRow(2).getCell(W).setCellValue("거주자 1 / 비거주자 ②");
        	}
        	
        	if (nationCode.equals("KR")) {
        		sheet1.getRow(3).getCell(W).setCellValue("내국인 ① / 외국인 9");
        	} else {
        		sheet1.getRow(3).getCell(W).setCellValue("내국인 1 / 외국인 ⑨");
        	}
        	
        	if(docKind.equals("1")) {
        		sheet1.getRow(4).getCell(H).setCellValue("([■]소득자보관용 [ ]발행자보관용 [ ]발행자보고용)");
        		sheet1.getRow(7).getCell(H).setCellValue("");				//(4)주민(법인)등록번호
        	} if(docKind.equals("2")) {
        		sheet1.getRow(4).getCell(H).setCellValue("([ ]소득자보관용 [■]발행자보관용 [ ]발행자보고용)");
        		sheet1.getRow(7).getCell(H).setCellValue(list1.get(i).get("REPRE_NO").toString());						//(4)주민(법인)등록번호
        	} if(docKind.equals("3")) {
        		sheet1.getRow(4).getCell(H).setCellValue("([ ]소득자보관용 [ ]발행자보관용 [■]발행자보고용)");
        		sheet1.getRow(7).getCell(H).setCellValue(list1.get(i).get("REPRE_NO").toString());						//(4)주민(법인)등록번호
        	}
        	
        	//sheet1.getRow(2).getCell(W).setCellValue("거주자 ① / 비거주자 2");
        	//sheet1.getRow(3).getCell(W).setCellValue("내국인 ① / 외국인 9");
        	//sheet1.getRow(4).getCell(H).setCellValue("([■]소득자보관용 [ ]발행자보관용 [ ]발행자보고용)");
        	
        	
        	sheet1.getRow(6).getCell(H).setCellValue(list1.get(i).get("COMPANY_NUM").toString());						//(1)사업자등록번호
        	sheet1.getRow(6).getCell(P).setCellValue(list1.get(i).get("DIV_FULL_NAME").toString());						//(2)법인명(상호)
        	sheet1.getRow(6).getCell(X).setCellValue(list1.get(i).get("REPRE_NAME").toString());						//(3)대표자(성명)
        	
        	//sheet1.getRow(7).getCell(H).setCellValue(list1.get(i).get("REPRE_NO").toString());						//(4)주민(법인)등록번호
        	sheet1.getRow(7).getCell(P).setCellValue(list1.get(i).get("KOR_ADDR").toString());							//(5)소재지(주소)
        	
        	sheet1.getRow(8).getCell(H).setCellValue(list1.get(i).get("NAME").toString());								//(6)성명
        	sheet1.getRow(8).getCell(P).setCellValue(list1.get(i).get("REPRE_NUM").toString());							//(7)주민등록번호
        	//sheet1.getRow(8).getCell(P).setCellValue(decrypto.getDecryptWithType(list1.get(i).get("REPRE_NUM").toString(),param.get("S_COMP_CODE") , "hrt716rkr", ""));							//(7)주민등록번호
        	sheet1.getRow(9).getCell(H).setCellValue(list1.get(i).get("ADDR_NAME").toString());							//(8)주소
        	
        	
        	if (retrKind.equals("OF")) {
        		sheet1.getRow(9).getCell(W).setCellValue("여");															//(9)임원여부
        	} else {
        		sheet1.getRow(9).getCell(W).setCellValue("부");															//(9)임원여부
        	}
        	
        	//sheet1.getRow(9).getCell(W).setCellValue(list1.get(i).get("RETR_OT_KIND").toString());					//(9)임원여부
        	
        	sheet1.getRow(10).getCell(T).setCellValue(list1.get(i).get("RETR_ANN_JOIN_DATE").toString());				//(10) 확정급여형 퇴직연금제도가입일
        	sheet1.getRow(10).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("RETR_ANNU_I_20111231")));		//(11) 2011.12.31퇴직금
        	sheet1.getRow(12).getCell(F).setCellValue(list1.get(i).get("RETR_DATE_FR").toString());						//귀속년도(부터)
        	sheet1.getRow(13).getCell(F).setCellValue(list1.get(i).get("RETR_DATE_TO").toString());						//귀속년도(까지)
        	
        	
        	if(retrResn.equals("1")) {
        		sheet1.getRow(12).getCell(P).setCellValue(" [■]정년퇴직 [ ]정리해고  [ ]자발적 퇴직 ");
        	} if(retrResn.equals("2")) {
        		sheet1.getRow(12).getCell(P).setCellValue(" [ ]정년퇴직  [■]정리해고 [ ]자발적 퇴직 ");
        	} if(retrResn.equals("3")) {
        		sheet1.getRow(12).getCell(P).setCellValue(" [ ]정년퇴직  [ ]정리해고  [■]자발적 퇴직 ");
        	} if(retrResn.equals("4")) {
        		sheet1.getRow(13).getCell(P).setCellValue(" [■]임원퇴직 [ ]중간정산  [ ]기 타 ");
        	} if(retrResn.equals("5")) {
        		sheet1.getRow(13).getCell(P).setCellValue(" [ ]임원퇴직  [■]중간정산 [ ]기 타");
        	} if(retrResn.equals("6")) {
        		sheet1.getRow(13).getCell(P).setCellValue(" [ ]임원퇴직  [ ]중간정산  [■]기 타 ");
        	}
        	
        	//sheet1.getRow(12).getCell(P).setCellValue(list1.get(i).get("RETR_RESN").toString());						//(12)퇴직사유
        	
        	
        	//'퇴직급여현황
        	sheet1.getRow(15).getCell(J).setCellValue(list1.get(i).get("M_DIV_NAME").toString());						//(13) 근무처명_중간지급	
        	sheet1.getRow(16).getCell(J).setCellValue(list1.get(i).get("M_COMPANY_NUM").toString());					//(14) 사업자등록번호_중간지급
        	sheet1.getRow(17).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_ANNU_TOTAL_I")));			//(15) 퇴직급여_중간지급
        	sheet1.getRow(18).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_OUT_INCOME_I")));			//(16) 비과세 퇴직급여_중간지급
        	sheet1.getRow(19).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_TAX_TOTAL_I")));			//(17) 과세대상 퇴직급여(15-16)_중간지급
        	
        	sheet1.getRow(15).getCell(P).setCellValue(list1.get(i).get("R_DIV_NAME").toString());						//(13) 근무처명_최종분	
        	sheet1.getRow(16).getCell(P).setCellValue(list1.get(i).get("R_COMPANY_NUM").toString());					//(14) 사업자등록번호_최종분	
        	sheet1.getRow(17).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_ANNU_TOTAL_I")));			//(15) 퇴직급여_최종분
        	sheet1.getRow(18).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_OUT_INCOME_I")));			//(16) 비과세 퇴직급여_최종분
        	sheet1.getRow(19).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_TAX_TOTAL_I")));			//(17) 과세대상 퇴직급여(15-16)_최종분
        	
        	sheet1.getRow(17).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_ANNU_TOTAL_I")));			//(15) 퇴직급여_정산
        	sheet1.getRow(18).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_OUT_INCOME_I")));			//(16) 비과세 퇴직급여_정산
        	sheet1.getRow(19).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_TAX_TOTAL_I")));			//(17) 과세대상 퇴직급여(15-16)_정산
	        
        	//'근속연수
        	sheet1.getRow(21).getCell(G).setCellValue(list1.get(i).get("M_JOIN_DATE").toString());						//(18)입사일_중간지급
        	sheet1.getRow(21).getCell(J).setCellValue(list1.get(i).get("M_CALCU_END_DATE").toString());					//(19)기산일_중간지급
        	sheet1.getRow(21).getCell(M).setCellValue(list1.get(i).get("M_RETR_DATE").toString());						//(20)퇴사일_중간지급
        	sheet1.getRow(21).getCell(P).setCellValue(list1.get(i).get("M_SUPP_DATE").toString());						//(21)지급일_중간지급
        	sheet1.getRow(21).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_LONG_MONTHS")));			//(22)근속월수_중간지급	
        	sheet1.getRow(21).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_EXEP_MONTHS")));			//(23)제외월수_중간지급	
        	sheet1.getRow(21).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_ADD_MONTHS")));				//(24)가산월수_중간지급	
        	sheet1.getRow(21).getCell(Z).setCellValue(ObjUtils.parseInt(list1.get(i).get("M_LONG_YEARS")));				//(26)근속연수_중간지급	
        	
        	sheet1.getRow(22).getCell(G).setCellValue(list1.get(i).get("R_JOIN_DATE").toString());						//(18)입사일_최종분
        	sheet1.getRow(22).getCell(J).setCellValue(list1.get(i).get("R_CALCU_END_DATE").toString());					//(19)기산일_최종분
        	sheet1.getRow(22).getCell(M).setCellValue(list1.get(i).get("R_RETR_DATE").toString());						//(20)퇴사일_최종분
        	sheet1.getRow(22).getCell(P).setCellValue(list1.get(i).get("R_SUPP_DATE").toString());						//(21)지급일_최종분
        	sheet1.getRow(22).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_LONG_MONTHS")));			//(22)근속월수_최종분	
        	sheet1.getRow(22).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_EXEP_MONTHS")));			//(23)제외월수_최종분	
        	sheet1.getRow(22).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_ADD_MONTHS")));				//(24)가산월수_최종분	
        	sheet1.getRow(22).getCell(Z).setCellValue(ObjUtils.parseInt(list1.get(i).get("R_LONG_YEARS")));				//(26)근속연수_최종분
        	
        	sheet1.getRow(23).getCell(G).setCellValue(list1.get(i).get("S_JOIN_DATE").toString());						//(18)입사일_정산(합산)
        	sheet1.getRow(23).getCell(J).setCellValue(list1.get(i).get("S_CALCU_END_DATE").toString());					//(19)기산일_정산(합산)
        	sheet1.getRow(23).getCell(M).setCellValue(list1.get(i).get("S_RETR_DATE").toString());						//(20)퇴사일_정산(합산)
        	//sheet1.getRow(23).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_SUPP_DATE")));    			//(21)지급일_정산(합산)
        	sheet1.getRow(23).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_LONG_MONTHS")));			//(22)근속월수_정산(합산)	
        	sheet1.getRow(23).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_ADD_MONTHS")));				//(23)제외월수_정산(합산)	
        	sheet1.getRow(23).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_DUPLI_MONTHS")));			//(24)가산월수_정산(합산)	
        	sheet1.getRow(23).getCell(Z).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_LONG_YEARS")));				//(26)근속연수_정산(합산)	
        	
        	sheet1.getRow(24).getCell(J).setCellValue(list1.get(i).get("CALCU_END_DATE_BE13").toString());				//(19)기산일_안분(2012.12.31이전)
        	sheet1.getRow(24).getCell(M).setCellValue(list1.get(i).get("RETR_DATE_BE13").toString());					//(20)퇴사일_안분(2012.12.31이전)
        	sheet1.getRow(24).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("LONG_MONTHS_BE13")));			//(22)근속월수_안분(2012.12.31이전)	
        	sheet1.getRow(24).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("EXEP_MONTHS_BE13")));			//(23)제외월수_안분(2012.12.31이전)	
        	sheet1.getRow(24).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("ADD_MONTHS_BE13")));			//(24)가산월수_안분(2012.12.31이전)
        	sheet1.getRow(24).getCell(Z).setCellValue(ObjUtils.parseInt(list1.get(i).get("LONG_YEARS_BE13")));			//(26)근속연수_안분(2012.12.31이전)
        	
        	sheet1.getRow(25).getCell(J).setCellValue(list1.get(i).get("CALCU_END_DATE_AF13").toString());		        //(19)기산일_안분(2013.01.01이후)
        	sheet1.getRow(25).getCell(M).setCellValue(list1.get(i).get("RETR_DATE_AF13").toString());			        //(20)퇴사일_안분(2013.01.01이후)
        	sheet1.getRow(25).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("LONG_MONTHS_AF13")));			//(22)근속월수_안분(2013.01.01이후)
        	sheet1.getRow(25).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("EXEP_MONTHS_AF13")));			//(23)제외월수_안분(2013.01.01이후)
        	sheet1.getRow(25).getCell(V).setCellValue(ObjUtils.parseInt(list1.get(i).get("ADD_MONTHS_AF13")));			//(24)가산월수_안분(2013.01.01이후)
        	sheet1.getRow(25).getCell(Z).setCellValue(ObjUtils.parseInt(list1.get(i).get("LONG_YEARS_AF13")));			//(26)근속연수_안분(2013.01.01이후)
        	
        	//개정규정에 따른 계산방법
        	sheet1.getRow(29).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_TAX_TOTAL_I2")));		    //퇴직소득(정산)
        	sheet1.getRow(30).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("INCOME_DED_I")));				//근속연수공제_정산(합산)
        	sheet1.getRow(31).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("PAY_TOTAL_I_16")));			//환산급여
        	sheet1.getRow(32).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("PAY_TOTAL_DED_I_16")));		//환산급여별공제
        	sheet1.getRow(33).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("TAX_STD_I_16")));				//(31)퇴직소득과세표준
        	sheet1.getRow(35).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("CHANGE_COMP_TAX_I_16")));		//(32)환산산출세액((31)X세율)
        	sheet1.getRow(36).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("COMP_TAX_I_16")));			//(33)산출세액((32)X정산근속연수/12배)
        	
        	//종전규정에 따른 계산방법
        	sheet1.getRow(38).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("S_TAX_TOTAL_I3")));		    //(35)퇴직소득(정산)
        	sheet1.getRow(39).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("SPEC_DED_I")));				//(35)퇴직소득정률공제_정산(합산)
        	sheet1.getRow(40).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("INCOME_DED_I")));				//(36)근속연수공제_정산(합산)
        	sheet1.getRow(41).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("TAX_STD_I")));				//(37) 퇴직소득과세표준(34-35-36)
        	
        	//종전규정에 따른 계산방법 - 2012.12.31 이전
        	sheet1.getRow(43).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("DIVI_TAX_STD_BE13")));		//(36)과세표준안분((30)×각근속연수/정산근속연수)_201.12.31이전
        	sheet1.getRow(44).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVG_TAX_STD_BE13")));			//(37)연평균과세표준((31)/각근속연수)_201.12.31이전
        	sheet1.getRow(47).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVR_COMP_TAX_BE13")));		//(40)연평균산출세액((34)/5배)_201.12.31이전
        	sheet1.getRow(48).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("COMP_TAX_BE13")));			//(41)산출세액((35)×각 근속연수)_201.12.31이전
        	
        	//종전규정에 따른 계산방법 - 2013.1.1 이후
        	sheet1.getRow(43).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("DIVI_TAX_STD_AF13")));		//(36)과세표준안분((30)×각근속연수/정산근속연수)_2013.01.01이후
        	sheet1.getRow(44).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVG_TAX_STD_AF13")));			//(37)연평균과세표준((31)/각근속연수)_2013.01.01이후
        	sheet1.getRow(45).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("EX_TAX_STD_AF13")));			//(38)환산과세표준((32)×5배)_2013.01.01이후
        	sheet1.getRow(46).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("EX_COMP_TAX_AF13")));			//(39)환산산출세액((33)×세율)_2013.01.01이후
        	sheet1.getRow(47).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVR_COMP_TAX_AF13")));		//(40)연평균산출세액((34)/5배)_2013.01.01이후
        	sheet1.getRow(48).getCell(T).setCellValue(ObjUtils.parseInt(list1.get(i).get("COMP_TAX_AF13")));			//(41)산출세액((35)×각 근속연수_2013.01.01이후
        	
        	//종전규정에 따른 계산방법 - 합계
        	sheet1.getRow(43).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("DIVI_TAX_STD")));				//(36)과세표준안분((30)×각근속연수/정산근속연수)_정산(합산)
        	sheet1.getRow(44).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVG_TAX_STD")));				//(37)연평균과세표준((31)/각근속연수)_정산(합산)   
        	sheet1.getRow(45).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("EX_TAX_STD")));				//(38)환산과세표준((32)×5배)_정산(합산)
        	sheet1.getRow(46).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("EX_COMP_TAX")));				//(39)환산산출세액((33)×세율)_정산(합산)
        	sheet1.getRow(47).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("AVR_COMP_TAX")));				//(40)연평균산출세액((34)/5배)_정산(합산)
        	sheet1.getRow(48).getCell(X).setCellValue(ObjUtils.parseInt(list1.get(i).get("COMP_TAX")));					//(41)산출세액((35)×각 근속연수_정산(합산)
        	
        	
        	//퇴직소득세액계산
        	sheet1.getRow(49).getCell(P).setCellValue(list1.get(i).get("CHANGE_TAX_YEAR_16").toString());				//(44)퇴직일이 속하는 과세연도
        	sheet1.getRow(50).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("EXEMPTION_COMP_TAX_I_16")));	//(45)특례적용산출세액 ((41)X퇴직연도별 비율)+((43)X퇴직연도별 비율)
        	sheet1.getRow(51).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("PAY_END_TAX")));				//(46)기납부(또는 기과세이연) 세액
        	sheet1.getRow(52).getCell(P).setCellValue(ObjUtils.parseInt(list1.get(i).get("CHANGE_TARGET_TAX_I_16")));   //(47)신고대상세액((45)-(46))
        	
        	//이연퇴직소득세액계산
        	
//        	if (bankAccount.equals("")) {
//        		sheet1.getRow(55).getCell(D).setCellValue("");															//신고대상세액(39)
//        		sheet1.getRow(55).getCell(U).setCellValue("");															//(41)퇴직급여(17)
//        	} else {
//        		sheet1.getRow(55).getCell(D).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEF_TAX_I2")));			//신고대상세액(39)
//   		    sheet1.getRow(55).getCell(U).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEFER_TAX_TOTAL_I")));	//(41)퇴직급여(17)
//        	}
        	
        	//sheet1.getRow(55).getCell(D).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEF_TAX_I2")));				//신고대상세액(39)
        	sheet1.getRow(55).getCell(D).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEF_TAX_I2")));			//신고대상세액(39)
    		sheet1.getRow(55).getCell(U).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEFER_TAX_TOTAL_I")));	//(41)퇴직급여(17)
        	sheet1.getRow(55).getCell(F).setCellValue(list1.get(i).get("COMP_NAME").toString());						//연금계좌취급자
        	sheet1.getRow(55).getCell(J).setCellValue(list1.get(i).get("COMP_NUM").toString());							//사업자등록번호
        	//sheet1.getRow(55).getCell(M).setCellValue(decrypto.getDecryptWithType(list1.get(i).get("BANK_ACCOUNT").toString(),param.get("S_COMP_CODE") , "hrt716rkr", "RR"));						//계좌번호
        	sheet1.getRow(55).getCell(M).setCellValue(list1.get(i).get("BANK_ACCOUNT").toString());						//계좌번호
        	sheet1.getRow(55).getCell(P).setCellValue(list1.get(i).get("DEPOSIT_DATE").toString());						//입금일
        	sheet1.getRow(55).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("TRANS_RETR_PAY")));			//(40)계좌입금금액
        	
        	//sheet1.getRow(55).getCell(U).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEFER_TAX_TOTAL_I")));		//(41)퇴직급여(17)
        	
        	
        	//sheet1.getRow(55).getCell(D).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEF_TAX_I2"))) * 
        	//sheet1.getRow(55).getCell(R).setCellValue(ObjUtils.parseInt(list1.get(i).get("TRANS_RETR_PAY"))) / 
        	//sheet1.getRow(55).getCell(U).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEFER_TAX_TOTAL_I")));
        	
        	//(51)이연 퇴직소득세 : ((48)×(49)/(50))
        	sheet1.getRow(55).getCell(Y).setCellFormula("D56 * R56 / U56");            
        	//sheet1.getRow(55).getCell(Y).setCellValue(ObjUtils.parseInt(list1.get(i).get("DEFER_TAX_I")));				//(42)이연 퇴직소득세((39)×(40)/(41))
        	
        	//납부명세
        	sheet1.getRow(59).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("IN_TAX_I1")));				//(53)신고대상세액_소득세        	
        	sheet1.getRow(60).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("IN_TAX_I2")));				//(54)이연퇴직소득세_소득세        	
        	sheet1.getRow(61).getCell(J).setCellValue(ObjUtils.parseInt(list1.get(i).get("IN_TAX_I3")));				//(55)차감원천징수세액_소득세        	
        	//sheet1.getRow(61).getCell(J).setCellFormula("ROUNDDOWN(J60 - J61, -1)");													//(55)차감원천징수세액_소득세
        	
        	
        	
        	sheet1.getRow(59).getCell(O).setCellValue(ObjUtils.parseInt(list1.get(i).get("LOCAL_TAX_I1")));				//(53)신고대상세액_지방소득세        	
        	sheet1.getRow(60).getCell(O).setCellValue(ObjUtils.parseInt(list1.get(i).get("LOCAL_TAX_I2")));				//(54)이연퇴직소득세_지방소득세        	
        	sheet1.getRow(61).getCell(O).setCellValue(ObjUtils.parseInt(list1.get(i).get("LOCAL_TAX_I3")));				//(55)차감원천징수세액_지방소득세
        	//sheet1.getRow(61).getCell(O).setCellFormula("ROUNDDOWN(O60 - O61, -1)");													//(55)차감원천징수세액_지방소득세
        	
        	sheet1.getRow(59).getCell(S).setCellValue(ObjUtils.parseInt(list1.get(i).get("SP_TAX_I1")));				//(53)신고대상세액_농어촌특별세
        	sheet1.getRow(60).getCell(S).setCellValue(ObjUtils.parseInt(list1.get(i).get("SP_TAX_I2")));				//(54)이연퇴직소득세_농어촌특별세
        	sheet1.getRow(61).getCell(S).setCellValue(ObjUtils.parseInt(list1.get(i).get("SP_TAX_I3")));				//(55)차감원천징수세액_농어촌특별세
        	//sheet1.getRow(61).getCell(S).setCellFormula("ROUNDDOWN(S60 - S61, -1)");													//(55)차감원천징수세액_농어촌특별세
        	
        	sheet1.getRow(59).getCell(W).setCellValue(ObjUtils.parseInt(list1.get(i).get("SUM_TAX_I1")));				//(53)신고대상세액(47)_계
        	sheet1.getRow(60).getCell(W).setCellValue(ObjUtils.parseInt(list1.get(i).get("SUM_TAX_I2")));				//(54)이연퇴직소득세(51)_계
        	sheet1.getRow(61).getCell(W).setCellValue(ObjUtils.parseInt(list1.get(i).get("SUM_TAX_I3")));				//(55)차감원천징수세액_계
        	//sheet1.getRow(61).getCell(W).setCellFormula("ROUNDDOWN(W60 - W61, -1)");													//(55)차감원천징수세액_계
        	
        	if(ObjUtils.getSafeString(list1.get(i).get("SUPP_DATE")).length() == 8 ){
        		String suppDate = ObjUtils.getSafeString(list1.get(i).get("SUPP_DATE"));
        		String suppDateFormat = "";
        		suppDateFormat = suppDate.substring(0, 4) + "년" + suppDate.substring(4,6)+ "월" + suppDate.substring(6,8)+ "일";
        		sheet1.getRow(63).getCell(B).setCellValue(suppDateFormat);					//
        	}else{
        		sheet1.getRow(63).getCell(B).setCellValue(list1.get(i).get("SUPP_DATE").toString());					//	
        	}
        	sheet1.getRow(64).getCell(R).setCellValue(list1.get(i).get("DIV_FULL_NAME").toString());				//징수의무자
        	sheet1.getRow(64).getCell(X).setCellValue(list1.get(i).get("REPRE_NAME").toString());					//서명
        	sheet1.getRow(65).getCell(F).setCellValue(list1.get(i).get("SAFFER_TAX_NM").toString());				//세무서장
  	
        	HSSFFormulaEvaluator.evaluateAllFormulaCells(workbook);
        	
        }
                
       
        return workbook;
    }
    
    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row - 1).getCell(cell).setCellValue(value);
    }
    
}
