package foren.unilite.modules.prodt.pmp;

import java.io.File;
import java.io.FileInputStream;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "pmpExcelService" )
public class PmpExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "pmp100ukrvService" )
    private Pmp100ukrvServiceImpl pmp100ukrvService;
    
    public Workbook makeExcel( Map param) throws Exception {
    	Workbook workbook = null;
    	String fileInfo = "";
    	
    	fileInfo = ObjUtils.getSafeString(param.get("FILE_PATH")) + File.separatorChar;
    	if(param.get("GUBUN").equals("A")){
    		//공통코드 P010에 파일명 지정되어있을경우
    		int pos = 0;
    		String fName = "";
    		String ext = "";
    		if(ObjUtils.getSafeString(param.get("FILE_ID")).contains(".")){
	        	pos = ObjUtils.getSafeString(param.get("FILE_ID")).lastIndexOf(".");
	        	fName = ObjUtils.getSafeString(param.get("FILE_ID")).substring(0,pos);
	        	ext = ObjUtils.getSafeString(param.get("FILE_ID")).substring(pos + 1).toLowerCase();
    		}else{
    			fName = ObjUtils.getSafeString(param.get("FILE_ID"));
	        	ext = "";
    		}
        	
        	fileInfo += fName;
        	
        	if(ext.equals("xls")){
            	FileInputStream file = new FileInputStream(new File(fileInfo + ".xls"));
        		workbook = new HSSFWorkbook(file);
        	}else{
            	FileInputStream file = new FileInputStream(new File(fileInfo + ".xlsx"));
        		workbook = new XSSFWorkbook(file);
        	}
    	}else if(param.get("GUBUN").equals("B")){
    		//공통코드 P010에 파일명 지정되어있지 않고 ITEM_CODE 에 따른 파일관련 읽어온것 BPR101T에서 
    		fileInfo += ObjUtils.getSafeString(param.get("FILE_ID")) + "." + ObjUtils.getSafeString(param.get("FILE_EXT"));
        	FileInputStream file = new FileInputStream(new File(fileInfo));
        	
        	if(ObjUtils.getSafeString(param.get("FILE_EXT")).equals("xls")){

        		workbook = new HSSFWorkbook(file);
        	}else{
        		workbook = new XSSFWorkbook(file);
        	}
    	}else{
    		fileInfo += ".xlsx";
        	FileInputStream file = new FileInputStream(new File(fileInfo));
    		workbook = new XSSFWorkbook(file);
    	}

        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
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
        
        Map<Object, String> dataMap = (Map<Object, String>)super.commonDao.select("pmp100ukrvServiceImpl.selectExcelMaster", param);

        //접수번호
        sheet1.getRow(29).getCell(F).setCellValue(dataMap.get("ITEM_NAME"));
        sheet1.getRow(29).getCell(U).setCellValue(dataMap.get("ITEM_CODE"));
        
        sheet1.getRow(32).getCell(G).setCellValue(dataMap.get("LOT_NO"));
        sheet1.getRow(35).getCell(G).setCellValue(dataMap.get("SPEC"));
        sheet1.getRow(36).getCell(G).setCellValue(ObjUtils.parseDouble(dataMap.get("WKORD_Q1")));
        sheet1.getRow(37).getCell(I).setCellValue(ObjUtils.parseDouble(dataMap.get("WKORD_Q2")));
      
        return workbook;
    }
}
