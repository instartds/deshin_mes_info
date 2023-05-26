package foren.unilite.modules.z_hs;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_afs100rkr_hsService")
public class S_Afs100rkr_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	/**
	 * 데이터 엑셀다운로드 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public Workbook makeExcelData( Map param , LoginVO user) throws Exception {
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "s_afs100rkr_hs.xlsx"));
		
		//Get the workbook instance for XLS file
		Workbook workbook = new XSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet1 = workbook.getSheetAt(0);
		Row row = null;
		
		int A = 0;
		int B = 1;
		int C = 2;
		int D = 3;
		int E = 4;
		int F = 5;
		int G = 6;
		int H = 7;
		int I = 8;
		
		int z1 = 4;
		int z2 = 10;
		int z3 = 30;
		
		List<Map> list2 = super.commonDao.list("s_afs100rkr_hsServiceImpl.selectToPrint", param);
		
		row = sheet1.getRow(1);
		
		row.getCell(A).setCellValue("( " +  param.get("WORK_DATE").toString().substring(0, 4) + "년 " + param.get("WORK_DATE").toString().substring(4, 6) + "월 " +param.get("WORK_DATE").toString().substring(6, 8)+ "일 )");
		row.getCell(I).setCellValue("");
		
		
		for(Map el : list2) {
			if(ObjUtils.getSafeString(el.get("ACCNT_SPEC")).equals("A")){
				row = sheet1.getRow(3);
				
				row.getCell(C).setCellValue(ObjUtils.parseDouble(el.get("IWALL_AMT_I")));
				row.getCell(D).setCellValue(ObjUtils.parseDouble(el.get("DR_AMT_I")));
				row.getCell(E).setCellValue(ObjUtils.parseDouble(el.get("CR_AMT_I")));
				row.getCell(G).setCellValue(ObjUtils.parseDouble(el.get("JAN_AMT_I")));
			}
			
			if(ObjUtils.getSafeString(el.get("ACCNT_SPEC")).equals("Z1")){
				row = sheet1.getRow(z1);
				
				row.getCell(B).setCellValue(ObjUtils.getSafeString(el.get("ACCNT_NAME")));
				row.getCell(C).setCellValue(ObjUtils.parseDouble(el.get("IWALL_AMT_I")));
				row.getCell(D).setCellValue(ObjUtils.parseDouble(el.get("DR_AMT_I")));
				row.getCell(E).setCellValue(ObjUtils.parseDouble(el.get("CR_AMT_I")));
				row.getCell(G).setCellValue(ObjUtils.parseDouble(el.get("JAN_AMT_I")));
				
				z1++;
			}

			if(ObjUtils.getSafeString(el.get("ACCNT_SPEC")).equals("Z2")){
				row = sheet1.getRow(z2);
				
				row.getCell(B).setCellValue(ObjUtils.getSafeString(el.get("ACCNT_NAME")));
				row.getCell(C).setCellValue(ObjUtils.parseDouble(el.get("IWALL_AMT_I")));
				row.getCell(D).setCellValue(ObjUtils.parseDouble(el.get("DR_AMT_I")));
				row.getCell(E).setCellValue(ObjUtils.parseDouble(el.get("CR_AMT_I")));
				row.getCell(G).setCellValue(ObjUtils.parseDouble(el.get("JAN_AMT_I")));
				
				z2++;
			}

			if(ObjUtils.getSafeString(el.get("ACCNT_SPEC")).equals("Z3")){
				row = sheet1.getRow(z3);
				
				row.getCell(B).setCellValue(ObjUtils.getSafeString(el.get("ACCNT_NAME")));
				row.getCell(C).setCellValue(ObjUtils.parseDouble(el.get("IWALL_AMT_I")));
				row.getCell(D).setCellValue(ObjUtils.parseDouble(el.get("DR_AMT_I")));
				row.getCell(E).setCellValue(ObjUtils.parseDouble(el.get("CR_AMT_I")));
				row.getCell(G).setCellValue(ObjUtils.parseDouble(el.get("JAN_AMT_I")));
				
				z3++;
			}

			if(ObjUtils.getSafeString(el.get("ACCNT_SPEC")).equals("ZZ")){
				row = sheet1.getRow(40);
				
				row.getCell(C).setCellValue(ObjUtils.parseDouble(el.get("IWALL_AMT_I")));
				row.getCell(D).setCellValue(ObjUtils.parseDouble(el.get("DR_AMT_I")));
				row.getCell(E).setCellValue(ObjUtils.parseDouble(el.get("CR_AMT_I")));
				row.getCell(G).setCellValue(ObjUtils.parseDouble(el.get("JAN_AMT_I")));
			}
		}
		
		row = sheet1.getRow(50);
		row.getCell(D).setCellValue("  " + user.getCompName());
		
		HSSFFormulaEvaluator.evaluateAllFormulaCells(workbook);
		
		InputStream logoStream = null;
		if(user.getCompCode().equals("SKCC")) {
			logoStream = new FileInputStream(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "SKCC.png");
		}
		else if(user.getCompCode().equals("MJIC")) {
			logoStream = new FileInputStream(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "MJIC.png");
		}
		else if(user.getCompCode().equals("GSIC")) {
			logoStream = new FileInputStream(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "GSIC.png");
		}
		else {
			logoStream = new FileInputStream(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "SKCP.png");
		}
		
		byte[] logoBytes = IOUtils.toByteArray(logoStream);
		int logoPic = workbook.addPicture(logoBytes, Workbook.PICTURE_TYPE_PNG);
		logoStream.close();
		
		CreationHelper helper = workbook.getCreationHelper();
		Drawing drawing = sheet1.createDrawingPatriarch();
		ClientAnchor anchor = helper.createClientAnchor();
		
		anchor.setRow1(50);
		anchor.setCol1(D);
		
		Picture logo = drawing.createPicture(anchor, logoPic);
		logo.resize();
		
		return workbook;
	}
	
	/**
	 * 데이터 엑셀다운로드 로직 (삭제 예정)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Deprecated
	@ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
	public Workbook makeExcelData2( Map param , LoginVO user) throws Exception {
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "s_afs100rkr_hs.xlsx"));

		//Get the workbook instance for XLS file
		Workbook workbook = new XSSFWorkbook(file);
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
		
		int z1 = 0;
		int z2 = 0;
		int z3 = 0;
		
		double sum10 = 0;
		double sum20 = 0;
		double sum30 = 0;
		double sum40 = 0;
		
		double sum11 = 0;
		double sum21 = 0;
		double sum31 = 0;
		double sum41 = 0;
		
		double sum12 = 0;
		double sum22 = 0;
		double sum32 = 0;
		double sum42 = 0;
		
		double sum13 = 0;
		double sum23 = 0;
		double sum33 = 0;
		double sum43 = 0;
		
	     // 타이틀폰트
        Font font0 = workbook.createFont();
        font0.setFontHeightInPoints((short)9);
        font0.setFontName("굴림체");
        
        // 본문및합계폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)9);
        font.setFontName("굴림체");
        
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)11);        
        font2.setFontName("굴림체");
  ///////////////////////////////////////////////////////////      
        // 본문및합계폰트(붉은색)
        Font font3 = workbook.createFont();
        font3.setFontHeightInPoints((short)9);
        font3.setColor(HSSFColor.RED.index);
        font3.setFontName("굴림체");
        
        Font font4 = workbook.createFont();
        font4.setFontHeightInPoints((short)11);        
        font4.setFontName("굴림체");
        
        Font font5 = workbook.createFont();
        font5.setFontHeightInPoints((short)11);        
        font5.setFontName("굴림체");
        
        Font font6 = workbook.createFont();
        font6.setFontHeightInPoints((short)12);        
        font6.setFontName("굴림체");
        font6.setBoldweight((short)Font.BOLDWEIGHT_BOLD);
/////////////////////////////////////////////////////////////
        
        //Style 01 : 현금시제1
        CellStyle style00 = workbook.createCellStyle();
        style00.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style00.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style00.setBorderRight(CellStyle.BORDER_MEDIUM);
        style00.setBorderTop(CellStyle.BORDER_MEDIUM);
        style00.setAlignment(CellStyle.ALIGN_CENTER);
        style00.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style00.setFont(font0);
        
        //Style 01 : 현금시제1
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style01.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style01.setBorderRight(CellStyle.BORDER_THIN);
        style01.setBorderTop(CellStyle.BORDER_MEDIUM);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);
        
        //Style 02 : 현금시제(숫자)
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style02.setBorderLeft(CellStyle.BORDER_THIN);
        style02.setBorderRight(CellStyle.BORDER_THIN);
        style02.setBorderTop(CellStyle.BORDER_MEDIUM);
        style02.setAlignment(CellStyle.ALIGN_RIGHT);
        style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setDataFormat(format.getFormat("#,##0"));
        style02.setFont(font);

        // Style 03 : 현금시제3(비고)
        CellStyle style03 = workbook.createCellStyle();
        style03.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style03.setBorderLeft(CellStyle.BORDER_THIN);
        style03.setBorderRight(CellStyle.BORDER_MEDIUM);
        style03.setBorderTop(CellStyle.BORDER_MEDIUM);
        style03.setAlignment(CellStyle.ALIGN_LEFT);
        style03.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setDataFormat(format.getFormat("#,##0"));
        style03.setFont(font);

        // Style 04 : 당좌예금 왼+위 볼드테두리(문자)
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        style04.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style04.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style04.setBorderRight(CellStyle.BORDER_THIN);
        style04.setBorderTop(CellStyle.BORDER_MEDIUM);
        style04.setAlignment(CellStyle.ALIGN_LEFT);
        style04.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style04.setFont(font);
        
        // Style 05 : 당좌예금 위 볼드테두리(숫자)
        CellStyle style05 = workbook.createCellStyle();
        style05.setBorderBottom(CellStyle.BORDER_THIN);
        style05.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style05.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        style05.setBorderTop(CellStyle.BORDER_MEDIUM);
        style05.setAlignment(CellStyle.ALIGN_RIGHT);
        style05.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style05.setDataFormat(format.getFormat("#,##0"));
        style05.setFont(font);
        
        // Style 06 : 당좌예금 위 + 우  볼드테두리(문자)
        CellStyle style06 = workbook.createCellStyle();
        style06.setBorderBottom(CellStyle.BORDER_THIN);
        style06.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style06.setBorderLeft(CellStyle.BORDER_THIN);
        style06.setBorderRight(CellStyle.BORDER_MEDIUM);
        style06.setBorderTop(CellStyle.BORDER_MEDIUM);
        style06.setAlignment(CellStyle.ALIGN_LEFT);
        style06.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style06.setFont(font);
        
        // Style 07 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style07 = workbook.createCellStyle();
        style07.setBorderBottom(CellStyle.BORDER_THIN);
        style07.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style07.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style07.setBorderRight(CellStyle.BORDER_THIN);
        style07.setBorderTop(CellStyle.BORDER_THIN);
        style07.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style07.setAlignment(CellStyle.ALIGN_LEFT);
        style07.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style07.setFont(font);
        
        // Style 08 : 당좌예금 위 볼드테두리(숫자)
        CellStyle style08 = workbook.createCellStyle();
        style08.setBorderBottom(CellStyle.BORDER_THIN);
        style08.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style08.setBorderLeft(CellStyle.BORDER_THIN);
        style08.setBorderRight(CellStyle.BORDER_THIN);
        style08.setBorderTop(CellStyle.BORDER_THIN);
        style08.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style08.setAlignment(CellStyle.ALIGN_RIGHT);
        style08.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style08.setDataFormat(format.getFormat("#,##0"));
        style08.setFont(font);       

        
        // Style 09 : 당좌예금 위 + 우  볼드테두리(문자)
        CellStyle style09 = workbook.createCellStyle();
        style09.setBorderBottom(CellStyle.BORDER_THIN);
        style09.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style09.setBorderLeft(CellStyle.BORDER_THIN);
        style09.setBorderRight(CellStyle.BORDER_MEDIUM);
        style09.setBorderTop(CellStyle.BORDER_THIN);
        style09.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style09.setAlignment(CellStyle.ALIGN_LEFT);
        style09.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style09.setFont(font);
        
        // Style 11 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style11 = workbook.createCellStyle();
        style11.setBorderBottom(CellStyle.BORDER_THIN);
        style11.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style11.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style11.setBorderRight(CellStyle.BORDER_THIN);
        style11.setBorderTop(CellStyle.BORDER_THIN);
        style11.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style11.setAlignment(CellStyle.ALIGN_CENTER);
        style11.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style11.setFont(font);
        
        // Style 07 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style12 = workbook.createCellStyle();
        style12.setBorderBottom(CellStyle.BORDER_THIN);
        style12.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style12.setBorderLeft(CellStyle.BORDER_THIN);
        style12.setBorderRight(CellStyle.BORDER_THIN);
        style12.setBorderTop(CellStyle.BORDER_THIN);
        style12.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style12.setAlignment(CellStyle.ALIGN_LEFT);
        style12.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style12.setFont(font);
        
        // Style 07 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style13 = workbook.createCellStyle();
        style13.setBorderBottom(CellStyle.BORDER_NONE);
        style13.setBorderLeft(CellStyle.BORDER_NONE);
        style13.setBorderRight(CellStyle.BORDER_NONE);
        style13.setBorderTop(CellStyle.BORDER_NONE);
        style13.setAlignment(CellStyle.ALIGN_CENTER);
        style13.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style13.setFont(font2);
        
        CellStyle style14 = workbook.createCellStyle();
        style14.setBorderBottom(CellStyle.BORDER_THIN);
        style14.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style14.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style14.setBorderRight(CellStyle.BORDER_THIN);
        style14.setBorderTop(CellStyle.BORDER_THIN);
        style14.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style14.setAlignment(CellStyle.ALIGN_CENTER);
        style14.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style14.setFillForegroundColor(HSSFColor.YELLOW.index);
        style14.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style14.setFont(font);
        
        CellStyle style15 = workbook.createCellStyle();
        style15.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style15.setBorderLeft(CellStyle.BORDER_THIN);
        style15.setBorderRight(CellStyle.BORDER_THIN);
        style15.setBorderTop(CellStyle.BORDER_MEDIUM);
        style15.setAlignment(CellStyle.ALIGN_RIGHT);
        style15.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style15.setFillForegroundColor(HSSFColor.YELLOW.index);
        style15.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style15.setDataFormat(format.getFormat("#,##0"));
        style15.setFont(font);
		
        CellStyle style16 = workbook.createCellStyle();
        style16.setBorderBottom(CellStyle.BORDER_THIN);
        style16.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style16.setBorderLeft(CellStyle.BORDER_THIN);
        style16.setBorderRight(CellStyle.BORDER_MEDIUM);
        style16.setBorderTop(CellStyle.BORDER_THIN);
        style16.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style16.setAlignment(CellStyle.ALIGN_RIGHT);
        style16.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style16.setFillForegroundColor(HSSFColor.YELLOW.index);
        style16.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style16.setDataFormat(format.getFormat("#,##0"));
        style16.setFont(font);
        
        //Style 01 : 현금시제1
        CellStyle style17 = workbook.createCellStyle();
        style17.setBorderBottom(CellStyle.BORDER_NONE);
        style17.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style17.setBorderRight(CellStyle.BORDER_NONE);
        style17.setBorderTop(CellStyle.BORDER_NONE);
        style17.setAlignment(CellStyle.ALIGN_CENTER);
        style17.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style17.setFont(font5);

        
        
//////////////////////////////////////////////////붉은색
        //Style 01 : 현금시제1
        CellStyle style101 = workbook.createCellStyle();
        style101.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style101.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style101.setBorderRight(CellStyle.BORDER_THIN);
        style101.setBorderTop(CellStyle.BORDER_MEDIUM);
        style101.setAlignment(CellStyle.ALIGN_CENTER);
        style101.setVerticalAlignment(CellStyle.VERTICAL_BOTTOM);
        style101.setFont(font3);
        
        //Style 02 : 현금시제(숫자)
        CellStyle style102 = workbook.createCellStyle();
        style102.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style102.setBorderLeft(CellStyle.BORDER_THIN);
        style102.setBorderRight(CellStyle.BORDER_THIN);
        style102.setBorderTop(CellStyle.BORDER_MEDIUM);
        style102.setAlignment(CellStyle.ALIGN_RIGHT);
        style102.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style102.setDataFormat(format.getFormat("#,##0"));
        style102.setFont(font3);

        // Style 03 : 현금시제3(비고)
        CellStyle style103 = workbook.createCellStyle();
        style103.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style103.setBorderLeft(CellStyle.BORDER_THIN);
        style103.setBorderRight(CellStyle.BORDER_MEDIUM);
        style103.setBorderTop(CellStyle.BORDER_MEDIUM);
        style103.setAlignment(CellStyle.ALIGN_LEFT);
        style103.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style103.setDataFormat(format.getFormat("#,##0"));
        style103.setFont(font3);
        
        // Style 04 : 당좌예금 왼+위 볼드테두리(문자)
        CellStyle style104 = workbook.createCellStyle();
        style104.setBorderBottom(CellStyle.BORDER_THIN);
        style104.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style104.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style104.setBorderRight(CellStyle.BORDER_THIN);
        style104.setBorderTop(CellStyle.BORDER_MEDIUM);
        style104.setAlignment(CellStyle.ALIGN_LEFT);
        style104.setVerticalAlignment(CellStyle.VERTICAL_BOTTOM);
        style104.setFont(font3);
        
        // Style 05 : 당좌예금 위 볼드테두리(숫자)
        CellStyle style105 = workbook.createCellStyle();
        style105.setBorderBottom(CellStyle.BORDER_THIN);
        style105.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style105.setBorderLeft(CellStyle.BORDER_THIN);
        style105.setBorderRight(CellStyle.BORDER_THIN);
        style105.setBorderTop(CellStyle.BORDER_MEDIUM);
        style105.setAlignment(CellStyle.ALIGN_RIGHT);
        style105.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style105.setDataFormat(format.getFormat("#,##0"));
        style105.setFont(font3);
        
        // Style 06 : 당좌예금 위 + 우  볼드테두리(문자)
        CellStyle style106 = workbook.createCellStyle();
        style106.setBorderBottom(CellStyle.BORDER_THIN);
        style106.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style106.setBorderLeft(CellStyle.BORDER_THIN);
        style106.setBorderRight(CellStyle.BORDER_MEDIUM);
        style106.setBorderTop(CellStyle.BORDER_MEDIUM);
        style106.setAlignment(CellStyle.ALIGN_LEFT);
        style106.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style106.setFont(font3);
        
        // Style 07 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style107 = workbook.createCellStyle();
        style107.setBorderBottom(CellStyle.BORDER_THIN);
        style107.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style107.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style107.setBorderRight(CellStyle.BORDER_THIN);
        style107.setBorderTop(CellStyle.BORDER_THIN);
        style107.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style107.setAlignment(CellStyle.ALIGN_LEFT);
        style107.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style107.setFont(font3);
        
        // Style 08 : 당좌예금 위 볼드테두리(숫자)
        CellStyle style108 = workbook.createCellStyle();
        style108.setBorderBottom(CellStyle.BORDER_THIN);
        style108.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style108.setBorderLeft(CellStyle.BORDER_THIN);
        style108.setBorderRight(CellStyle.BORDER_THIN);
        style108.setBorderTop(CellStyle.BORDER_THIN);
        style108.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style108.setAlignment(CellStyle.ALIGN_RIGHT);
        style108.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style108.setDataFormat(format.getFormat("#,##0"));
        style108.setFont(font3);       

        
        // Style 09 : 당좌예금 위 + 우  볼드테두리(문자)
        CellStyle style109 = workbook.createCellStyle();
        style109.setBorderBottom(CellStyle.BORDER_THIN);
        style109.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style109.setBorderLeft(CellStyle.BORDER_THIN);
        style109.setBorderRight(CellStyle.BORDER_MEDIUM);
        style109.setBorderTop(CellStyle.BORDER_THIN);
        style109.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style109.setAlignment(CellStyle.ALIGN_LEFT);
        style109.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style109.setFont(font3);
        
        CellStyle style114 = workbook.createCellStyle();
        style114.setBorderBottom(CellStyle.BORDER_THIN);
        style114.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style114.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style114.setBorderRight(CellStyle.BORDER_THIN);
        style114.setBorderTop(CellStyle.BORDER_THIN);
        style114.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style114.setAlignment(CellStyle.ALIGN_CENTER);
        style114.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style114.setFillForegroundColor(HSSFColor.YELLOW.index);
        style114.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style114.setFont(font3);
        
        CellStyle style115 = workbook.createCellStyle();
        style115.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style115.setBorderLeft(CellStyle.BORDER_THIN);
        style115.setBorderRight(CellStyle.BORDER_THIN);
        style115.setBorderTop(CellStyle.BORDER_MEDIUM);
        style115.setAlignment(CellStyle.ALIGN_RIGHT);
        style115.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style115.setFillForegroundColor(HSSFColor.YELLOW.index);
        style115.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style115.setDataFormat(format.getFormat("#,##0"));
        style115.setFont(font3);
		
        CellStyle style116 = workbook.createCellStyle();
        style116.setBorderBottom(CellStyle.BORDER_THIN);
        style116.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style116.setBorderLeft(CellStyle.BORDER_THIN);
        style116.setBorderRight(CellStyle.BORDER_MEDIUM);
        style116.setBorderTop(CellStyle.BORDER_THIN);
        style116.setTopBorderColor(HSSFColor.GREY_25_PERCENT.index);
        style116.setAlignment(CellStyle.ALIGN_RIGHT);
        style116.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style116.setFillForegroundColor(HSSFColor.YELLOW.index);
        style116.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style116.setDataFormat(format.getFormat("#,##0"));
        style116.setFont(font3);
        
        
        CellStyle style24 = workbook.createCellStyle();
        style24.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style24.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style24.setBorderRight(CellStyle.BORDER_THIN);
        style24.setBorderTop(CellStyle.BORDER_MEDIUM);
        style24.setAlignment(CellStyle.ALIGN_CENTER);
        style24.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style24.setFillForegroundColor(HSSFColor.YELLOW.index);
        style24.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style24.setFont(font);
        
        
        CellStyle style26 = workbook.createCellStyle();
        style26.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style26.setBorderLeft(CellStyle.BORDER_THIN);
        style26.setBorderRight(CellStyle.BORDER_MEDIUM);
        style26.setBorderTop(CellStyle.BORDER_MEDIUM);
        style26.setAlignment(CellStyle.ALIGN_RIGHT);
        style26.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style26.setFillForegroundColor(HSSFColor.YELLOW.index);
        style26.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style26.setDataFormat(format.getFormat("#,##0"));
        style26.setFont(font);
        
        CellStyle style27 = workbook.createCellStyle();
        style27.setBorderBottom(CellStyle.BORDER_MEDIUM);
        style27.setBorderLeft(CellStyle.BORDER_NONE);
        style27.setBorderRight(CellStyle.BORDER_MEDIUM);
        style27.setBorderTop(CellStyle.BORDER_NONE);
        style27.setAlignment(CellStyle.ALIGN_RIGHT);
        style27.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        //style27.setFillForegroundColor(HSSFColor.LEMON_CHIFFON.index);
        //style27.setFillPattern(CellStyle.SOLID_FOREGROUND);
        //style27.setDataFormat(format.getFormat("#,##0"));
        style27.setFont(font);
        
        // Style 07 : 당좌예금 왼 볼드테두리(문자)
        CellStyle style113 = workbook.createCellStyle();
        style113.setBorderBottom(CellStyle.BORDER_NONE);
        style113.setBorderLeft(CellStyle.BORDER_NONE);
        style113.setBorderRight(CellStyle.BORDER_NONE);
        style113.setBorderTop(CellStyle.BORDER_NONE);
        style113.setAlignment(CellStyle.ALIGN_CENTER);
        style113.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style113.setFont(font6);
        
		List<Map> list2 = super.commonDao.list("s_afs100rkr_hsServiceImpl.selectToPrint", param);
		
		headerRow = sheet1.createRow(1);
		headerRow.createCell(A).setCellValue("( " +  param.get("WORK_DATE").toString().substring(0, 4) + "년 " + param.get("WORK_DATE").toString().substring(4, 6) + "월 " +param.get("WORK_DATE").toString().substring(6, 8)+ "일 )");
		
		headerRow.createCell(I).setCellValue("");
		headerRow.getCell(A).setCellStyle(style17);
		headerRow.getCell(I).setCellStyle(style27);  //합계		
		
		headerRow.setHeight((short)400);
		
		headerRow = sheet1.createRow(3);
		headerRow.createCell(A).setCellValue("현 금 시 재");
		headerRow.getCell(A).setCellStyle(style02);
		
		sheet1.addMergedRegion(new CellRangeAddress((int)3, (short)3, (int)0, (short)2));   //적요 ( 가로병합 - First Row, Last Row, First Col, Last Col  )
		
		for(int i = 0; i < list2.size(); i++) {
			
			if(ObjUtils.getSafeString(list2.get(i).get("ACCNT_SPEC")).equals("A")){
				headerRow = sheet1.createRow(3);
				headerRow.createCell(A).setCellValue("현 금 시 재");
				//headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) == 0){
					headerRow.createCell(D).setCellValue("- ");
				} else {
					
					headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				}
				
				//headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) == 0){
					headerRow.createCell(E).setCellValue("- ");
				} else {
					
					headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				}
				
				//headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(F).setCellValue("- ");
				} else {
					
					headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) == 0){
					headerRow.createCell(H).setCellValue("- ");
				} else {
					
					headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				}
				headerRow.createCell(I).setCellValue("");
				
				headerRow.getCell(A).setCellStyle(style01);
				headerRow.getCell(D).setCellStyle(style02);
				headerRow.getCell(E).setCellStyle(style02);
				headerRow.getCell(F).setCellStyle(style02);
				headerRow.getCell(H).setCellStyle(style02);
				headerRow.getCell(I).setCellStyle(style03);
				
				sum10 = ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I"));
				sum20 = ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I"));
				sum30 = ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I"));
				sum40 = ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I"));								
				
			}
			
			////////////////////////////////////////////////////////////////////////
			//당좌예금//
			////////////////////////////////////////////////////////////////////////
			if(ObjUtils.getSafeString(list2.get(i).get("ACCNT_SPEC")).equals("Z1")){
				headerRow = sheet1.createRow(4 + z1);
				
				if(z1 == 0)
				{
					
					headerRow.createCell(A).setCellValue("\n");				
					headerRow.getCell(A).setCellStyle(style00);

				}
				
				headerRow.createCell(A).setCellValue("\n");				
				headerRow.getCell(A).setCellStyle(style00);
				
				headerRow.createCell(B).setCellValue("  " + ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				
				//headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) == 0){
					headerRow.createCell(D).setCellValue("- ");
				}else{
					headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				}
				
				//headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) == 0){
					headerRow.createCell(E).setCellValue("- ");
				}else {
					headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
					
				}
				
				//headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(F).setCellValue("- ");
				} else {
					headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(G).setCellValue("- ");
				}else{
					headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) == 0){
					headerRow.createCell(H).setCellValue("- ");
				} else {
					headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				}
				headerRow.createCell(I).setCellValue("");
				
				if(z1 == 0)
				{
					
					headerRow.getCell(B).setCellStyle(style04);
					headerRow.getCell(C).setCellStyle(style04);
					
					//headerRow.getCell(D).setCellStyle(style05);
					if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) >= 0){
						headerRow.getCell(D).setCellStyle(style05);
					}else {
						headerRow.getCell(D).setCellStyle(style105);
					}
					
					//headerRow.getCell(E).setCellStyle(style05);
					if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) >= 0){
						headerRow.getCell(E).setCellStyle(style05);
					}else {
						headerRow.getCell(E).setCellStyle(style105);
					}
					
					//headerRow.getCell(F).setCellStyle(style05);
					if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
						headerRow.getCell(F).setCellStyle(style05);
					}else {
						headerRow.getCell(F).setCellStyle(style105);
					}
					
					//headerRow.getCell(G).setCellStyle(style05);
					if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
						headerRow.getCell(G).setCellStyle(style05);
					}else {
						headerRow.getCell(G).setCellStyle(style105);
					}
					
					//headerRow.getCell(H).setCellStyle(style05);
					if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) >= 0){
						headerRow.getCell(H).setCellStyle(style05);
					}else {
						headerRow.getCell(H).setCellStyle(style105);
					}
					
					headerRow.getCell(I).setCellStyle(style06);
				} else {
					
					headerRow.getCell(B).setCellStyle(style07);
					headerRow.getCell(C).setCellStyle(style07);
					
					//headerRow.getCell(D).setCellStyle(style08);
					if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) >= 0){
						headerRow.getCell(D).setCellStyle(style08);
					}else {
						headerRow.getCell(D).setCellStyle(style108);
					}					
					
					//headerRow.getCell(E).setCellStyle(style08);
					if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) >= 0){
						headerRow.getCell(E).setCellStyle(style08);
					}else {
						headerRow.getCell(E).setCellStyle(style108);
					}
					
					//headerRow.getCell(F).setCellStyle(style08);
					if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
						headerRow.getCell(F).setCellStyle(style08);
					}else {
						headerRow.getCell(F).setCellStyle(style108);
					}	
					
					//headerRow.getCell(G).setCellStyle(style08);
					if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
						headerRow.getCell(G).setCellStyle(style08);
					}else {
						headerRow.getCell(G).setCellStyle(style108);
					}	
					
					//headerRow.getCell(H).setCellStyle(style08);
					if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) >= 0){
						headerRow.getCell(H).setCellStyle(style08);
					}else {
						headerRow.getCell(H).setCellStyle(style108);
					}	
					headerRow.getCell(I).setCellStyle(style09);
				}
					
				double row11 = ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I"));
				double row21 = ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I"));
				double row31 = ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I"));
				double row41 = ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I"));
				

				sum11 += row11;
				sum21 += row21;
				sum31 += row31;
				sum41 += row41;
				
				z1 = z1 + 1;
				
			}
			
			headerRow = sheet1.createRow(9);
			
			headerRow.createCell(A).setCellValue("\n");				
			headerRow.getCell(A).setCellStyle(style00);
			
			headerRow.createCell(B).setCellValue("소     계");
			headerRow.createCell(C).setCellValue("소     계");
			
			//headerRow.createCell(D).setCellValue(sum11);
			if(sum11 == 0){
				headerRow.createCell(D).setCellValue("- ");
			} else {
				headerRow.createCell(D).setCellValue(sum11);
				
			}
			
			//headerRow.createCell(E).setCellValue(sum21);
			if(sum21 == 0){
				headerRow.createCell(E).setCellValue("- ");
			} else {
				headerRow.createCell(E).setCellValue(sum21);
				
			}
			
			//headerRow.createCell(F).setCellValue(sum31);
			if(sum31 == 0){
				headerRow.createCell(F).setCellValue("- ");
			} else {
				headerRow.createCell(F).setCellValue(sum31);
			}
			
			//headerRow.createCell(G).setCellValue(sum31);
			if(sum31 == 0){
				headerRow.createCell(G).setCellValue("- ");
			}else{
				headerRow.createCell(G).setCellValue(sum31);
			}
			
			//headerRow.createCell(H).setCellValue(sum41);
			if(sum41 == 0){
				headerRow.createCell(H).setCellValue("- ");
			} else {
				headerRow.createCell(H).setCellValue(sum41);
			}
			headerRow.createCell(I).setCellValue("");
			
			headerRow.getCell(B).setCellStyle(style24);  //합계
			headerRow.getCell(C).setCellStyle(style24);  //합계
			
			//headerRow.getCell(D).setCellStyle(style15);  //합계
			if(sum11 >= 0){
				headerRow.getCell(D).setCellStyle(style15);
			}else {
				headerRow.getCell(D).setCellStyle(style115);
			}
			
			//headerRow.getCell(E).setCellStyle(style15);  //합계
			if(sum21 >= 0){
				headerRow.getCell(E).setCellStyle(style15);
			}else {
				headerRow.getCell(E).setCellStyle(style115);
			}
			
			//headerRow.getCell(F).setCellStyle(style15);  //합계
			if(sum31 >= 0){
				headerRow.getCell(F).setCellStyle(style15);
			}else {
				headerRow.getCell(F).setCellStyle(style115);
			}
			
			//headerRow.getCell(G).setCellStyle(style15);  //합계
			if(sum31 >= 0){
				headerRow.getCell(G).setCellStyle(style15);
			}else {
				headerRow.getCell(G).setCellStyle(style115);
			}
			
			//headerRow.getCell(H).setCellStyle(style15);  //합계
			if(sum41 >= 0){
				headerRow.getCell(H).setCellStyle(style15);
			}else {
				headerRow.getCell(H).setCellStyle(style115);
			}
			
			headerRow.getCell(I).setCellStyle(style26);  //합계			
			

			////////////////////////////////////////////////////////////////////////
			//보통예금//
			////////////////////////////////////////////////////////////////////////
			if(ObjUtils.getSafeString(list2.get(i).get("ACCNT_SPEC")).equals("Z2")){								
				
				headerRow = sheet1.createRow(10 + z2);
				
				if(z2 == 0)
				{
					
					headerRow.createCell(A).setCellValue("\n");				
					headerRow.getCell(A).setCellStyle(style00);
				}					
					
				headerRow.createCell(A).setCellValue("\n");				
				headerRow.getCell(A).setCellStyle(style00);
				
				headerRow.createCell(B).setCellValue("  " + ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				headerRow.createCell(C).setCellValue("  " + ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				
				//headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) == 0){
					headerRow.createCell(D).setCellValue("- ");
				} else {
					headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				}
				
				//headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) == 0){
					headerRow.createCell(E).setCellValue("- ");
				} else {
					headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
					
				}
				
				//headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(F).setCellValue("- ");
				} else {
					headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(G).setCellValue("- ");
				} else {
					headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) == 0){
					headerRow.createCell(H).setCellValue("- ");
				}else{
					headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				}
				
				headerRow.createCell(I).setCellValue("");
				
				headerRow.getCell(B).setCellStyle(style07);
				headerRow.getCell(C).setCellStyle(style07);
				
				//headerRow.getCell(D).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) >= 0){
					headerRow.getCell(D).setCellStyle(style08);
				}else {
					headerRow.getCell(D).setCellStyle(style108);
				}
				
				//headerRow.getCell(E).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) >= 0){
					headerRow.getCell(E).setCellStyle(style08);
				}else {
					headerRow.getCell(E).setCellStyle(style108);
				}
				
				//headerRow.getCell(F).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(F).setCellStyle(style08);
				}else {
					headerRow.getCell(F).setCellStyle(style108);
				}
				
				//headerRow.getCell(G).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(G).setCellStyle(style08);
				}else {
					headerRow.getCell(G).setCellStyle(style108);
				}
				
				//headerRow.getCell(H).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) >= 0){
					headerRow.getCell(H).setCellStyle(style08);
				}else {
					headerRow.getCell(H).setCellStyle(style108);
				}
				
				headerRow.getCell(I).setCellStyle(style09);
				
				double row12 = ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I"));
				double row22 = ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I"));
				double row32 = ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I"));
				double row42 = ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I"));
				

				sum12 += row12;
				sum22 += row22;
				sum32 += row32;
				sum42 += row42;
				
				z2 = z2 + 1;
			}
			
			headerRow = sheet1.createRow(29);
			
			headerRow.createCell(A).setCellValue("\n");				
			headerRow.getCell(A).setCellStyle(style00);
			
			headerRow.createCell(B).setCellValue("소     계");
			headerRow.createCell(C).setCellValue("소     계");
			//headerRow.createCell(D).setCellValue(sum12);
			if(sum12 == 0){
				headerRow.createCell(D).setCellValue("- ");
			} else {
				headerRow.createCell(D).setCellValue(sum12);
			}
			
			//headerRow.createCell(E).setCellValue(sum22);
			if(sum22 == 0){
				headerRow.createCell(E).setCellValue("- ");
			} else {
				headerRow.createCell(E).setCellValue(sum22);
				
			}
			
			//headerRow.createCell(F).setCellValue(sum32);
			if(sum32 == 0){
				headerRow.createCell(F).setCellValue("- ");
			} else {
				headerRow.createCell(F).setCellValue(sum32);
			}
			
			//headerRow.createCell(G).setCellValue(sum32);
			if(sum32 == 0){
				headerRow.createCell(G).setCellValue("- ");
			} else {
				headerRow.createCell(G).setCellValue(sum32);
			}
			
			//headerRow.createCell(H).setCellValue(sum42);
			if(sum42 == 0){
				headerRow.createCell(H).setCellValue("- ");
			} else {
				headerRow.createCell(H).setCellValue(sum42);
			}
			
			headerRow.createCell(I).setCellValue("");
			
			headerRow.getCell(B).setCellStyle(style24);  //합계
			headerRow.getCell(C).setCellStyle(style24);  //합계
			
			//headerRow.getCell(D).setCellStyle(style15);  //합계
			if(sum12 >= 0){
				headerRow.getCell(D).setCellStyle(style15);
			}else {
				headerRow.getCell(D).setCellStyle(style115);
			}
			
			//headerRow.getCell(E).setCellStyle(style15);  //합계
			if(sum22 >= 0){
				headerRow.getCell(E).setCellStyle(style15);
			}else {
				headerRow.getCell(E).setCellStyle(style115);
			}
			
			//headerRow.getCell(F).setCellStyle(style15);  //합계
			if(sum32 >= 0){
				headerRow.getCell(F).setCellStyle(style15);
			}else {
				headerRow.getCell(F).setCellStyle(style115);
			}
			
			//headerRow.getCell(G).setCellStyle(style15);  //합계
			if(sum32 >= 0){
				headerRow.getCell(G).setCellStyle(style15);
			}else {
				headerRow.getCell(G).setCellStyle(style115);
			}
			
			//headerRow.getCell(H).setCellStyle(style15);  //합계
			if(sum42 >= 0){
				headerRow.getCell(H).setCellStyle(style15);
			}else {
				headerRow.getCell(H).setCellStyle(style115);
			}
			
			headerRow.getCell(I).setCellStyle(style26);  //합계
			
			
			////////////////////////////////////////////////////////////////////////
			//외화예금//
			////////////////////////////////////////////////////////////////////////
			if(ObjUtils.getSafeString(list2.get(i).get("ACCNT_SPEC")).equals("Z3")){
				headerRow = sheet1.createRow(30 + z3);
				headerRow.createCell(A).setCellValue("\n");				
				headerRow.getCell(A).setCellStyle(style00);
				headerRow.createCell(B).setCellValue("\n ");
				headerRow.getCell(B).setCellStyle(style11);
				
				//headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				headerRow.createCell(B).setCellValue("  " + ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				headerRow.createCell(C).setCellValue("  " + ObjUtils.getSafeString(list2.get(i).get("ACCNT_NAME")));
				
				//headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) == 0){
					headerRow.createCell(D).setCellValue("- ");
				} else {
					headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				}
				
				//headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) == 0){
					headerRow.createCell(E).setCellValue("- ");
				} else {
					headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				}
				
				//headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(F).setCellValue("- ");
				} else {
					headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(G).setCellValue("- ");
				} else {
					headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) == 0){
					headerRow.createCell(H).setCellValue("- ");
				} else {
					headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				}
				headerRow.createCell(I).setCellValue("");
				
				//headerRow.getCell(C).setCellStyle(style12);
				headerRow.getCell(B).setCellStyle(style12);
				headerRow.getCell(C).setCellStyle(style12);
				
				//headerRow.getCell(D).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) >= 0){
					headerRow.getCell(D).setCellStyle(style08);
				}else {
					headerRow.getCell(D).setCellStyle(style108);
				}
				
				//headerRow.getCell(E).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) >= 0){
					headerRow.getCell(E).setCellStyle(style08);
				}else {
					headerRow.getCell(E).setCellStyle(style108);
				}
				
				//headerRow.getCell(F).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(F).setCellStyle(style08);
				}else {
					headerRow.getCell(F).setCellStyle(style108);
				}
				
				//headerRow.getCell(G).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(G).setCellStyle(style08);
				}else {
					headerRow.getCell(G).setCellStyle(style108);
				}
				
				//headerRow.getCell(H).setCellStyle(style08);
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) >= 0){
					headerRow.getCell(H).setCellStyle(style08);
				}else {
					headerRow.getCell(H).setCellStyle(style108);
				}
				
				headerRow.getCell(I).setCellStyle(style09);
				
				double row13 = ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I"));
				double row23 = ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I"));
				double row33 = ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I"));
				double row43 = ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I"));
				

				sum13 += row13;
				sum23 += row23;
				sum33 += row33;
				sum43 += row43;
				
				z3 = z3 + 1;
			}	
			
			headerRow = sheet1.createRow(38);
			
			headerRow.createCell(A).setCellValue("\n");				
			headerRow.getCell(A).setCellStyle(style00);
			
			headerRow.createCell(B).setCellValue("소     계");
			headerRow.createCell(C).setCellValue("소     계");
			
			//headerRow.createCell(D).setCellValue(sum13);
			if(sum13 == 0){
				headerRow.createCell(D).setCellValue("- ");
			} else {
				headerRow.createCell(D).setCellValue(sum13);
			}
			
			//headerRow.createCell(E).setCellValue(sum23);
			if(sum23 == 0){
				headerRow.createCell(E).setCellValue("- ");
			} else {
				headerRow.createCell(E).setCellValue(sum23);
			}
			
			//headerRow.createCell(F).setCellValue(sum33);
			if(sum33 == 0){
				headerRow.createCell(F).setCellValue("- ");
			} else {
				headerRow.createCell(F).setCellValue(sum33);
			}
			
			//headerRow.createCell(G).setCellValue(sum33);
			if(sum33 == 0){
				headerRow.createCell(G).setCellValue("- ");
			} else {
				headerRow.createCell(G).setCellValue(sum33);
			}
			
			//headerRow.createCell(H).setCellValue(sum43);
			if(sum33 == 0){
				headerRow.createCell(H).setCellValue("- ");
			} else {
				headerRow.createCell(H).setCellValue(sum43);
			}
			
			headerRow.createCell(I).setCellValue("");
			
			headerRow.getCell(B).setCellStyle(style24);  //합계
			headerRow.getCell(C).setCellStyle(style24);  //합계
			//headerRow.getCell(D).setCellStyle(style15);  //합계
			if(sum13 >= 0){
				headerRow.getCell(D).setCellStyle(style15);
			}else {
				headerRow.getCell(D).setCellStyle(style115);
			}
			
			//headerRow.getCell(E).setCellStyle(style15);  //합계
			if(sum23 >= 0){
				headerRow.getCell(E).setCellStyle(style15);
			}else {
				headerRow.getCell(E).setCellStyle(style115);
			}
			
			//headerRow.getCell(F).setCellStyle(style15);  //합계
			if(sum33 >= 0){
				headerRow.getCell(F).setCellStyle(style15);
			}else {
				headerRow.getCell(F).setCellStyle(style115);
			}
			
			//headerRow.getCell(G).setCellStyle(style15);  //합계
			if(sum33 >= 0){
				headerRow.getCell(G).setCellStyle(style15);
			}else {
				headerRow.getCell(G).setCellStyle(style115);
			}
			
			//headerRow.getCell(H).setCellStyle(style15);  //합계
			if(sum43 >= 0){
				headerRow.getCell(H).setCellStyle(style15);
			}else {
				headerRow.getCell(H).setCellStyle(style115);
			}
			headerRow.getCell(I).setCellStyle(style26);  //합계
			
			headerRow = sheet1.createRow(39);
			
			headerRow.createCell(A).setCellValue("합          계");
			headerRow.createCell(B).setCellValue("합          계");
			headerRow.createCell(C).setCellValue("합          계");
			
			//headerRow.createCell(D).setCellValue(sum10 + sum11 + sum12 + sum13);
			if(sum10 + sum11 + sum12 + sum13 == 0){
				headerRow.createCell(D).setCellValue("- ");
			} else {
				headerRow.createCell(D).setCellValue(sum10 + sum11 + sum12 + sum13);
			}
			
			//headerRow.createCell(E).setCellValue(sum20 + sum21 + sum22 + sum23);
			if(sum20 + sum21 + sum22 + sum23 == 0){
				headerRow.createCell(E).setCellValue("- ");
			} else {
				headerRow.createCell(E).setCellValue(sum20 + sum21 + sum22 + sum23);
			}
			
			//headerRow.createCell(F).setCellValue(sum30 + sum31 + sum32 + sum33);
			if(sum30 + sum31 + sum32 + sum33 == 0){
				headerRow.createCell(F).setCellValue("- ");
			} else {
				headerRow.createCell(F).setCellValue(sum30 + sum31 + sum32 + sum33);
			}
			
			//headerRow.createCell(G).setCellValue(sum30 + sum31 + sum32 + sum33);
			if(sum30 + sum31 + sum32 + sum33 == 0){
				headerRow.createCell(G).setCellValue("- ");
			} else {
				headerRow.createCell(G).setCellValue(sum30 + sum31 + sum32 + sum33);
			}
			
			//headerRow.createCell(H).setCellValue(sum40 + sum41 + sum42 + sum43);
			if(sum40 + sum41 + sum42 + sum43 == 0){
				headerRow.createCell(H).setCellValue("- ");
			} else {
				headerRow.createCell(H).setCellValue(sum40 + sum41 + sum42 + sum43);
			}
			
			headerRow.createCell(I).setCellValue("");
			
			headerRow.getCell(A).setCellStyle(style24);  //합계
			headerRow.getCell(B).setCellStyle(style24);  //합계
			headerRow.getCell(C).setCellStyle(style24);  //합계
			
			//headerRow.getCell(D).setCellStyle(style15);  //합계
			if(sum10 + sum11 + sum12 + sum13 >= 0){
				headerRow.getCell(D).setCellStyle(style15);
			}else {
				headerRow.getCell(D).setCellStyle(style115);
			}
			
			//headerRow.getCell(E).setCellStyle(style15);  //합계
			if(sum20 + sum21 + sum22 + sum23 >= 0){
				headerRow.getCell(E).setCellStyle(style15);
			}else {
				headerRow.getCell(E).setCellStyle(style115);
			}
			
			//headerRow.getCell(F).setCellStyle(style15);  //합계
			if(sum30 + sum31 + sum32 + sum33 >= 0){
				headerRow.getCell(F).setCellStyle(style15);
			}else {
				headerRow.getCell(F).setCellStyle(style115);
			}
			
			//headerRow.getCell(G).setCellStyle(style15);  //합계
			if(sum30 + sum31 + sum32 + sum33 >= 0){
				headerRow.getCell(G).setCellStyle(style15);
			}else {
				headerRow.getCell(G).setCellStyle(style115);
			}
			
			//headerRow.getCell(H).setCellStyle(style15);  //합계
			if(sum40 + sum41 + sum42 + sum43 >= 0){
				headerRow.getCell(H).setCellStyle(style15);
			}else {
				headerRow.getCell(H).setCellStyle(style115);
			}
			
			headerRow.getCell(I).setCellStyle(style26);  //합계
					
			if(ObjUtils.getSafeString(list2.get(i).get("ACCNT_SPEC")).equals("ZZ")){
				headerRow = sheet1.createRow(40);
				headerRow.createCell(A).setCellValue("받  을  어  음");
				headerRow.createCell(B).setCellValue("받  을  어  음");
				headerRow.createCell(C).setCellValue("받  을  어  음");
				
				//headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) == 0){
					headerRow.createCell(D).setCellValue("- ");
				} else {
					headerRow.createCell(D).setCellValue(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")));
				}
				
				//headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) == 0){
					headerRow.createCell(E).setCellValue("- ");
				} else {
					headerRow.createCell(E).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")));
				}
				
				//headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(F).setCellValue("- ");
				} else {
					headerRow.createCell(F).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) == 0){
					headerRow.createCell(G).setCellValue("- ");
				} else {
					headerRow.createCell(G).setCellValue(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")));
				}
				
				//headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) == 0){
					headerRow.createCell(H).setCellValue("- ");
				} else {
					headerRow.createCell(H).setCellValue(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")));
				}
				headerRow.createCell(I).setCellValue("");
				
				headerRow.getCell(A).setCellStyle(style01);
				headerRow.getCell(B).setCellStyle(style01);
				headerRow.getCell(C).setCellStyle(style01);
				
				//headerRow.getCell(D).setCellStyle(style02);
				if(ObjUtils.parseDouble(list2.get(i).get("IWALL_AMT_I")) >= 0){
					headerRow.getCell(D).setCellStyle(style02);
				}else {
					headerRow.getCell(D).setCellStyle(style102);
				}
				
				//headerRow.getCell(E).setCellStyle(style02);
				if(ObjUtils.parseDouble(list2.get(i).get("DR_AMT_I")) >= 0){
					headerRow.getCell(E).setCellStyle(style02);
				}else {
					headerRow.getCell(E).setCellStyle(style102);
				}
				
				//headerRow.getCell(F).setCellStyle(style02);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(F).setCellStyle(style02);
				}else {
					headerRow.getCell(F).setCellStyle(style102);
				}
				
				//headerRow.getCell(G).setCellStyle(style02);
				if(ObjUtils.parseDouble(list2.get(i).get("CR_AMT_I")) >= 0){
					headerRow.getCell(G).setCellStyle(style02);
				}else {
					headerRow.getCell(G).setCellStyle(style102);
				}
				
				//headerRow.getCell(H).setCellStyle(style02);
				if(ObjUtils.parseDouble(list2.get(i).get("JAN_AMT_I")) >= 0){
					headerRow.getCell(H).setCellStyle(style02);
				}else {
					headerRow.getCell(H).setCellStyle(style102);
				}
				headerRow.getCell(I).setCellStyle(style03);		
				
			}
			
		}
	
		headerRow = sheet1.createRow(50);		
		headerRow.createCell(B).setCellValue(user.getCompName());
		headerRow.getCell(B).setCellStyle(style113);
	
		
		return workbook;
	}
}
