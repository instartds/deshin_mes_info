package foren.unilite.modules.base.gba;

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

@Service( "gbaExcelService" )
public class GbaExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "gba200skrvService" )
    private Gba200skrvServiceImpl gba200skrvService;
    
    public Workbook makeExcel( Map param ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "gba210skrv-201711.xlsx"));
        
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
        
        // 본문
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)10);
        
        // 타이틀 및 소계
        Font font1 = workbook.createFont();
        font1.setFontHeightInPoints((short)10);
        font1.setBoldweight((short)Font.BOLDWEIGHT_BOLD);
        
     // 본문
        Font font3 = workbook.createFont();
        font3.setFontHeightInPoints((short)9);
        
        // Style 00 : 타이틀
        CellStyle style00 = workbook.createCellStyle();
        style00.setBorderBottom(CellStyle.BORDER_THIN);
        style00.setBorderLeft(CellStyle.BORDER_THIN);
        style00.setBorderRight(CellStyle.BORDER_THIN);
        style00.setBorderTop(CellStyle.BORDER_THIN);
        style00.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style00.setFont(font1);
        
        // Style 01 : 본문
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_THIN);
        style01.setBorderLeft(CellStyle.BORDER_THIN);
        style01.setBorderRight(CellStyle.BORDER_THIN);
        style01.setBorderTop(CellStyle.BORDER_THIN);
        style01.setFont(font);
        
        // Style 02 : 숫자
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_THIN);
        style02.setBorderLeft(CellStyle.BORDER_THIN);
        style02.setBorderRight(CellStyle.BORDER_THIN);
        style02.setBorderTop(CellStyle.BORDER_THIN);
        style02.setDataFormat(format.getFormat("#,##0"));
        style02.setFont(font);
        
        // Style 03 : 비율
        CellStyle style03 = workbook.createCellStyle();
        style03.setBorderBottom(CellStyle.BORDER_THIN);
        style03.setBorderLeft(CellStyle.BORDER_THIN);
        style03.setBorderRight(CellStyle.BORDER_THIN);
        style03.setBorderTop(CellStyle.BORDER_THIN);
        style03.setAlignment(CellStyle.ALIGN_CENTER);
        style03.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style03.setFont(font);
        
        // Style 04 : 소계문자
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        style04.setBorderLeft(CellStyle.BORDER_THIN);
        style04.setBorderRight(CellStyle.BORDER_THIN);
        style04.setBorderTop(CellStyle.BORDER_THIN);
        style04.setAlignment(CellStyle.ALIGN_CENTER);
        style04.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style04.setFont(font1);
        
        // Style 05 : 소계숫자
        CellStyle style05 = workbook.createCellStyle();
        style05.setBorderBottom(CellStyle.BORDER_THIN);
        style05.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        style05.setBorderTop(CellStyle.BORDER_THIN);
        style05.setDataFormat(format.getFormat("#,##0"));
        style05.setFont(font1);
        
        
       // Style 06 : 합계타이틀(노란색)
        CellStyle style06 = workbook.createCellStyle();
        style06.setBorderBottom(CellStyle.BORDER_THIN);
        style06.setBorderLeft(CellStyle.BORDER_THIN);
        style06.setBorderRight(CellStyle.BORDER_THIN);
        style06.setBorderTop(CellStyle.BORDER_THIN);
        style06.setAlignment(CellStyle.ALIGN_CENTER);
        style06.setDataFormat(format.getFormat("#,##0"));
        style06.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style06.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style06.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style06.setFont(font1);
        
        // Style 07 : 합계숫자(노란색)
        CellStyle style07 = workbook.createCellStyle();
        style07.setBorderBottom(CellStyle.BORDER_THIN);
        style07.setBorderLeft(CellStyle.BORDER_THIN);
        style07.setBorderRight(CellStyle.BORDER_THIN);
        style07.setBorderTop(CellStyle.BORDER_THIN);
        style07.setDataFormat(format.getFormat("#,##0"));
        style07.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style07.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style07.setFont(font1);
        
        // Style 08 : 소계문자
        CellStyle style08 = workbook.createCellStyle();
        style08.setBorderBottom(CellStyle.BORDER_THIN);
        style08.setBorderLeft(CellStyle.BORDER_THIN);
        style08.setBorderRight(CellStyle.BORDER_THIN);
        style08.setBorderTop(CellStyle.BORDER_THIN);
        style08.setAlignment(CellStyle.ALIGN_CENTER);
        style08.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style08.setFont(font3);
        
        // Style 09 : 비고
        CellStyle style09 = workbook.createCellStyle();
        /*style09.setBorderBottom(CellStyle.BORDER_THIN);
        style09.setBorderLeft(CellStyle.BORDER_THIN);
        style09.setBorderRight(CellStyle.BORDER_THIN);
        style09.setBorderTop(CellStyle.BORDER_THIN);
        style09.setAlignment(CellStyle.ALIGN_CENTER);
        style09.setVerticalAlignment(CellStyle.VERTICAL_CENTER);*/
        style09.setFont(font1);

        String remark = "";
        
        Map dataMap = (Map) super.commonDao.select("gba200skrvServiceImpl.selectInfo", param);
        if (!ObjUtils.isEmpty(dataMap)) {
	        
        	sheet1.getRow(3).getCell(K).setCellValue("작성일 : " + dataMap.get("PRINT_DATE").toString());
        	
        	sheet1.getRow(4).getCell(B).setCellValue(dataMap.get("PJT_CODE").toString());
	        sheet1.getRow(4).getCell(E).setCellValue("수주일 / " + dataMap.get("FR_DATE").toString());
	        
	        sheet1.getRow(5).getCell(B).setCellValue(dataMap.get("PJT_NAME").toString());
	        sheet1.getRow(5).getCell(E).setCellValue("납   기 / " + dataMap.get("TO_DATE").toString());
	        
	        remark = dataMap.get("REMARK").toString();
        }
        
        DecimalFormat df = new DecimalFormat("#,###");
        DecimalFormat df2 = new DecimalFormat("#.00");
        
        //1. 직접재료비
        List<Map> list1 = super.commonDao.list("gba200skrvServiceImpl.selectList1", param);
        
        double orderSum1 = 0;
        double budgSum1 = 0;
        
        for(int i = 0; i < list1.size(); i++) {
        	
        	headerRow = sheet1.createRow(9 + i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_CODE")));
        	
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_NAME")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_NAME")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_NAME")));
        	
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SPEC")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SPEC")));
        	
        	headerRow.createCell(G).setCellValue(ObjUtils.parseInt(list1.get(i).get("ORDER_UNIT_Q")));
        	headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list1.get(i).get("ORDER_P")));
        	headerRow.createCell(I).setCellValue(ObjUtils.parseDouble(list1.get(i).get("ORDER_O")));
        	headerRow.createCell(J).setCellValue(ObjUtils.parseDouble(list1.get(i).get("BUDGET_UNIT_O")));
        	headerRow.createCell(K).setCellValue(ObjUtils.parseDouble(list1.get(i).get("BUDGET_O")));
        	
        	headerRow.getCell(A).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(B).setCellStyle(style01);  //본문
        	headerRow.getCell(C).setCellStyle(style01);  //본문
        	headerRow.getCell(D).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(E).setCellStyle(style01);  //본문
        	headerRow.getCell(F).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(G).setCellStyle(style02);  //숫자
        	headerRow.getCell(H).setCellStyle(style02);  //숫자
        	headerRow.getCell(I).setCellStyle(style02);  //숫자
        	headerRow.getCell(J).setCellStyle(style02);  //숫자
        	headerRow.getCell(K).setCellStyle(style02);  //숫자

        	
        	sheet1.addMergedRegion(new CellRangeAddress((int)9 + i, (short)9 + i, (int)1, (short)3));
        	sheet1.addMergedRegion(new CellRangeAddress((int)9 + i, (short)9 + i, (int)4, (short)5));
        	        	
        	double orderO = ObjUtils.parseDouble(list1.get(i).get("ORDER_O"));
        	double budgetO = ObjUtils.parseDouble(list1.get(i).get("BUDGET_O"));
        	
        	String rate = df.format((orderO / budgetO * 100)) + "%";
        	headerRow.createCell(L).setCellValue(rate);
        	headerRow.createCell(M).setCellValue(rate);
        	
        	headerRow.getCell(L).setCellStyle(style03);  //비율
        	headerRow.getCell(M).setCellStyle(style03);  //비율
        	
        	sheet1.addMergedRegion(new CellRangeAddress((int)9 + i, (short)9 + i, (int)11, (short)12));
        	
        	orderSum1 += orderO;
        	budgSum1 += budgetO;
        	
        	row1 = i;
        }
        
        headerRow = sheet1.createRow(9 + 1 + row1);
        
    	headerRow.createCell(A).setCellValue("소계");
    	headerRow.createCell(B).setCellValue("소계");
    	headerRow.createCell(C).setCellValue("소계");
    	headerRow.createCell(D).setCellValue("소계");
    	headerRow.createCell(E).setCellValue("소계");
    	headerRow.createCell(F).setCellValue("소계");
    	
    	headerRow.createCell(G).setCellValue("");
    	headerRow.createCell(H).setCellValue("");
    	headerRow.createCell(I).setCellValue(orderSum1);
    	headerRow.createCell(J).setCellValue("");
    	headerRow.createCell(K).setCellValue(budgSum1);
//    	headerRow.createCell(L).setCellValue("");
//    	headerRow.createCell(M).setCellValue("");
    	
    	String rate1 = df.format((orderSum1 / budgSum1 * 100)) + "%";
    	headerRow.createCell(L).setCellValue(rate1);
    	headerRow.createCell(M).setCellValue(rate1);
    	
    	
    	headerRow.getCell(A).setCellStyle(style04);  //소계
    	headerRow.getCell(B).setCellStyle(style04);  //소계
    	headerRow.getCell(C).setCellStyle(style04);  //소계
    	headerRow.getCell(D).setCellStyle(style04);  //소계
    	headerRow.getCell(E).setCellStyle(style04);  //소계
    	headerRow.getCell(F).setCellStyle(style04);  //소계
    	
    	headerRow.getCell(G).setCellStyle(style05);  //소계
    	headerRow.getCell(H).setCellStyle(style05);  //소계
    	headerRow.getCell(I).setCellStyle(style05);  //소계
    	headerRow.getCell(J).setCellStyle(style05);  //소계
    	headerRow.getCell(K).setCellStyle(style05);  //소계

    	headerRow.getCell(L).setCellStyle(style03);  //비율
    	headerRow.getCell(M).setCellStyle(style03);  //비율
    
    	sheet1.addMergedRegion(new CellRangeAddress((int)9 + 1 + row1, (short)9 + 1 + row1, (int)0, (short)5));
    	sheet1.addMergedRegion(new CellRangeAddress((int)9 + 1 + row1, (short)9 + 1 + row1, (int)11, (short)12));
    	
    	
    	row1 = 9 + 1 + row1;
    	
        
        //2. 직접경비
        List<Map> list2 = super.commonDao.list("gba200skrvServiceImpl.selectList2", param);
        
        double orderSum2 = 0;
        double budgSum2 = 0;
        
        
        headerRow = sheet1.createRow(row1 + 1);
        
    	headerRow.createCell(A).setCellValue("2. 직접경비");
    	headerRow.createCell(B).setCellValue("2. 직접경비");
    	headerRow.createCell(C).setCellValue("2. 직접경비");
    	headerRow.createCell(D).setCellValue("2. 직접경비");
    	headerRow.createCell(E).setCellValue("2. 직접경비");
    	headerRow.createCell(F).setCellValue("2. 직접경비");
    	headerRow.createCell(G).setCellValue("2. 직접경비");
    	headerRow.createCell(H).setCellValue("2. 직접경비");
    	headerRow.createCell(I).setCellValue("2. 직접경비");
    	headerRow.createCell(J).setCellValue("2. 직접경비");
    	headerRow.createCell(K).setCellValue("2. 직접경비");
    	headerRow.createCell(L).setCellValue("2. 직접경비");
    	headerRow.createCell(M).setCellValue("2. 직접경비");
    	
    	headerRow.getCell(A).setCellStyle(style00);  //타이틀
    	headerRow.getCell(B).setCellStyle(style00);  //타이틀
    	headerRow.getCell(C).setCellStyle(style00);  //타이틀
    	headerRow.getCell(D).setCellStyle(style00);  //타이틀
    	headerRow.getCell(E).setCellStyle(style00);  //타이틀
    	headerRow.getCell(F).setCellStyle(style00);  //타이틀
    	headerRow.getCell(G).setCellStyle(style00);  //타이틀
    	headerRow.getCell(H).setCellStyle(style00);  //타이틀
    	headerRow.getCell(I).setCellStyle(style00);  //타이틀
    	headerRow.getCell(J).setCellStyle(style00);  //타이틀
    	headerRow.getCell(K).setCellStyle(style00);  //타이틀
    	headerRow.getCell(L).setCellStyle(style00);  //타이틀
    	headerRow.getCell(M).setCellStyle(style00);  //타이틀
    	
    	headerRow.setHeight((short)350);
    	
    	sheet1.addMergedRegion(new CellRangeAddress((int)row1 + 1, (short)row1 + 1, (int)0, (short)12));
        
        
        
        for(int i = 0; i < list2.size(); i++) {
        	/*JSONArray jsonArray = JSONArray.fromObject(ObjUtils.getSafeString(param.get("BUDG_DATA")));
        	List<Map> budgList = (List) JSONArray.toCollection(jsonArray, Map.class); */
        	
        	/*double budgetO = 0;
        	double budgetP = 0;*/
        	
        	/*if(budgList.size() > 0) {
        		for(Map budg : budgList) {

            		if(ObjUtils.getSafeString(list2.get(i).get("ITEM_CODE")).equals(budg.get("ITEM_CODE").toString())) {
            			budgetO = ObjUtils.parseDouble(budg.get("BUDGET_O"));
            			budgetP = ObjUtils.parseDouble(budg.get("BUDGET_UNIT_O"));
            		}
            	}
        	}*/
        	
        	headerRow = sheet1.createRow(row1 + 2 + i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_CODE")));
        	
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_NAME")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_NAME")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_NAME")));
        	
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list2.get(i).get("SPEC")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list2.get(i).get("SPEC")));
        	
        	headerRow.createCell(G).setCellValue(ObjUtils.parseInt(list2.get(i).get("ORDER_UNIT_Q")));
        	headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("ORDER_P")));
        	headerRow.createCell(I).setCellValue(ObjUtils.parseDouble(list2.get(i).get("ORDER_O")));
/*        	headerRow.createCell(J).setCellValue(budgetP == 0 ? "" : String.valueOf(budgetP));
        	headerRow.createCell(K).setCellValue(budgetO == 0 ? "" : String.valueOf(budgetO));*/
        	
        	headerRow.createCell(J).setCellValue(ObjUtils.parseDouble(list2.get(i).get("BUDGET_UNIT_O")));
        	headerRow.createCell(K).setCellValue(ObjUtils.parseDouble(list2.get(i).get("BUDGET_O")));
        	
        	headerRow.getCell(A).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(B).setCellStyle(style01);  //본문
        	headerRow.getCell(C).setCellStyle(style01);  //본문
        	headerRow.getCell(D).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(E).setCellStyle(style01);  //본문
        	headerRow.getCell(F).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(G).setCellStyle(style02);  //숫자
        	headerRow.getCell(H).setCellStyle(style02);  //숫자
        	headerRow.getCell(I).setCellStyle(style02);  //숫자
        	headerRow.getCell(J).setCellStyle(style02);  //숫자
        	headerRow.getCell(K).setCellStyle(style02);  //숫자

        	
        	sheet1.addMergedRegion(new CellRangeAddress((int)row1 + 2 + i, (short)row1 + 2 + i, (int)1, (short)5));

        	
        	
        	double orderO = ObjUtils.parseDouble(list2.get(i).get("ORDER_O"));
        	double budgetO = ObjUtils.parseDouble(list2.get(i).get("BUDGET_O"));

        	String rate = "";
        	if(budgetO > 0) {
        		rate = df2.format((orderO / budgetO * 100)) + "%";
        	}
        	
        	
        	headerRow.createCell(L).setCellValue(rate);
        	headerRow.createCell(M).setCellValue(rate);
        	
        	headerRow.getCell(L).setCellStyle(style03);  //비율
        	headerRow.getCell(M).setCellStyle(style03);  //비율
        	
        	sheet1.addMergedRegion(new CellRangeAddress((int)row1 + 2 + i, (short)row1 + 2 + i, (int)11, (short)12));
        	
        	
        	headerRow.getCell(A).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(B).setCellStyle(style01);  //본문
        	headerRow.getCell(C).setCellStyle(style01);  //본문
        	headerRow.getCell(D).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(E).setCellStyle(style01);  //본문
        	headerRow.getCell(F).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(G).setCellStyle(style02);  //숫자
        	headerRow.getCell(H).setCellStyle(style02);  //숫자
        	headerRow.getCell(I).setCellStyle(style02);  //숫자
        	headerRow.getCell(J).setCellStyle(style02);  //숫자
        	headerRow.getCell(K).setCellStyle(style02);  //숫자
        	
        	orderSum2 += orderO;
        	budgSum2 += budgetO;
        	
        	row2 = i;
        	
        	/*sheet1.getRow(18+i).getCell(A).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_CODE")));
        	sheet1.getRow(18+i).getCell(B).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ITEM_NAME")));
        	sheet1.getRow(18+i).getCell(E).setCellValue(ObjUtils.getSafeString(list2.get(i).get("SPEC")));
        	sheet1.getRow(18+i).getCell(G).setCellValue(ObjUtils.parseInt(list2.get(i).get("ORDER_UNIT_Q")));
        	sheet1.getRow(18+i).getCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("ORDER_P")));
        	sheet1.getRow(18+i).getCell(I).setCellValue(ObjUtils.parseDouble(list2.get(i).get("ORDER_O")));
        	sheet1.getRow(18+i).getCell(J).setCellValue(budgetP == 0 ? "" : String.valueOf(budgetP));
        	sheet1.getRow(18+i).getCell(K).setCellValue(budgetO == 0 ? "" : String.valueOf(budgetO));
        	double orderO = ObjUtils.parseDouble(list2.get(i).get("ORDER_O"));

        	String rate = "";
        	if(budgetO > 0) {
        		rate = df.format((orderO / budgetO * 100)) + "%";
        	}
        	
        	sheet1.getRow(18+i).getCell(L).setCellValue(rate);
        	orderSum2 += orderO;
        	budgSum2 += budgetO;*/
        }
        
        headerRow = sheet1.createRow(row1 + row2 + 2 + 1);
        
    	headerRow.createCell(A).setCellValue("소계");
    	headerRow.createCell(B).setCellValue("소계");
    	headerRow.createCell(C).setCellValue("소계");
    	headerRow.createCell(D).setCellValue("소계");
    	headerRow.createCell(E).setCellValue("소계");
    	headerRow.createCell(F).setCellValue("소계");
    	
    	headerRow.createCell(G).setCellValue("");
    	headerRow.createCell(H).setCellValue("");
    	headerRow.createCell(I).setCellValue(orderSum2);
    	headerRow.createCell(J).setCellValue("");
    	headerRow.createCell(K).setCellValue(budgSum2);
//    	headerRow.createCell(L).setCellValue("");
//    	headerRow.createCell(M).setCellValue("");
    	
    	String rate2 = df.format((orderSum2 / budgSum2 * 100)) + "%";
    	headerRow.createCell(L).setCellValue(rate2);
    	headerRow.createCell(M).setCellValue(rate2);
    	
    	headerRow.getCell(A).setCellStyle(style04);  //소계
    	headerRow.getCell(B).setCellStyle(style04);  //소계
    	headerRow.getCell(C).setCellStyle(style04);  //소계
    	headerRow.getCell(D).setCellStyle(style04);  //소계
    	headerRow.getCell(E).setCellStyle(style04);  //소계
    	headerRow.getCell(F).setCellStyle(style04);  //소계
    	
    	headerRow.getCell(G).setCellStyle(style05);  //소계
    	headerRow.getCell(H).setCellStyle(style05);  //소계
    	headerRow.getCell(I).setCellStyle(style05);  //소계
    	headerRow.getCell(J).setCellStyle(style05);  //소계
    	headerRow.getCell(K).setCellStyle(style05);  //소계
//    	headerRow.getCell(L).setCellStyle(style05);  //소계
//    	headerRow.getCell(M).setCellStyle(style05);  //소계
    	
    	headerRow.getCell(L).setCellStyle(style03);  //비율
    	headerRow.getCell(M).setCellStyle(style03);  //비율
    
    	sheet1.addMergedRegion(new CellRangeAddress((int)row1 + row2 + 2 + 1, (short)row1 + row2 + 2 + 1, (int)0, (short)5));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row1 + row2 + 2 + 1, (short)row1 + row2 + 2 + 1, (int)11, (short)12));
    	
    	row2 = row1 + row2 + 2 + 1;
       
        
        
        //3. 기타경비 배부액
        List<Map> list3 = super.commonDao.list("gba200skrvServiceImpl.selectList3", param);
        
        double budgSum3 = 0;
        double orderSum3 = 0;
        
        headerRow = sheet1.createRow(row2 + 1);
        
    	headerRow.createCell(A).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(B).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(C).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(D).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(E).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(F).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(G).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(H).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(I).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(J).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(K).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(L).setCellValue("3. 기타경비 배부액");
    	headerRow.createCell(M).setCellValue("3. 기타경비 배부액");
    	
    	headerRow.getCell(A).setCellStyle(style00);  //타이틀
    	headerRow.getCell(B).setCellStyle(style00);  //타이틀
    	headerRow.getCell(C).setCellStyle(style00);  //타이틀
    	headerRow.getCell(D).setCellStyle(style00);  //타이틀
    	headerRow.getCell(E).setCellStyle(style00);  //타이틀
    	headerRow.getCell(F).setCellStyle(style00);  //타이틀
    	headerRow.getCell(G).setCellStyle(style00);  //타이틀
    	headerRow.getCell(H).setCellStyle(style00);  //타이틀
    	headerRow.getCell(I).setCellStyle(style00);  //타이틀
    	headerRow.getCell(J).setCellStyle(style00);  //타이틀
    	headerRow.getCell(K).setCellStyle(style00);  //타이틀
    	headerRow.getCell(L).setCellStyle(style00);  //타이틀
    	headerRow.getCell(M).setCellStyle(style00);  //타이틀
    	
    	headerRow.setHeight((short)350);
    	
    	sheet1.addMergedRegion(new CellRangeAddress((int)row2 + 1, (short)row2 + 1, (int)0, (short)12));
        
        for(int i = 0; i < list3.size(); i++) {
        	
        	headerRow = sheet1.createRow(row2 + 2 + i);
        	headerRow.createCell(A).setCellValue(ObjUtils.getSafeString(list3.get(i).get("ITEM_CODE")));
        	
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list3.get(i).get("ITEM_NAME")));
        	headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list3.get(i).get("ITEM_NAME")));
        	headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list3.get(i).get("ITEM_NAME")));
        	
        	headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list3.get(i).get("SPEC")));
        	headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list3.get(i).get("SPEC")));
        	
        	headerRow.createCell(G).setCellValue(ObjUtils.parseInt(list3.get(i).get("ORDER_UNIT_Q")));
        	headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list3.get(i).get("ORDER_P")));
        	headerRow.createCell(I).setCellValue(ObjUtils.parseDouble(list3.get(i).get("ORDER_O")));
        	headerRow.createCell(J).setCellValue(ObjUtils.parseDouble(list3.get(i).get("BUDGET_UNIT_O")));
        	
        	String rate = ObjUtils.getSafeString(list3.get(i).get("ST_COST_RATE"));
        	double budgO = orderSum1 * ObjUtils.parseDouble(list3.get(i).get("ST_COST_RATE")) / 100;
        	
        	
        	double orderO3 = ObjUtils.parseDouble(list3.get(i).get("ORDER_O"));

        	
 
        	headerRow.createCell(K).setCellValue(budgO);
        	headerRow.createCell(L).setCellValue(df2.format(Double.parseDouble(rate)) + "%");
        	headerRow.createCell(M).setCellValue(df2.format(Double.parseDouble(rate)) + "%");
        	
        	
           	
        	headerRow.getCell(A).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(B).setCellStyle(style01);  //본문
        	headerRow.getCell(C).setCellStyle(style01);  //본문
        	headerRow.getCell(D).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(E).setCellStyle(style01);  //본문
        	headerRow.getCell(F).setCellStyle(style01);  //본문
        	
        	headerRow.getCell(G).setCellStyle(style02);  //숫자
        	headerRow.getCell(H).setCellStyle(style02);  //숫자
        	headerRow.getCell(I).setCellStyle(style02);  //숫자
        	headerRow.getCell(J).setCellStyle(style02);  //숫자
        	headerRow.getCell(K).setCellStyle(style02);  //숫자
        	
        	headerRow.getCell(L).setCellStyle(style03);  //비율
        	headerRow.getCell(M).setCellStyle(style03);  //비율
        	
        	sheet1.addMergedRegion(new CellRangeAddress((int)row2 + 2 + i, (short)row2 + 2 + i, (int)1, (short)5));
        	sheet1.addMergedRegion(new CellRangeAddress((int)row2 + 2 + i, (short)row2 + 2 + i, (int)11, (short)12));
        	
        	budgSum3 += budgO;
        	orderSum3 += orderO3;
        	
        	row3 = i;
        	
        }
        
        headerRow = sheet1.createRow(row2 + row3 + 2 + 1);
        
    	headerRow.createCell(A).setCellValue("소계");
    	headerRow.createCell(B).setCellValue("소계");
    	headerRow.createCell(C).setCellValue("소계");
    	headerRow.createCell(D).setCellValue("소계");
    	headerRow.createCell(E).setCellValue("소계");
    	headerRow.createCell(F).setCellValue("소계");
    	
    	headerRow.createCell(G).setCellValue("");
    	headerRow.createCell(H).setCellValue("");
    	headerRow.createCell(I).setCellValue(orderSum3);
    	headerRow.createCell(J).setCellValue("");
    	headerRow.createCell(K).setCellValue(budgSum3);
    	headerRow.createCell(L).setCellValue("");
    	headerRow.createCell(M).setCellValue("");

    	headerRow.getCell(A).setCellStyle(style04);  //소계
    	headerRow.getCell(B).setCellStyle(style04);  //소계
    	headerRow.getCell(C).setCellStyle(style04);  //소계
    	headerRow.getCell(D).setCellStyle(style04);  //소계
    	headerRow.getCell(E).setCellStyle(style04);  //소계
    	headerRow.getCell(F).setCellStyle(style04);  //소계
    	
    	headerRow.getCell(G).setCellStyle(style05);  //소계
    	headerRow.getCell(H).setCellStyle(style05);  //소계
    	headerRow.getCell(I).setCellStyle(style05);  //소계
    	headerRow.getCell(J).setCellStyle(style05);  //소계
    	headerRow.getCell(K).setCellStyle(style05);  //소계
//    	headerRow.getCell(L).setCellStyle(style05);  //소계
//    	headerRow.getCell(M).setCellStyle(style05);  //소계
    	headerRow.getCell(L).setCellStyle(style03);  //비율
    	headerRow.getCell(M).setCellStyle(style03);  //비율
    
    	sheet1.addMergedRegion(new CellRangeAddress((int)row2 + row3 + 2 + 1, (short)row2 + row3 + 2 + 1, (int)0, (short)5));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row2 + row3 + 2 + 1, (short)row2 + row3 + 2 + 1, (int)11, (short)12));
    	
    	row3 = row2 + row3 + 2 + 1;
    
    	double orderSum = orderSum1 + orderSum2;
        double budgSum = budgSum1 + budgSum2 + budgSum3;
        double jingSum = budgSum2 + budgSum3;

        
        //수주금액, 수주등록금액 + 경비금액
        sheet1.getRow(5).getCell(G).setCellValue(orderSum);
        //예산(P/L)금액(A)
        sheet1.getRow(5).getCell(I).setCellValue(budgSum1);
        //경비(B)
        sheet1.getRow(5).getCell(K).setCellValue(jingSum);
        //예산합계(A+B)
        sheet1.getRow(5).getCell(L).setCellValue(budgSum);
    	
    	//합계
    	headerRow = sheet1.createRow(row3 + 1);
        
    	headerRow.createCell(A).setCellValue("합계");
    	headerRow.createCell(B).setCellValue("합계");
    	headerRow.createCell(C).setCellValue("합계");
    	headerRow.createCell(D).setCellValue("합계");
    	headerRow.createCell(E).setCellValue("합계");
    	headerRow.createCell(F).setCellValue("합계");
    	
    	headerRow.createCell(G).setCellValue("");
    	headerRow.createCell(H).setCellValue("");
    	headerRow.createCell(I).setCellValue(orderSum);
    	headerRow.createCell(J).setCellValue("");
    	headerRow.createCell(K).setCellValue(budgSum);
//    	headerRow.createCell(L).setCellValue("");
//    	headerRow.createCell(M).setCellValue("");
    	
    	String rate3 = df.format((orderSum / budgSum * 100)) + "%";
    	headerRow.createCell(L).setCellValue(rate3);
    	headerRow.createCell(M).setCellValue(rate3);
    	
    	headerRow.getCell(A).setCellStyle(style06);  //합계
    	headerRow.getCell(B).setCellStyle(style06);  //합계
    	headerRow.getCell(C).setCellStyle(style06);  //합계
    	headerRow.getCell(D).setCellStyle(style06);  //합계
    	headerRow.getCell(E).setCellStyle(style06);  //합계
    	headerRow.getCell(F).setCellStyle(style06);  //합계
    	
    	headerRow.getCell(G).setCellStyle(style07);  //합계
    	headerRow.getCell(H).setCellStyle(style07);  //합계
    	headerRow.getCell(I).setCellStyle(style07);  //합계
    	headerRow.getCell(J).setCellStyle(style07);  //합계
    	headerRow.getCell(K).setCellStyle(style07);  //합계
//    	headerRow.getCell(L).setCellStyle(style07);  //합계
//    	headerRow.getCell(M).setCellStyle(style07);  //합계
    	headerRow.getCell(L).setCellStyle(style03);  //비율
    	headerRow.getCell(M).setCellStyle(style03);  //비율
    	
    	headerRow.setHeight((short)350);
    
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 1, (short)row3 + 1, (int)0, (short)5));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 1, (short)row3 + 1, (int)11, (short)12));		
        
        
        //결재란
    	headerRow = sheet1.createRow(row3 + 3);
    	headerRow.createCell(A).setCellValue("세금계산서(VAT포함)");
    	headerRow.createCell(B).setCellValue("세금계산서(VAT포함)");
    	headerRow.createCell(C).setCellValue("결재");
    	headerRow.createCell(D).setCellValue("입금(VAT포함)");
    	headerRow.createCell(E).setCellValue("입금(VAT포함)");
    	headerRow.createCell(F).setCellValue("결재");
    	headerRow.createCell(H).setCellValue("비고 : " + remark);
    	
    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	headerRow.getCell(H).setCellStyle(style09);  //비고
    	
    	headerRow = sheet1.createRow(row3 + 4);
    	headerRow.createCell(A).setCellValue("제출일");
    	headerRow.createCell(B).setCellValue("금액");
    	headerRow.createCell(C).setCellValue("결재");
    	headerRow.createCell(D).setCellValue("입금일");
    	headerRow.createCell(E).setCellValue("금액");
    	headerRow.createCell(F).setCellValue("결재");
    	

    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	
    	
//    	headerRow.getCell(H).setCellValue(dataMap.get("REMARK").toString());
  //  	headerRow.getCell(H).setCellValue("비고 : " + dataMap.get("REMARK").toString());
    	
    	
    	headerRow = sheet1.createRow(row3 + 5);
    	headerRow.createCell(A).setCellValue("");
    	headerRow.createCell(B).setCellValue("");
    	headerRow.createCell(C).setCellValue("");
    	headerRow.createCell(D).setCellValue("");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	
    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	
    	headerRow = sheet1.createRow(row3 + 6);
    	headerRow.createCell(A).setCellValue("");
    	headerRow.createCell(B).setCellValue("");
    	headerRow.createCell(C).setCellValue("");
    	headerRow.createCell(D).setCellValue("");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	
    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	
    	headerRow = sheet1.createRow(row3 + 7);
    	headerRow.createCell(A).setCellValue("");
    	headerRow.createCell(B).setCellValue("");
    	headerRow.createCell(C).setCellValue("");
    	headerRow.createCell(D).setCellValue("");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	
    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	
    	headerRow = sheet1.createRow(row3 + 8);
    	headerRow.createCell(A).setCellValue("");
    	headerRow.createCell(B).setCellValue("");
    	headerRow.createCell(C).setCellValue("");
    	headerRow.createCell(D).setCellValue("");
    	headerRow.createCell(E).setCellValue("");
    	headerRow.createCell(F).setCellValue("");
    	
    	headerRow.getCell(A).setCellStyle(style08);  //결재
    	headerRow.getCell(B).setCellStyle(style08);  //결재
    	headerRow.getCell(C).setCellStyle(style08);  //결재
    	headerRow.getCell(D).setCellStyle(style08);  //결재
    	headerRow.getCell(E).setCellStyle(style08);  //결재
    	headerRow.getCell(F).setCellStyle(style08);  //결재
    	
    	
    	
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 3, (short)row3 + 3, (int)0, (short)1));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 3, (short)row3 + 3, (int)3, (short)4));
    	
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 3, (short)row3 + 4, (int)2, (short)2));
    	sheet1.addMergedRegion(new CellRangeAddress((int)row3 + 3, (short)row3 + 4, (int)5, (short)5));
    	        
        
        return workbook;
    }
    
    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row - 1).getCell(cell).setCellValue(value);
    }
    
}
