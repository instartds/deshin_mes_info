package foren.unilite.modules.busevaluation.gra;

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


@Service("graExcelService")
public class GraExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	
	
	@Resource(name="gra100ukrvService")
	private Gra100ukrvServiceImpl gra100ukrvService;
	
	public Workbook  selectList(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) gra100ukrvService.selectList(param);
		int stockNumTot = ObjUtils.parseInt(data.get("STOCK_NUM_TOT"));
		int stockNum1 = ObjUtils.parseInt(data.get("STOCK_NUM1"));
		int stockNum2 = ObjUtils.parseInt(data.get("STOCK_NUM2"));
		int stockNum3 = ObjUtils.parseInt(data.get("STOCK_NUM3"));
		int stockNum4 = ObjUtils.parseInt(data.get("STOCK_NUM4"));
		int stockNumEtc = ObjUtils.parseInt(data.get("STOCK_NUM_ETC"));
		
		float stockRate1 = stockNumTot == 0 ? 0:ObjUtils.parseFloat(ObjUtils.getSafeString(Math.floor(stockNum1/ObjUtils.parseDouble(stockNumTot) * 100 *100)/100));
		float stockRate2 = stockNumTot == 0 ? 0:ObjUtils.parseFloat(ObjUtils.getSafeString(Math.floor(stockNum2/ObjUtils.parseDouble(stockNumTot) * 100 *100)/100));
		float stockRate3 = stockNumTot == 0 ? 0:ObjUtils.parseFloat(ObjUtils.getSafeString(Math.floor(stockNum3/ObjUtils.parseDouble(stockNumTot) * 100 *100)/100));
		float stockRate4 = stockNumTot == 0 ? 0:ObjUtils.parseFloat(ObjUtils.getSafeString(Math.floor(stockNum4/ObjUtils.parseDouble(stockNumTot) * 100 *100)/100));
		float stockRateEtc = stockNumTot == 0 ? 0:ObjUtils.parseFloat(ObjUtils.getSafeString(Math.floor(stockNumEtc/ObjUtils.parseDouble(stockNumTot) * 100 *100)/100));
		
		
		int inLargeGen =  ObjUtils.parseInt(data.get("IN_LARGE_GEN"));
		int inLargeCtr =  ObjUtils.parseInt(data.get("IN_LARGE_CTR"));
		int inLargePub =  ObjUtils.parseInt(data.get("IN_LARGE_PUB"));
		int inMediumGen =  ObjUtils.parseInt(data.get("IN_MEDIUM_GEN"));
		int inMediumCtr =  ObjUtils.parseInt(data.get("IN_MEDIUM_CTR"));
		int inMediumPub =  ObjUtils.parseInt(data.get("IN_MEDIUM_PUB"));
		int inExpGen =  ObjUtils.parseInt(data.get("IN_EXPRESS_GEN"));
		int inNonStopGen =  ObjUtils.parseInt(data.get("IN_NONSTOP_GEN"));
		int outSlowGen =  ObjUtils.parseInt(data.get("OUT_SLOW_GEN"));
		int outNonStopGen =  ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN"));
		int outAirGen =  ObjUtils.parseInt(data.get("OUT_AIR_GEN"));
		int airLimitGen =  ObjUtils.parseInt(data.get("AIR_LIMIT_GEN"));
		int etcVilleageGen =  ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN"));
		
		int generalSum = inLargeGen + inMediumGen + inExpGen + inNonStopGen + outSlowGen + outNonStopGen + outAirGen + airLimitGen + etcVilleageGen;
		int regionalSum = inLargeCtr + inMediumCtr ;
		int publicSum = inLargePub + inMediumPub;
		
		int inLargeSum = inLargeGen + inLargeCtr + inLargePub;
		int inMediumSum = inMediumGen + inMediumCtr + inMediumPub;
		
		int totalSum = generalSum + regionalSum + publicSum;
		
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"gra100.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 
		
		Row  row = sheet.getRow(2);
		Cell cell = row.getCell(0);
	    cell.setCellValue("기준년도: "+ObjUtils.getSafeString(param.get("SERVICE_YEAR"))+".12.31");
	   
	    
		row = sheet.getRow(3);
		cell = row.getCell(1);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("COMP_NAME")));
	    cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("COMP_ID")));	    
	    cell = row.getCell(5);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("COMPANY_NUM")));
	    
	    row = sheet.getRow(5);
		cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADDR2")));	    
	    cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADDR3")));	    
	    cell = row.getCell(4);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADDR4")));
		    
		row = sheet.getRow(6);
		cell = row.getCell(1);
	    cell.setCellValue(ObjUtils.parseInt(data.get("CAPITAL_AMT")));
		    
		row = sheet.getRow(7);
		cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.parseInt(data.get("STOCKHOLDER_NUM")));    
	    cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("STOCKHOLDER_NAME1")));
	    cell = row.getCell(4);
	    cell.setCellValue(stockNum1);
	    cell = row.getCell(5);
	    cell.setCellValue(stockRate1);
	    
		row = sheet.getRow(8);
		cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("STOCKHOLDER_NAME2")));	   
	    cell = row.getCell(4);
	    cell.setCellValue(stockNum2);
	    cell = row.getCell(5);
	    cell.setCellValue(stockRate2);
	    
	    row = sheet.getRow(9);
	    cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.parseInt(data.get("EXECUTIVE_NUM")));	    
		cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("STOCKHOLDER_NAME3")));	  
	    cell = row.getCell(4);  
	    cell.setCellValue(stockNum3);
	    cell = row.getCell(5);
	    cell.setCellValue(stockRate3);
	    
	    row = sheet.getRow(10);
	    cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.parseInt(data.get("ADMINISTRATIVE_NUM")));	
		cell = row.getCell(3);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("STOCKHOLDER_NAME4")));	  
	    cell = row.getCell(4);  
	    cell.setCellValue(stockNum4);
	    cell = row.getCell(5);
	    cell.setCellValue(stockRate4);
	    
	    
	    row = sheet.getRow(11);   
	    cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.parseInt(data.get("DRIVER_NUM")));	
	    cell = row.getCell(4);
	    cell.setCellValue(stockNumEtc);
	    cell = row.getCell(5);
	    cell.setCellValue(stockRateEtc);
	    
	    row = sheet.getRow(12);   
	    cell = row.getCell(2);
	    cell.setCellValue(ObjUtils.parseInt(data.get("MECHANIC_NUM")));	
	    cell = row.getCell(4);
	    cell.setCellValue(stockNumTot);

	    row = sheet.getRow(14);    
	    cell = row.getCell(2);
	    cell.setCellValue(totalSum);	 
	    cell = row.getCell(3);
	    cell.setCellValue(generalSum);	
	    cell = row.getCell(4);
	    cell.setCellValue(regionalSum);
	    cell = row.getCell(5);
	    cell.setCellValue(publicSum);

	    row = sheet.getRow(15);    
	    cell = row.getCell(2);
	    cell.setCellValue(inLargeSum);	 
	    cell = row.getCell(3);
	    cell.setCellValue(inLargeGen);	
	    cell = row.getCell(4);
	    cell.setCellValue(inLargeCtr);
	    cell = row.getCell(5);
	    cell.setCellValue(inLargePub);
	    
	    
	    row = sheet.getRow(16);    
	    cell = row.getCell(2);
	    cell.setCellValue(inMediumSum);	 
	    cell = row.getCell(3);
	    cell.setCellValue(inMediumGen);	
	    cell = row.getCell(4);
	    cell.setCellValue(inMediumCtr);
	    cell = row.getCell(5);
	    cell.setCellValue(inMediumPub);
	    
	    
	    row = sheet.getRow(17);    
	    cell = row.getCell(2);
	    cell.setCellValue(inExpGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(inExpGen);	
	    
	    row = sheet.getRow(18);    
	    cell = row.getCell(2);
	    cell.setCellValue(inNonStopGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(inNonStopGen);	
	    
	    row = sheet.getRow(19);    
	    cell = row.getCell(2);
	    cell.setCellValue(outSlowGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(outSlowGen);	
	    
	    row = sheet.getRow(20);    
	    cell = row.getCell(2);
	    cell.setCellValue(outNonStopGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(outNonStopGen);	
	    
	    row = sheet.getRow(21);    
	    cell = row.getCell(2);
	    cell.setCellValue(outAirGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(outAirGen);
	    
	    row = sheet.getRow(22);    
	    cell = row.getCell(2);
	    cell.setCellValue(airLimitGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(airLimitGen);
	    
	    row = sheet.getRow(23);    
	    cell = row.getCell(2);
	    cell.setCellValue(etcVilleageGen);	 
	    cell = row.getCell(3);
	    cell.setCellValue(etcVilleageGen);
	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
}
