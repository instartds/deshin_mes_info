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

@Service( "s_hatExcel_ygService" )
public class S_HatExcel_ygServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "s_hat531skr_ygService" )
    private S_hat531skr_ygServiceImpl s_hat531skr_ygService;
    
    public Workbook makeExcel( Map param ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "hat531skr-201807.xlsx"));
        
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
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
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

        
        
        Map dataMap = (Map) super.commonDao.select("s_hat531skr_ygServiceImpl.selectInfo", param);
        if (!ObjUtils.isEmpty(dataMap)) {
	        
        	sheet1.getRow(1).getCell(A).setCellValue(dataMap.get("PRINT_DATE").toString());

        }
        
        DecimalFormat df = new DecimalFormat("#,###");
        DecimalFormat df2 = new DecimalFormat("#.00");
        

        List<Map> list1 = super.commonDao.list("s_hat531skr_ygServiceImpl.selectList", param);
        
        double orderSum1 = 0;
        double budgSum1 = 0;
        
        for(int i = 0; i < list1.size(); i++) {
        	
        	headerRow = sheet1.createRow(4 + i);
        	headerRow.createCell(A).setCellValue(1 + i);
        	headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("NAME")));			//성명
        	
        	headerRow.createCell(C).setCellValue(ObjUtils.parseInt(list1.get(i).get("NWK_DATE")));			//총근무(일)
        	
        	headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list1.get(i).get("WK_DATE")));		//출근(일)
        	headerRow.createCell(E).setCellValue(ObjUtils.parseInt(list1.get(i).get("WK_DATE_LATE")));		//출근율(%)
        	headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list1.get(i).get("YHOL")));			//년차(일)
        	headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list1.get(i).get("ABSEN")));			//결근(일)
        	headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list1.get(i).get("PHOL")));			//유급(일)
        	headerRow.createCell(I).setCellValue(ObjUtils.parseDouble(list1.get(i).get("OHOL")));			//무급(일)
        	headerRow.createCell(J).setCellValue(ObjUtils.parseDouble(list1.get(i).get("EDUC")));			//교욱(일)
        	headerRow.createCell(K).setCellValue(ObjUtils.parseDouble(list1.get(i).get("TRAIN")));			//훈련(일)
        	
        	headerRow.createCell(L).setCellValue(ObjUtils.parseDouble(list1.get(i).get("LATEN")));			//지각(회수)
        	headerRow.createCell(M).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LATENTIME")));	//지각(시간)
        	
        	headerRow.createCell(N).setCellValue(ObjUtils.parseDouble(list1.get(i).get("EALIER")));			//조퇴(회수)
        	headerRow.createCell(O).setCellValue(ObjUtils.getSafeString(list1.get(i).get("EALIERTIME")));	//조퇴(시간)
        	
        	headerRow.createCell(P).setCellValue(ObjUtils.parseDouble(list1.get(i).get("OUTB")));			//외출(회수)
        	headerRow.createCell(Q).setCellValue(ObjUtils.getSafeString(list1.get(i).get("OUTBTIME")));		//외출(시간)
        	
        	headerRow.getCell(A).setCellStyle(style01);  //문자형
        	headerRow.getCell(B).setCellStyle(style01);  //문자형
        	headerRow.getCell(C).setCellStyle(style02);  //숫자형
        	headerRow.getCell(D).setCellStyle(style02);  //숫자형
        	headerRow.getCell(E).setCellStyle(style02);  //숫자형
        	headerRow.getCell(F).setCellStyle(style02);  //숫자형
        	headerRow.getCell(G).setCellStyle(style02);  //숫자형
        	headerRow.getCell(H).setCellStyle(style02);  //숫자형
        	headerRow.getCell(I).setCellStyle(style02);  //숫자형
        	headerRow.getCell(J).setCellStyle(style02);  //숫자형
        	headerRow.getCell(K).setCellStyle(style02);  //숫자형
        	headerRow.getCell(L).setCellStyle(style02);  //숫자형
        	headerRow.getCell(M).setCellStyle(style01);  //문자형
        	headerRow.getCell(N).setCellStyle(style02);  //숫자형
        	headerRow.getCell(O).setCellStyle(style01);  //문자형
        	headerRow.getCell(P).setCellStyle(style02);  //숫자형
        	headerRow.getCell(Q).setCellStyle(style01);  //문자형
        	
        	row1 = i;
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
