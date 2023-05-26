package foren.unilite.modules.busevaluation.grg;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.*;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("grgExcelService")
public class GrgExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	
	
	@Resource(name="grg100ukrvService")
	private Grg100ukrvServiceImpl grg100ukrvService;
	
	public Workbook  selectExcel1(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) grg100ukrvService.selectExcel1(param);
		
		
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grg100.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 
		
		Row  row = sheet.getRow(1);
		Cell cell = row.getCell(0);
	    cell.setCellValue("G1.손익계산서("+ObjUtils.getSafeString(param.get("SERVICE_YEAR"))+")");
	    
	    row = sheet.getRow(3);
	    cell = row.getCell(19);
	    cell.setCellValue(ObjUtils.getSafeString(param.get("SERVICE_YEAR")));
	    

	    row = sheet.getRow(5);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_01")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_42")));
	    
	    row = sheet.getRow(6);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_02")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_43")));
	    
	    row = sheet.getRow(7);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_03")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_44")));
	    
	    row = sheet.getRow(8);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_04")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_45")));
	    
	    row = sheet.getRow(9);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_05")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_46")));
	    
	    row = sheet.getRow(10);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_06")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_47")));
	    
	    row = sheet.getRow(11);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_07")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_48")));
	    
	    row = sheet.getRow(12);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_08")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_49")));
	    
	    row = sheet.getRow(13);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_09")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_50")));
	    
	    row = sheet.getRow(14);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_10")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_51")));
	    
	    row = sheet.getRow(15);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_11")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_52")));
	    
	    row = sheet.getRow(16);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_12")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_53")));
	    
	    row = sheet.getRow(17);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_13")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_54")));
	    
	    row = sheet.getRow(18);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_14")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_55")));
	    
	    row = sheet.getRow(19);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_15")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_56")));
	    
	    row = sheet.getRow(20);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_16")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_57")));
	    
	    row = sheet.getRow(21);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_17")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_58")));
	    
	    row = sheet.getRow(22);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_18")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_59")));
	    
	    row = sheet.getRow(23);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_19")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_60")));
	    
	    row = sheet.getRow(24);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_20")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_61")));
	    
	    row = sheet.getRow(25);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_21")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_62")));
	    
	    row = sheet.getRow(26);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_22")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_63")));
	    
	    row = sheet.getRow(27);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_23")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_64")));
	    
	    row = sheet.getRow(28);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_24")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_65")));
	    
	    row = sheet.getRow(29);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_25")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_66")));
	    
	    row = sheet.getRow(30);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_26")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_67")));
	    
	    row = sheet.getRow(31);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_27")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_68")));
	    
	    row = sheet.getRow(32);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_28")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_69")));
	    
	    row = sheet.getRow(33);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_29")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_70")));
	    
	    row = sheet.getRow(34);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_30")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_71")));
	    
	    row = sheet.getRow(35);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_31")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_72")));
	    
	    row = sheet.getRow(36);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_32")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_73")));
	    
	    row = sheet.getRow(37);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_33")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_74")));
	    
	    row = sheet.getRow(38);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_34")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_75")));
	    
	    row = sheet.getRow(39);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_35")));
	    
	    row = sheet.getRow(40);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_36")));
	    
	    row = sheet.getRow(41);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_37")));
	    
	    row = sheet.getRow(42);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_38")));
	    
	    row = sheet.getRow(43);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_39")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_80")));
	    
	    row = sheet.getRow(44);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_40")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_81")));
	    
	    row = sheet.getRow(45);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_41")));
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("G_82")));
	    
	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
	@Resource(name="grg200ukrvService")
	private Grg200ukrvServiceImpl grg200ukrvService;
	
	public Workbook  selectlist(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) grg200ukrvService.selectList(param);
		
		
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grg200.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 

	    
	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
	
}
