package foren.unilite.modules.z_hs;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.DevFreeUtils;
import net.sf.json.JSONArray;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellReference;

@Service( "s_pmr140rkrv_hsService" )
public class S_Pmr140rkrv_hsServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
	
    @Resource(name="tlabCodeService")
	private TlabCodeService tlabCodeService;
    
    @ExtDirectMethod( group = "prodt")
    public Workbook makeExcel1( Map param , LoginVO user) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "SKCC_pmr140_1.xlsx"));
        
        String filePath = ConfigUtil.getUploadBasePath("excel/template");
        
        
        Workbook workbook = new XSSFWorkbook(file);
       
        
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        
        DataFormat format = workbook.createDataFormat();

        int  A = 0  ,  B = 1  , C = 2  , D = 3  , E = 4  , F = 5  , G = 6  , H = 7  , I = 8  , J = 9;
        int  K = 10 ,  L = 11 , M = 12 , N = 13 , O = 14 , P = 15 , Q = 16 , R = 17 , S = 18 , T = 19;
        int  U = 20 ,  V = 21 , W = 22 , X = 23 , Y = 24 , Z = 25;
        int AA = 26 , AB = 27;
           
        // 타이틀폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)11);
        font.setFontName("굴림");
        font.setBoldweight((short)Font.BOLDWEIGHT_BOLD);


        // 본문및합계폰트
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)10);
        font2.setFontName("굴림"); //글씨체
        font2.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // Style 01 : 타이틀 왼쪽정렬
        CellStyle style01 = workbook.createCellStyle();
        //style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);
        
        // Stylec 01 : 타이틀 중앙정렬1
        CellStyle stylec01 = workbook.createCellStyle();
        stylec01.setAlignment(CellStyle.ALIGN_CENTER);
        stylec01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        stylec01.setFont(font);

        // Stylec 02 : 본물 중앙정렬1
        CellStyle stylec02 = workbook.createCellStyle();
        
        stylec02.setAlignment(CellStyle.ALIGN_CENTER);
        stylec02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        stylec02.setFont(font2);

        // Style  0: 숫자(#,##0)
        CellStyle styleNum_0 = workbook.createCellStyle();
        styleNum_0.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_0.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_0.setDataFormat(format.getFormat("#,##0"));
        styleNum_0.setFont(font2);
        
        // Style  1: 숫자(#,##0.0)
        CellStyle styleNum_1 = workbook.createCellStyle();
        styleNum_1.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_1.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_1.setDataFormat(format.getFormat("#,##0.0"));
        styleNum_1.setFont(font2);
        
        // Style  2: 숫자(#,##0.00)
        CellStyle styleNum_2 = workbook.createCellStyle();
        styleNum_2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_2.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_2.setDataFormat(format.getFormat("#,##0.00"));
        styleNum_2.setFont(font2);
        
        // Style 3: 숫자(#,##0.000)
        CellStyle styleNum_3 = workbook.createCellStyle();
        styleNum_3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_3.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_3.setDataFormat(format.getFormat("#,##0.00"));
        styleNum_3.setFont(font2);
        
        Row  row = null;
        Cell cell = null;
        
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("B079", ObjUtils.getSafeString(param.get("GROUP_CD")));

        if(cdo !=null && ObjUtils.isNotEmpty(cdo.getCodeName())) {
        	row = sheet1.getRow(5);
    		this.setData(row.getCell(A), user.getCompName() +" "+ cdo.getCodeName(), "text", style01 , font);
        }
        // 생산현황, 실적
        List<Map> list1 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList1", param);
        int i = 9, j = 0;;
      
        //일일업무보고
        for(Map data : list1) {
        	if(i==9)	{
        		// 타이틀 작업일 - 한번만 추가
        		row = sheet1.getRow(6);
        		this.setData(row.getCell(A), data.get("WORK_DATE"), "text", style01 , font);
        	} 
        	if(i < 24) {
        		row = sheet1.getRow(i);
			    this.setData(row.getCell(A), data.get("WORK_SHOP_NAME")	, "text"	 , stylec02	, font2);  // 기계별
			    this.setData(row.getCell(C), data.get("ITEM_NAME")		, "text"	 , stylec02	, font2);	// 자
			    
			    //this.setData(row.getCell(G), data.get("FR_PRODT_Q")		, "float"	 , styleNum_2	, font2);		// 생산계획
			    if(ObjUtils.parseDouble(data.get("FR_PRODT_Q")) != 0){
			    	this.setData(row.getCell(G), data.get("FR_PRODT_Q")		, "float"	 , styleNum_2	, font2);		// 생산계획
			    }
			    
			    //this.setData(row.getCell(I), data.get("WORK_MAN")		, "number"	 , styleNum_0	, font2);		// 인원
			    if(ObjUtils.parseDouble(data.get("WORK_MAN")) != 0){
			    	this.setData(row.getCell(I), data.get("WORK_MAN")		, "number"	 , styleNum_0	, font2);		// 인원
			    } 
			    
			    //this.setData(row.getCell(K),( ObjUtils.getSafeString(data.get("FR_SERIAL_NO")) + " ~ " +	ObjUtils.getSafeString(data.get("TO_SERIAL_NO")) ) 
			    //														, "text"	 , stylec02	, font2);		// 작업시간
			    if(!ObjUtils.getSafeString(data.get("FR_SERIAL_NO")).equals("") && !ObjUtils.getSafeString(data.get("TO_SERIAL_NO")).equals("")){
			    	this.setData(row.getCell(K),( ObjUtils.getSafeString(data.get("FR_SERIAL_NO")) + " ~ " +	ObjUtils.getSafeString(data.get("TO_SERIAL_NO")) ) 
				    														, "text"	 , stylec02	, font2);		// 작업시간
			    }
	
			    //this.setData(row.getCell(O), data.get("WORK_TIME")		, "float"	 , styleNum_2	, font2);		// 실가동
			    if(ObjUtils.parseDouble(data.get("WORK_TIME")) != 0){
			    	this.setData(row.getCell(O), data.get("WORK_TIME")		, "float"	 , styleNum_2	, font2);		// 실가동
			    } 
			    
			    //this.setData(row.getCell(R), data.get("MAN_HOUR")		, "float"	 , styleNum_2	, font2);		// 투입공수
			    if(ObjUtils.parseDouble(data.get("MAN_HOUR")) != 0){
			    	this.setData(row.getCell(R), data.get("MAN_HOUR")		, "float"	 , styleNum_2	, font2);		// 실가동
			    } 
			    
			    //this.setData(row.getCell(U), data.get("PRODT_Q")		, "float"	 , styleNum_2	, font2);		// 생산량
			    if(ObjUtils.parseDouble(data.get("PRODT_Q")) != 0){
			    	this.setData(row.getCell(U), data.get("PRODT_Q")		, "float"	 , styleNum_2	, font2);		// 생산량
			    } 
			    
			    //this.setData(row.getCell(X), data.get("PRODT_QR")		, "float"	 , styleNum_1	, font2);		// 생산량/hr
			    if(ObjUtils.parseDouble(data.get("PRODT_QR")) != 0){
			    	this.setData(row.getCell(X), data.get("PRODT_QR")		, "float"	 , styleNum_1	, font2);		// 생산량/hr
			    } 
			    
			    //this.setData(row.getCell(AA), data.get("TO_PRODT_Q")	, "number"	 , styleNum_2	, font2);		// 내일 계획
			    if(ObjUtils.parseDouble(data.get("TO_PRODT_Q")) != 0){
			    	this.setData(row.getCell(AA), data.get("TO_PRODT_Q")	, "number"	 , styleNum_2	, font2);		// 내일 계획 생산량/hr
			    } 
	        }
        	i++;
        }
		
        // 생산/출고
        List<Map> list2 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList2", param);
        i = 27;
      
        //일일업무보고
        for(Map data : list2) {
        	if(i < 40) {
        		row = sheet1.getRow(i);
        		this.setData(row.getCell(A), data.get("ITEM_NAME")		, "text"	 , stylec02	, font2); 		// 품명
			    this.setData(row.getCell(F), data.get("IN_DAY_Q")		, "float"	 , styleNum_3	, font2);		// 생산량	금일								
			    this.setData(row.getCell(I), data.get("IN_MONTH_Q")		, "float"	 , styleNum_3	, font2);		// 생산량 금월
			    this.setData(row.getCell(L), data.get("IN_TOT_Q")		, "float"	 , styleNum_3	, font2);		// 생산량 총계
			    this.setData(row.getCell(P), data.get("OUT_DAY_Q")		, "float"	 , styleNum_3	, font2);		// 출하량	금일		
			    this.setData(row.getCell(S), data.get("OUT_MONTH_Q")	, "float"	 , styleNum_3	, font2);		// 출하량	금월		
			    this.setData(row.getCell(V), data.get("OUT_TOT_Q")		, "float"	 , styleNum_3	, font2);		// 출하량	총계		
			    this.setData(row.getCell(Z), data.get("TOT_Q")			, "float"	 , styleNum_3	, font2);		// 재고량	
	        }
        	i++;
        }
        
        // 거래처별 출고량
        List<Map> list3 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList3", param);
        i = 41;
        //일일업무보고
        for(Map data : list3) {
        	if(i < 47) {
        		row = sheet1.getRow(i);
        		if(j == 0){
				    this.setData(row.getCell(C), data.get("INOUT_NAME")		, "text"	 , stylec02	, font2); 		// 거래처
				    this.setData(row.getCell(I), data.get("ITEM_NAME")		, "text"	 , stylec02	, font2);		// 제품명							
				    this.setData(row.getCell(M), data.get("INOUT_Q")		, "float"	 , styleNum_3	, font2);		// 출고량
        		} else if(j == 1)	{
        			this.setData(row.getCell(P), data.get("INOUT_NAME")		, "text"	 , stylec02	, font2); 		// 거래처
				    this.setData(row.getCell(V), data.get("ITEM_NAME")		, "text"	 , stylec02	, font2);		// 제품명							
				    this.setData(row.getCell(Z), data.get("INOUT_Q")		, "float"	 , styleNum_3	, font2);		// 출고량
        		}
	        }
        	if( i == 46)	{
        		i = 41 ;
        		j++;
        	} else {
        		i++;
        	}        
        }
        return workbook;

    }
    
    public Workbook makeExcel2( Map param, LoginVO user ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "SKCC_pmr141_1.xlsx"));
        
        String filePath = ConfigUtil.getUploadBasePath("excel/template");
        
        
        Workbook workbook = new XSSFWorkbook(file);
       
        
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        
        DataFormat format = workbook.createDataFormat();

        int  A = 0  ,  B = 1  ,  C = 2  ,  D = 3  ,  E = 4  ,  F = 5   ,  G = 6   ,  H = 7   ,  I = 8  , J = 9;
        int  K = 10 ,  L = 11 ,  M = 12 ,  N = 13 ,  O = 14 ,  P = 15  ,  Q = 16  ,  R = 17  ,  S = 18 , T = 19;
        int  U = 20 ,  V = 21 ,  W = 22 ,  X = 23 ,  Y = 24 ,  Z = 25;
        int AA = 26 , AB = 27 , AC = 28 , AD = 29 , AE = 30 , AF = 31  , AG = 32  , AH = 33  , AI = 34  , AJ = 35;
        int AK = 36 , AL = 37 , AM = 38 , AN = 39 , AO = 40 , AP = 41  ; 
        // 타이틀폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)11);
        font.setFontName("굴림");
        font.setBoldweight((short)Font.BOLDWEIGHT_BOLD);


        // 본문및합계폰트
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)10);
        font2.setFontName("굴림"); //글씨체
        font2.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // Style 01 : 타이틀 왼쪽정렬
        CellStyle style01 = workbook.createCellStyle();
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);
        
        // Stylec 01 : 타이틀 중앙정렬1
        CellStyle stylec01 = workbook.createCellStyle();
        stylec01.setAlignment(CellStyle.ALIGN_CENTER);
        stylec01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        stylec01.setFont(font);

        // Stylec 02 : 본물 중앙정렬1
        CellStyle stylec02 = workbook.createCellStyle();
        stylec02.setAlignment(CellStyle.ALIGN_CENTER);
        stylec02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        stylec02.setFont(font2);

        // Style  0: 숫자(#,##0)
        CellStyle styleNum_0 = workbook.createCellStyle();
        styleNum_0.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_0.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_0.setDataFormat(format.getFormat("#,##0"));
        styleNum_0.setFont(font2);
        
        // Style  1: 숫자(#,##0.0)
        CellStyle styleNum_1 = workbook.createCellStyle();
        styleNum_1.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_1.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_1.setDataFormat(format.getFormat("#,##0.0"));
        styleNum_1.setFont(font2);
        
        // Style  2: 숫자(#,##0.00)
        CellStyle styleNum_2 = workbook.createCellStyle();
        styleNum_2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_2.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_2.setDataFormat(format.getFormat("#,##0.00"));
        styleNum_2.setFont(font2);
        
        // Style 3: 숫자(#,##0.000)
        CellStyle styleNum_3 = workbook.createCellStyle();
        styleNum_3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styleNum_3.setAlignment(CellStyle.ALIGN_RIGHT);
        styleNum_3.setDataFormat(format.getFormat("#,##0.00"));
        styleNum_3.setFont(font2);
        
        Row  row = null;
        Cell cell = null;
        
        //법인명, 작업장 그룹 표시
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("B079", ObjUtils.getSafeString(param.get("GROUP_CD")));

        if(cdo !=null && ObjUtils.isNotEmpty(cdo.getCodeName())) {
        	row = sheet1.getRow(4);
    		this.setData(row.getCell(A), user.getCompName() +" "+ cdo.getCodeName(), "text", style01 , font);
        }
        
        // 생산량
        List<Map> list1 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList4", param);
        int i = 8, j = 0;;
      
        double daySum01   = 0d ,  daySum02   = 0d ,  daySum03   = 0d ,  daySum04   = 0d ,  daySum05   = 0d ,  daySum06   = 0d ;
        double monthSum01 = 0d ,  monthSum02 = 0d ,  monthSum03 = 0d ,  monthSum04 = 0d ,  monthSum05 = 0d ,  monthSum06 = 0d ;
        double    daySumFrQ    = 0d   // 전일재고 일계
        		, dayTotSum    = 0d   // 일계
        		, daySumOutQ   = 0d   // 출허량(일계)
        		, daySumQ      = 0d   // 재고량(일계)
        		, monthSumFrQ  = 0d   // 전일재고 (월계)
                , monthTotSum  = 0d   // 일계(월계)
        		, monthSumOutQ = 0d   // 출하량(월계)
        		, monthInSumQ  = 0d   // 당월누계 생산(월계)
        		, monthOutSumQ = 0d;  // 당월누계 출하(월계)	
        
        for(Map data : list1) {
        	if(i==8)	{
        		// 타이틀 작업일 - 한번만 추가
        		row = sheet1.getRow(5);
        		this.setData(row.getCell(A), data.get("WORK_DATE"), "text", style01 , font);
        		
        		row = sheet1.getRow(7);
        		this.setData(row.getCell(J), data.get("B01")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(M), data.get("B02")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(P), data.get("B03")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(S), data.get("B04")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(V), data.get("B05")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(Y), data.get("B06")		, "text"	 , stylec02 , font2);	
        	} 
        	if(i < 22) {
        		row = sheet1.getRow(i);
        		this.setData(row.getCell(A), data.get("ITEM_NAME")		, "text"	 , stylec02 , font2);	
        		this.setData(row.getCell(G), data.get("FR_DAY_TOT_Q")	, "float"	 , styleNum_2 , font2);	
        		
			    //this.setData(row.getCell(J), data.get("P_DAY_01")		, "float"	 , styleNum_2 , font2);
        		if(ObjUtils.parseDouble(data.get("P_DAY_01")) != 0){
        			this.setData(row.getCell(J), data.get("P_DAY_01")		, "float"	 , styleNum_2 , font2);
        		}
        		
			    //this.setData(row.getCell(M), data.get("P_DAY_02")		, "float"	 , styleNum_2 , font2);	
        		if(ObjUtils.parseDouble(data.get("P_DAY_02")) != 0){
        			this.setData(row.getCell(M), data.get("P_DAY_02")		, "float"	 , styleNum_2 , font2);
        		}
        		
			    //this.setData(row.getCell(P), data.get("P_DAY_03")		, "float"	 , styleNum_2 , font2);
        		if(ObjUtils.parseDouble(data.get("P_DAY_03")) != 0){
        			this.setData(row.getCell(P), data.get("P_DAY_03")		, "float"	 , styleNum_2 , font2);
        		}
        		
			    //this.setData(row.getCell(S), data.get("P_DAY_04")		, "float"	 , styleNum_2 , font2);
        		if(ObjUtils.parseDouble(data.get("P_DAY_04")) != 0){
        			this.setData(row.getCell(S), data.get("P_DAY_04")		, "float"	 , styleNum_2 , font2);
        		}
        		
			    //this.setData(row.getCell(V), data.get("P_DAY_05")		, "float"	 , styleNum_2 , font2);
        		if(ObjUtils.parseDouble(data.get("P_DAY_05")) != 0){
        			this.setData(row.getCell(V), data.get("P_DAY_05")		, "float"	 , styleNum_2 , font2);
        		}
			    
        		//this.setData(row.getCell(Y), data.get("P_DAY_06")		, "float"	 , styleNum_2 , font2);		
        		if(ObjUtils.parseDouble(data.get("P_DAY_06")) != 0){
        			this.setData(row.getCell(Y), data.get("P_DAY_06")		, "float"	 , styleNum_2 , font2);
        		}
        		
			    this.setData(row.getCell(AB), data.get("P_DAY_TOT")	    , "float"	 , styleNum_2 , font2);	//일계
			    this.setData(row.getCell(AE), data.get("OUT_DAY_Q")	    , "float"	 , styleNum_2 , font2);	//출하량
			    this.setData(row.getCell(AH), data.get("TOT_Q")	        , "float"	 , styleNum_2 , font2);	//재고량
			    this.setData(row.getCell(AK), data.get("IN_MONTH_Q")	, "float"	 , styleNum_2 , font2);	//당원누계(생산)
			    this.setData(row.getCell(AN), data.get("OUT_MONTH_Q")	, "float"	 , styleNum_2 , font2);	//당월누계(출하)
			    
			    //일계 계산
			    daySumFrQ  = daySumFrQ+  ObjUtils.parseDouble(data.get("FR_DAY_TOT_Q")) ;
			    daySum01   = daySum01 +  ObjUtils.parseDouble(data.get("P_DAY_01")) ;
			    daySum02   = daySum02 +  ObjUtils.parseDouble(data.get("P_DAY_02")) ;
			    daySum03   = daySum03 +  ObjUtils.parseDouble(data.get("P_DAY_03")) ;
			    daySum04   = daySum04 +  ObjUtils.parseDouble(data.get("P_DAY_04")) ;
			    daySum05   = daySum05 +  ObjUtils.parseDouble(data.get("P_DAY_05")) ;
			    daySum06   = daySum06 +  ObjUtils.parseDouble(data.get("P_DAY_06")) ;
			    dayTotSum  = dayTotSum+  ObjUtils.parseDouble(data.get("P_DAY_TOT")) ;
			    
			    
			    monthSumFrQ= monthSumFrQ+  ObjUtils.parseDouble(data.get("FR_TOT_Q")) ;
			    monthSum01 = monthSum01 + ObjUtils.parseDouble(data.get("P_MONTH_01")) ;
			    monthSum02 = monthSum02 + ObjUtils.parseDouble(data.get("P_MONTH_02")) ;
			    monthSum03 = monthSum03 + ObjUtils.parseDouble(data.get("P_MONTH_03")) ;
			    monthSum04 = monthSum04 + ObjUtils.parseDouble(data.get("P_MONTH_04")) ;
			    monthSum05 = monthSum05 + ObjUtils.parseDouble(data.get("P_MONTH_05")) ;
			    monthSum06 = monthSum06 + ObjUtils.parseDouble(data.get("P_MONTH_06")) ;
			    monthTotSum= monthTotSum+ ObjUtils.parseDouble(data.get("P_MONTH_TOT")) ; 
			    
			    daySumOutQ   = daySumOutQ	+ ObjUtils.parseDouble(data.get("OUT_DAY_Q")) ;  // 출허량(일계)
		        daySumQ      = daySumQ   	+ ObjUtils.parseDouble(data.get("TOT_Q")) ;  // 재고량(일계)
		       // monthSumOutQ = monthSumOutQ	+ ObjUtils.parseDouble(data.get("OUT_DAY_Q")) ;  // 출하량(월계)
		        monthInSumQ  = monthInSumQ	+ ObjUtils.parseDouble(data.get("IN_MONTH_Q")) ;  // 당월누계 생산(월계)
		        monthOutSumQ = monthOutSumQ	+ ObjUtils.parseDouble(data.get("OUT_MONTH_Q")) ;  // 당월누계 출하(월계)	
			    
	        }
        	i++;
        }
        row = sheet1.getRow(21);
	    
        this.setData(row.getCell(G), daySumFrQ		, "float"	 , styleNum_2 , font2);	
        this.setData(row.getCell(J), daySum01		, "float"	 , styleNum_2 , font2);
	    this.setData(row.getCell(M), daySum02		, "float"	 , styleNum_2 , font2);						
	    this.setData(row.getCell(P), daySum03		, "float"	 , styleNum_2 , font2);				
	    this.setData(row.getCell(S), daySum04		, "float"	 , styleNum_2 , font2);			
	    this.setData(row.getCell(V), daySum05		, "float"	 , styleNum_2 , font2);				
	    this.setData(row.getCell(Y), daySum06		, "float"	 , styleNum_2 , font2);	
	    this.setData(row.getCell(AB),dayTotSum	    , "float"	 , styleNum_2 , font2);	
	    
	    this.setData(row.getCell(AE),daySumOutQ	    , "float"	 , styleNum_2 , font2);	
	    this.setData(row.getCell(AH),daySumQ        , "float"	 , styleNum_2 , font2);	
	    
	    row = sheet1.getRow(22);
	    
	    //월계 표현삭제
	    //this.setData(row.getCell(G), monthSumFrQ		, "float"	 , styleNum_2 , font2);	
        this.setData(row.getCell(J), monthSum01		, "float"	 , styleNum_2 , font2);
	    this.setData(row.getCell(M), monthSum02		, "float"	 , styleNum_2 , font2);						
	    this.setData(row.getCell(P), monthSum03		, "float"	 , styleNum_2 , font2);				
	    this.setData(row.getCell(S), monthSum04		, "float"	 , styleNum_2 , font2);			
	    this.setData(row.getCell(V), monthSum05		, "float"	 , styleNum_2 , font2);				
	    this.setData(row.getCell(Y), monthSum06		, "float"	 , styleNum_2 , font2);	
	    this.setData(row.getCell(AB),monthTotSum	, "float"	 , styleNum_2 , font2);	
	    
	    this.setData(row.getCell(AE),daySumOutQ	    , "float"	 , styleNum_2 , font2);	 // 출하량 일계와 월계가 같음 (?)
	    //this.setData(row.getCell(AH),daySumQ        , "float"	 , styleNum_2 , font2);	 //재고량 
	    this.setData(row.getCell(AK), monthInSumQ	, "float"	 , styleNum_2 , font2);	//당원누계(생산)
	    this.setData(row.getCell(AN), monthOutSumQ	, "float"	 , styleNum_2 , font2);	//당월누계(출하)
	    
		
        // 원재료
        List<Map> list2 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList5", param);
        i = 26;
      
        //일일업무보고
        for(Map data : list2) {
        	if(i < 31) {
        		row = sheet1.getRow(i);
        		this.setData(row.getCell(A), data.get("ITEM_NAME")		, "text"	 , stylec02   , font2); 		// 재료명
			    this.setData(row.getCell(G), data.get("FR_TOT_Q")		, "float"	 , styleNum_3 , font2);		// 전일재고								
			    this.setData(row.getCell(M), data.get("IN_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 입고량
			    this.setData(row.getCell(S), data.get("OUT_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 금일 사용량
			    this.setData(row.getCell(Y), data.get("TOT_Q")		    , "float"	 , styleNum_3 , font2);		// 재고량	
			    this.setData(row.getCell(AE), data.get("IN_MONTH_Q")	, "float"	 , styleNum_3 , font2);		// 당월 누계 입 고		
			    this.setData(row.getCell(AK), data.get("OUT_MONTH_Q")	, "float"	 , styleNum_3 , font2);		// 당월 누계 사용량		
	        }
        	i++;
        }
        
        // 부재료
        List<Map> list3 = super.commonDao.list("s_pmr140rkrv_hsServiceImpl.selectList6", param);
        i = 33;
        //일일업무보고
        for(Map data : list3) {
        	if(i < 42) {
        		row = sheet1.getRow(i);
        		if(j == 0){
				    this.setData(row.getCell(A), data.get("ITEM_NAME")		, "text"	 , stylec02   , font2); 	// 부자재 품목
				    this.setData(row.getCell(F), data.get("FR_TOT_Q")		, "float"	 , styleNum_3 , font2);		// 이월							
				    this.setData(row.getCell(J), data.get("IN_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 입고
				    this.setData(row.getCell(N), data.get("OUT_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 출하
				    this.setData(row.getCell(R), data.get("TOT_Q")		    , "float"	 , styleNum_3 , font2);		// 재고
        		} else if(j == 1)	{
        			this.setData(row.getCell(V), data.get("ITEM_NAME")		, "text"	 , stylec02   , font2); 	// 부자재 품목
				    this.setData(row.getCell(AA), data.get("FR_TOT_Q")		, "float"	 , styleNum_3 , font2);		// 이월							
				    this.setData(row.getCell(AE), data.get("IN_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 입고
				    this.setData(row.getCell(AI), data.get("OUT_DAY_Q")		, "float"	 , styleNum_3 , font2);		// 출하
				    this.setData(row.getCell(AM), data.get("TOT_Q")		    , "float"	 , styleNum_3 , font2);		// 재고
        		}
	        }
        	if( i == 42)	{
        		i = 33 ;
        		j++;
        	} else {
        		i++;
        	}        
        }
        return workbook;

    }
    private void setData(Cell cell,  Object data , String type, CellStyle style, Font font) {
    	if("text".equals(type))	{
    		cell.setCellValue(ObjUtils.getSafeString(data));
    	} else if("number".equals(type)) {
    		cell.setCellValue(ObjUtils.parseInt(data));
    		CellStyle mStyle = cell.getCellStyle();
    		mStyle.setDataFormat(style.getDataFormat());
    		mStyle.setAlignment(style.getAlignment());
    		mStyle.setFont(font);
    		cell.setCellStyle(mStyle);
    	} else if("float".equals(type)) {
    		cell.setCellValue(ObjUtils.parseFloat(ObjUtils.getSafeString(data)));
    		CellStyle mStyle = cell.getCellStyle();
    		mStyle.setDataFormat(style.getDataFormat());
    		mStyle.setAlignment(style.getAlignment());
    		mStyle.setFont(font);
    		cell.setCellStyle(mStyle);
    	}
    	
    }
    
    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row).getCell(cell).setCellValue(value);
    }

}