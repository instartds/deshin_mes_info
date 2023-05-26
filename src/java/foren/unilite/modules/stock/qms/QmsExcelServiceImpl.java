package foren.unilite.modules.stock.qms;

import java.io.File;
import java.io.FileInputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
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

@Service( "qmsExcelService" )
@SuppressWarnings({ "rawtypes", "unchecked" })
public class QmsExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource( name = "qms703skrvService" )
	private Qms703skrvServiceImpl qms703skrvService;

	public Workbook makeExcel( Map param ) throws Exception {
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "qms703skrv_v2.xlsx"));

		//Get the workbook instance for XLS file
		XSSFWorkbook workbook = new XSSFWorkbook(file);
		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
		FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
		//Get first sheet from the workbook
		Sheet sheet1 = workbook.getSheetAt(2);
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
		String date_s = " 2011-01-18 00:00:00";
		Date d = new Date();
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		String oldstring = "";

		List<Map> list1 = super.commonDao.list("qms703skrvServiceImpl.selectList", param);
		for(int i = 0; i < list1.size(); i++) {
			sheet1.getRow(1 + i).getCell(A).setCellValue(ObjUtils.getSafeString(list1.get(i).get("LOT_NO")));
			sheet1.getRow(1 + i).getCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_CODE")));
			sheet1.getRow(1 + i).getCell(C).setCellValue(ObjUtils.getSafeString(list1.get(i).get("SPEC")));
			sheet1.getRow(1 + i).getCell(D).setCellValue(ObjUtils.parseDouble(list1.get(i).get("WKORD_Q")));
			sheet1.getRow(1 + i).getCell(E).setCellValue(ObjUtils.getSafeString(list1.get(i).get("CUSTOM_NAME")));
			//20200512 수정: PRODT_DATE_PRINT -> PRODT_DATE
			oldstring = ObjUtils.getSafeString(list1.get(i).get("PRODT_DATE"));
			//20200512 수정: 날짜cell 속성주기위해 수정
//			Date date = new SimpleDateFormat("yyyy-MM-dd").parse(oldstring);
//			sheet1.getRow(1 + i).getCell(F).setCellValue(date);
			//20200512_1. 폰트 설정
			Font font = workbook.createFont();
			font.setFontName("맑은 고딕");
			font.setFontHeightInPoints((short)9);
			//20200512_2. cell 스타일 설정
			CellStyle style = workbook.createCellStyle();
			style.setAlignment(CellStyle.ALIGN_CENTER);
			style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			style.setFont(font);
			sheet1.getRow(1 + i).getCell(F).setCellStyle(style);
			//20200512_3. data 보여줄 형식 변경하여 set
			sheet1.getRow(1 + i).getCell(F).setCellValue(oldstring.substring(0, 4) + '.' + oldstring.substring(4, 6) + '.' + oldstring.substring(6, 8));
			sheet1.getRow(1 + i).getCell(G).setCellValue(ObjUtils.getSafeString(list1.get(i).get("UPN_CODE")));
		}
		return workbook;
	}

	public static String formattedDate
	(String date, String fromFormatString, String toFormatString) {
		SimpleDateFormat fromFormat =
			new SimpleDateFormat(fromFormatString);
		SimpleDateFormat toFormat =
			new SimpleDateFormat(toFormatString);
		Date fromDate = null;

		try
		{
			fromDate = fromFormat.parse(date);
		}
		catch(ParseException e)
		{
			fromDate = new Date();
		}
		return toFormat.format(fromDate);
	}
}