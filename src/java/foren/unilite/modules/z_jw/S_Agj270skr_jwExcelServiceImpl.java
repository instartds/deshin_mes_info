package foren.unilite.modules.z_jw;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
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

import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.DevFreeUtils;
import net.sf.json.JSONArray;

import org.apache.poi.hssf.util.HSSFColor;

@Service( "s_agj270skr_jwExcelService" )
public class S_Agj270skr_jwExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());

    @Resource( name = "s_agj270skr_jwService" )
    private S_Agj270skr_jwServiceImpl s_agj270skr_jwService;

    public Workbook makeExcel( Map param , LoginVO user) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "s_agj270skr_jw-201809.xlsx"));
        logger.debug("[excelDownload]" + ConfigUtil.getUploadBasePath("ExcelFrame"));
        //Get the workbook instance for XLS file
        Workbook workbook = new XSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        //Get first sheet from the workbook
        //Sheet sheet1 = workbook.getSheetAt(0);
        logger.debug("[sheet1]" + file);
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
        DecimalFormat df = new DecimalFormat("#,###");
        DecimalFormat df2 = new DecimalFormat("#.00");

        String remark = "";
        logger.debug("[[param]]" + param);
        List<Map> listMaster =  super.commonDao.list("s_agj270skr_jwServiceImpl.selectListExcel", param);
        Sheet sheet0 = workbook.getSheetAt(0);
        Map sheetMap = new HashMap<>();
        int i = 0;
        if (!ObjUtils.isEmpty(listMaster)) {
        	 for(Map mapMaster : listMaster){
        		 Sheet sheet1 = workbook.getSheetAt(0);
        		 /*sheetMap.put("sheet" + i,  sheet);
        		 Sheet sheet1 = (Sheet) sheetMap.get("sheet" + i);*/
        		 if(i == 0){
        			 workbook.setSheetName(0, "지출결의서 " + (String) mapMaster.get("EX_NUM_EXCEL"));
        		 }else{
    				workbook.cloneSheet(0);
             		sheet1 = workbook.getSheetAt(i);
             		workbook.setSheetName(i, "지출결의서 " + (String) mapMaster.get("EX_NUM_EXCEL"));
        		 }

            		 sheet1.getRow(3).getCell(E).setCellValue("지출결의서 번호: " + (String) mapMaster.get("EX_NUM_EXCEL"));
            		 logger.debug("[[지출결의서1]]" + mapMaster.get("EX_NUM_EXCEL"));
            		 //계정리스트
            		 param.put("AC_DATE", mapMaster.get("AC_DATE"));
            		 param.put("SLIP_NUM", mapMaster.get("SLIP_NUM"));
            	        List<Map> listDetail = super.commonDao.list("s_agj270skr_jwServiceImpl.selectList2Excel", param);

    	        	        for(Map mapDetail : listDetail){

    	        	        	sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(A).setCellValue((String) mapDetail.get("ACCNT"));
    	        	        	sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(D).setCellValue((String) mapDetail.get("ACCNT_NAME"));

    	        	        	if(mapDetail.get("AC_CODE1").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME1"));

    	        	        	}else if(mapDetail.get("AC_CODE2").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME2"));

    	        	        	}else if(mapDetail.get("AC_CODE3").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME3"));

    	        	        	}else if(mapDetail.get("AC_CODE4").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME4"));

    	        	        	}else if(mapDetail.get("AC_CODE5").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME5"));

    	        	        	}else if(mapDetail.get("AC_CODE6").equals("A4")){

    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(H).setCellValue((String) mapDetail.get("AC_DATA_NAME6"));

    	        	        	}
    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(Q).setCellValue((String) mapDetail.get("REMARK"));
    	        	        		sheet1.getRow(ObjUtils.parseInt(mapDetail.get("EX_SEQ")) + 10).getCell(Y).setCellValue(ObjUtils.parseDouble( mapDetail.get("AMT_I")));
    	        	        		sheet1.getRow(8).getCell(F).setCellValue((String) mapMaster.get("AMT_TO_HANGUL"));
    	        	        		sheet1.getRow(8).getCell(O).setCellValue(ObjUtils.parseDouble(mapMaster.get("DR_AMT_I")));
    	        	        		sheet1.getRow(22).getCell(D).setCellValue((String) mapMaster.get("AC_DATE2"));
    	        	        		sheet1.getRow(22).getCell(L).setCellValue(user.getUserName());
    	        	        		sheet1.getRow(22).getCell(S).setCellValue(user.getDeptName());
    	        	        		sheet1.getRow(21).getCell(Y).setCellValue(ObjUtils.parseDouble(mapMaster.get("DR_AMT_I")));
    	        	        		sheet1.getRow(24).getCell(D).setCellValue((String) mapMaster.get("AC_DATE2"));
    	        	        		sheet1.getRow(24).getCell(L).setCellValue( ObjUtils.parseDouble(mapMaster.get("SLIP_NUM")));

    	        	        }



        	        i ++;
        	 }
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
