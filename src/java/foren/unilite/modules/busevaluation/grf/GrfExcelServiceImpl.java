package foren.unilite.modules.busevaluation.grf;

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


@Service("grfExcelService")
public class GrfExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	
	
	@Resource(name="grf100ukrvService")
	private Grf100ukrvServiceImpl grf100ukrvService;
	
	public Workbook  selectList(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) grf100ukrvService.selectExcel(param);		
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grf100.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 
		
		Row  row = sheet.getRow(1);
		Cell cell = row.getCell(0);
	    cell.setCellValue("F.재무상태표");
    
		row = sheet.getRow(3);
		cell = row.getCell(19);
	    cell.setCellValue(ObjUtils.getSafeString(ObjUtils.getSafeString(param.get("SERVICE_YEAR"))));
	    
	    row = sheet.getRow(5);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_01")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_37")));	    
  
	    row = sheet.getRow(6);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_02")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_38")));	
	    
	    row = sheet.getRow(7);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_03")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_39")));
	    
	    row = sheet.getRow(8);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_04")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_40")));
	    
	    row = sheet.getRow(9);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_05")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_41")));
	    
	    row = sheet.getRow(10);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_06")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_42")));
	    
	    row = sheet.getRow(11);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_07")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_43")));
	    
	    row = sheet.getRow(12);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_08")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_44")));
	    
	    row = sheet.getRow(13);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_09")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_45")));
	    
	    row = sheet.getRow(14);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_10")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_46")));
	    
	    row = sheet.getRow(15);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_11")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_47")));
	    
	    row = sheet.getRow(16);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_12")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_48")));
	    
	    row = sheet.getRow(17);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_13")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_49")));
	    
	    row = sheet.getRow(18);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_14")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_50")));
	    
	    row = sheet.getRow(19);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_15")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_51")));
	    
	    row = sheet.getRow(20);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_16")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_52")));
	    
	    row = sheet.getRow(21);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_17")));	    
//	    cell = row.getCell(21);
//	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_53")));
	    
	    row = sheet.getRow(22);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_18")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_54")));
	    
	    row = sheet.getRow(23);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_19")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_55")));
	    
	    row = sheet.getRow(24);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_20")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_56")));
	    
	    row = sheet.getRow(25);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_21")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_57")));
	    
	    row = sheet.getRow(26);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_22")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_58")));

	    row = sheet.getRow(27);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_23")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_59")));
	    
	    row = sheet.getRow(28);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_24")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_60")));
    
	    row = sheet.getRow(29);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_25")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_61")));
	    
	    row = sheet.getRow(30);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_26")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_62")));
 
	    row = sheet.getRow(31);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_27")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_63")));
	    
	    row = sheet.getRow(32);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_28")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_64")));
	    
	    row = sheet.getRow(33);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_29")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_65")));
	    
	    row = sheet.getRow(34);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_30")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_66")));
	    
	    row = sheet.getRow(35);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_31")));	    
//	    cell = row.getCell(21);
//	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_67")));
	    
	    row = sheet.getRow(36);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_32")));	    
//	    cell = row.getCell(21);
//	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_68")));
	    
	    row = sheet.getRow(37);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_33")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_69")));
	    
	    row = sheet.getRow(38);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_34")));	    
//	    cell = row.getCell(21);
//	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_70")));
	    
	    row = sheet.getRow(39);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_35")));	    
	    cell = row.getCell(21);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_70")));
	    
	    row = sheet.getRow(40);
		cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("F_36")));	 
//	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
}
