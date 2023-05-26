package foren.unilite.modules.busevaluation.grb;

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


@Service("grbExcelService")
public class GrbExcelServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="grb100ukrvService")
	private Grb100ukrvServiceImpl grb100ukrvService;
	
	public Workbook  selectList1(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) grb100ukrvService.selectList(param);
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grb100.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 
		
		Row  row = sheet.getRow(2);
		Cell cell = row.getCell(0);
	    cell.setCellValue("기준년도: "+ObjUtils.getSafeString(param.get("SERVICE_YEAR"))+".12.31");
	    
	    //시내일반-대형
	    row = sheet.getRow(6);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_GEN_PART")));	    
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_CTR_FULL")));
	    cell = row.getCell(18);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_CTR_PART")));
	    cell = row.getCell(20);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_PUB_FULL")));
	    cell = row.getCell(22);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_PUB_PART")));
	    
  		int largeFullTotal = ObjUtils.parseInt(data.get("IN_LARGE_GEN_FULL"))	+ ObjUtils.parseInt(data.get("IN_LARGE_CTR_FULL")) + ObjUtils.parseInt(data.get("IN_LARGE_PUB_FULL")) ;
  		int largePartTotal = ObjUtils.parseInt(data.get("IN_LARGE_GEN_PART"))	+ ObjUtils.parseInt(data.get("IN_LARGE_CTR_PART")) + ObjUtils.parseInt(data.get("IN_LARGE_PUB_PART")) ;
	    
	    cell = row.getCell(4);
	    cell.setCellValue(largeFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(largePartTotal);
	    
	    
	    //시내일반-중형
	    row = sheet.getRow(7);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_GEN_PART")));	    
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_CTR_FULL")));
	    cell = row.getCell(18);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_CTR_PART")));
	    cell = row.getCell(20);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_PUB_FULL")));
	    cell = row.getCell(22);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_PUB_PART")));
	    
	    int MediumFullTotal = ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_FULL")) ;
  		int MediumPartTotal = ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_PART")) ;
	    
	    cell = row.getCell(4);
	    cell.setCellValue(MediumFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(MediumPartTotal);

	    
	    //시내좌석버스
	    row = sheet.getRow(8);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_GEN_PART")));
	    
	    int ExpressFullTotal = ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_FULL"));
  		int ExpressPartTotal = ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_PART"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(ExpressFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(ExpressPartTotal);
	    
	    //시내직행버스
	    row = sheet.getRow(9);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_GEN_PART")));
	    
	    int inNonstopFullTotal = ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_FULL"));
  		int inNonstopPartTotal = ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_PART"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(inNonstopFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(inNonstopPartTotal);
	    
	    //시외완행버스
	    row = sheet.getRow(10);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_GEN_PART")));
	    
	    int outslowFullTotal = ObjUtils.parseInt(data.get("OUT_SLOW_GEN_FULL"));
  		int outslowPartTotal = ObjUtils.parseInt(data.get("OUT_SLOW_GEN_PART"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(outslowFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(outslowPartTotal);
	    
	    //시외직행버스
	    row = sheet.getRow(11);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_GEN_PART")));
	    
	    int outNonstopFullTotal = ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_FULL"));
  		int outNonstopPartTotal = ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(outNonstopFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(outNonstopPartTotal);
	    
	    //시외공항버스
	    row = sheet.getRow(12);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_GEN_PART")));
	    
	    int outAirFullTotal = ObjUtils.parseInt(data.get("OUT_AIR_GEN_FULL"));
  		int outAirPartTotal = ObjUtils.parseInt(data.get("OUT_AIR_GEN_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(outAirFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(outAirPartTotal);
	    
	    //공황한정버스
	    row = sheet.getRow(13);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_GEN_PART")));
	    
	    int AirLimFullTotal = ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_FULL"));
  		int AirLimPartTotal = ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(AirLimFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(AirLimPartTotal);
	    
	    //마을전세버스
	    row = sheet.getRow(14);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_GEN_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_GEN_PART")));
	    
	    int etcVillFullTotal = ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_FULL"));
  		int etcVillPartTotal = ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(etcVillFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(etcVillPartTotal);
	    
	    //정비직
	    row = sheet.getRow(15);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_PART")));
	    
	    int mechFullTotal = ObjUtils.parseInt(data.get("MECHANIC_FULL"));
  		int mechPartTotal = ObjUtils.parseInt(data.get("MECHANIC_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(mechFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(mechPartTotal);
	    
	    ///소계
	    row = sheet.getRow(16);

	    cell = row.getCell(4);
	    cell.setCellValue(largeFullTotal + MediumFullTotal + ExpressFullTotal + ExpressFullTotal + inNonstopFullTotal + outslowFullTotal + outNonstopFullTotal
	    		+ outNonstopFullTotal + outAirFullTotal + AirLimFullTotal + etcVillFullTotal + mechFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(largePartTotal + MediumPartTotal + ExpressPartTotal + ExpressPartTotal + inNonstopPartTotal + outslowPartTotal + outNonstopPartTotal
	    		+ outNonstopPartTotal + outAirPartTotal + AirLimPartTotal + etcVillPartTotal + mechPartTotal);
	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_GEN_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_FULL")) + ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_FULL"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_FULL")) + ObjUtils.parseInt(data.get("OUT_SLOW_GEN_FULL")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_FULL"))  +
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_GEN_FULL"))  + ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_FULL"))  + ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_FULL"))  +
	    		+ ObjUtils.parseInt(data.get("MECHANIC_FULL")));
	    
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_GEN_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_PART")) + ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_PART"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_PART")) + ObjUtils.parseInt(data.get("OUT_SLOW_GEN_PART")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_PART"))  +
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_GEN_PART"))  + ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_PART"))  + ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_PART"))  +
	    		+ ObjUtils.parseInt(data.get("MECHANIC_PART")));
	    
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_CTR_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_FULL")));
	    
	    cell = row.getCell(18);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_CTR_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_PART")));
	    
	    cell = row.getCell(20);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_PUB_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_FULL")));
	    
	    cell = row.getCell(22);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_PUB_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_PART")));
	    
	    //임원
	    row = sheet.getRow(17);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_PART")));
	    
	    int exeFullTotal = ObjUtils.parseInt(data.get("EXECUTIVE_FULL"));
  		int exePartTotal = ObjUtils.parseInt(data.get("EXECUTIVE_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(exeFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(exePartTotal);
	    
	    //관리직
	    row = sheet.getRow(18);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_FULL")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_PART")));
	    
	    int adminFullTotal = ObjUtils.parseInt(data.get("ADMINISTRATIVE_FULL"));
  		int adminPartTotal = ObjUtils.parseInt(data.get("ADMINISTRATIVE_PART"));
  		
	    cell = row.getCell(4);
	    cell.setCellValue(adminFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(adminPartTotal);
	    
	    row = sheet.getRow(19);
	    cell = row.getCell(4);
	    cell.setCellValue(exeFullTotal + adminFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(exePartTotal + adminPartTotal);
		cell = row.getCell(8);
	    cell.setCellValue(exeFullTotal + adminFullTotal);
	    cell = row.getCell(10);
	    cell.setCellValue(exePartTotal + adminPartTotal);
	    
	    row = sheet.getRow(20);
	    cell = row.getCell(4);
	    cell.setCellValue(largeFullTotal + MediumFullTotal + ExpressFullTotal + ExpressFullTotal + inNonstopFullTotal + outslowFullTotal + outNonstopFullTotal
	    		+ outNonstopFullTotal + outAirFullTotal + AirLimFullTotal + etcVillFullTotal + mechFullTotal + exeFullTotal + adminFullTotal);
	    cell = row.getCell(6);
	    cell.setCellValue(largePartTotal + MediumPartTotal + ExpressPartTotal + ExpressPartTotal + inNonstopPartTotal + outslowPartTotal + outNonstopPartTotal
	    		+ outNonstopPartTotal + outAirPartTotal + AirLimPartTotal + etcVillPartTotal + mechPartTotal + exePartTotal + adminPartTotal);
		cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_GEN_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_FULL")) + ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_FULL"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_FULL")) + ObjUtils.parseInt(data.get("OUT_SLOW_GEN_FULL")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_FULL"))  +
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_GEN_FULL"))  + ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_FULL"))  + ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_FULL"))  +
	    		+ ObjUtils.parseInt(data.get("MECHANIC_FULL")) + exeFullTotal + adminFullTotal);
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_GEN_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_GEN_PART")) + ObjUtils.parseInt(data.get("IN_EXPRESS_GEN_PART"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_GEN_PART")) + ObjUtils.parseInt(data.get("OUT_SLOW_GEN_PART")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_GEN_PART"))  +
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_GEN_PART"))  + ObjUtils.parseInt(data.get("AIR_LIMIT_GEN_PART"))  + ObjUtils.parseInt(data.get("ETC_VILLEAGE_GEN_PART"))  +
	    		+ ObjUtils.parseInt(data.get("MECHANIC_PART")) + exePartTotal + adminPartTotal);
	    
	    
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_CTR_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_FULL")));
	    
	    cell = row.getCell(18);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_CTR_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_CTR_PART")));
	    
	    cell = row.getCell(20);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_PUB_FULL")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_FULL")));
	    
	    cell = row.getCell(22);
	    cell.setCellValue(ObjUtils.parseInt(data.get("IN_LARGE_PUB_PART")) + ObjUtils.parseInt(data.get("IN_MEDIUM_PUB_PART")));
	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
	
	@Resource(name="grb200ukrvService")
	private Grb200ukrvServiceImpl grb200ukrvService;
	
	public Workbook  selectList2(Map param) throws Exception {	
		
		Map<Object, String> data =  (Map<Object, String>) grb200ukrvService.selectList(param);
		
		
		
		FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("busevaluation")+ File.separatorChar+"grb200.xls"));
        
		//Get the workbook instance for XLS file 
		Workbook workbook = new HSSFWorkbook(file);
		
		//Get first sheet from the workbook
		Sheet sheet = workbook.getSheetAt(0);
		 
		
		Row  row = sheet.getRow(2);
		Cell cell = row.getCell(0);
	    cell.setCellValue("기준년도: "+ObjUtils.getSafeString(param.get("SERVICE_YEAR"))+".12.31");
	    
	    //시내일반-대형
	    row = sheet.getRow(5);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_LARGE_10")));
	    
	    int largeTotal = ObjUtils.parseInt(data.get("IN_LARGE_00"))	+ ObjUtils.parseInt(data.get("IN_LARGE_01")) + ObjUtils.parseInt(data.get("IN_LARGE_02")) 
	    		+ ObjUtils.parseInt(data.get("IN_LARGE_03")) + ObjUtils.parseInt(data.get("IN_LARGE_04")) + ObjUtils.parseInt(data.get("IN_LARGE_05"))
	    		+ ObjUtils.parseInt(data.get("IN_LARGE_06")) + ObjUtils.parseInt(data.get("IN_LARGE_07")) + ObjUtils.parseInt(data.get("IN_LARGE_08"))
	    		+ ObjUtils.parseInt(data.get("IN_LARGE_09")) + ObjUtils.parseInt(data.get("IN_LARGE_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(largeTotal);
	    
	    //시내일반-중형
	    row = sheet.getRow(6);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_MEDIUM_10")));
	    
	    int mediumTotal = ObjUtils.parseInt(data.get("IN_MEDIUM_00"))	+ ObjUtils.parseInt(data.get("IN_MEDIUM_01")) + ObjUtils.parseInt(data.get("IN_MEDIUM_02")) 
	    		+ ObjUtils.parseInt(data.get("IN_MEDIUM_03")) + ObjUtils.parseInt(data.get("IN_MEDIUM_04")) + ObjUtils.parseInt(data.get("IN_MEDIUM_05"))
	    		+ ObjUtils.parseInt(data.get("IN_MEDIUM_06")) + ObjUtils.parseInt(data.get("IN_MEDIUM_07")) + ObjUtils.parseInt(data.get("IN_MEDIUM_08"))
	    		+ ObjUtils.parseInt(data.get("IN_MEDIUM_09")) + ObjUtils.parseInt(data.get("IN_MEDIUM_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(mediumTotal);
    
	    //시내좌석버스
	    row = sheet.getRow(7);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_EXPRESS_10")));
	    
	    int expressTotal = ObjUtils.parseInt(data.get("IN_EXPRESS_00"))	+ ObjUtils.parseInt(data.get("IN_EXPRESS_01")) + ObjUtils.parseInt(data.get("IN_EXPRESS_02")) 
	    		+ ObjUtils.parseInt(data.get("IN_EXPRESS_03")) + ObjUtils.parseInt(data.get("IN_EXPRESS_04")) + ObjUtils.parseInt(data.get("IN_EXPRESS_05"))
	    		+ ObjUtils.parseInt(data.get("IN_EXPRESS_06")) + ObjUtils.parseInt(data.get("IN_EXPRESS_07")) + ObjUtils.parseInt(data.get("IN_EXPRESS_08"))
	    		+ ObjUtils.parseInt(data.get("IN_EXPRESS_09")) + ObjUtils.parseInt(data.get("IN_EXPRESS_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(expressTotal);

	    //시내직행버스
	    row = sheet.getRow(8);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("IN_NONSTOP_10")));
	    
	    int nonstopTotal = ObjUtils.parseInt(data.get("IN_NONSTOP_00"))	+ ObjUtils.parseInt(data.get("IN_NONSTOP_01")) + ObjUtils.parseInt(data.get("IN_NONSTOP_02")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_03")) + ObjUtils.parseInt(data.get("IN_NONSTOP_04")) + ObjUtils.parseInt(data.get("IN_NONSTOP_05"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_06")) + ObjUtils.parseInt(data.get("IN_NONSTOP_07")) + ObjUtils.parseInt(data.get("IN_NONSTOP_08"))
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_09")) + ObjUtils.parseInt(data.get("IN_NONSTOP_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(nonstopTotal);
  
	    //시외완행버스
	    row = sheet.getRow(9);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_SLOW_10")));
	    
	    int outslowTotal = ObjUtils.parseInt(data.get("OUT_SLOW_00"))	+ ObjUtils.parseInt(data.get("OUT_SLOW_01")) + ObjUtils.parseInt(data.get("OUT_SLOW_02")) 
	    		+ ObjUtils.parseInt(data.get("OUT_SLOW_03")) + ObjUtils.parseInt(data.get("OUT_SLOW_04")) + ObjUtils.parseInt(data.get("OUT_SLOW_05"))
	    		+ ObjUtils.parseInt(data.get("OUT_SLOW_06")) + ObjUtils.parseInt(data.get("OUT_SLOW_07")) + ObjUtils.parseInt(data.get("OUT_SLOW_08"))
	    		+ ObjUtils.parseInt(data.get("OUT_SLOW_09")) + ObjUtils.parseInt(data.get("OUT_SLOW_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(outslowTotal);
   
//	    //시외직행버스
	    row = sheet.getRow(10);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_NONSTOP_10")));
	    
	    int outnonstopTotal = ObjUtils.parseInt(data.get("OUT_NONSTOP_00"))	+ ObjUtils.parseInt(data.get("OUT_NONSTOP_01")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_02")) 
	    		+ ObjUtils.parseInt(data.get("OUT_NONSTOP_03")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_04")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_05"))
	    		+ ObjUtils.parseInt(data.get("OUT_NONSTOP_06")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_07")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_08"))
	    		+ ObjUtils.parseInt(data.get("OUT_NONSTOP_09")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(outnonstopTotal);

	    //시외공항버스
	    row = sheet.getRow(11);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("OUT_AIR_10")));
	    
	    int outairTotal = ObjUtils.parseInt(data.get("OUT_AIR_00"))	+ ObjUtils.parseInt(data.get("OUT_AIR_01")) + ObjUtils.parseInt(data.get("OUT_AIR_02")) 
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_03")) + ObjUtils.parseInt(data.get("OUT_AIR_04")) + ObjUtils.parseInt(data.get("OUT_AIR_05"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_06")) + ObjUtils.parseInt(data.get("OUT_AIR_07")) + ObjUtils.parseInt(data.get("OUT_AIR_08"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_09")) + ObjUtils.parseInt(data.get("OUT_AIR_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(outairTotal);
	    
	    //공황한정버스
	    row = sheet.getRow(12);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("AIR_LIMIT_10")));
	    
	    int airlimTotal = ObjUtils.parseInt(data.get("AIR_LIMIT_00"))	+ ObjUtils.parseInt(data.get("AIR_LIMIT_01")) + ObjUtils.parseInt(data.get("AIR_LIMIT_02")) 
	    		+ ObjUtils.parseInt(data.get("AIR_LIMIT_03")) + ObjUtils.parseInt(data.get("AIR_LIMIT_04")) + ObjUtils.parseInt(data.get("AIR_LIMIT_05"))
	    		+ ObjUtils.parseInt(data.get("AIR_LIMIT_06")) + ObjUtils.parseInt(data.get("AIR_LIMIT_07")) + ObjUtils.parseInt(data.get("AIR_LIMIT_08"))
	    		+ ObjUtils.parseInt(data.get("AIR_LIMIT_09")) + ObjUtils.parseInt(data.get("AIR_LIMIT_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(airlimTotal);

	    //마을전세버스
	    row = sheet.getRow(13);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ETC_VILLEAGE_10")));
	    
	    int etcVilTotal = ObjUtils.parseInt(data.get("ETC_VILLEAGE_00")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_01")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_02")) 
	    		+ ObjUtils.parseInt(data.get("ETC_VILLEAGE_03")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_04")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_05"))
	    		+ ObjUtils.parseInt(data.get("ETC_VILLEAGE_06")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_07")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_08"))
	    		+ ObjUtils.parseInt(data.get("ETC_VILLEAGE_09")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(etcVilTotal);

	    //종비직
	    row = sheet.getRow(14);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("MECHANIC_10")));
	    
	    int mechTotal = ObjUtils.parseInt(data.get("MECHANIC_00")) + ObjUtils.parseInt(data.get("MECHANIC_01")) + ObjUtils.parseInt(data.get("MECHANIC_02")) 
	    		+ ObjUtils.parseInt(data.get("MECHANIC_03")) + ObjUtils.parseInt(data.get("MECHANIC_04")) + ObjUtils.parseInt(data.get("MECHANIC_05"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_06")) + ObjUtils.parseInt(data.get("MECHANIC_07")) + ObjUtils.parseInt(data.get("MECHANIC_08"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_09")) + ObjUtils.parseInt(data.get("MECHANIC_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(mechTotal);
	    
	    
	    //소계
	    row = sheet.getRow(15);
	    
	    int subtotal_1_00 = ObjUtils.parseInt(data.get("IN_LARGE_00")) + ObjUtils.parseInt(data.get("IN_MEDIUM_00")) + ObjUtils.parseInt(data.get("IN_EXPRESS_00")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_00")) + ObjUtils.parseInt(data.get("OUT_SLOW_00")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_00"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_00")) + ObjUtils.parseInt(data.get("AIR_LIMIT_00")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_00"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_00"));
	    
	    cell = row.getCell(6);
	    cell.setCellValue(subtotal_1_00);
	    
	    int subtotal_1_01 = ObjUtils.parseInt(data.get("IN_LARGE_01")) + ObjUtils.parseInt(data.get("IN_MEDIUM_01")) + ObjUtils.parseInt(data.get("IN_EXPRESS_01")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_01")) + ObjUtils.parseInt(data.get("OUT_SLOW_01")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_01"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_01")) + ObjUtils.parseInt(data.get("AIR_LIMIT_01")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_01"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_01"));
	    
	    cell = row.getCell(7);
	    cell.setCellValue(subtotal_1_01);
	    
	    int subtotal_1_02 = ObjUtils.parseInt(data.get("IN_LARGE_02")) + ObjUtils.parseInt(data.get("IN_MEDIUM_02")) + ObjUtils.parseInt(data.get("IN_EXPRESS_02")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_02")) + ObjUtils.parseInt(data.get("OUT_SLOW_02")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_02"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_02")) + ObjUtils.parseInt(data.get("AIR_LIMIT_02")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_02"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_02"));
	    
	    cell = row.getCell(8);
	    cell.setCellValue(subtotal_1_02);
	    
	    int subtotal_1_03 = ObjUtils.parseInt(data.get("IN_LARGE_03")) + ObjUtils.parseInt(data.get("IN_MEDIUM_03")) + ObjUtils.parseInt(data.get("IN_EXPRESS_03")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_03")) + ObjUtils.parseInt(data.get("OUT_SLOW_03")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_03"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_03")) + ObjUtils.parseInt(data.get("AIR_LIMIT_03")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_03"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_03"));
	    
	    cell = row.getCell(9);
	    cell.setCellValue(subtotal_1_03);
	    
	    int subtotal_1_04 = ObjUtils.parseInt(data.get("IN_LARGE_04")) + ObjUtils.parseInt(data.get("IN_MEDIUM_04")) + ObjUtils.parseInt(data.get("IN_EXPRESS_04")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_04")) + ObjUtils.parseInt(data.get("OUT_SLOW_04")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_04"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_04")) + ObjUtils.parseInt(data.get("AIR_LIMIT_04")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_04"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_04"));
	    
	    cell = row.getCell(10);
	    cell.setCellValue(subtotal_1_04);
	    
	    int subtotal_1_05 = ObjUtils.parseInt(data.get("IN_LARGE_05")) + ObjUtils.parseInt(data.get("IN_MEDIUM_05")) + ObjUtils.parseInt(data.get("IN_EXPRESS_05")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_05")) + ObjUtils.parseInt(data.get("OUT_SLOW_05")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_05"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_05")) + ObjUtils.parseInt(data.get("AIR_LIMIT_05")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_05"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_05"));
	    
	    cell = row.getCell(11);
	    cell.setCellValue(subtotal_1_05);
	    
	    int subtotal_1_06 = ObjUtils.parseInt(data.get("IN_LARGE_06")) + ObjUtils.parseInt(data.get("IN_MEDIUM_06")) + ObjUtils.parseInt(data.get("IN_EXPRESS_06")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_06")) + ObjUtils.parseInt(data.get("OUT_SLOW_06")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_06"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_06")) + ObjUtils.parseInt(data.get("AIR_LIMIT_06")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_06"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_06"));
	    
	    cell = row.getCell(12);
	    cell.setCellValue(subtotal_1_06);
	    
	    int subtotal_1_07 = ObjUtils.parseInt(data.get("IN_LARGE_07")) + ObjUtils.parseInt(data.get("IN_MEDIUM_07")) + ObjUtils.parseInt(data.get("IN_EXPRESS_07")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_07")) + ObjUtils.parseInt(data.get("OUT_SLOW_07")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_07"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_07")) + ObjUtils.parseInt(data.get("AIR_LIMIT_07")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_07"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_07"));
	    
	    cell = row.getCell(13);
	    cell.setCellValue(subtotal_1_07);
	    
	    int subtotal_1_08 = ObjUtils.parseInt(data.get("IN_LARGE_08")) + ObjUtils.parseInt(data.get("IN_MEDIUM_08")) + ObjUtils.parseInt(data.get("IN_EXPRESS_08")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_08")) + ObjUtils.parseInt(data.get("OUT_SLOW_08")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_08"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_08")) + ObjUtils.parseInt(data.get("AIR_LIMIT_08")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_08"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_08"));
	    
	    cell = row.getCell(14);
	    cell.setCellValue(subtotal_1_08);
	    
	    int subtotal_1_09 = ObjUtils.parseInt(data.get("IN_LARGE_09")) + ObjUtils.parseInt(data.get("IN_MEDIUM_09")) + ObjUtils.parseInt(data.get("IN_EXPRESS_09")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_09")) + ObjUtils.parseInt(data.get("OUT_SLOW_09")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_09"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_09")) + ObjUtils.parseInt(data.get("AIR_LIMIT_09")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_09"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_09"));
	    
	    cell = row.getCell(15);
	    cell.setCellValue(subtotal_1_09);
	    
	    int subtotal_1_10 = ObjUtils.parseInt(data.get("IN_LARGE_10")) + ObjUtils.parseInt(data.get("IN_MEDIUM_10")) + ObjUtils.parseInt(data.get("IN_EXPRESS_10")) 
	    		+ ObjUtils.parseInt(data.get("IN_NONSTOP_10")) + ObjUtils.parseInt(data.get("OUT_SLOW_10")) + ObjUtils.parseInt(data.get("OUT_NONSTOP_10"))
	    		+ ObjUtils.parseInt(data.get("OUT_AIR_10")) + ObjUtils.parseInt(data.get("AIR_LIMIT_10")) + ObjUtils.parseInt(data.get("ETC_VILLEAGE_10"))
	    		+ ObjUtils.parseInt(data.get("MECHANIC_10"));
	    
	    cell = row.getCell(16);
	    cell.setCellValue(subtotal_1_10);
	    
	    cell = row.getCell(4);
	    cell.setCellValue(subtotal_1_00 + subtotal_1_01 + subtotal_1_02 + subtotal_1_03 + subtotal_1_04 + subtotal_1_05 + subtotal_1_06
	    		+ subtotal_1_07 + subtotal_1_08 + subtotal_1_09 + subtotal_1_10);
	    
    
	    //임원
	    row = sheet.getRow(16);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("EXECUTIVE_10")));
	    
	    int execTotal = ObjUtils.parseInt(data.get("EXECUTIVE_00")) + ObjUtils.parseInt(data.get("EXECUTIVE_01")) + ObjUtils.parseInt(data.get("EXECUTIVE_02")) 
	    		+ ObjUtils.parseInt(data.get("EXECUTIVE_03")) + ObjUtils.parseInt(data.get("EXECUTIVE_04")) + ObjUtils.parseInt(data.get("EXECUTIVE_05"))
	    		+ ObjUtils.parseInt(data.get("EXECUTIVE_06")) + ObjUtils.parseInt(data.get("EXECUTIVE_07")) + ObjUtils.parseInt(data.get("EXECUTIVE_08"))
	    		+ ObjUtils.parseInt(data.get("EXECUTIVE_09")) + ObjUtils.parseInt(data.get("EXECUTIVE_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(execTotal);

	    //관리직
	    row = sheet.getRow(17);
		cell = row.getCell(6);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_00")));
	    cell = row.getCell(7);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_01")));	    
	    cell = row.getCell(8);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_02")));
	    cell = row.getCell(9);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_03")));
	    cell = row.getCell(10);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_04")));
	    cell = row.getCell(11);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_05")));
	    cell = row.getCell(12);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_06")));
	    cell = row.getCell(13);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_07")));
	    cell = row.getCell(14);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_08")));
	    cell = row.getCell(15);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_09")));
	    cell = row.getCell(16);
	    cell.setCellValue(ObjUtils.getSafeString(data.get("ADMINISTRATIVE_10")));
	    
	    int adminTotal = ObjUtils.parseInt(data.get("ADMINISTRATIVE_00")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_01")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_02")) 
	    		+ ObjUtils.parseInt(data.get("ADMINISTRATIVE_03")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_04")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_05"))
	    		+ ObjUtils.parseInt(data.get("ADMINISTRATIVE_06")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_07")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_08"))
	    		+ ObjUtils.parseInt(data.get("ADMINISTRATIVE_09")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_10"));
	    
	    cell = row.getCell(4);
	    cell.setCellValue(adminTotal);
	    
	    //소계
	    row = sheet.getRow(18);
	    
	    int subtotal_2_00 = ObjUtils.parseInt(data.get("EXECUTIVE_00")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_00"));
	    
	    cell = row.getCell(6);
	    cell.setCellValue(subtotal_2_00);
	    
	    int subtotal_2_01 = ObjUtils.parseInt(data.get("EXECUTIVE_01")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_01"));
	    
	    cell = row.getCell(7);
	    cell.setCellValue(subtotal_2_01);
	    
	    int subtotal_2_02 = ObjUtils.parseInt(data.get("EXECUTIVE_02")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_02"));
	    
	    cell = row.getCell(8);
	    cell.setCellValue(subtotal_2_02);
	    
	    int subtotal_2_03 = ObjUtils.parseInt(data.get("EXECUTIVE_03")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_03"));
	    
	    cell = row.getCell(9);
	    cell.setCellValue(subtotal_2_03);
	    
	    int subtotal_2_04 = ObjUtils.parseInt(data.get("EXECUTIVE_04")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_04"));
	    
	    cell = row.getCell(10);
	    cell.setCellValue(subtotal_2_04);
	    
	    int subtotal_2_05 = ObjUtils.parseInt(data.get("EXECUTIVE_05")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_05"));
	    
	    cell = row.getCell(11);
	    cell.setCellValue(subtotal_2_05);
	    
	    int subtotal_2_06 = ObjUtils.parseInt(data.get("EXECUTIVE_06")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_06"));
	    
	    cell = row.getCell(12);
	    cell.setCellValue(subtotal_2_06);
	    
	    int subtotal_2_07 = ObjUtils.parseInt(data.get("EXECUTIVE_07")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_07"));
	    
	    cell = row.getCell(13);
	    cell.setCellValue(subtotal_2_07);
	    
	    int subtotal_2_08 = ObjUtils.parseInt(data.get("EXECUTIVE_08")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_08"));
	    
	    cell = row.getCell(14);
	    cell.setCellValue(subtotal_2_08);
	    
	    int subtotal_2_09 = ObjUtils.parseInt(data.get("EXECUTIVE_09")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_09"));
	    
	    cell = row.getCell(15);
	    cell.setCellValue(subtotal_2_09);
	    
	    int subtotal_2_10 = ObjUtils.parseInt(data.get("EXECUTIVE_10")) + ObjUtils.parseInt(data.get("ADMINISTRATIVE_10"));
	    
	    cell = row.getCell(16);
	    cell.setCellValue(subtotal_2_10);
	    
	    cell = row.getCell(4);
	    cell.setCellValue(subtotal_2_00 + subtotal_2_01 + subtotal_2_02 + subtotal_2_03 + subtotal_2_04 + subtotal_2_05 + subtotal_2_06
	    		+ subtotal_2_07 + subtotal_2_08 + subtotal_2_09 + subtotal_2_10);
	    
	    //총계
	    row = sheet.getRow(19);
	    
	    cell = row.getCell(6);
	    cell.setCellValue(subtotal_1_00 + subtotal_2_00);
	    
	    cell = row.getCell(7);
	    cell.setCellValue(subtotal_1_01 + subtotal_2_01);
	    
	    cell = row.getCell(8);
	    cell.setCellValue(subtotal_1_02 + subtotal_2_02);
	    
	    cell = row.getCell(9);
	    cell.setCellValue(subtotal_1_03 + subtotal_2_03);
	    
	    cell = row.getCell(10);
	    cell.setCellValue(subtotal_1_04 + subtotal_2_04);
	    
	    cell = row.getCell(11);
	    cell.setCellValue(subtotal_1_05 + subtotal_2_05);
	    
	    cell = row.getCell(12);
	    cell.setCellValue(subtotal_1_06 + subtotal_2_06);
	    
	    cell = row.getCell(13);
	    cell.setCellValue(subtotal_1_07 + subtotal_2_07);
	    
	    cell = row.getCell(14);
	    cell.setCellValue(subtotal_1_08 + subtotal_2_08);
	    
	    cell = row.getCell(15);
	    cell.setCellValue(subtotal_1_09 + subtotal_2_09);
	    
	    cell = row.getCell(16);
	    cell.setCellValue(subtotal_1_10 + subtotal_2_10);
	    
	    cell = row.getCell(4);
	    cell.setCellValue(subtotal_1_00 + subtotal_2_00 + subtotal_1_01 + subtotal_2_01 + subtotal_1_02 + subtotal_2_02 + subtotal_1_03 + subtotal_2_03
	    		+ subtotal_1_04 + subtotal_2_04 + subtotal_1_05 + subtotal_2_05 + subtotal_1_06 + subtotal_2_06 + subtotal_1_07 + subtotal_2_07
	    		+ subtotal_1_08 + subtotal_2_08 + subtotal_1_09 + subtotal_2_09 + subtotal_1_10 + subtotal_2_10);
	    
	    
	    
	   
	    file.close();
        //Write the workbook in file system
        return workbook;
    }
	
}
