package foren.unilite.modules.z_hs;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_hat530rkr_hsService")
public class S_Hat530rkr_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectHBS400T(Map param) throws Exception {
		return (List) super.commonDao.list("s_hat530rkr_hsServiceImpl.selectHBS400T", param);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectDutyCode(Map param) throws Exception {
		return (List) super.commonDao.list("s_hat530rkr_hsServiceImpl.selectDutyCode", param);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selectToPrint(Map param) throws Exception {
		return (List) super.commonDao.list("s_hat530rkr_hsServiceImpl.selectToPrint", param);
	}
	
	/**
	 * BOM 전체 데이터 엑셀다운로드 로직: 20191217
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "human", value = ExtDirectMethodType.STORE_READ )
	public Workbook makeExcelData( Map param ) throws Exception {
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "s_hat530rkr_hs.xlsx"));

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
		
		double sum0 = 0;
		double sum1 = 0;
		double sum2 = 0;
		double sum3 = 0;
		double sum4 = 0;
		
        // 본문및합계폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)10);
        
        
     // 타이틀폰트
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)12);
        font2.setBoldweight((short)Font.BOLDWEIGHT_BOLD);
        font2.setFontName("맑은 고딕");
        
        //Style 01 : 좌측볼드 테두리
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_THIN);
        style01.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style01.setBorderRight(CellStyle.BORDER_THIN);
        style01.setBorderTop(CellStyle.BORDER_THIN);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);
        
        //Style 02 : 우측볼드테드리
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_THIN);
        style02.setBorderLeft(CellStyle.BORDER_THIN);
        style02.setBorderRight(CellStyle.BORDER_MEDIUM);
        style02.setBorderTop(CellStyle.BORDER_THIN);
        style02.setAlignment(CellStyle.ALIGN_CENTER);
        style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setFont(font);

        // Style 03 : 본문 중앙정렬
        CellStyle style03 = workbook.createCellStyle();
        style03.setBorderBottom(CellStyle.BORDER_THIN);
        style03.setBorderLeft(CellStyle.BORDER_THIN);
        style03.setBorderRight(CellStyle.BORDER_THIN);
        style03.setBorderTop(CellStyle.BORDER_THIN);
        style03.setAlignment(CellStyle.ALIGN_CENTER);
        style03.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style03.setFont(font);

        // Style 04 : 본문 숫자 우측정렬
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        style04.setBorderLeft(CellStyle.BORDER_THIN);
        style04.setBorderRight(CellStyle.BORDER_THIN);
        style04.setBorderTop(CellStyle.BORDER_THIN);
        style04.setAlignment(CellStyle.ALIGN_RIGHT);
        style04.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style04.setDataFormat(format.getFormat("#,##0.0"));
        style04.setFont(font);
        
        // Style 05 : 본문문자컬러
        CellStyle style05 = workbook.createCellStyle();
        style05.setBorderBottom(CellStyle.BORDER_THIN);
        style05.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        style05.setBorderTop(CellStyle.BORDER_THIN);
        style05.setAlignment(CellStyle.ALIGN_CENTER);
        style05.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style05.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style05.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style05.setFont(font);
        
        // Style 05 : 우측숫자컬러
        CellStyle style06 = workbook.createCellStyle();
        style06.setBorderBottom(CellStyle.BORDER_THIN);
        style06.setBorderLeft(CellStyle.BORDER_THIN);
        style06.setBorderRight(CellStyle.BORDER_THIN);
        style06.setBorderTop(CellStyle.BORDER_THIN);
        style06.setAlignment(CellStyle.ALIGN_RIGHT);
        style06.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style06.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style06.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style06.setDataFormat(format.getFormat("#,##0.0"));
        style06.setFont(font);
        
        //Style 01 : 좌측볼드 테두리
        CellStyle style07 = workbook.createCellStyle();
        style07.setBorderBottom(CellStyle.BORDER_THIN);
        style07.setBorderLeft(CellStyle.BORDER_MEDIUM);
        style07.setBorderRight(CellStyle.BORDER_THIN);
        style07.setBorderTop(CellStyle.BORDER_THIN);
        style07.setAlignment(CellStyle.ALIGN_CENTER);
        style07.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style07.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style07.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style07.setFont(font);
        
        //Style 02 : 우측볼드테드리
        CellStyle style08 = workbook.createCellStyle();
        style08.setBorderBottom(CellStyle.BORDER_THIN);
        style08.setBorderLeft(CellStyle.BORDER_THIN);
        style08.setBorderRight(CellStyle.BORDER_MEDIUM);
        style08.setBorderTop(CellStyle.BORDER_THIN);
        style08.setAlignment(CellStyle.ALIGN_CENTER);
        style08.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style08.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style08.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style08.setFont(font);
        
        // Style 01 : 타이틀 중앙정렬
        CellStyle style09 = workbook.createCellStyle();
        style09.setAlignment(CellStyle.ALIGN_CENTER);
        style09.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style09.setFont(font2);
		
		String crfFile = "";		
		String dutyInputRuleStr = "N";
		
		List<Map> list1 = super.commonDao.list("s_hat530rkr_hsServiceImpl.selectHBS400T", param);
		//List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
		
		if (list1 != null && list1.size() > 0) {
			
			Map<String, Object> map = list1.get(0);
			
			param.put("FROM_WEEK", map.get("FROM_WEEK"));
			param.put("TO_WEEK", map.get("TO_WEEK"));
			
		}
		
				
		List<Map> list2 = super.commonDao.list("s_hat530rkr_hsServiceImpl.selectToPrint", param);
		
		headerRow = sheet1.createRow(1);
		headerRow.createCell(B).setCellValue("근태일자 : " +  param.get("DUTY_DATE_FR").toString().substring(0, 4) + "." + param.get("DUTY_DATE_FR").toString().substring(4, 6) +"." +param.get("DUTY_DATE_FR").toString().substring(6, 8) + "_" + param.get("FROM_WEEK").toString() 
				+ "~" + param.get("DUTY_DATE_TO").toString().substring(0, 4) + "." + param.get("DUTY_DATE_TO").toString().substring(4, 6) +"." + param.get("DUTY_DATE_TO").toString().substring(6, 8)+ "_" + param.get("TO_WEEK").toString());
		
		headerRow.getCell(B).setCellStyle(style09);
		
		headerRow.setHeight((short)700);
		
		
		
		for(int i = 0; i < list2.size(); i++) {
			
			headerRow = sheet1.createRow(2);
			headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list2.get(0).get("DIV_CODE")));
			
			headerRow = sheet1.createRow(6 + i);
			headerRow.createCell(B).setCellValue(i+1);
			headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list2.get(i).get("DEPT_NAME")));
			headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list2.get(i).get("POST_NAME")));
			headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list2.get(i).get("NAME")));
			
			headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list2.get(i).get("DUTY_FR_D")));
			headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list2.get(i).get("DUTY_TO_D")));
			headerRow.createCell(H).setCellValue(ObjUtils.getSafeString(list2.get(i).get("WORK_TEAM")));
			
			//parseDouble
			headerRow.createCell(I).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DUTY0")));
			headerRow.createCell(J).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DUTY1")));
			headerRow.createCell(K).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DUTY2")));
			headerRow.createCell(L).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DUTY3")));
			headerRow.createCell(M).setCellValue(ObjUtils.parseDouble(list2.get(i).get("DUTY4")));
			headerRow.createCell(N).setCellValue(ObjUtils.getSafeString(list2.get(i).get("REMARK")));
			
			headerRow.getCell(B).setCellStyle(style01);
			headerRow.getCell(C).setCellStyle(style03);
			headerRow.getCell(D).setCellStyle(style03);
			headerRow.getCell(E).setCellStyle(style03);
			headerRow.getCell(F).setCellStyle(style03);
			headerRow.getCell(G).setCellStyle(style03);
			headerRow.getCell(H).setCellStyle(style03);
			
			headerRow.getCell(I).setCellStyle(style04);
			headerRow.getCell(J).setCellStyle(style04);
			headerRow.getCell(K).setCellStyle(style04);
			headerRow.getCell(L).setCellStyle(style04);
			headerRow.getCell(M).setCellStyle(style04);
			headerRow.getCell(N).setCellStyle(style02);
			
			headerRow.setHeight((short)400);
			
			double row0 = ObjUtils.parseDouble(list2.get(i).get("DUTY0"));
			double row1 = ObjUtils.parseDouble(list2.get(i).get("DUTY1"));
			double row2 = ObjUtils.parseDouble(list2.get(i).get("DUTY2"));
			double row3 = ObjUtils.parseDouble(list2.get(i).get("DUTY3"));
			double row4 = ObjUtils.parseDouble(list2.get(i).get("DUTY4"));
			
			sum0 += row0;
			sum1 += row1;
			sum2 += row2;
			sum3 += row3;
			sum4 += row4;
			
			
			
			
			//
			/*headerRow.createCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("CHILD_ITEM_CODE")));
			headerRow.createCell(C).setCellValue(ObjUtils.getSafeString(list1.get(i).get("START_DATE")));
			headerRow.createCell(D).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PATH_CODE")));
			headerRow.createCell(E).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SEQ")));
			headerRow.createCell(F).setCellValue(ObjUtils.getSafeString(list1.get(i).get("GRANT_TYPE")));
			headerRow.createCell(G).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_Q")));
			headerRow.createCell(H).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PROD_UNIT_Q")));
			headerRow.createCell(I).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LOSS_RATE")));
			headerRow.createCell(J).setCellValue(ObjUtils.getSafeString(list1.get(i).get("USE_YN")));
			headerRow.createCell(K).setCellValue(ObjUtils.getSafeString(list1.get(i).get("BOM_YN")));
			headerRow.createCell(L).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P1")));
			headerRow.createCell(M).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P2")));
			headerRow.createCell(N).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UNIT_P3")));
			headerRow.createCell(O).setCellValue(ObjUtils.getSafeString(list1.get(i).get("MAN_HOUR")));
			headerRow.createCell(P).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SET_QTY")));
			headerRow.createCell(Q).setCellValue(ObjUtils.getSafeString(list1.get(i).get("REMARK")));
			headerRow.createCell(R).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PROC_DRAW")));
			headerRow.createCell(S).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LAB_NO")));
			headerRow.createCell(T).setCellValue(ObjUtils.getSafeString(list1.get(i).get("REQST_ID")));
			headerRow.createCell(U).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SAMPLE_KEY")));
			headerRow.createCell(V).setCellValue(ObjUtils.getSafeString(list1.get(i).get("GROUP_CODE")));*/
			

		}
		headerRow = sheet1.createRow(5);
		headerRow.createCell(I).setCellValue(sum0);
		headerRow.createCell(J).setCellValue(sum1);
		headerRow.createCell(K).setCellValue(sum2);
		headerRow.createCell(L).setCellValue(sum3);
		headerRow.createCell(M).setCellValue(sum4);
		
		headerRow.createCell(B).setCellValue("합계");
		headerRow.createCell(C).setCellValue("");
		headerRow.createCell(D).setCellValue("");
		headerRow.createCell(E).setCellValue("");
		headerRow.createCell(F).setCellValue("");
		headerRow.createCell(G).setCellValue("");
		headerRow.createCell(H).setCellValue("");
		headerRow.createCell(N).setCellValue("");
		
		headerRow.getCell(B).setCellStyle(style07);
		headerRow.getCell(C).setCellStyle(style05);
		headerRow.getCell(D).setCellStyle(style05);
		headerRow.getCell(E).setCellStyle(style05);
		headerRow.getCell(F).setCellStyle(style05);
		headerRow.getCell(G).setCellStyle(style05);
		headerRow.getCell(H).setCellStyle(style05);
		
		headerRow.getCell(I).setCellStyle(style06);
		headerRow.getCell(J).setCellStyle(style06);
		headerRow.getCell(K).setCellStyle(style06);
		headerRow.getCell(L).setCellStyle(style06);
		headerRow.getCell(M).setCellStyle(style06);
		headerRow.getCell(N).setCellStyle(style08);
		
		//headerRow.getCell(C).setCellStyle(style05);
		//headerRow.getCell(D).setCellStyle(style05);
		//headerRow.getCell(E).setCellStyle(style05);
		
		headerRow.setHeight((short)500);
			


	
	
		return workbook;
		}

	}
