package foren.unilite.modules.busevaluation.grc;

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


@Service("grcExcelService")
public class GrcExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="grc100ukrvService")
	private Grc100ukrvServiceImpl grc100ukrvService;
	
	
	public Workbook  selectList(Map param) throws Exception {	
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grc100.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		
		Row  row = sheet.getRow(2);
		Cell cell = row.getCell(0);
	    cell.setCellValue("기준년도: "+ObjUtils.getSafeString(param.get("SERVICE_YEAR"))+".12.31");
	    
		List<Map<Object, String>>	dataList = grc100ukrvService.selectList(param);
		for (int i = 0; i < dataList.size(); i++) {
			Map<Object, String> data = dataList.get(i);
			row = sheet.getRow(i + 7);//7은 Excel 시트에서 최초 세팅해줄 Row 반복문으로 row인 i가 1씩 증가 
			cell = row.getCell(5);
			cell.setCellValue(ObjUtils.getSafeString(data.get("OWN_SUM")));
			cell = row.getCell(6);
			cell.setCellValue(ObjUtils.getSafeString(data.get("OWN_GAN_GEN")));
			cell = row.getCell(7);
			cell.setCellValue(ObjUtils.getSafeString(data.get("OWN_CNG_GEN")));
			cell = row.getCell(8);
			cell.setCellValue(ObjUtils.getSafeString(data.get("OWN_CNG_LOW")));   
			//Excell set 구현..
		}
		 return workbook;
    }
	
}
