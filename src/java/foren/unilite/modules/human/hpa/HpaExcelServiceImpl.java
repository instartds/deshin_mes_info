package foren.unilite.modules.human.hpa;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
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
import org.apache.poi.ss.util.CellReference;

@Service( "HpaExcelService" )
public class HpaExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());

    public Workbook makeExcel( Map param ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "hpa990p-201602.xlsx"));

        Workbook workbook = new XSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        Sheet sheet2 = workbook.getSheetAt(1);
        Sheet sheet3 = workbook.getSheetAt(2);
        Sheet sheet4 = workbook.getSheetAt(3);
        Sheet sheet5 = workbook.getSheetAt(4);
        Sheet sheet6 = workbook.getSheetAt(5);
        Sheet sheet7 = workbook.getSheetAt(6);
        Sheet sheet8 = workbook.getSheetAt(7);
        Sheet sheet9 = workbook.getSheetAt(8);
        Sheet sheet10 = workbook.getSheetAt(9);
        Sheet sheet11= workbook.getSheetAt(10);
        Sheet sheet12 = workbook.getSheetAt(11);
        Sheet sheet13 = workbook.getSheetAt(12);

        Row headerRow = null;
        DataFormat format = workbook.createDataFormat();

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;        

        int row1 = 0;
        int row2 = 0;
        int row3 = 0;
        int row4 = 0;
        int row5 = 0;
        int row6 = 0;
        int row7 = 0;
        
        String strChk = "";
        String SAFFER_TAX_NM = "";
        String SAFFER_BANK_NUM = "";
        String RECEIVE_DATE = "";
        String COMP_OWN_NO = "";
        String LOCAL_TAX_GOV = "";
        String DIV_NAME = "";
        String REPRE_NO = "";
        String SUPP_DATE = "";
        String TAX_BASE_CHCK = "";
        

        // 타이틀폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)13);
        font.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // 노란색컬럼폰트
        Font font1 = workbook.createFont();
        font1.setFontHeightInPoints((short)10);
        font1.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // 본문및합계폰트
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)9);
        font2.setFontName("돋움체"); //글씨체
        
        // 본문및합계폰트
        Font font3 = workbook.createFont();
        font3.setFontHeightInPoints((short)9);
        font3.setFontName("돋움체"); //글씨체
        font3.setColor(IndexedColors.WHITE.getIndex());


        // Style 01 : 타이틀 중앙정렬
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_THIN);
        style01.setBorderLeft(CellStyle.BORDER_THIN);
        style01.setBorderRight(CellStyle.BORDER_THIN);
        style01.setBorderTop(CellStyle.BORDER_THIN);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);

       // Style 02 : 중간명칭 중앙정렬과 노란색
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_THIN);
        style02.setBorderLeft(CellStyle.BORDER_THIN);
        style02.setBorderRight(CellStyle.BORDER_THIN);
        style02.setBorderTop(CellStyle.BORDER_THIN);
        style02.setAlignment(CellStyle.ALIGN_CENTER);
        style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style02.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style02.setFont(font1);

        // Style 03 : 숫자
        CellStyle style03 = workbook.createCellStyle();
        //style03.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style03.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style03.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style03.setAlignment(CellStyle.ALIGN_RIGHT);
        style03.setDataFormat(format.getFormat("#,##0"));
        style03.setFont(font2);


        // Style 04 : 숫자(밑줄)
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style03.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style04.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style04.setAlignment(CellStyle.ALIGN_RIGHT);
        style04.setDataFormat(format.getFormat("#,##0"));
        style04.setFont(font2);
        
        // Style 05 : 숫자(오른쪽)
        CellStyle style05 = workbook.createCellStyle();
        //style05.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style05.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style05.setAlignment(CellStyle.ALIGN_RIGHT);
        style05.setDataFormat(format.getFormat("#,##0"));
        style05.setFont(font2);

        // Style 06 : 숫자(밑줄 + 오른쪽)
        CellStyle style06 = workbook.createCellStyle();
        style06.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style06.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style06.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style06.setAlignment(CellStyle.ALIGN_RIGHT);
        style06.setDataFormat(format.getFormat("#,##0"));
        style06.setFont(font2);
        
        // Style 07 : 숫자(밑줄 + 오른쪽)
        CellStyle style07 = workbook.createCellStyle();
        style07.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style07.setBorderRight(CellStyle.BORDER_MEDIUM);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style07.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style07.setAlignment(CellStyle.ALIGN_RIGHT);
        style07.setDataFormat(format.getFormat("#,##0"));
        style07.setFont(font2);
        
        // Style 08 : 숫자(밑줄 + 오른쪽)
        CellStyle style08 = workbook.createCellStyle();
        style08.setBorderBottom(CellStyle.BORDER_MEDIUM);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style08.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style08.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style08.setAlignment(CellStyle.ALIGN_RIGHT);
        style08.setDataFormat(format.getFormat("#,##0"));
        style08.setFont(font2);
        
        // Style 08 : 숫자(밑줄 + 오른쪽 + 글씨색 흰색)
        CellStyle style09 = workbook.createCellStyle();
        //style08.setBorderBottom(CellStyle.BORDER_MEDIUM);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style08.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style09.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style09.setAlignment(CellStyle.ALIGN_RIGHT);
        //style09.setDataFormat(format.getFormat("#,##0"));
        style09.setFont(font3);
        
        // Style 10 : 숫자(오른쪽)
        CellStyle style10 = workbook.createCellStyle();
        style10.setBorderBottom(CellStyle.BORDER_HAIR);
        style10.setBorderLeft(CellStyle.BORDER_HAIR);
        style10.setBorderRight(CellStyle.BORDER_HAIR);
        style10.setBorderTop(CellStyle.BORDER_HAIR);
        style10.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style10.setAlignment(CellStyle.ALIGN_RIGHT);
        style10.setDataFormat(format.getFormat("#,##0"));
        style10.setFont(font2);
        
        
        List<Map> list1 = super.commonDao.list("hpa990ukrServiceImpl.printExcel1", param);
        
        Row  row = null;
        Cell cell = null;
        
        if(list1.size() > 0) {
        	//신고세무소명                       
        	SAFFER_TAX_NM = ObjUtils.getSafeString(list1.get(0).get("SAFFER_TAX_NM"));
        	//납부서 계좌번호
		    SAFFER_BANK_NUM = ObjUtils.getSafeString(list1.get(0).get("SAFFER_BANK_NUM"));
		    //작성일자
		    RECEIVE_DATE = ObjUtils.getSafeString(param.get("RECEIVE_DATE"));
		    //법인등록번호
		    COMP_OWN_NO = ObjUtils.getSafeString(list1.get(0).get("COMP_OWN_NO"));
		    //주민세관할관청
		    LOCAL_TAX_GOV = ObjUtils.getSafeString(list1.get(0).get("LOCAL_TAX_GOV"));
		    //사업장명
		    DIV_NAME = ObjUtils.getSafeString(list1.get(0).get("DIV_NAME"));
		    //주민등록번호
		    REPRE_NO = ObjUtils.getSafeString(list1.get(0).get("REPRE_NO"));
		    //지급일
		    SUPP_DATE = ObjUtils.getSafeString(param.get("SUPP_DATE"));
		    
		    TAX_BASE_CHCK = ObjUtils.getSafeString(list1.get(0).get("TAX_BASE_CHCK"));
		    
		    if(TAX_BASE_CHCK.equals("Y")){
		    	TAX_BASE_CHCK = "(여), 부";
		    }else{
		    	TAX_BASE_CHCK = "여, (부)";
		    }
		    
	        
	        //----------------------------------------//
	        //시트1
	        //----------------------------------------//
	        //귀속년월
	        row = sheet1.getRow(2);
			cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(param.get("PAY_YYYYMM")).substring(0,4) + "년 " + ObjUtils.getSafeString(param.get("PAY_YYYYMM")).substring(4,6) + "월");
		    
		    //지급년월
		    row = sheet1.getRow(3);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(param.get("SUPP_DATE")).substring(0,4) + "년 " + ObjUtils.getSafeString(param.get("SUPP_DATE")).substring(4,6) + "월");
		    
		    //전화번호
		    row = sheet1.getRow(7);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("TELEPHON")));
		    
		    //법인명(상호)
		    row = sheet1.getRow(5);
		    cell = row.getCell(E);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("DIV_FULL_NAME")));
		    
		    //대표자성명
		    row = sheet1.getRow(5);
		    cell = row.getCell(I);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("REPRE_NAME")));
		    
		    //사업자단위과세여부
		    row = sheet1.getRow(6);
		    cell = row.getCell(N);
		    cell.setCellValue(TAX_BASE_CHCK);
		    
		    //사업자(주민)등록번호
		    row = sheet1.getRow(7);
		    cell = row.getCell(E);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("COMPANY_NUM")));
		    
		    //사업장소재지
		    row = sheet1.getRow(7);
		    cell = row.getCell(I);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("ADDR")));
		    
		    //서류날짜
		    row = sheet1.getRow(48);
		    cell = row.getCell(G);
		    cell.setCellValue(ObjUtils.getSafeString(param.get("RECEIVE_DATE")).substring(0,4) + "년 " + ObjUtils.getSafeString(param.get("RECEIVE_DATE")).substring(4,6) + "월 " + ObjUtils.getSafeString(param.get("RECEIVE_DATE")).substring(6,8)+ "일");
		    
		    //원천징수의무자
		    row = sheet1.getRow(49);
		    cell = row.getCell(G);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("DIV_FULL_NAME")));
		    
		    //세무서명
		    row = sheet1.getRow(54);
		    cell = row.getCell(C);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("SAFFER_TAX_NM")) + " 세무서장 귀하");		    
		    		    
		    //세무대리인 이름
		    row = sheet1.getRow(52);
		    cell = row.getCell(G);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("TAX_NAME")));
		    
		    //전자우편주소
		    row = sheet1.getRow(8);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("EMAIL")));
		    
		    //세무대리인 이름
		    row = sheet1.getRow(49);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("TAX_NAME")));
		    
		    //대리인 사업자등록번호
		    row = sheet1.getRow(50);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("TAX_NUM")));
		    
		    //TAX_TEL
		    row = sheet1.getRow(51);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("TAX_TEL")));
		    
		    
		    //Q11
		    row = sheet1.getRow(10);
		    cell = row.getCell(Q);
		    cell.setCellValue(ObjUtils.parseDouble(list1.get(0).get("SCOUNT")));
		    
		    //R4
		    row = sheet1.getRow(3);
		    cell = row.getCell(R);
		    cell.setCellValue(ObjUtils.parseDouble(list1.get(0).get("TAX_EXEMPTION_I")));
		    cell.setCellStyle(style09);
		    
		    //Q12
		    row = sheet1.getRow(11);
		    cell = row.getCell(Q);
		    cell.setCellValue(ObjUtils.parseDouble(list1.get(0).get("TOTAL_I")));
		    		    
		    
		    for(int i = 0; i < list1.size(); i++) {
		    	
		    	//근로소득
		    	if ("A01".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    		//간이세액 인원
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    		//간이세액 총지급액
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    //cell.setCellStyle(style10);
		    	    
		    		//간이세액 소득세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    //cell.setCellStyle(style10);
		    	    
		    		//농어촌특별세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    //cell.setCellStyle(style10);
		    	    
		    		//가산세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    //cell.setCellStyle(style10);
		    	    
		    	} else if ("A02".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
	
		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style10);
		    	    
		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style10);
		    	    
		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style10);
		    	    
		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style10);
		    	    
		    	} else if ("A03".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(15);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet1.getRow(15);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(15);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(15);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(15);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    //R11
				    row = sheet1.getRow(10);
				    cell = row.getCell(R);
				    cell.setCellValue(ObjUtils.getSafeString(list1.get(0).get("INCOME_CNT")));
		    	    
		    	} else if ("A04".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(16);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(16);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(16);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(16);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(16);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    if ("0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	
		    	    	row = sheet1.getRow(3);
			    	    cell = row.getCell(A);
			    	    cell.setCellValue("(매월)");
			    	    
			    	    row = sheet1.getRow(3);
			    	    cell = row.getCell(D);
			    	    cell.setCellValue("연말");
		    	    	
		    	    } else {
		    	    	
		    	    	row = sheet1.getRow(3);
			    	    cell = row.getCell(A);
			    	    cell.setCellValue("(매월)");
			    	    
			    	    row = sheet1.getRow(3);
			    	    cell = row.getCell(D);
			    	    cell.setCellValue("(연말)");
		    	    	
		    	    }	  
		    	    
		    	} else if ("A05".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(17);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(17);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(17);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(17);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(17);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A06".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(18);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet1.getRow(18);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(18);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(18);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(18);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A10".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
	
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style04);    	    
		    	    
		    	    row = sheet1.getRow(19);
		    	    cell = row.getCell(P);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style04);    	    
		    	    
		    	    //확인
		    	    row = sheet1.getRow(19);
					cell = row.getCell(P);
					cell.setCellFormula("M20 + N20");
					//cell.setCellStyle(style09);	
		    	    
		    	} 
		    	
		    	//퇴직소득
	    		else if ("A21".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(20);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A22".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(21);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A20".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(22);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	}
		    	
		    	//사업소득
		    	else if ("A25".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(23);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet1.getRow(23);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(23);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(23);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A26".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(24);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(24);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(24);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(24);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(24);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A30".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(25);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));   	    
		    	    //cell.setCellStyle(style04);
		    	    
		    	    //확인
					row = sheet1.getRow(25);
					cell = row.getCell(R);
					cell.setCellFormula("M26 + N26");
					//cell.setCellStyle(style09);  
		    	    
		    	}
		    	
		    	//기타소득
		    	else if ("A41".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	        
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(26);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    
		    	} else if ("A42".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    	    
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(27);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    
		    	} else if ("A40".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    	    
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(28);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    		    	    
		    	}
		    	
		    	//연금소득
		    	else if ("A48".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    	    
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(29);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));	    	    	    	    
		    	    //cell.setCellStyle(style03);
		    	    
		    	    
		    	} else if ("A45".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	        	    
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(30);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A46".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style05);
		    	    
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    	    
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(31);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	} else if ("A47".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	        	    
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(32);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	}
		    	
		    	//이자소득
		    	else if ("A50".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    		//간이세액 인원
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    		//간이세액 총지급액
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    		//간이세액 소득세
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    	    	    
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(33);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    if (!"0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	strChk = "true";	    	    	
		    	    }
		    	    
		    	}
		    	
		    	//배당소득
		    	else if ("A60".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	       
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(34);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    //확인
		    	    row = sheet1.getRow(34);
					cell = row.getCell(R);
					cell.setCellFormula("M35 + N35");
					//cell.setCellStyle(style09);    
		    	    
		    	    if (!"0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	strChk = "true";	    	    	
		    	    }
		    	    
		    	}
		    	
		    	//저축해지 추징세액
		    	else if ("A69".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(35);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(35);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(35);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(35);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(35);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    if (!"0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	strChk = "true";	    	    	
		    	    }
		    	    
		    	}
		    	
		    	//비거주자양도소득
		    	else if ("A70".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(36);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    if (!"0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	strChk = "true";	    	    	
		    	    }
		    	    
		    	}
		    	
		    	//내외국법인원천
		    	else if ("A80".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style06);
		    	    
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(37);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    if (!"0".equals(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")))){
		    	    	strChk = "true";	    	    	
		    	    }
		    	    
		    	}
		    	
		    	//수정신고(세액)
		    	else if ("A90".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	    row = sheet1.getRow(38);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    	}
		    	
		    	//내외국법인원천
		    	else if ("A99".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){	    		
		    		
		    		//간이세액 인원
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    //cell.setCellStyle(style04);
		    	    
		    		//간이세액 소득세
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	    row = sheet1.getRow(39);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    //cell.setCellStyle(style03);
		    	    
		    	}
		    	   
		    }
	        
		    //신고서(부표)작성여부
		    if (strChk == "true"){
		    	row = sheet1.getRow(47);
	    	    cell = row.getCell(L);
	    	    cell.setCellValue("○");
		    }
	        
		    
		    List<Map> list2 = super.commonDao.list("hpa990ukrServiceImpl.printExcel2", param);
		    
			    if(list2.size() > 0) {
			    //전월미환급액
			    row = sheet1.getRow(44);
			    cell = row.getCell(A);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("LAST_IN_TAX_I")));
			    //cell.setCellStyle(style03);
	    	    
			    //기환급신청한세액
			    row = sheet1.getRow(44);
			    cell = row.getCell(D);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("BEFORE_IN_TAX_I")));
			    //cell.setCellStyle(style03);
	    	    
			    //차감잔액
			    row = sheet1.getRow(44);
			    cell = row.getCell(G);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("BAL_AMT")));
			    //cell.setCellStyle(style05);
	    	    
			    //일반환급
			    row = sheet1.getRow(44);
			    cell = row.getCell(H);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("RET_AMT")));
			    //cell.setCellStyle(style05);
	    	    
			    //신탁재산
			    row = sheet1.getRow(44);
			    cell = row.getCell(I);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("TRUST_AMT")));
			    //cell.setCellStyle(style05);
	    	    
			    //금융회사등
			    row = sheet1.getRow(44);
			    cell = row.getCell(J);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("FIN_COMP_AMT")));
			    //cell.setCellStyle(style05);
	    	    
			    //합병등
			    row = sheet1.getRow(44);
			    cell = row.getCell(K);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("MERGER_AMT")));
			    //cell.setCellStyle(style05);
	    	    
			    //조정대상환급세액
			    row = sheet1.getRow(44);
			    cell = row.getCell(L);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("ROW_IN_TAX_I")));
			    //cell.setCellStyle(style05);
	    	    
			    //당월조정환급세액계
			    row = sheet1.getRow(44);
			    cell = row.getCell(M);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("TOTAL_IN_TAX_I")));
			    //cell.setCellStyle(style06);
	    	    
			    //차월이월환급세액
			    row = sheet1.getRow(44);
			    cell = row.getCell(N);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("NEXT_IN_TAX_I")));
			    //cell.setCellStyle(style06);
	    	    
			    //환급신청액
			    row = sheet1.getRow(44);
			    cell = row.getCell(O);
			    cell.setCellValue(ObjUtils.parseDouble(list2.get(0).get("RET_IN_TAX_I")));
			    //cell.setCellStyle(style07);
	    	    
			    }
		    
	        //----------------------------------------//
	        //시트2
	        //----------------------------------------//
		    //귀속년월
		    row = sheet2.getRow(1);
		    cell = row.getCell(A);
		    cell.setCellValue("사업자등록번호 " + ObjUtils.getSafeString(list1.get(1).get("COMPANY_NUM")));
		    
			for(int i = 0; i < list1.size(); i++) {
				
				if ("C01".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					//소득지급 인원
					row = sheet2.getRow(4);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    //소득지급 총지급액
		    	    row = sheet2.getRow(4);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style03);
		    	    
					
				} else if ("C02".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(5);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(5);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C03".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(6);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(6);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C05".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(7);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(7);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C06".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					//소득지급 인원
					row = sheet2.getRow(8);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    //소득지급 총지급액
		    	    row = sheet2.getRow(8);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    //농어촌 특별세
		    	    row = sheet2.getRow(8);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    //가산세
		    	    row = sheet2.getRow(8);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C07".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(9);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(9);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C08".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(10);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(10);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C10".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(11);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(11);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C20".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(12);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(12);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C23".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(13);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(13);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C28".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(14);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(14);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C40".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(15);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(15);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(15);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(15);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C19".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(16);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(16);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(16);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(16);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C29".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(17);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(17);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(17);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(17);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C11".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(18);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(18);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(18);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(18);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(18);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C31".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(19);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(19);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(19);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(19);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(19);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C33".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(20);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(20);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(20);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(20);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(20);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C34".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(21);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(21);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(21);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(21);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(21);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C54".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(22);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(22);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(22);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(22);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(22);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C55".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(23);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(23);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(23);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(23);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(23);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C56".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(24);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(24);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(24);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(24);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(24);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C57".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(25);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(25);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(25);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(25);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(25);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C12".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(26);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(26);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(26);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(26);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(26);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C22".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(27);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(27);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(27);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(27);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(27);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C13".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(28);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(28);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(28);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        	    
		    	    row = sheet2.getRow(28);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C18".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(29);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(29);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(29);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    	    
		    	    row = sheet2.getRow(29);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C36".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(30);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(30);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(30);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	     	    
		    	    row = sheet2.getRow(30);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C37".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(31);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(31);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(31);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        
		    	    row = sheet2.getRow(31);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C38".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(32);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(32);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(32);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	     	    
		    	    row = sheet2.getRow(32);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C52".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(33);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(33);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(33);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	     	    
		    	    row = sheet2.getRow(33);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C58".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(34);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(34);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(34);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    	    
		    	    row = sheet2.getRow(34);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C39".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(35);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(35);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(35);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	     	    
		    	    row = sheet2.getRow(35);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C14".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(36);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(36);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(36);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	      	    
		    	    row = sheet2.getRow(36);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C24".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(37);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(37);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(37);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    	    
		    	    row = sheet2.getRow(37);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C15".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(38);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(38);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(38);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    	    
		    	    row = sheet2.getRow(38);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C25".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(39);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(39);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(39);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        	    
		    	    row = sheet2.getRow(39);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C16".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(40);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(40);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(40);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        	    
		    	    row = sheet2.getRow(40);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C26".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(41);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(41);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(41);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        	    
		    	    row = sheet2.getRow(41);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C30".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(42);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(K);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(42);
		    	    cell = row.getCell(O);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C41".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(43);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(43);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	       	    
		    	    row = sheet2.getRow(43);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C42".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(44);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(44);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	       
		    	    row = sheet2.getRow(44);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C43".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(45);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(45);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
		    	    row = sheet2.getRow(45);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C44".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(46);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(46);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    	    	    
		    	    row = sheet2.getRow(46);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C45".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(47);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(47);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	        	    
		    	    row = sheet2.getRow(47);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C46".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(48);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(48);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	      
		    	    row = sheet2.getRow(48);
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style06);
		    	    
				} else if ("C50".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
					
					row = sheet2.getRow(49);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
	
		    	    row = sheet2.getRow(49);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style08);
		    	    
		    	    row = sheet2.getRow(49);		    	    
		    	    cell = row.getCell(L);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style08);
		    	    
		    	    row = sheet2.getRow(49);
		    	    cell = row.getCell(M);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
		    	    cell.setCellStyle(style08);
		    	    
		    	    row = sheet2.getRow(49);
		    	    cell = row.getCell(N);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
		    	    cell.setCellStyle(style08);
		    	    
				} 
				
			}
			
			//----------------------------------------//
	        //시트3
	        //----------------------------------------//
			
				for(int i = 0; i < list1.size(); i++) {
					
					if ("C61".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(3);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(3);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(3);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(3);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C62".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(4);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(4);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(4);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(4);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C63".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(5);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(5);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(5);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(5);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(5);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(5);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(5);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(5);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C64".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(6);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(6);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(6);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(6);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(6);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(6);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(6);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(6);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C65".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(7);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(7);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(7);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(7);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(7);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(7);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(7);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(7);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C66".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(8);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(8);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(8);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(8);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(8);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(8);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(8);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(8);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C67".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(9);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(9);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(9);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(9);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(9);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(9);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(9);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(9);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C68".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(10);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(10);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(10);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(10);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(10);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(10);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(10);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(10);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C70".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(11);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(11);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(11);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(11);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(11);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(11);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(11);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(11);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);
			    	    
					} else if ("C71".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(12);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(12);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(12);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(12);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(12);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(12);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    
					} else if ("C72".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(13);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(13);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(13);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    	    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(13);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(13);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(13);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    
					} else if ("C73".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(14);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(14);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(14);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(14);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(14);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(14);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
					} else if ("C74".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(15);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(15);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(15);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(15);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(15);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(15);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	        
					} else if ("C75".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(16);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(16);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(16);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(16);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(16);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(16);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	        
					} else if ("C76".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(17);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(17);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
					} else if ("C81".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(18);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(18);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(18);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(18);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(18);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(18);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	      	    
					} else if ("C82".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(19);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(19);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(19);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(19);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(19);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(19);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	     	    
					} else if ("C83".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(20);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(20);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(20);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(20);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(20);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(20);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    	    
					} else if ("C84".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(21);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(21);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(21);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(21);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(21);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(21);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	     	    
					} else if ("C85".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(22);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(22);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(22);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(22);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(22);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(22);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    	    
					} else if ("C86".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(23);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(23);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(23);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(23);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(23);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(23);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	        	    
					} else if ("C87".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(24);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(24);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(24);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(24);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(24);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(24);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	        	    
					} else if ("C88".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(25);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(25);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(25);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(25);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(25);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(25);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	     	    
					} else if ("C90".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){
						
						//소득지급 인원
						row = sheet3.getRow(26);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));
			    	    
			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(26);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 소득세
						row = sheet3.getRow(26);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));	    	    
			    	    cell.setCellStyle(style06);
			    	    
			    	    //징수세액 가산세
						row = sheet3.getRow(26);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //조징환급세액
			    	    row = sheet3.getRow(26);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	    
			    	    //납부세액 소득세등
						row = sheet3.getRow(26);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);
			    	        	    
					}
					
				}

				//근로소득납부서
				sheet4 = makeExcelSheet4(sheet4, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//주민세납부서
				sheet5 = makeExcelSheet5(sheet5, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//주민세납부서
				sheet6 = makeExcelSheet6(sheet6, COMP_OWN_NO, LOCAL_TAX_GOV);
				//법인원천세납부서
				sheet7 = makeExcelSheet7(sheet7, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//기타소득납부서
				sheet8 = makeExcelSheet8(sheet8, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//배당소득납부서
				sheet9 = makeExcelSheet9(sheet9, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//사업소득납부서
				sheet10 = makeExcelSheet10(sheet10, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//사업소세(재산할)신고서
				sheet11 = makeExcelSheet11(sheet11, DIV_NAME, RECEIVE_DATE, COMP_OWN_NO, REPRE_NO, LOCAL_TAX_GOV);
				//사업소세(종업원할)신고서
				sheet12 = makeExcelSheet12(sheet12, DIV_NAME, RECEIVE_DATE, COMP_OWN_NO, REPRE_NO, SUPP_DATE, LOCAL_TAX_GOV);
				//지방소득세(종업원)납부서
				sheet13 = makeExcelSheet13(sheet13, DIV_NAME, RECEIVE_DATE, COMP_OWN_NO, SUPP_DATE, LOCAL_TAX_GOV);
				
	        }
		
        return workbook;

    }
    
    
    
    public Sheet makeExcelSheet4( Sheet sheet4, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트4 - 1면
        //----------------------------------------//
		//납부년월
		row = sheet4.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet4.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet4.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet4.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet4.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet4.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet4.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet4.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet4.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet4.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//갑종근로소득세
		row = sheet4.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 13), 1), "  + "\"\"" + ")");		
		
		// 농어촌특별세
		row = sheet4.getRow(16);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet4.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 13), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet4.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet4.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트4 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet4.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet4.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet4.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet4.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet4.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet4.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet4.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet4.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet4.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet4.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//갑종근로소득세
		row = sheet4.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 13), 1), "  + "\"\"" + ")");
		
		// 농어촌특별세
		row = sheet4.getRow(38);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet4.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 13), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet4.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet4.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트4 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet4.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet4.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet4.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet4.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet4.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet4.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet4.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet4.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet4.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet4.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//갑종근로소득세
		row = sheet4.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$20, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet4.getRow(60);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$20, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet4.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=1, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 1), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=2, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 2), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=3, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 3), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=4, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 4), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=5, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 5), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=6, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 6), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=7, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 7), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=8, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 8), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=9, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 9), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=10, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 10), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=11, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 11), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=12, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 12), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$P$20)>=13, LEFT(RIGHT(원천징수이행상황신고서!$P$20, 13), 1), "  + "\"\"" + ")");
		
		row = sheet4.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet4.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet4.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet4;
    }
    
    public Sheet makeExcelSheet5( Sheet sheet5, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트5 - 1면
        //----------------------------------------//
		//납부년월
		row = sheet5.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet5.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet5.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet5.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet5.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet5.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet5.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet5.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet5.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet5.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//퇴직소득세
		row = sheet5.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet5.getRow(16);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet5.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet5.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet5.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트5 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet5.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet5.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet5.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet5.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet5.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet5.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet5.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet5.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet5.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet5.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//퇴직소득세
		row = sheet5.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet5.getRow(38);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet5.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet5.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet5.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트5 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet5.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet5.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet5.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet5.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet5.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet5.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet5.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet5.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet5.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet5.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//퇴직소득세
		row = sheet5.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet5.getRow(60);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$O$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$O$23, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet5.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 1), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 2), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 3), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 4), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 5), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 6), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 7), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 8), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 9), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 10), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 11), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 12), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$23)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$23, 13), 1), "  + "\"\"" + ")");
		
		row = sheet5.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet5.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet5.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet5;
    }
        
    
    public Sheet makeExcelSheet6( Sheet sheet6, String COMP_OWN_NO, String LOCAL_TAX_GOV ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
        //----------------------------------------//
        //시트6
        //----------------------------------------//
		//납부년월
		row = sheet6.getRow(3);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//납부년월
		row = sheet6.getRow(3);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//납부년월
		row = sheet6.getRow(3);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//주민(법인)등록번호
		row = sheet6.getRow(4);
		cell = row.getCell(E);
		cell.setCellValue(COMP_OWN_NO);
		
		//주민(법인)등록번호
		row = sheet6.getRow(4);
		cell = row.getCell(R);
		cell.setCellValue(COMP_OWN_NO);
		
		//주민(법인)등록번호
		row = sheet6.getRow(4);
		cell = row.getCell(AE);
		cell.setCellValue(COMP_OWN_NO);
		
		//상호(대표자)
		row = sheet6.getRow(5);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//상호(대표자)
		row = sheet6.getRow(5);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//상호(대표자)
		row = sheet6.getRow(5);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//사업자등록번호
		row = sheet6.getRow(6);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//사업자등록번호
		row = sheet6.getRow(6);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//사업자등록번호
		row = sheet6.getRow(6);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//주소(소재지)
		row = sheet6.getRow(7);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		//주소(소재지)
		row = sheet6.getRow(7);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		//주소(소재지)
		row = sheet6.getRow(7);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		
		//전  화  번  호
		row = sheet6.getRow(8);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!N8");
		
		//전  화  번  호
		row = sheet6.getRow(8);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!N8");
		
		//전  화  번  호
		row = sheet6.getRow(8);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!N8");
		
		//
		row = sheet6.getRow(9);
		cell = row.getCell(A);
		cell.setCellFormula("원천징수이행상황신고서!N3");
		
		row = sheet6.getRow(9);
		cell = row.getCell(N);
		cell.setCellFormula("원천징수이행상황신고서!N3");
		
		row = sheet6.getRow(9);
		cell = row.getCell(AA);
		cell.setCellFormula("원천징수이행상황신고서!N3");
		
		//
		row = sheet6.getRow(9);
		cell = row.getCell(F);
		cell.setCellFormula("\"(지급 \"&" + "RIGHT(원천징수이행상황신고서!N4,3)"+ "&\")\"");
		
		row = sheet6.getRow(9);
		cell = row.getCell(S);
		cell.setCellFormula("\"(지급 \"&" + "RIGHT(원천징수이행상황신고서!N4,3)"+ "&\")\"");
		
		row = sheet6.getRow(9);
		cell = row.getCell(AF);
		cell.setCellFormula("\"(지급 \"&" + "RIGHT(원천징수이행상황신고서!N4,3)"+ "&\")\"");

		//LOCAL_TAX_GOV
		row = sheet6.getRow(10);
		cell = row.getCell(H);
		cell.setCellValue(LOCAL_TAX_GOV);
		
		//LOCAL_TAX_GOV
		row = sheet6.getRow(10);
		cell = row.getCell(U);
		cell.setCellValue(LOCAL_TAX_GOV);
		
		//LOCAL_TAX_GOV
		row = sheet6.getRow(10);
		cell = row.getCell(AH);
		cell.setCellValue(LOCAL_TAX_GOV);
		
		
		//이   자   소   득(인원)
		row = sheet6.getRow(13);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34 <= 0,0,원천징수이행상황신고서!E34)");
		
		//이   자   소   득(인원)
		row = sheet6.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34 <= 0,0,원천징수이행상황신고서!E34)");
		
		//이   자   소   득(인원)
		row = sheet6.getRow(13);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34 <= 0,0,원천징수이행상황신고서!E34)");
		
		//이   자   소   득(과세표준)
		row = sheet6.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M34");
		
		//이   자   소   득(과세표준)
		row = sheet6.getRow(13);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M34");
		
		//이   자   소   득(과세표준)
		row = sheet6.getRow(13);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M34");
		
		//이   자   소   득(지방소득세)
		row = sheet6.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34> 0,(ROUND(((원천징수이행상황신고서!M34*0.1)/10-0.5),0)*10),0)");
		
		//이   자   소   득(지방소득세)
		row = sheet6.getRow(13);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34> 0,(ROUND(((원천징수이행상황신고서!M34*0.1)/10-0.5),0)*10),0)");
		
		//이   자   소   득(지방소득세)
		row = sheet6.getRow(13);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M34> 0,(ROUND(((원천징수이행상황신고서!M34*0.1)/10-0.5),0)*10),0)");
				
		//배   당   소   득(인원)
		row = sheet6.getRow(14);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35 <= 0,0,원천징수이행상황신고서!E35)");
		
		//배   당   소   득(인원)
		row = sheet6.getRow(14);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35 <= 0,0,원천징수이행상황신고서!E35)");
		
		//배   당   소   득(인원)
		row = sheet6.getRow(14);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35 <= 0,0,원천징수이행상황신고서!E35)");
		
		//배   당   소   득(과세표준)
		row = sheet6.getRow(14);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M35");
		
		//배   당   소   득(과세표준)
		row = sheet6.getRow(14);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M35");
		
		//배   당   소   득(과세표준)
		row = sheet6.getRow(14);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M35");
		
		//배   당   소   득(지방소득세)
		row = sheet6.getRow(14);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35> 0,(ROUND(((원천징수이행상황신고서!M35*0.1)/10-0.5),0)*10),0)");
		
		//배   당   소   득(지방소득세)
		row = sheet6.getRow(14);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35> 0,(ROUND(((원천징수이행상황신고서!M35*0.1)/10-0.5),0)*10),0)");
		
		//배   당   소   득(지방소득세)
		row = sheet6.getRow(14);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M35> 0,(ROUND(((원천징수이행상황신고서!M35*0.1)/10-0.5),0)*10),0)");
		
		//사   업   소   득(인원)
		row = sheet6.getRow(15);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26 <= 0,0,원천징수이행상황신고서!E26)");
		
		//사   업   소   득(인원)
		row = sheet6.getRow(15);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26 <= 0,0,원천징수이행상황신고서!E26)");
		
		//사   업   소   득(인원)
		row = sheet6.getRow(15);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26 <= 0,0,원천징수이행상황신고서!E26)");
		
		//사   업   소   득(과세표준)
		row = sheet6.getRow(15);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M26");
		
		//사   업   소   득(과세표준)
		row = sheet6.getRow(15);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M26");
		
		//사   업   소   득(과세표준)
		row = sheet6.getRow(15);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M26");
		
		//사   업   소   득(지방소득세)
		row = sheet6.getRow(15);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26> 0,(ROUND(((원천징수이행상황신고서!M26*0.1)/10-0.5),0)*10),0)");
		
		//사   업   소   득(지방소득세)
		row = sheet6.getRow(15);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26> 0,(ROUND(((원천징수이행상황신고서!M26*0.1)/10-0.5),0)*10),0)");
		
		//사   업   소   득(지방소득세)
		row = sheet6.getRow(15);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M26> 0,(ROUND(((원천징수이행상황신고서!M26*0.1)/10-0.5),0)*10),0)");
		
		//근   로   소   득(인원)
		row = sheet6.getRow(16);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M20 <= 0,0,원천징수이행상황신고서!E20)");
		
		//근   로   소   득(인원)
		row = sheet6.getRow(16);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M20 <= 0,0,원천징수이행상황신고서!E20)");
		
		//근   로   소   득(인원)
		row = sheet6.getRow(16);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M20 <= 0,0,원천징수이행상황신고서!E20)");
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M20");
		
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M20");
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M20");
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(I);
		cell.setCellFormula("원천징수이행상황신고서!S20");
		
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!S20");
		
		//근   로   소   득(과세표준)
		row = sheet6.getRow(16);
		cell = row.getCell(AI);
		cell.setCellFormula("원천징수이행상황신고서!S20");
		
		//연   금   소   득(인원)
		row = sheet6.getRow(17);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33 <= 0,0,원천징수이행상황신고서!E33)");
		
		//연   금   소   득(인원)
		row = sheet6.getRow(17);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33 <= 0,0,원천징수이행상황신고서!E33)");
		
		//연   금   소   득(인원)
		row = sheet6.getRow(17);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33 <= 0,0,원천징수이행상황신고서!E33)");
		
		//연   금   소   득(과세표준)
		row = sheet6.getRow(17);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M33");
		
		//연   금   소   득(과세표준)
		row = sheet6.getRow(17);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M33");
		
		//연   금   소   득(과세표준)
		row = sheet6.getRow(17);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M33");
		
		//연   금   소   득(지방소득세)
		row = sheet6.getRow(17);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33> 0,(ROUND(((원천징수이행상황신고서!M33*0.1)/10-0.5),0)*10),0)");
		
		//연   금   소   득(지방소득세)
		row = sheet6.getRow(17);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33> 0,(ROUND(((원천징수이행상황신고서!M33*0.1)/10-0.5),0)*10),0)");
		
		//연   금   소   득(지방소득세)
		row = sheet6.getRow(17);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M33> 0,(ROUND(((원천징수이행상황신고서!M33*0.1)/10-0.5),0)*10),0)");
		
		//기   타   소   득(인원)
		row = sheet6.getRow(18);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29 <= 0,0,원천징수이행상황신고서!E29)");
		
		//기   타   소   득(인원)
		row = sheet6.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29 <= 0,0,원천징수이행상황신고서!E29)");
		
		//기   타   소   득(인원)
		row = sheet6.getRow(18);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29 <= 0,0,원천징수이행상황신고서!E29)");
		
		//기   타   소   득(과세표준)
		row = sheet6.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M29");
		
		//기   타   소   득(과세표준)
		row = sheet6.getRow(18);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M29");
		
		//기   타   소   득(과세표준)
		row = sheet6.getRow(18);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M29");
		
		//기   타   소   득(지방소득세)
		row = sheet6.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29> 0,(ROUND(((원천징수이행상황신고서!M29*0.1)/10-0.5),0)*10),0)");
		
		//기   타   소   득(지방소득세)
		row = sheet6.getRow(18);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29> 0,(ROUND(((원천징수이행상황신고서!M29*0.1)/10-0.5),0)*10),0)");
		
		//기   타   소   득(지방소득세)
		row = sheet6.getRow(18);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M29> 0,(ROUND(((원천징수이행상황신고서!M29*0.1)/10-0.5),0)*10),0)");
		
		//퇴   직   소   득(인원)
		row = sheet6.getRow(19);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23 <= 0,0,원천징수이행상황신고서!E23)");
		
		//퇴   직   소   득(인원)
		row = sheet6.getRow(19);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23 <= 0,0,원천징수이행상황신고서!E23)");
		
		//퇴   직   소   득(인원)
		row = sheet6.getRow(19);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23 <= 0,0,원천징수이행상황신고서!E23)");
		
		//퇴   직   소   득(과세표준)
		row = sheet6.getRow(19);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M23");
		
		//퇴   직   소   득(과세표준)
		row = sheet6.getRow(19);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M23");
		
		//퇴   직   소   득(과세표준)
		row = sheet6.getRow(19);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M23");
		
		//퇴   직   소   득(지방소득세)
		row = sheet6.getRow(19);
		cell = row.getCell(I);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23> 0,(ROUND(((원천징수이행상황신고서!M23*0.1)/10-0.5),0)*10),0)");
		
		//퇴   직   소   득(지방소득세)
		row = sheet6.getRow(19);
		cell = row.getCell(V);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23> 0,(ROUND(((원천징수이행상황신고서!M23*0.1)/10-0.5),0)*10),0)");
		
		//퇴   직   소   득(지방소득세)
		row = sheet6.getRow(19);
		cell = row.getCell(AI);
		cell.setCellFormula("IF(원천징수이행상황신고서!M23> 0,(ROUND(((원천징수이행상황신고서!M23*0.1)/10-0.5),0)*10),0)");

		//「소득세법」 제119조(양도소득)에 따른 원천징수(인원)
		row = sheet6.getRow(22);
		cell = row.getCell(E);
		cell.setCellFormula("IF(원천징수이행상황신고서!M37 <= 0,0,원천징수이행상황신고서!E37)");
		
		//「소득세법」 제119조(양도소득)에 따른 원천징수(인원)
		row = sheet6.getRow(22);
		cell = row.getCell(R);
		cell.setCellFormula("IF(원천징수이행상황신고서!M37 <= 0,0,원천징수이행상황신고서!E37)");
		
		//「소득세법」 제119조(양도소득)에 따른 원천징수(인원)
		row = sheet6.getRow(22);
		cell = row.getCell(AE);
		cell.setCellFormula("IF(원천징수이행상황신고서!M37 <= 0,0,원천징수이행상황신고서!E37)");
		
		//「소득세법」 제119조(양도소득)에 따른 원천징수(과세표준)
		row = sheet6.getRow(22);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!M37");
		
		//「소득세법」 제119조(양도소득)에 따른 원천징수(과세표준)
		row = sheet6.getRow(22);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!M37");
		
		//「소득세법」 제119조(양도소득)에 따른 원천징수(과세표준)
		row = sheet6.getRow(22);
		cell = row.getCell(AF);
		cell.setCellFormula("원천징수이행상황신고서!M37");
						
		//계(인원)
		row = sheet6.getRow(24);
		cell = row.getCell(E);
		cell.setCellFormula("SUM(E14:E24)");
		
		//계(인원)
		row = sheet6.getRow(24);
		cell = row.getCell(R);
		cell.setCellFormula("SUM(R14:R24)");
		
		//계(인원)
		row = sheet6.getRow(24);
		cell = row.getCell(AE);
		cell.setCellFormula("SUM(AE14:AE24)");
		
		//계(과세표준)
		row = sheet6.getRow(24);
		cell = row.getCell(F);
		cell.setCellFormula("SUM(F14:H24)");
		
		//계(과세표준)
		row = sheet6.getRow(24);
		cell = row.getCell(S);
		cell.setCellFormula("SUM(S14:U24)");
		
		//계(과세표준)
		row = sheet6.getRow(24);
		cell = row.getCell(AF);
		cell.setCellFormula("SUM(AF14:AH24)");
		
		//계(지방소득세)
		row = sheet6.getRow(24);
		cell = row.getCell(I);
		cell.setCellFormula("SUM(I14:K24)");
		
		//계(지방소득세)
		row = sheet6.getRow(24);
		cell = row.getCell(V);
		cell.setCellFormula("SUM(V14:X24)");
		
		//계(지방소득세)
		row = sheet6.getRow(24);
		cell = row.getCell(AI);
		cell.setCellFormula("SUM(AI14:AK24)");
		
		//
		row = sheet6.getRow(27);
		cell = row.getCell(A);
		cell.setCellFormula("원천징수이행상황신고서!G49");
		
		row = sheet6.getRow(27);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!G49");
		
		row = sheet6.getRow(27);
		cell = row.getCell(S);
		cell.setCellFormula("원천징수이행상황신고서!G49");
		
		row = sheet6.getRow(27);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!G49");
		
		row = sheet6.getRow(29);
		cell = row.getCell(A);
		cell.setCellValue(LOCAL_TAX_GOV + "장 귀하");
		
		row = sheet6.getRow(29);
		cell = row.getCell(E);
		cell.setCellValue(LOCAL_TAX_GOV + "장 귀하");
		
		row = sheet6.getRow(28);
		cell = row.getCell(S);
		cell.setCellValue(LOCAL_TAX_GOV + "장 귀하");
		
		row = sheet6.getRow(29);
		cell = row.getCell(AA);
		cell.setCellValue(LOCAL_TAX_GOV + "장 귀하");		
		
		row = sheet6.getRow(36);
		cell = row.getCell(A);
		cell.setCellFormula("IF(LEN($I$25)>=11, LEFT(RIGHT($I$25, 11), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(B);
		cell.setCellFormula("IF(LEN($I$25)>=10, LEFT(RIGHT($I$25, 10), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(C);
		cell.setCellFormula("IF(LEN($I$25)>=9, LEFT(RIGHT($I$25, 9), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(D);
		cell.setCellFormula("IF(LEN($I$25)>=8, LEFT(RIGHT($I$25, 8), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(E);
		cell.setCellFormula("IF(LEN($I$25)>=7, LEFT(RIGHT($I$25, 7), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN($I$25)>=6, LEFT(RIGHT($I$25, 6), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN($I$25)>=5, LEFT(RIGHT($I$25, 5), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN($I$25)>=4, LEFT(RIGHT($I$25, 4), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN($I$25)>=3, LEFT(RIGHT($I$25, 3), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN($I$25)>=2, LEFT(RIGHT($I$25, 2), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(36);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN($I$25)>=1, LEFT(RIGHT($I$25, 1), 1), "  + "\"\"" + ")");
		
		row = sheet6.getRow(37);
		cell = row.getCell(A);		
		cell.setCellFormula("IF(A37=" + "\"9\"" + "," + "\"구\"" + ",IF(A37="+ "\"0\"" + "," + "\"\"" + ",A37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(B);		
		cell.setCellFormula("IF(B37=" + "\"9\"" + "," + "\"구\"" + ",IF(B37="+ "\"0\"" + "," + "\"\"" + ",B37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(C);		
		cell.setCellFormula("IF(C37=" + "\"9\"" + "," + "\"구\"" + ",IF(C37="+ "\"0\"" + "," + "\"\"" + ",C37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(D);		
		cell.setCellFormula("IF(D37=" + "\"9\"" + "," + "\"구\"" + ",IF(D37="+ "\"0\"" + "," + "\"\"" + ",D37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(E);		
		cell.setCellFormula("IF(E37=" + "\"9\"" + "," + "\"구\"" + ",IF(E37="+ "\"0\"" + "," + "\"\"" + ",E37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(F);		
		cell.setCellFormula("IF(F37=" + "\"9\"" + "," + "\"구\"" + ",IF(F37="+ "\"0\"" + "," + "\"\"" + ",F37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(G);		
		cell.setCellFormula("IF(G37=" + "\"9\"" + "," + "\"구\"" + ",IF(G37="+ "\"0\"" + "," + "\"\"" + ",G37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(H);		
		cell.setCellFormula("IF(H37=" + "\"9\"" + "," + "\"구\"" + ",IF(H37="+ "\"0\"" + "," + "\"\"" + ",H37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(I);		
		cell.setCellFormula("IF(I37=" + "\"9\"" + "," + "\"구\"" + ",IF(I37="+ "\"0\"" + "," + "\"\"" + ",I37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(J);		
		cell.setCellFormula("IF(J37=" + "\"9\"" + "," + "\"구\"" + ",IF(J37="+ "\"0\"" + "," + "\"\"" + ",J37))");
		
		row = sheet6.getRow(37);
		cell = row.getCell(K);		
		cell.setCellFormula("IF(K37=" + "\"9\"" + "," + "\"구\"" + ",IF(K37="+ "\"0\"" + "," + "\"\"" + ",K37))");

		row = sheet6.getRow(39);
		cell = row.getCell(A);		
		cell.setCellFormula("D38");
		
		row = sheet6.getRow(39);
		cell = row.getCell(B);		
		cell.setCellFormula("IF(B39=" + "\"\"" + "," + "\"\"" + ",IF(B39=" + "\"-\"" + ",B39,B39&B36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(C);		
		cell.setCellFormula("IF(C39=" + "\"\"" + "," + "\"\"" + ",IF(C39=" + "\"-\"" + ",C39,C39&C36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(D);		
		cell.setCellFormula("D38");
		
		row = sheet6.getRow(39);
		cell = row.getCell(E);		
		cell.setCellFormula("IF(E39=" + "\"\"" + "," + "\"\"" + ",IF(E39=" + "\"-\"" + ",E39,E39&E36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(F);		
		cell.setCellFormula("IF(F39=" + "\"\"" + "," + "\"\"" + ",IF(F39=" + "\"-\"" + ",F39,F39&F36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(G);		
		cell.setCellFormula("IF(G39=" + "\"\"" + "," + "\"\"" + ",IF(G39=" + "\"-\"" + ",G39,G39&G36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(H);		
		cell.setCellFormula("IF(H39=" + "\"\"" + "," + "\"\"" + ",IF(H39=" + "\"-\"" + ",H39,H39&H36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(I);		
		cell.setCellFormula("IF(I39=" + "\"\"" + "," + "\"\"" + ",IF(I39=" + "\"-\"" + ",I39,I39&I36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(J);		
		cell.setCellFormula("IF(J39=" + "\"\"" + "," + "\"\"" + ",IF(J39=" + "\"-\"" + ",J39,J39&J36))");
		
		row = sheet6.getRow(39);
		cell = row.getCell(K);		
		cell.setCellFormula("K39&K36");
		
		
		row = sheet6.getRow(38);
		cell = row.getCell(A);	
		cell.setCellFormula("IF(A38=" + "\"1\"" + "," + "\"일\"" + ",IF(A38=" + "\"2\"" + "," + "\"이\"" + ",IF(A38=" + "\"3\"" + "," + "\"삼\"" + ",IF(A38=" + "\"4\"" + "," + "\"사\"" + ",IF(A38=" + "\"5\"" + "," + "\"오\"" + ",IF(A38=" + "\"6\"" + "," + "\"육\"" + ",IF(A38=" + "\"7\"" + "," + "\"칠\"" + ",IF(A38=" + "\"8\"" + "," + "\"팔\"" + ",A38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(B);	
		cell.setCellFormula("IF(B38=" + "\"1\"" + "," + "\"일\"" + ",IF(B38=" + "\"2\"" + "," + "\"이\"" + ",IF(B38=" + "\"3\"" + "," + "\"삼\"" + ",IF(B38=" + "\"4\"" + "," + "\"사\"" + ",IF(B38=" + "\"5\"" + "," + "\"오\"" + ",IF(B38=" + "\"6\"" + "," + "\"육\"" + ",IF(B38=" + "\"7\"" + "," + "\"칠\"" + ",IF(B38=" + "\"8\"" + "," + "\"팔\"" + ",B38))))))))");

		row = sheet6.getRow(38);
		cell = row.getCell(C);	
		cell.setCellFormula("IF(C38=" + "\"1\"" + "," + "\"일\"" + ",IF(C38=" + "\"2\"" + "," + "\"이\"" + ",IF(C38=" + "\"3\"" + "," + "\"삼\"" + ",IF(C38=" + "\"4\"" + "," + "\"사\"" + ",IF(C38=" + "\"5\"" + "," + "\"오\"" + ",IF(C38=" + "\"6\"" + "," + "\"육\"" + ",IF(C38=" + "\"7\"" + "," + "\"칠\"" + ",IF(C38=" + "\"8\"" + "," + "\"팔\"" + ",C38))))))))");

		row = sheet6.getRow(38);
		cell = row.getCell(D);	
		cell.setCellFormula("IF(D38=" + "\"1\"" + "," + "\"일\"" + ",IF(D38=" + "\"2\"" + "," + "\"이\"" + ",IF(D38=" + "\"3\"" + "," + "\"삼\"" + ",IF(D38=" + "\"4\"" + "," + "\"사\"" + ",IF(D38=" + "\"5\"" + "," + "\"오\"" + ",IF(D38=" + "\"6\"" + "," + "\"육\"" + ",IF(D38=" + "\"7\"" + "," + "\"칠\"" + ",IF(D38=" + "\"8\"" + "," + "\"팔\"" + ",D38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(E);	
		cell.setCellFormula("IF(E38=" + "\"1\"" + "," + "\"일\"" + ",IF(E38=" + "\"2\"" + "," + "\"이\"" + ",IF(E38=" + "\"3\"" + "," + "\"삼\"" + ",IF(E38=" + "\"4\"" + "," + "\"사\"" + ",IF(E38=" + "\"5\"" + "," + "\"오\"" + ",IF(E38=" + "\"6\"" + "," + "\"육\"" + ",IF(E38=" + "\"7\"" + "," + "\"칠\"" + ",IF(E38=" + "\"8\"" + "," + "\"팔\"" + ",E38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(F);	
		cell.setCellFormula("IF(F38=" + "\"1\"" + "," + "\"일\"" + ",IF(F38=" + "\"2\"" + "," + "\"이\"" + ",IF(F38=" + "\"3\"" + "," + "\"삼\"" + ",IF(F38=" + "\"4\"" + "," + "\"사\"" + ",IF(F38=" + "\"5\"" + "," + "\"오\"" + ",IF(F38=" + "\"6\"" + "," + "\"육\"" + ",IF(F38=" + "\"7\"" + "," + "\"칠\"" + ",IF(F38=" + "\"8\"" + "," + "\"팔\"" + ",F38))))))))");

		row = sheet6.getRow(38);
		cell = row.getCell(G);	
		cell.setCellFormula("IF(G38=" + "\"1\"" + "," + "\"일\"" + ",IF(G38=" + "\"2\"" + "," + "\"이\"" + ",IF(G38=" + "\"3\"" + "," + "\"삼\"" + ",IF(G38=" + "\"4\"" + "," + "\"사\"" + ",IF(G38=" + "\"5\"" + "," + "\"오\"" + ",IF(G38=" + "\"6\"" + "," + "\"육\"" + ",IF(G38=" + "\"7\"" + "," + "\"칠\"" + ",IF(G38=" + "\"8\"" + "," + "\"팔\"" + ",G38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(H);	
		cell.setCellFormula("IF(H38=" + "\"1\"" + "," + "\"일\"" + ",IF(H38=" + "\"2\"" + "," + "\"이\"" + ",IF(H38=" + "\"3\"" + "," + "\"삼\"" + ",IF(H38=" + "\"4\"" + "," + "\"사\"" + ",IF(H38=" + "\"5\"" + "," + "\"오\"" + ",IF(H38=" + "\"6\"" + "," + "\"육\"" + ",IF(H38=" + "\"7\"" + "," + "\"칠\"" + ",IF(H38=" + "\"8\"" + "," + "\"팔\"" + ",H38))))))))");

		row = sheet6.getRow(38);
		cell = row.getCell(I);	
		cell.setCellFormula("IF(I38=" + "\"1\"" + "," + "\"일\"" + ",IF(I38=" + "\"2\"" + "," + "\"이\"" + ",IF(I38=" + "\"3\"" + "," + "\"삼\"" + ",IF(I38=" + "\"4\"" + "," + "\"사\"" + ",IF(I38=" + "\"5\"" + "," + "\"오\"" + ",IF(I38=" + "\"6\"" + "," + "\"육\"" + ",IF(I38=" + "\"7\"" + "," + "\"칠\"" + ",IF(I38=" + "\"8\"" + "," + "\"팔\"" + ",I38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(J);	
		cell.setCellFormula("IF(J38=" + "\"1\"" + "," + "\"일\"" + ",IF(J38=" + "\"2\"" + "," + "\"이\"" + ",IF(J38=" + "\"3\"" + "," + "\"삼\"" + ",IF(J38=" + "\"4\"" + "," + "\"사\"" + ",IF(J38=" + "\"5\"" + "," + "\"오\"" + ",IF(J38=" + "\"6\"" + "," + "\"육\"" + ",IF(J38=" + "\"7\"" + "," + "\"칠\"" + ",IF(J38=" + "\"8\"" + "," + "\"팔\"" + ",J38))))))))");
		
		row = sheet6.getRow(38);
		cell = row.getCell(K);	
		cell.setCellFormula("IF(K38=" + "\"1\"" + "," + "\"일\"" + ",IF(K38=" + "\"2\"" + "," + "\"이\"" + ",IF(K38=" + "\"3\"" + "," + "\"삼\"" + ",IF(K38=" + "\"4\"" + "," + "\"사\"" + ",IF(K38=" + "\"5\"" + "," + "\"오\"" + ",IF(K38=" + "\"6\"" + "," + "\"육\"" + ",IF(K38=" + "\"7\"" + "," + "\"칠\"" + ",IF(K38=" + "\"8\"" + "," + "\"팔\"" + ",K38))))))))");
		
		row = sheet6.getRow(11);
		cell = row.getCell(E);		
		cell.setCellFormula("TRIM(A40&B40&C40&D40&E40&F40&G40&H40&I40&J40&K40)");
		
		row = sheet6.getRow(11);
		cell = row.getCell(R);		
		cell.setCellFormula("TRIM(A40&B40&C40&D40&E40&F40&G40&H40&I40&J40&K40)");
		
		row = sheet6.getRow(11);
		cell = row.getCell(AE);		
		cell.setCellFormula("TRIM(A40&B40&C40&D40&E40&F40&G40&H40&I40&J40&K40)");
		
		return sheet6;
    }
        
    
    public Sheet makeExcelSheet7( Sheet sheet7, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트7 - 1면
        //----------------------------------------//

		//납부년월
		row = sheet7.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet7.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet7.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet7.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet7.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet7.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet7.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet7.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet7.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet7.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//법인원천세
		row = sheet7.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
		
		
		// 계
		row = sheet7.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet7.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet7.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트7 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet7.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet7.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet7.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet7.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet7.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet7.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet7.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet7.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet7.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet7.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//법인원천세
		row = sheet7.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
		
			
		// 계
		row = sheet7.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet7.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet7.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트7 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet7.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet7.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet7.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet7.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet7.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet7.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet7.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet7.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet7.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet7.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//퇴직소득세
		row = sheet7.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
				
		
		// 계
		row = sheet7.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 1), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 2), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 3), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 4), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 5), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 6), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 7), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 8), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 9), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 10), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 11), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 12), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$38)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$38, 13), 1), "  + "\"\"" + ")");
		
		row = sheet7.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet7.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet7.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet7;
    }
    
    
    public Sheet makeExcelSheet8( Sheet sheet8, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트8 - 1면
        //----------------------------------------//
		//납부년월
		row = sheet8.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet8.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet8.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet8.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet8.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet8.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet8.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet8.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet8.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet8.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//기타소득세
		row = sheet8.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet8.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet8.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet8.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트7 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet8.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet8.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet8.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet8.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet8.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet8.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet8.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet8.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet8.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet8.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//기타소득세
		row = sheet8.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");

		
		// 계
		row = sheet8.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet8.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet8.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트7 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet8.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet8.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet8.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet8.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet8.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet8.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet8.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet8.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet8.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet8.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//기타소득세
		row = sheet8.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");
		
		
		// 계
		row = sheet8.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 1), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 2), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 3), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 4), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 5), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 6), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 7), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 8), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 9), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 10), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 11), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 12), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$29)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$29, 13), 1), "  + "\"\"" + ")");
		
		row = sheet8.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet8.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet8.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet8;
    }
        
    
    public Sheet makeExcelSheet9( Sheet sheet9, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		

        //----------------------------------------//
        //시트9 - 1면
        //----------------------------------------//
		//납부년월
		row = sheet9.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet9.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet9.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet9.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet9.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet9.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet9.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet9.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet9.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet9.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//배당소득
		row = sheet9.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet9.getRow(16);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet9.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 13), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet9.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet9.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트9 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet9.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet9.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet9.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet9.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet9.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet9.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet9.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet9.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet9.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet9.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//배당소득
		row = sheet9.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet9.getRow(38);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet9.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 13), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet9.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet9.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트9 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet9.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet9.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet9.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet9.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet9.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet9.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet9.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet9.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet9.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet9.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//배당소득
		row = sheet9.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$35, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet9.getRow(60);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$35, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet9.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 1), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 2), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 3), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 4), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 5), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 6), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 7), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 8), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 9), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 10), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 11), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 12), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$35)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$35, 13), 1), "  + "\"\"" + ")");
		
		row = sheet9.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet9.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet9.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet9;
    }
    
        
    public Sheet makeExcelSheet10( Sheet sheet10, String SAFFER_TAX_NM, String SAFFER_BANK_NUM, String RECEIVE_DATE ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트10 - 1면
        //----------------------------------------//
		//납부년월
		row = sheet10.getRow(5);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet10.getRow(5);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet10.getRow(5);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet10.getRow(6);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet10.getRow(6);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet10.getRow(7);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet10.getRow(7);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet10.getRow(7);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet10.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet10.getRow(10);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//배당소득
		row = sheet10.getRow(13);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(13);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet10.getRow(16);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet10.getRow(18);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(18);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 13), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet10.getRow(16);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet10.getRow(16);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트10 - 2면
        //----------------------------------------//
		//납부년월
		row = sheet10.getRow(27);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet10.getRow(27);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet10.getRow(27);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet10.getRow(28);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet10.getRow(28);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet10.getRow(29);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet10.getRow(29);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet10.getRow(29);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet10.getRow(32);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet10.getRow(32);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//사업소득세
		row = sheet10.getRow(35);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(35);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet10.getRow(38);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(16);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet10.getRow(40);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(40);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 13), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(38);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet10.getRow(38);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet10.getRow(38);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		//----------------------------------------//
        //시트10 - 3면
        //----------------------------------------//
		//납부년월
		row = sheet10.getRow(49);
		cell = row.getCell(J);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)&MID(원천징수이행상황신고서!$G$49,6,4)");
		
		//세무서명
		row = sheet10.getRow(49);
		cell = row.getCell(G);
		cell.setCellValue(SAFFER_TAX_NM);
		
		//세무서 계좌번호
		row = sheet10.getRow(49);
		cell = row.getCell(AA);
		cell.setCellValue(SAFFER_BANK_NUM);
		
		//상호성명
		row = sheet10.getRow(50);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$E$6");
		
		//사업자 등록번호
		row = sheet10.getRow(50);
		cell = row.getCell(V);
		cell.setCellFormula("원천징수이행상황신고서!$E$8");
		
		//사업장(주소)
		row = sheet10.getRow(51);
		cell = row.getCell(G);
		cell.setCellFormula("원천징수이행상황신고서!$I$8");
		
		//전화번호
		row = sheet10.getRow(51);
		cell = row.getCell(Y);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//회계연도
		row = sheet10.getRow(51);
		cell = row.getCell(AG);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$G$49,5)");
		
		//귀속연도
		row = sheet10.getRow(54);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//귀속월
		row = sheet10.getRow(54);
		cell = row.getCell(M);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 7, 2)");
		
		//배당소득
		row = sheet10.getRow(57);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(57);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$M$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$M$26, 13), 1), "  + "\"\"" + ")");
		
		
		// 농어촌특별세
		row = sheet10.getRow(60);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$N$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$N$26, 13), 1), "  + "\"\"" + ")");
		
		// 계
		row = sheet10.getRow(62);
		cell = row.getCell(R);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=1, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 1), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(Q);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=2, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 2), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(P);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=3, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 3), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(O);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=4, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 4), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(N);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=5, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 5), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(M);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=6, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 6), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(L);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=7, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 7), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=8, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 8), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=9, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 9), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=10, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 10), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=11, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 11), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=12, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 12), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(62);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN(원천징수이행상황신고서!$R$26)>=13, LEFT(RIGHT(원천징수이행상황신고서!$R$26, 13), 1), "  + "\"\"" + ")");
		
		row = sheet10.getRow(60);
		cell = row.getCell(W);
		cell.setCellValue(RECEIVE_DATE.substring(0,4));
		
		row = sheet10.getRow(60);
		cell = row.getCell(Z);
		cell.setCellValue(RECEIVE_DATE.substring(4,6));
		
		row = sheet10.getRow(60);
		cell = row.getCell(AC);
		cell.setCellValue(RECEIVE_DATE.substring(6,8));
		
		return sheet10;
    }
        
    
    public Sheet makeExcelSheet11( Sheet sheet11, String DIV_NAME, String RECEIVE_DATE, String COMP_OWN_NO, String REPRE_NO, String LOCAL_TAX_GOV ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트11 - 1면
        //----------------------------------------//
		//사   업   장   명
		row = sheet11.getRow(6);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//사 업 장 소 재 지
		row = sheet11.getRow(7);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		//사업자등록번호
		row = sheet11.getRow(7);
		cell = row.getCell(M);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//법 인 명(상호명)
		row = sheet11.getRow(9);
		cell = row.getCell(F);
		cell.setCellValue(DIV_NAME);
		
		//법인등록번호
		row = sheet11.getRow(9);
		cell = row.getCell(M);
		cell.setCellValue(COMP_OWN_NO);
		
		//대 표 자 성 명
		row = sheet11.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//주민등록번호
		row = sheet11.getRow(10);
		cell = row.getCell(M);
		cell.setCellValue(REPRE_NO);
		
		//전 화 번 호
		row = sheet11.getRow(11);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!N8");
		
		//
		row = sheet11.getRow(12);
		cell = row.getCell(A);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//
		row = sheet11.getRow(12);
		cell = row.getCell(G);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");
		
		//
		row = sheet11.getRow(27);
		cell = row.getCell(I);
		cell.setCellValue(DIV_NAME);
		
		//
		row = sheet11.getRow(28);
		cell = row.getCell(A);
		cell.setCellValue(LOCAL_TAX_GOV);
		
		//
		row = sheet11.getRow(34);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		row = sheet11.getRow(34);
		cell = row.getCell(H);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");
		
		row = sheet11.getRow(35);
		cell = row.getCell(C);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		row = sheet11.getRow(35);
		cell = row.getCell(J);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		row = sheet11.getRow(36);
		cell = row.getCell(A);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		row = sheet11.getRow(36);
		cell = row.getCell(C);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");
		
		return sheet11;
    }
    
    
    public Sheet makeExcelSheet12( Sheet sheet12, String DIV_NAME, String RECEIVE_DATE, String COMP_OWN_NO, String REPRE_NO, String SUPP_DATE, String LOCAL_TAX_GOV ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트12 - 1면
        //----------------------------------------//
		//사   업   장   명
		row = sheet12.getRow(6);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//사 업 장 소 재 지
		row = sheet12.getRow(7);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		//사업자등록번호
		row = sheet12.getRow(7);
		cell = row.getCell(N);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//법 인 명(상호명)
		row = sheet12.getRow(9);
		cell = row.getCell(F);
		cell.setCellValue(DIV_NAME);
		
		//법인등록번호
		row = sheet12.getRow(9);
		cell = row.getCell(N);
		cell.setCellValue(COMP_OWN_NO);
		
		//대 표 자 성 명
		row = sheet12.getRow(10);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//주민등록번호
		row = sheet12.getRow(10);
		cell = row.getCell(N);
		cell.setCellValue(REPRE_NO);			
		
		
		//전 화 번 호
		row = sheet12.getRow(11);
		cell = row.getCell(F);
		cell.setCellFormula("원천징수이행상황신고서!N8");
		
		//
		row = sheet12.getRow(12);
		cell = row.getCell(A);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		//
		row = sheet12.getRow(12);
		cell = row.getCell(E);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");
		
		//지급일
		row = sheet12.getRow(12);
		cell = row.getCell(K);
		cell.setCellValue(SUPP_DATE.substring(0, 4) + "년 " + SUPP_DATE.substring(4, 6) + "월" + SUPP_DATE.substring(6, 8) + "일");
		
		//인 원
		row = sheet12.getRow(15);
		cell = row.getCell(A);
		cell.setCellFormula("원천징수이행상황신고서!Q11+원천징수이행상황신고서!R11");

		
		//계
		row = sheet12.getRow(15);
		cell = row.getCell(D);
		cell.setCellFormula("원천징수이행상황신고서!Q12");
		
		
		//비과세대상
		row = sheet12.getRow(15);
		cell = row.getCell(H);
		cell.setCellFormula("원천징수이행상황신고서!R4");
		
		//과세대상
		row = sheet12.getRow(15);
		cell = row.getCell(L);
		cell.setCellFormula("원천징수이행상황신고서!Q12-원천징수이행상황신고서!R4");
		
		//과세대상
		row = sheet12.getRow(17);
		cell = row.getCell(C);
		cell.setCellFormula("원천징수이행상황신고서!Q12-원천징수이행상황신고서!R4");
		
		//원 X 0.5%
		row = sheet12.getRow(17);
		cell = row.getCell(H);
		cell.setCellFormula("ROUND(C18*0.5%,-1)");
		
		//
		row = sheet12.getRow(17);
		cell = row.getCell(L);
		cell.setCellFormula("H18");
	
		//
		row = sheet12.getRow(20);
		cell = row.getCell(I);
		cell.setCellValue(DIV_NAME);
		
		//
		row = sheet12.getRow(21);
		cell = row.getCell(A);
		cell.setCellValue(LOCAL_TAX_GOV);
		
		row = sheet12.getRow(27);
		cell = row.getCell(F);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		row = sheet12.getRow(27);
		cell = row.getCell(H);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");		
		
		row = sheet12.getRow(28);
		cell = row.getCell(C);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		row = sheet12.getRow(28);
		cell = row.getCell(J);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		row = sheet12.getRow(29);
		cell = row.getCell(A);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!$N$3, 4)");
		
		row = sheet12.getRow(29);
		cell = row.getCell(C);
		cell.setCellFormula("MID(원천징수이행상황신고서!$N$3, 6, 3)");
		
		
		return sheet12;
    }
    
    
    public Sheet makeExcelSheet13( Sheet sheet13, String DIV_NAME, String RECEIVE_DATE, String COMP_OWN_NO, String SUPP_DATE, String LOCAL_TAX_GOV ) throws Exception {

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
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        Row  row = null;
        Cell cell = null;
		
		//----------------------------------------//
        //시트13 - 1면
        //----------------------------------------//        
        //사업장 소재지
		row = sheet13.getRow(2);
		cell = row.getCell(I);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!N4,4)" + "&\"년도\"");
		
		row = sheet13.getRow(2);
		cell = row.getCell(V);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!N4,4)" + "&\"년도\"");
		
		row = sheet13.getRow(2);
		cell = row.getCell(AI);
		cell.setCellFormula("LEFT(원천징수이행상황신고서!N4,4)" + "&\"년도\"");
		
		//사 업 장 소 재 지
		row = sheet13.getRow(3);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		row = sheet13.getRow(3);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		row = sheet13.getRow(3);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!I8");
		
		//법인상호명
		row = sheet13.getRow(4);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		row = sheet13.getRow(4);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		row = sheet13.getRow(4);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!E6");
		
		//법인(주민) 등록번호
		row = sheet13.getRow(5);
		cell = row.getCell(E);
		cell.setCellValue(COMP_OWN_NO);
		
		row = sheet13.getRow(5);
		cell = row.getCell(R);
		cell.setCellValue(COMP_OWN_NO);
		
		row = sheet13.getRow(5);
		cell = row.getCell(AE);
		cell.setCellValue(COMP_OWN_NO);
		
		//사업자 등록 번호
		row = sheet13.getRow(6);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		row = sheet13.getRow(6);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		row = sheet13.getRow(6);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!E8");
		
		//대  표  자  성  명
		row = sheet13.getRow(7);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		row = sheet13.getRow(7);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		row = sheet13.getRow(7);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!I6");
		
		//담당자 전화번호
		row = sheet13.getRow(8);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		row = sheet13.getRow(8);
		cell = row.getCell(R);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		row = sheet13.getRow(8);
		cell = row.getCell(AE);
		cell.setCellFormula("원천징수이행상황신고서!$N$8");
		
		//
		row = sheet13.getRow(9);
		cell = row.getCell(A);
		cell.setCellFormula("원천징수이행상황신고서!N3" + "&\"분 신고납부\"");
		
		//지급일
		row = sheet13.getRow(9);
		cell = row.getCell(H);
		cell.setCellValue(SUPP_DATE.substring(0, 4) + "년 " + SUPP_DATE.substring(4, 6) + "월" + SUPP_DATE.substring(6, 8) + "일");
		
		//
		row = sheet13.getRow(9);
		cell = row.getCell(N);
		cell.setCellFormula("원천징수이행상황신고서!N3" + "&\"분\"");
		
		//
		row = sheet13.getRow(9);
		cell = row.getCell(AA);
		cell.setCellFormula("원천징수이행상황신고서!N3" + "&\"분\"");
		
		
		//히든컬럼
		row = sheet13.getRow(34);
		cell = row.getCell(A);
		cell.setCellFormula("IF(LEN($I$15)>=11, LEFT(RIGHT($I$15, 11), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(B);
		cell.setCellFormula("IF(LEN($I$15)>=10, LEFT(RIGHT($I$15, 10), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(C);
		cell.setCellFormula("IF(LEN($I$15)>=9, LEFT(RIGHT($I$15, 9), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(D);
		cell.setCellFormula("IF(LEN($I$15)>=8, LEFT(RIGHT($I$15, 8), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(E);
		cell.setCellFormula("IF(LEN($I$15)>=7, LEFT(RIGHT($I$15, 7), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(F);
		cell.setCellFormula("IF(LEN($I$15)>=6, LEFT(RIGHT($I$15, 6), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(G);
		cell.setCellFormula("IF(LEN($I$15)>=5, LEFT(RIGHT($I$15, 5), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(H);
		cell.setCellFormula("IF(LEN($I$15)>=4, LEFT(RIGHT($I$15, 4), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(I);
		cell.setCellFormula("IF(LEN($I$15)>=3, LEFT(RIGHT($I$15, 3), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(J);
		cell.setCellFormula("IF(LEN($I$15)>=2, LEFT(RIGHT($I$15, 2), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(34);
		cell = row.getCell(K);
		cell.setCellFormula("IF(LEN($I$15)>=1, LEFT(RIGHT($I$15, 1), 1),"  + "\"\"" + ")");
		
		row = sheet13.getRow(35);
		cell = row.getCell(A);		
		cell.setCellFormula("IF(A35=" + "\"9\"" + "," + "\"구\"" + ",IF(A35="+ "\"0\"" + "," + "\"\"" + ",A35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(B);		
		cell.setCellFormula("IF(B35=" + "\"9\"" + "," + "\"구\"" + ",IF(B35="+ "\"0\"" + "," + "\"\"" + ",B35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(C);		
		cell.setCellFormula("IF(C35=" + "\"9\"" + "," + "\"구\"" + ",IF(C35="+ "\"0\"" + "," + "\"\"" + ",C35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(D);		
		cell.setCellFormula("IF(D35=" + "\"9\"" + "," + "\"구\"" + ",IF(D35="+ "\"0\"" + "," + "\"\"" + ",D35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(E);		
		cell.setCellFormula("IF(E35=" + "\"9\"" + "," + "\"구\"" + ",IF(E35="+ "\"0\"" + "," + "\"\"" + ",E35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(F);		
		cell.setCellFormula("IF(F35=" + "\"9\"" + "," + "\"구\"" + ",IF(F35="+ "\"0\"" + "," + "\"\"" + ",F35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(G);		
		cell.setCellFormula("IF(G35=" + "\"9\"" + "," + "\"구\"" + ",IF(G35="+ "\"0\"" + "," + "\"\"" + ",G35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(H);		
		cell.setCellFormula("IF(H35=" + "\"9\"" + "," + "\"구\"" + ",IF(H35="+ "\"0\"" + "," + "\"\"" + ",H35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(I);		
		cell.setCellFormula("IF(I35=" + "\"9\"" + "," + "\"구\"" + ",IF(I35="+ "\"0\"" + "," + "\"\"" + ",I35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(J);		
		cell.setCellFormula("IF(J35=" + "\"9\"" + "," + "\"구\"" + ",IF(J35="+ "\"0\"" + "," + "\"\"" + ",J35))");
		
		row = sheet13.getRow(35);
		cell = row.getCell(K);		
		cell.setCellFormula("IF(K35=" + "\"9\"" + "," + "\"구\"" + ",IF(K35="+ "\"0\"" + "," + "\"\"" + ",K35))");
		
		row = sheet13.getRow(36);
		cell = row.getCell(A);	
		cell.setCellFormula("IF(A36=" + "\"1\"" + "," + "\"일\"" + ",IF(A36=" + "\"2\"" + "," + "\"이\"" + ",IF(A36=" + "\"3\"" + "," + "\"삼\"" + ",IF(A36=" + "\"4\"" + "," + "\"사\"" + ",IF(A36=" + "\"5\"" + "," + "\"오\"" + ",IF(A36=" + "\"6\"" + "," + "\"육\"" + ",IF(A36=" + "\"7\"" + "," + "\"칠\"" + ",IF(A36=" + "\"8\"" + "," + "\"팔\"" + ",A36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(B);	
		cell.setCellFormula("IF(B36=" + "\"1\"" + "," + "\"일\"" + ",IF(B36=" + "\"2\"" + "," + "\"이\"" + ",IF(B36=" + "\"3\"" + "," + "\"삼\"" + ",IF(B36=" + "\"4\"" + "," + "\"사\"" + ",IF(B36=" + "\"5\"" + "," + "\"오\"" + ",IF(B36=" + "\"6\"" + "," + "\"육\"" + ",IF(B36=" + "\"7\"" + "," + "\"칠\"" + ",IF(B36=" + "\"8\"" + "," + "\"팔\"" + ",B36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(C);	
		cell.setCellFormula("IF(C36=" + "\"1\"" + "," + "\"일\"" + ",IF(C36=" + "\"2\"" + "," + "\"이\"" + ",IF(C36=" + "\"3\"" + "," + "\"삼\"" + ",IF(C36=" + "\"4\"" + "," + "\"사\"" + ",IF(C36=" + "\"5\"" + "," + "\"오\"" + ",IF(C36=" + "\"6\"" + "," + "\"육\"" + ",IF(C36=" + "\"7\"" + "," + "\"칠\"" + ",IF(C36=" + "\"8\"" + "," + "\"팔\"" + ",C36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(D);	
		cell.setCellFormula("IF(D36=" + "\"1\"" + "," + "\"일\"" + ",IF(D36=" + "\"2\"" + "," + "\"이\"" + ",IF(D36=" + "\"3\"" + "," + "\"삼\"" + ",IF(D36=" + "\"4\"" + "," + "\"사\"" + ",IF(D36=" + "\"5\"" + "," + "\"오\"" + ",IF(D36=" + "\"6\"" + "," + "\"육\"" + ",IF(D36=" + "\"7\"" + "," + "\"칠\"" + ",IF(D36=" + "\"8\"" + "," + "\"팔\"" + ",D36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(E);	
		cell.setCellFormula("IF(E36=" + "\"1\"" + "," + "\"일\"" + ",IF(E36=" + "\"2\"" + "," + "\"이\"" + ",IF(E36=" + "\"3\"" + "," + "\"삼\"" + ",IF(E36=" + "\"4\"" + "," + "\"사\"" + ",IF(E36=" + "\"5\"" + "," + "\"오\"" + ",IF(E36=" + "\"6\"" + "," + "\"육\"" + ",IF(E36=" + "\"7\"" + "," + "\"칠\"" + ",IF(E36=" + "\"8\"" + "," + "\"팔\"" + ",E36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(F);	
		cell.setCellFormula("IF(F36=" + "\"1\"" + "," + "\"일\"" + ",IF(F36=" + "\"2\"" + "," + "\"이\"" + ",IF(F36=" + "\"3\"" + "," + "\"삼\"" + ",IF(F36=" + "\"4\"" + "," + "\"사\"" + ",IF(F36=" + "\"5\"" + "," + "\"오\"" + ",IF(F36=" + "\"6\"" + "," + "\"육\"" + ",IF(F36=" + "\"7\"" + "," + "\"칠\"" + ",IF(F36=" + "\"8\"" + "," + "\"팔\"" + ",F36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(G);	
		cell.setCellFormula("IF(G36=" + "\"1\"" + "," + "\"일\"" + ",IF(G36=" + "\"2\"" + "," + "\"이\"" + ",IF(G36=" + "\"3\"" + "," + "\"삼\"" + ",IF(G36=" + "\"4\"" + "," + "\"사\"" + ",IF(G36=" + "\"5\"" + "," + "\"오\"" + ",IF(G36=" + "\"6\"" + "," + "\"육\"" + ",IF(G36=" + "\"7\"" + "," + "\"칠\"" + ",IF(G36=" + "\"8\"" + "," + "\"팔\"" + ",G36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(H);	
		cell.setCellFormula("IF(H36=" + "\"1\"" + "," + "\"일\"" + ",IF(H36=" + "\"2\"" + "," + "\"이\"" + ",IF(H36=" + "\"3\"" + "," + "\"삼\"" + ",IF(H36=" + "\"4\"" + "," + "\"사\"" + ",IF(H36=" + "\"5\"" + "," + "\"오\"" + ",IF(H36=" + "\"6\"" + "," + "\"육\"" + ",IF(H36=" + "\"7\"" + "," + "\"칠\"" + ",IF(H36=" + "\"8\"" + "," + "\"팔\"" + ",H36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(I);	
		cell.setCellFormula("IF(I36=" + "\"1\"" + "," + "\"일\"" + ",IF(I36=" + "\"2\"" + "," + "\"이\"" + ",IF(I36=" + "\"3\"" + "," + "\"삼\"" + ",IF(I36=" + "\"4\"" + "," + "\"사\"" + ",IF(I36=" + "\"5\"" + "," + "\"오\"" + ",IF(I36=" + "\"6\"" + "," + "\"육\"" + ",IF(I36=" + "\"7\"" + "," + "\"칠\"" + ",IF(I36=" + "\"8\"" + "," + "\"팔\"" + ",I36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(J);	
		cell.setCellFormula("IF(J36=" + "\"1\"" + "," + "\"일\"" + ",IF(J36=" + "\"2\"" + "," + "\"이\"" + ",IF(J36=" + "\"3\"" + "," + "\"삼\"" + ",IF(J36=" + "\"4\"" + "," + "\"사\"" + ",IF(J36=" + "\"5\"" + "," + "\"오\"" + ",IF(J36=" + "\"6\"" + "," + "\"육\"" + ",IF(J36=" + "\"7\"" + "," + "\"칠\"" + ",IF(J36=" + "\"8\"" + "," + "\"팔\"" + ",J36))))))))");

		row = sheet13.getRow(36);
		cell = row.getCell(K);	
		cell.setCellFormula("IF(K36=" + "\"1\"" + "," + "\"일\"" + ",IF(K36=" + "\"2\"" + "," + "\"이\"" + ",IF(K36=" + "\"3\"" + "," + "\"삼\"" + ",IF(K36=" + "\"4\"" + "," + "\"사\"" + ",IF(K36=" + "\"5\"" + "," + "\"오\"" + ",IF(K36=" + "\"6\"" + "," + "\"육\"" + ",IF(K36=" + "\"7\"" + "," + "\"칠\"" + ",IF(K36=" + "\"8\"" + "," + "\"팔\"" + ",K36))))))))");

		row = sheet13.getRow(37);
		cell = row.getCell(A);
		cell.setCellFormula("D36");

		row = sheet13.getRow(37);
		cell = row.getCell(B);
		cell.setCellFormula("IF(B37=" + "\"\"" + "," + "\"\"" + ",IF(B37=" + "\"-\"" + ",B37,B37&B34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(C);
		cell.setCellFormula("IF(C37=" + "\"\"" + "," + "\"\"" + ",IF(C37=" + "\"-\"" + ",C37,C37&C34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(D);
		cell.setCellFormula("IF(D37=" + "\"\"" + "," + "\"\"" + ",IF(D37=" + "\"-\"" + ",D37,D37&D34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(E);
		cell.setCellFormula("IF(E37=" + "\"\"" + "," + "\"\"" + ",IF(E37=" + "\"-\"" + ",E37,E37&E34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(F);
		cell.setCellFormula("IF(F37=" + "\"\"" + "," + "\"\"" + ",IF(F37=" + "\"-\"" + ",F37,F37&F34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(G);
		cell.setCellFormula("IF(G37=" + "\"\"" + "," + "\"\"" + ",IF(G37=" + "\"-\"" + ",G37,G37&G34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(H);
		cell.setCellFormula("IF(H37=" + "\"\"" + "," + "\"\"" + ",IF(H37=" + "\"-\"" + ",H37,H37&H34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(I);
		cell.setCellFormula("IF(I37=" + "\"\"" + "," + "\"\"" + ",IF(I37=" + "\"-\"" + ",I37,I37&I34))");
		
		row = sheet13.getRow(37);
		cell = row.getCell(J);
		cell.setCellFormula("IF(J37=" + "\"\"" + "," + "\"\"" + ",IF(J37=" + "\"-\"" + ",J37,J37&J34))");

		row = sheet13.getRow(37);
		cell = row.getCell(K);
		cell.setCellFormula("K37&K34");	
		
		//인 원
		row = sheet13.getRow(12);
		cell = row.getCell(C);
		cell.setCellFormula("원천징수이행상황신고서!Q11+원천징수이행상황신고서!R11");
		
		//비과세대상
		row = sheet13.getRow(12);
		cell = row.getCell(E);
		cell.setCellFormula("원천징수이행상황신고서!R4");
		
		//과세대상
		row = sheet13.getRow(12);
		cell = row.getCell(H);
		cell.setCellFormula("원천징수이행상황신고서!Q12-원천징수이행상황신고서!R4");
		
		//지방소득세(일금)
		row = sheet13.getRow(14);
		cell = row.getCell(D);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(14);
		cell = row.getCell(I);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//계(일금)
		row = sheet13.getRow(15);
		cell = row.getCell(D);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(15);
		cell = row.getCell(I);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//지방소득세(일금)
		row = sheet13.getRow(11);
		cell = row.getCell(Q);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(11);
		cell = row.getCell(V);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//계(일금)
		row = sheet13.getRow(12);
		cell = row.getCell(Q);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(12);
		cell = row.getCell(V);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//지방소득세(일금)
		row = sheet13.getRow(11);
		cell = row.getCell(AD);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(11);
		cell = row.getCell(AI);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//계(일금)
		row = sheet13.getRow(12);
		cell = row.getCell(AD);
		cell.setCellFormula("TRIM(A38&B38&C38&D38&E38&F38&G38&H38&I38&J38&K38)");
		
		row = sheet13.getRow(12);
		cell = row.getCell(AI);
		cell.setCellFormula("ROUND(H13*0.5%,-1)");
		
		//신고인
		row = sheet13.getRow(18);
		cell = row.getCell(D);
		cell.setCellFormula("원천징수이행상황신고서!E6");		

		row = sheet13.getRow(16);
		cell = row.getCell(Q);
		cell.setCellFormula("원천징수이행상황신고서!G49");		

		row = sheet13.getRow(16);
		cell = row.getCell(AD);
		cell.setCellFormula("원천징수이행상황신고서!G49");
		
		row = sheet13.getRow(20);
		cell = row.getCell(A);
		cell.setCellValue(LOCAL_TAX_GOV + "장 귀하");		
		
		return sheet13;
    }
    

    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row).getCell(cell).setCellValue(value);
    }

}