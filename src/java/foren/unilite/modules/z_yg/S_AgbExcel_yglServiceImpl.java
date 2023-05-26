package foren.unilite.modules.z_yg;

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

@Service( "s_agbExcel_ygService" )
public class S_AgbExcel_yglServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());

    @Resource( name = "s_agb221rkr_ygService" )
    private S_Agb221rkr_ygServiceImpl gba200skrvService;

    public Workbook makeExcel( Map param ) throws Exception {
        //FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "gba210skrv-201711.xlsx"));
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "agb221rkr.xlsx"));

        //Get the workbook instance for XLS file
        Workbook workbook = new XSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);

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

        int row1 = 0;
        int row2 = 0;
        int row3 = 0;
        int row4 = 0;
        int row5 = 0;
        int row6 = 0;
        int row7 = 0;


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
        font2.setFontHeightInPoints((short)10);


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
        style03.setBorderBottom(CellStyle.BORDER_THIN);
        style03.setBorderLeft(CellStyle.BORDER_THIN);
        style03.setBorderRight(CellStyle.BORDER_THIN);
        style03.setBorderTop(CellStyle.BORDER_THIN);
        style03.setDataFormat(format.getFormat("#,##0"));
        style03.setFont(font2);


        // Style 04 : 분문
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        style04.setBorderLeft(CellStyle.BORDER_THIN);
        style04.setBorderRight(CellStyle.BORDER_THIN);
        style04.setBorderTop(CellStyle.BORDER_THIN);
        style04.setFont(font2);

        // Style 05 : 합계
        CellStyle style05 = workbook.createCellStyle();
        style05.setBorderBottom(CellStyle.BORDER_THIN);
        style05.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        style05.setBorderTop(CellStyle.BORDER_THIN);
        style05.setAlignment(CellStyle.ALIGN_CENTER);
        style05.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style05.setFont(font2);



        List<Map> list = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectInfo", param);

        for(int i = 0; i < list.size(); i++) {
        	sheet1.getRow(2).getCell(A).setCellValue(ObjUtils.getSafeString(list.get(i).get("SUBMIT_DATE")));

        }
        //DecimalFormat df = new DecimalFormat("#.00");



        //1. 은행예금
        List<Map> list1 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList1", param);

        headerRow = sheet1.createRow(3);
    	headerRow.createCell(A).setCellValue("은행예금");
    	headerRow.createCell(B).setCellValue("은행예금");
    	headerRow.createCell(C).setCellValue("은행예금");
    	headerRow.createCell(D).setCellValue("은행예금");
    	headerRow.createCell(E).setCellValue("은행예금");
    	headerRow.createCell(F).setCellValue("은행예금");
    	headerRow.createCell(G).setCellValue("은행예금");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)3, (short)3, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(4);
    	headerRow.createCell(A).setCellValue("은행");
    	headerRow.createCell(B).setCellValue("은행");
    	headerRow.createCell(C).setCellValue("은행");
    	headerRow.createCell(D).setCellValue("전일잔액");
    	headerRow.createCell(E).setCellValue("예입");
    	headerRow.createCell(F).setCellValue("인출");
    	headerRow.createCell(G).setCellValue("금일잔액");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)4, (short)4, (int)0, (short)2));

        double sum1 = 0;
        double sum2 = 0;
        double sum3 = 0;
        double sum4 = 0;

        for(int i = 0; i < list1.size(); i++) {

        	headerRow = sheet1.createRow(5+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list1.get(i).get("BANK_NAME")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("BANK_NAME")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list1.get(i).get("BANK_NAME")));
        	headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list1.get(i).get("CLAST_AMT")));
        	headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list1.get(i).get("D_DR_AMT")));
        	headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list1.get(i).get("D_CR_AMT")));
        	headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list1.get(i).get("CTD_AMT")));

        	headerRow.getCell(A).setCellStyle(style03);  //본문글자
        	headerRow.getCell(B).setCellStyle(style03);  //본문글자
        	headerRow.getCell(C).setCellStyle(style03);  //본문글자
        	headerRow.getCell(D).setCellStyle(style03);  // 숫자
        	headerRow.getCell(E).setCellStyle(style03);  // 숫자
        	headerRow.getCell(F).setCellStyle(style03);  // 숫자
        	headerRow.getCell(G).setCellStyle(style03);  // 숫자

        	sheet1.addMergedRegion(new CellRangeAddress((int)5+i, (short)5+i, (int)0, (short)2));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )

        	row1 = i;

        	double amt1 = ObjUtils.parseDouble(list1.get(i).get("CLAST_AMT"));
        	double amt2 = ObjUtils.parseDouble(list1.get(i).get("D_DR_AMT"));
        	double amt3 = ObjUtils.parseDouble(list1.get(i).get("D_CR_AMT"));
        	double amt4 = ObjUtils.parseDouble(list1.get(i).get("CTD_AMT"));


        	sum1 += amt1;
        	sum2 += amt2;
        	sum3 += amt3;
        	sum4 += amt4;

        }

        headerRow = sheet1.createRow(5+row1+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue(sum1);
    	headerRow.createCell(E).setCellValue(sum2);
    	headerRow.createCell(F).setCellValue(sum3);
    	headerRow.createCell(G).setCellValue(sum4);

    	headerRow.getCell(A).setCellStyle(style05);  //합계
    	headerRow.getCell(B).setCellStyle(style05);  //합계
    	headerRow.getCell(C).setCellStyle(style05);  //합계
    	headerRow.getCell(D).setCellStyle(style03);  // 숫자
    	headerRow.getCell(E).setCellStyle(style03);  // 숫자
    	headerRow.getCell(F).setCellStyle(style03);  // 숫자
    	headerRow.getCell(G).setCellStyle(style03);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)5+row1+1, (short)5+row1+1, (int)0, (short)2));


    	row1 = 5+row1+1;


        //2. 통장입금
        List<Map> list2 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList2", param);

        double sum21 = 0;

        headerRow = sheet1.createRow(row1+1);
    	headerRow.createCell(A).setCellValue("통장입금");
    	headerRow.createCell(B).setCellValue("통장입금");
    	headerRow.createCell(C).setCellValue("통장입금");
    	headerRow.createCell(D).setCellValue("통장입금");
    	headerRow.createCell(E).setCellValue("통장입금");
    	headerRow.createCell(F).setCellValue("통장입금");
    	headerRow.createCell(G).setCellValue("통장입금");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row1+1, (short)row1+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row1+2);
    	headerRow.createCell(A).setCellValue("내용");
    	headerRow.createCell(B).setCellValue("내용");
    	headerRow.createCell(C).setCellValue("내용");
    	headerRow.createCell(D).setCellValue("내용");
    	headerRow.createCell(E).setCellValue("금액");
    	headerRow.createCell(F).setCellValue("비고");
    	headerRow.createCell(G).setCellValue("비고");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row1+2, (short)row1+2, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row1+2, (short)row1+2, (int)5, (short)6));

    	row1 = row1+3;

        for(int i = 0; i < list2.size(); i++) {

        	headerRow = sheet1.createRow(row1+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list2.get(i).get("REMARK")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list2.get(i).get("REMARK")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list2.get(i).get("REMARK")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list2.get(i).get("REMARK")));
        	headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("AMT")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list2.get(i).get("CUSTOM_NAME")));
        	headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list2.get(i).get("CUSTOM_NAME")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style04);  //본문글자
        	headerRow.getCell(E).setCellStyle(style03);  // 숫자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style04);  //본문글자


        	sheet1.addMergedRegion(new CellRangeAddress((int)row1+i, (short)row1+i, (int)0, (short)3));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row1+i, (short)row1+i, (int)5, (short)6));

        	row2 = i;

        	double amt21 = ObjUtils.parseDouble(list2.get(i).get("AMT"));

        	sum21 += amt21;

        }

        headerRow = sheet1.createRow(row1+row2+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("합계");

    	headerRow.createCell(E).setCellValue(sum21);
    	headerRow.createCell(F).setCellValue("");
    	headerRow.createCell(G).setCellValue("");

    	headerRow.getCell(A).setCellStyle(style05);  //합계
    	headerRow.getCell(B).setCellStyle(style05);  //합계
    	headerRow.getCell(C).setCellStyle(style05);  //합계
    	headerRow.getCell(D).setCellStyle(style05);  //합계
    	headerRow.getCell(E).setCellStyle(style03);  // 숫자
    	headerRow.getCell(F).setCellStyle(style05);  // 숫자
    	headerRow.getCell(G).setCellStyle(style05);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)row1+row2+1, (short)row1+row2+1, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row1+row2+1, (short)row1+row2+1, (int)5, (short)6));

        row2 = row1+row2+1;


        //3. 통장출금
        List<Map> list3 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList3", param);

        double sum31 = 0;

        headerRow = sheet1.createRow(row2+1);
    	headerRow.createCell(A).setCellValue("통장출금");
    	headerRow.createCell(B).setCellValue("통장출금");
    	headerRow.createCell(C).setCellValue("통장출금");
    	headerRow.createCell(D).setCellValue("통장출금");
    	headerRow.createCell(E).setCellValue("통장출금");
    	headerRow.createCell(F).setCellValue("통장출금");
    	headerRow.createCell(G).setCellValue("통장출금");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row2+1, (short)row2+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row2+2);
    	headerRow.createCell(A).setCellValue("내용");
    	headerRow.createCell(B).setCellValue("내용");
    	headerRow.createCell(C).setCellValue("내용");
    	headerRow.createCell(D).setCellValue("내용");
    	headerRow.createCell(E).setCellValue("금액");
    	headerRow.createCell(F).setCellValue("비고");
    	headerRow.createCell(G).setCellValue("비고");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row2+2, (short)row2+2, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row2+2, (short)row2+2, (int)5, (short)6));

    	row2 = row2+3;

        for(int i = 0; i < list3.size(); i++) {

        	headerRow = sheet1.createRow(row2+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list3.get(i).get("REMARK")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list3.get(i).get("REMARK")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list3.get(i).get("REMARK")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list3.get(i).get("REMARK")));
        	headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list3.get(i).get("AMT")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list3.get(i).get("CUSTOM_NAME")));
        	headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list3.get(i).get("CUSTOM_NAME")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style04);  //본문글자
        	headerRow.getCell(E).setCellStyle(style03);  // 숫자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style04);  //본문글자

        	sheet1.addMergedRegion(new CellRangeAddress((int)row2+i, (short)row2+i, (int)0, (short)3));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row2+i, (short)row2+i, (int)5, (short)6));

        	row3 = i;

        	double amt31 = ObjUtils.parseDouble(list3.get(i).get("AMT"));

        	sum31 += amt31;

        }

        headerRow = sheet1.createRow(row2+row3+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("합계");
    	headerRow.createCell(E).setCellValue(sum31);
    	headerRow.createCell(F).setCellValue("");
    	headerRow.createCell(G).setCellValue("");

    	headerRow.getCell(A).setCellStyle(style05);  // 합계
    	headerRow.getCell(B).setCellStyle(style05);  // 합계
    	headerRow.getCell(C).setCellStyle(style05);  // 합계
    	headerRow.getCell(D).setCellStyle(style05);  // 합계
    	headerRow.getCell(E).setCellStyle(style03);  // 숫자
    	headerRow.getCell(F).setCellStyle(style05);  // 합계
    	headerRow.getCell(G).setCellStyle(style05);  // 합계

    	sheet1.addMergedRegion(new CellRangeAddress((int)row2+row3+1, (short)row2+row3+1, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row2+row3+1, (short)row2+row3+1, (int)5, (short)6));

        row3 = row2+row3+1;



        //4. 받을어음
        List<Map> list4 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList4", param);

        double sum41 = 0;

        headerRow = sheet1.createRow(row3+1);
    	headerRow.createCell(A).setCellValue("받을어음");
    	headerRow.createCell(B).setCellValue("받을어음");
    	headerRow.createCell(C).setCellValue("받을어음");
    	headerRow.createCell(D).setCellValue("받을어음");
    	headerRow.createCell(E).setCellValue("받을어음");
    	headerRow.createCell(F).setCellValue("받을어음");
    	headerRow.createCell(G).setCellValue("받을어음");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);

    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row3+1, (short)row3+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row3+2);
    	headerRow.createCell(A).setCellValue("상호");
    	headerRow.createCell(B).setCellValue("상호");
    	headerRow.createCell(C).setCellValue("상호");
    	headerRow.createCell(D).setCellValue("상호");
    	headerRow.createCell(E).setCellValue("내용");
    	headerRow.createCell(F).setCellValue("내용");
    	headerRow.createCell(G).setCellValue("금액");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row3+2, (short)row3+2, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3+2, (short)row3+2, (int)4, (short)5));

    	row3 = row3+3;

        for(int i = 0; i < list4.size(); i++) {

        	headerRow = sheet1.createRow(row3+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list4.get(i).get("REMARK")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list4.get(i).get("REMARK")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list4.get(i).get("REMARK")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list4.get(i).get("REMARK")));
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list4.get(i).get("AC_DATA1")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list4.get(i).get("AC_DATA1")));
        	headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list4.get(i).get("AMT_I")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style04);  //본문글자
        	headerRow.getCell(E).setCellStyle(style04);  //본문글자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style03);  // 숫자

        	sheet1.addMergedRegion(new CellRangeAddress((int)row3+i, (short)row3+i, (int)0, (short)3));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row3+i, (short)row3+i, (int)4, (short)5));

        	row4 = i;

        	double amt41 = ObjUtils.parseDouble(list4.get(i).get("AMT_I"));

        	sum41 += amt41;

        }

        headerRow = sheet1.createRow(row3+row4+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("합계");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	headerRow.createCell(G).setCellValue(sum41);

    	headerRow.getCell(A).setCellStyle(style05);  //합계
    	headerRow.getCell(B).setCellStyle(style05);  //합계
    	headerRow.getCell(C).setCellStyle(style05);  //합계
    	headerRow.getCell(D).setCellStyle(style05);  //합계
    	headerRow.getCell(E).setCellStyle(style05);  //합계
    	headerRow.getCell(F).setCellStyle(style05);  //합계
    	headerRow.getCell(G).setCellStyle(style03);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)row3+row4+1, (short)row3+row4+1, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3+row4+1, (short)row3+row4+1, (int)4, (short)5));

        row4 = row3+row4+1;





        //5. 지급어음
        List<Map> list5 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList5", param);

        double sum51 = 0;

        headerRow = sheet1.createRow(row4+1);
    	headerRow.createCell(A).setCellValue("지급어음");
    	headerRow.createCell(B).setCellValue("지급어음");
    	headerRow.createCell(C).setCellValue("지급어음");
    	headerRow.createCell(D).setCellValue("지급어음");
    	headerRow.createCell(E).setCellValue("지급어음");
    	headerRow.createCell(F).setCellValue("지급어음");
    	headerRow.createCell(G).setCellValue("지급어음");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row4+1, (short)row4+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row4+2);
    	headerRow.createCell(A).setCellValue("상호");
    	headerRow.createCell(B).setCellValue("상호");
    	headerRow.createCell(C).setCellValue("상호");
    	headerRow.createCell(D).setCellValue("상호");
    	headerRow.createCell(E).setCellValue("내용");
    	headerRow.createCell(F).setCellValue("내용");
    	headerRow.createCell(G).setCellValue("금액");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row4+2, (short)row4+2, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row4+2, (short)row4+2, (int)4, (short)5));

    	row4 = row4+3;

        for(int i = 0; i < list5.size(); i++) {

        	headerRow = sheet1.createRow(row4+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list5.get(i).get("REMARK")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list5.get(i).get("REMARK")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list5.get(i).get("REMARK")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list5.get(i).get("REMARK")));
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list5.get(i).get("AC_DATA1")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list5.get(i).get("AC_DATA1")));
        	headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list5.get(i).get("AMT_I")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style04);  //본문글자
        	headerRow.getCell(E).setCellStyle(style04);  //본문글자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style03);  // 숫자

        	sheet1.addMergedRegion(new CellRangeAddress((int)row4+i, (short)row4+i, (int)0, (short)3));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row4+i, (short)row4+i, (int)4, (short)5));

        	row5 = i;

        	double amt51 = ObjUtils.parseDouble(list5.get(i).get("AMT_I"));

        	sum51 += amt51;

        }

        headerRow = sheet1.createRow(row4+row5+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("합계");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	headerRow.createCell(G).setCellValue(sum51);

    	headerRow.getCell(A).setCellStyle(style05);  //합계
    	headerRow.getCell(B).setCellStyle(style05);  //합계
    	headerRow.getCell(C).setCellStyle(style05);  //합계
    	headerRow.getCell(D).setCellStyle(style05);  //합계
    	headerRow.getCell(E).setCellStyle(style05);  //합계
    	headerRow.getCell(F).setCellStyle(style05);  //합계
    	headerRow.getCell(G).setCellStyle(style03);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)row4+row5+1, (short)row4+row5+1, (int)0, (short)3));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row4+row5+1, (short)row4+row5+1, (int)4, (short)5));

        row5 = row4+row5+1;






        //6. 세금계산서제출
        List<Map> list6 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList6", param);

        double sum61 = 0;

        headerRow = sheet1.createRow(row5+1);
    	headerRow.createCell(A).setCellValue("세금계산서제출");
    	headerRow.createCell(B).setCellValue("세금계산서제출");
    	headerRow.createCell(C).setCellValue("세금계산서제출");
    	headerRow.createCell(D).setCellValue("세금계산서제출");
    	headerRow.createCell(E).setCellValue("세금계산서제출");
    	headerRow.createCell(F).setCellValue("세금계산서제출");
    	headerRow.createCell(G).setCellValue("세금계산서제출");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row5+1, (short)row5+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row5+2);
    	headerRow.createCell(A).setCellValue("상호");
    	headerRow.createCell(B).setCellValue("상호");
    	headerRow.createCell(C).setCellValue("상호");
    	headerRow.createCell(D).setCellValue("계약번호");
    	headerRow.createCell(E).setCellValue("계약번호");
    	headerRow.createCell(F).setCellValue("제출일");
    	headerRow.createCell(G).setCellValue("금액");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row5+2, (short)row5+2, (int)0, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row5+2, (short)row5+2, (int)3, (short)4));

    	row5 = row5+3;

        for(int i = 0; i < list6.size(); i++) {

        	headerRow = sheet1.createRow(row5+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list6.get(i).get("CM")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list6.get(i).get("CM")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list6.get(i).get("CM")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list6.get(i).get("PN")));
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list6.get(i).get("PN")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list6.get(i).get("BD")));
        	headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list6.get(i).get("AMT")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style04);  //본문글자
        	headerRow.getCell(E).setCellStyle(style04);  //본문글자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style03);  // 숫자

        	sheet1.addMergedRegion(new CellRangeAddress((int)row5+i, (short)row5+i, (int)0, (short)2));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row5+i, (short)row5+i, (int)3, (short)4));

        	row6 = i;

        	double amt61 = ObjUtils.parseDouble(list6.get(i).get("AMT"));

        	sum61 += amt61;

        }

        headerRow = sheet1.createRow(row5+row6+1);
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	headerRow.createCell(G).setCellValue(sum61);

    	headerRow.getCell(A).setCellStyle(style05);  //합계
    	headerRow.getCell(B).setCellStyle(style05);  //합계
    	headerRow.getCell(C).setCellStyle(style05);  //합계
    	headerRow.getCell(D).setCellStyle(style05);  //합계
    	headerRow.getCell(E).setCellStyle(style05);  //합계
    	headerRow.getCell(F).setCellStyle(style05);  //합계
    	headerRow.getCell(G).setCellStyle(style03);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)row5+row6+1, (short)row5+row6+1, (int)0, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row5+row6+1, (short)row5+row6+1, (int)3, (short)4));

    	row6 = row5+row6+1;




        //7. 현금출납
        List<Map> list7 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList7", param);

        double sum71 = 0;
        double sum72 = 0;

        headerRow = sheet1.createRow(row6+1);
    	headerRow.createCell(A).setCellValue("현금출납");
    	headerRow.createCell(B).setCellValue("현금출납");
    	headerRow.createCell(C).setCellValue("현금출납");
    	headerRow.createCell(D).setCellValue("현금출납");
    	headerRow.createCell(E).setCellValue("현금출납");
    	headerRow.createCell(F).setCellValue("현금출납");
    	headerRow.createCell(G).setCellValue("현금출납");
    	headerRow.getCell(A).setCellStyle(style01);
    	headerRow.getCell(B).setCellStyle(style01);
    	headerRow.getCell(C).setCellStyle(style01);
    	headerRow.getCell(D).setCellStyle(style01);
    	headerRow.getCell(E).setCellStyle(style01);
    	headerRow.getCell(F).setCellStyle(style01);
    	headerRow.getCell(G).setCellStyle(style01);
    	headerRow.setHeight((short)500);

    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+1, (short)row6+1, (int)0, (short)6));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )


    	headerRow = sheet1.createRow(row6+2);
    	headerRow.createCell(A).setCellValue("금일발생");
    	headerRow.createCell(B).setCellValue("금일발생");
    	headerRow.createCell(C).setCellValue("금일발생");
    	headerRow.createCell(D).setCellValue("입금액");
    	headerRow.createCell(E).setCellValue("출금액");
    	headerRow.createCell(F).setCellValue("비고");
    	headerRow.createCell(G).setCellValue("비고");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+2, (short)row6+2, (int)0, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+2, (short)row6+2, (int)5, (short)6));

    	row6 = row6+3;

        for(int i = 0; i < list7.size(); i++) {

        	headerRow = sheet1.createRow(row6+i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list7.get(i).get("ACCNT_NAME")));
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list7.get(i).get("ACCNT_NAME")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list7.get(i).get("ACCNT_NAME")));
        	headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list7.get(i).get("DR_AMT")));
        	headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list7.get(i).get("CR_AMT")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list7.get(i).get("REMARK")));
        	headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list7.get(i).get("REMARK")));

        	headerRow.getCell(A).setCellStyle(style04);  //본문글자
        	headerRow.getCell(B).setCellStyle(style04);  //본문글자
        	headerRow.getCell(C).setCellStyle(style04);  //본문글자
        	headerRow.getCell(D).setCellStyle(style03);  // 숫자
        	headerRow.getCell(E).setCellStyle(style03);  // 숫자
        	headerRow.getCell(F).setCellStyle(style04);  //본문글자
        	headerRow.getCell(G).setCellStyle(style04);  //본문글자

        	sheet1.addMergedRegion(new CellRangeAddress((int)row6+i, (short)row6+i, (int)0, (short)2));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row6+i, (short)row6+i, (int)5, (short)6));

        	row7 = i;

        	double amt71 = ObjUtils.parseDouble(list7.get(i).get("DR_AMT"));
        	double amt72 = ObjUtils.parseDouble(list7.get(i).get("CR_AMT"));

        	sum71 += amt71;
        	sum72 += amt72;

        }

        headerRow = sheet1.createRow(row6+row7+1);
    	headerRow.createCell(A).setCellValue("금일발생");
    	headerRow.createCell(B).setCellValue("금일발생");
    	headerRow.createCell(C).setCellValue("금일발생");
    	headerRow.createCell(D).setCellValue("금일총입금액");
    	headerRow.createCell(E).setCellValue("금일총출금액");
    	headerRow.createCell(F).setCellValue("금일잔액");
    	headerRow.createCell(G).setCellValue("금일잔액");

    	headerRow.getCell(A).setCellStyle(style02);  //노란색
    	headerRow.getCell(B).setCellStyle(style02);  //노란색
    	headerRow.getCell(C).setCellStyle(style02);  //노란색
    	headerRow.getCell(D).setCellStyle(style02);  //노란색
    	headerRow.getCell(E).setCellStyle(style02);  //노란색
    	headerRow.getCell(F).setCellStyle(style02);  //노란색
    	headerRow.getCell(G).setCellStyle(style02);  //노란색

    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+row7+1, (short)row6+row7+1, (int)0, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+row7+1, (short)row6+row7+1, (int)5, (short)6));

    	headerRow = sheet1.createRow(row6+row7+2);
    	headerRow.createCell(A).setCellValue(0);
    	headerRow.createCell(B).setCellValue(0);
    	headerRow.createCell(C).setCellValue(0);
    	headerRow.createCell(D).setCellValue(sum71);
    	headerRow.createCell(E).setCellValue(sum72);
    	headerRow.createCell(F).setCellValue(0);
    	headerRow.createCell(G).setCellValue(0);

    	headerRow.getCell(A).setCellStyle(style03);  // 숫자
    	headerRow.getCell(B).setCellStyle(style03);  // 숫자
    	headerRow.getCell(C).setCellStyle(style03);  // 숫자
    	headerRow.getCell(D).setCellStyle(style03);  // 숫자
    	headerRow.getCell(E).setCellStyle(style03);  // 숫자
    	headerRow.getCell(F).setCellStyle(style03);  // 숫자
    	headerRow.getCell(G).setCellStyle(style03);  // 숫자

    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+row7+2, (short)row6+row7+2, (int)0, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row6+row7+2, (short)row6+row7+2, (int)5, (short)6));


        List<Map> list8 = super.commonDao.list("s_agb221rkr_ygServiceImpl.selectList8", param);

        for(int i = 0; i < list8.size(); i++) {

        	headerRow.createCell(A).setCellValue(ObjUtils.parseDouble(list8.get(i).get("LSD_AMT")));

        	headerRow.getCell(A).setCellStyle(style03);  // 숫자

        	double amt81 = ObjUtils.parseDouble(list8.get(i).get("LSD_AMT"));

        	double amt82 = amt81 + sum71 - sum72;


        	headerRow.createCell(F).setCellValue(amt82);

        	headerRow.getCell(F).setCellStyle(style03);  // 숫자


        }











        return workbook;









    }

    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row).getCell(cell).setCellValue(value);
    }

}
