package foren.unilite.modules.z_sh;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
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

@Service("s_mpo080ukrv_shService")
public class S_Mpo080ukrv_shServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
/*

    public ModelAndView downloadExcel( HttpServletRequest request, HttpServletResponse response, Locale locale,
            ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp ) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        Map<String, Object> param = navigator.getParam();

        String data = _req.getP("xmlData");
        String pgmId = _req.getP("pgmId");
        String fileName = _req.getP("fileName");
        int maxRows	= ConfigUtil.getIntValue("common.excel.maxRowsToCSV", 1000);
        logger.debug("excel.maxRowsToCSV " + String.valueOf(maxRows));
        MethodInfo methodInfo = MethodInfoCache.INSTANCE.get(_req.getP("extAction"), _req.getP("extMethod"));
        Map<String, Object> paramMap = _req.getParameterMap();
        Map<String, Object> cMap = new HashMap<String, Object>();
        for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
            if (ObjUtils.isNotEmpty(entry.getValue())) {
                cMap.put(entry.getKey(), entry.getValue());
            } else {
                cMap.put(entry.getKey(), "");
            }
        }
        Object[] paramArr = prepareParameters(request, response, locale, methodInfo, _req);

        List paramList = methodInfo.getParameters();
        //logger.debug("################     methodInfo.getParameters : " + paramList.get(0));

        Object result = ExtDirectSpringUtil.invoke(context, _req.getP("extAction"), methodInfo, paramArr);

        List<Map<String, Object>> dataList = (List<Map<String, Object>>)result;
        if(dataList != null && dataList.size() <= maxRows)	{
        	SXSSFWorkbook wb = excelDownloadService.genWorkBook(data, pgmId, param, dataList, loginVO);
        	return ViewHelper.getExcelDownloadView(wb, ObjUtils.nvl(fileName, pgmId));

         * FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("ExcelDownload"), pgmId+".xlsx");
         * FileOutputStream fos = new FileOutputStream(fInfo.getFile()); wb.write(fos); fos.flush(); fos.close(); wb = null;

        //logger.debug("################    fileName : " + fileName);
        } else if(dataList != null ){
        	StringBuffer wb = excelDownloadService.genCSV(data, pgmId, param, dataList, loginVO, fileName+".csv" );
        	return ViewHelper.getCSVDownloadView(wb, fileName);
        }
        return ViewHelper.getExcelDownloadView(null, ObjUtils.nvl(fileName, pgmId));


        // return ViewHelper.getFileDownloadView(fInfo);
    }
    */

//    public Workbook makeExcel( Map param ) throws Exception {

   /* 참고 1 public static void setDataCell2(Workbook wb, Cell cell, ExcelDownloadFieldVO field, String value) throws Exception {
        CreationHelper createHelper = wb.getCreationHelper();

        if(ExcelUploadFieldVO.FIELD_TYPE_STRING.equals(field.getType())) {
            cell.setCellValue(createHelper.createRichTextString(value));
        } else  if (ExcelUploadFieldVO.FIELD_TYPE_NUMBER.equals(field.getType())) {
            if(!isEmpty(value)) {
                cell.setCellValue(Double.parseDouble(value));
            }
        } else  if (ExcelUploadFieldVO.FIELD_TYPE_INTEGER.equals(field.getType())) {

            if(!isEmpty(value)) {
                cell.setCellValue(Double.parseDouble(value));
            }

        } else {
            cell.setCellValue(value);
        }

    }*/
    public Workbook makeExcel( Map param ) throws Exception {
    	String excelFile = ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "Sample20190618.xlsx";


    	FileOutputStream fileOut = new FileOutputStream(excelFile);

        Workbook workbook = new SXSSFWorkbook();

        Sheet sheet1 = workbook.getSheetAt(0);
        Sheet sheet2 = workbook.getSheetAt(1);
        sheet1.getRow(0).getCell(0).setCellValue("첫번째 시트");
        sheet2.getRow(5).getCell(1).setCellValue("두번째 시트");

    /*  참고 2   CodeInfo codeInfo = tlabCodeService.getCodeInfo(ObjUtils.getSafeString(param.get("S_COMP_CODE")));
        //logger.debug("###################   start data cell" );
        int i=0;
        if(recordList != null) {
            for(Map<String,Object> record : recordList) {
            	i++;
                Row rowSample = sheet.createRow(rowIdx++);
                for(ExcelDownloadFieldVO field : fieldList ) {
                	//logger.debug("###################   field Name "+i+" : "+field.getName() );
                    Cell cell = rowSample.createCell(field.getCol());
                    String value = ObjUtils.getSafeString(record.get(field.getName()));

                    if(field.getComboCode() != null)	{

                    	CodeDetailVO cdo = codeInfo.getCodeInfo(field.getComboCode(), value);
                    	if(cdo != null) {
                    		value = cdo.getCodeName();
                    	}
                    }
                    if(field.getComboDataList() != null)	{
                    	value = ObjUtils.nvl(field.getComboDataList().get(value), value);
                    }
                    //cell.setCellValue(value);


                    ExcelUtil.setDataCell2(wb,cell,field, value);
                    cell.setCellStyle(field.getStyle());
                    cell.setCellType(field.getCellType());
                }

            }

        }*/
        workbook.write(fileOut);

        fileOut.close();

//        return "Y";
//        workbook.close();
    /*
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "20190618mpo080.xlsx"));

        Workbook workbook = new XSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();

        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        Sheet sheet2 = workbook.getSheetAt(1);

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
        sheet1.getRow(0).getCell(0).setCellValue("첫번째 시트");
        sheet2.getRow(5).getCell(1).setCellValue("두번째 시트");
        */

/*
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
        int W = 22;
        int X = 23;
        int Y = 24;
        int Z = 25;
        int AA = 26;
        int AB = 27;
        int AC = 28;
        int AD = 29;
        int AE = 30;
        int AF = 31;
        int AG = 32;
        int AH = 33;
        int AI = 34;
        int AJ = 35;

        int row1 = 0;
        int row2 = 0;
        int row3 = 0;
        int row4 = 0;
        int row5 = 0;
        int row6 = 0;
        int row7 = 0;

        String strChk = "";
        String SAFFER_TAX_NM = "";
        String SAFFER_BANK_NUM = "";
        String RECEIVE_DATE = "";
        String COMP_OWN_NO = "";
        String LOCAL_TAX_GOV = "";
        String DIV_NAME = "";
        String REPRE_NO = "";
        String SUPP_DATE = "";


        // 타이틀폰트
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short)13);
        font.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // 노란색컬럼폰트
        Font font1 = workbook.createFont();
        font1.setFontHeightInPoints((short)10);
        font1.setBoldweight((short)Font.BOLDWEIGHT_BOLD);

        // 본문및합계폰트
        Font font2 = workbook.createFont();
        font2.setFontHeightInPoints((short)9);
        font2.setFontName("돋움체"); //글씨체

     // 본문및합계폰트
        Font font3 = workbook.createFont();
        font3.setFontHeightInPoints((short)9);
        font3.setFontName("돋움체"); //글씨체
        font3.setColor(IndexedColors.WHITE.getIndex());


        // Style 01 : 타이틀 중앙정렬
        CellStyle style01 = workbook.createCellStyle();
        style01.setBorderBottom(CellStyle.BORDER_THIN);
        style01.setBorderLeft(CellStyle.BORDER_THIN);
        style01.setBorderRight(CellStyle.BORDER_THIN);
        style01.setBorderTop(CellStyle.BORDER_THIN);
        style01.setAlignment(CellStyle.ALIGN_CENTER);
        style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style01.setFont(font);

       // Style 02 : 중간명칭 중앙정렬과 노란색
        CellStyle style02 = workbook.createCellStyle();
        style02.setBorderBottom(CellStyle.BORDER_THIN);
        style02.setBorderLeft(CellStyle.BORDER_THIN);
        style02.setBorderRight(CellStyle.BORDER_THIN);
        style02.setBorderTop(CellStyle.BORDER_THIN);
        style02.setAlignment(CellStyle.ALIGN_CENTER);
        style02.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style02.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style02.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style02.setFont(font1);

        // Style 03 : 숫자
        CellStyle style03 = workbook.createCellStyle();
        //style03.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style03.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style03.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style03.setAlignment(CellStyle.ALIGN_RIGHT);
        style03.setDataFormat(format.getFormat("#,##0"));
        style03.setFont(font2);


        // Style 04 : 숫자(밑줄)
        CellStyle style04 = workbook.createCellStyle();
        style04.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style03.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style04.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style04.setAlignment(CellStyle.ALIGN_RIGHT);
        style04.setDataFormat(format.getFormat("#,##0"));
        style04.setFont(font2);

        // Style 05 : 숫자(오른쪽)
        CellStyle style05 = workbook.createCellStyle();
        //style05.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style05.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style05.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style05.setAlignment(CellStyle.ALIGN_RIGHT);
        style05.setDataFormat(format.getFormat("#,##0"));
        style05.setFont(font2);

        // Style 06 : 숫자(밑줄 + 오른쪽)
        CellStyle style06 = workbook.createCellStyle();
        style06.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style06.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style06.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style06.setAlignment(CellStyle.ALIGN_RIGHT);
        style06.setDataFormat(format.getFormat("#,##0"));
        style06.setFont(font2);

        // Style 07 : 숫자(밑줄 + 오른쪽)
        CellStyle style07 = workbook.createCellStyle();
        style07.setBorderBottom(CellStyle.BORDER_THIN);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style07.setBorderRight(CellStyle.BORDER_MEDIUM);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style07.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style07.setAlignment(CellStyle.ALIGN_RIGHT);
        style07.setDataFormat(format.getFormat("#,##0"));
        style07.setFont(font2);

        // Style 08 : 숫자(밑줄 + 오른쪽)
        CellStyle style08 = workbook.createCellStyle();
        style08.setBorderBottom(CellStyle.BORDER_MEDIUM);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        style08.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style08.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style08.setAlignment(CellStyle.ALIGN_RIGHT);
        style08.setDataFormat(format.getFormat("#,##0"));
        style08.setFont(font2);

        // Style 08 : 숫자(밑줄 + 오른쪽 + 글씨색 흰색)
        CellStyle style09 = workbook.createCellStyle();
        //style08.setBorderBottom(CellStyle.BORDER_MEDIUM);
        //style03.setBorderLeft(CellStyle.BORDER_THIN);
        //style08.setBorderRight(CellStyle.BORDER_THIN);
        //style03.setBorderTop(CellStyle.BORDER_THIN);
        style09.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style09.setAlignment(CellStyle.ALIGN_RIGHT);
        //style09.setDataFormat(format.getFormat("#,##0"));
        style09.setFont(font3);


        List<Map> list1 = super.commonDao.list("hpa990ukrServiceImpl.printExcel1", param);

        Row  row = null;
        Cell cell = null;

        if(list1.size() > 0) {
        	//신고세무소명
        	SAFFER_TAX_NM = ObjUtils.getSafeString(list1.get(0).get("SAFFER_TAX_NM"));
        	//납부서 계좌번호
		    SAFFER_BANK_NUM = ObjUtils.getSafeString(list1.get(0).get("SAFFER_BANK_NUM"));
		    //작성일자
		    RECEIVE_DATE = ObjUtils.getSafeString(param.get("RECEIVE_DATE"));
		    //법인등록번호
		    COMP_OWN_NO = ObjUtils.getSafeString(list1.get(0).get("COMP_OWN_NO"));
		    //주민세관할관청
		    LOCAL_TAX_GOV = ObjUtils.getSafeString(list1.get(0).get("LOCAL_TAX_GOV"));
		    //사업장명
		    DIV_NAME = ObjUtils.getSafeString(list1.get(0).get("DIV_NAME"));
		    //주민등록번호
		    REPRE_NO = ObjUtils.getSafeString(list1.get(0).get("REPRE_NO"));
		    //지급일
		    SUPP_DATE = ObjUtils.getSafeString(param.get("SUPP_DATE"));


	        //----------------------------------------//
	        //시트1
	        //----------------------------------------//
	        //귀속년월
	        row = sheet1.getRow(2);
			cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(param.get("PAY_YYYYMM")).substring(0,4) + "년 " + ObjUtils.getSafeString(param.get("PAY_YYYYMM")).substring(4,6) + "월");

		    //지급년월
		    row = sheet1.getRow(3);
		    cell = row.getCell(N);
		    cell.setCellValue(ObjUtils.getSafeString(param.get("SUPP_DATE")).substring(0,4) + "년 " + ObjUtils.getSafeString(param.get("SUPP_DATE")).substring(4,6) + "월");


		    for(int i = 0; i < list1.size(); i++) {

		    	//근로소득
		    	if ("A01".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){

		    		//간이세액 인원
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));

		    		//간이세액 총지급액
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style05);

		    		//간이세액 소득세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style03);

		    		//농어촌특별세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style03);

		    		//가산세
		    	    row = sheet1.getRow(13);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style03);

		    	} else if ("A02".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){

		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(E);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_CNT")));

		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(G);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
		    	    cell.setCellStyle(style05);

		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(H);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
		    	    cell.setCellStyle(style03);

		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(I);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
		    	    cell.setCellStyle(style03);

		    	    row = sheet1.getRow(14);
		    	    cell = row.getCell(J);
		    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
		    	    cell.setCellStyle(style03);

		    	}

			}

			//----------------------------------------//
	        //시트3
	        //----------------------------------------//

				for(int i = 0; i < list1.size(); i++) {

					if ("C61".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){

						//소득지급 인원
						row = sheet3.getRow(3);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));

			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 소득세
						row = sheet3.getRow(3);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 가산세
						row = sheet3.getRow(3);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //조징환급세액
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //납부세액 소득세등
						row = sheet3.getRow(3);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(3);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);

					} else if ("C62".equals(ObjUtils.getSafeString(list1.get(i).get("INCCODE")))){

						//소득지급 인원
						row = sheet3.getRow(4);
			    	    cell = row.getCell(H);
			    	    cell.setCellValue(ObjUtils.getSafeString(list1.get(i).get("INCOME_CNT")));

			    	    //소득지급 총지급액
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(I);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("INCOME_SUPP_TOTAL_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 소득세
						row = sheet3.getRow(4);
			    	    cell = row.getCell(J);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 농어촌특별세
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(K);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("DEF_SP_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //징수세액 가산세
						row = sheet3.getRow(4);
			    	    cell = row.getCell(L);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("ADD_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //조징환급세액
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(M);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("RET_IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //납부세액 소득세등
						row = sheet3.getRow(4);
			    	    cell = row.getCell(N);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("IN_TAX_I")));
			    	    cell.setCellStyle(style06);

			    	    //납부세액 농어촌특별세
			    	    row = sheet3.getRow(4);
			    	    cell = row.getCell(O);
			    	    cell.setCellValue(ObjUtils.parseDouble(list1.get(i).get("SP_TAX_I")));
			    	    cell.setCellStyle(style07);

					}
				}

				//근로소득납부서
				sheet4 = makeExcelSheet4(sheet4, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);
				//주민세납부서
				sheet5 = makeExcelSheet5(sheet5, SAFFER_TAX_NM, SAFFER_BANK_NUM, RECEIVE_DATE);

	        }
		*/
        return workbook;



	}
















	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectMasterList", param);
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		param.put("MRP_CONTROL_NUM", param.get("MRP_CONTROL_NUM"));
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectDetailList", param);
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1_Print(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectDetailList1_Print", param);
	}
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectDetailList2", param);
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectDetailList3", param);
	}


	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3_Print(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectDetailList3_Print", param);
	}
	/**
	 *
	 * 생산계획 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProdList(Map param) throws Exception {
		return super.commonDao.list("s_mpo080ukrv_shServiceImpl.selectProdList", param);
	}


	/**
	 * master 그리드 삭제
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//List<Map> dataList = new ArrayList<Map>();
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			if(paramData.get("method").equals("insertMaster"))
				insertList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("updateMaster"))
				updateList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("deleteMaster"))
				deleteList = (List<Map>)paramData.get("data");

			if(deleteList != null) {
				this.deleteMaster(keyValue, deleteList, user);
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * datail 그리드 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//List<Map> dataList = new ArrayList<Map>();
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))
				insertList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("updateDetail"))
				updateList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("deleteDetail"))
				deleteList = (List<Map>)paramData.get("data");

			if(insertList != null) {
				oprFlag = "N";
				this.insertLogDetail(keyValue, oprFlag, insertList, user);
				this.insertDetail(keyValue, insertList, user);
			}
			if(updateList != null) {
				oprFlag = "U";
				this.insertLogDetail(keyValue, oprFlag, updateList, user);
				this.updateDetail(keyValue, updateList, user);
			}
			if(deleteList != null) {
				oprFlag = "D";
				this.insertLogDetail(keyValue, oprFlag, deleteList, user);
				this.deleteDetail(keyValue, deleteList, user);
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	private void insertLogDetail(String keyValue, String oprFlag, List<Map> dataList, LoginVO user) {
		for(Map param:  dataList) {
			if(ObjUtils.parseDouble(ObjUtils.getSafeString(param.get("ORDER_REQ_Q"))) > 0){
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("COMP_CDOE", user.getCompCode());
				param.put("WORK_STEP", "M");  //'T':임시,'M':소요량
				if(ObjUtils.isEmpty(param.get("SER_NO"))){
					param.put("SER_NO", 0);
				}

				super.commonDao.insert("s_mpo080ukrv_shServiceImpl.insertLogDetail", param);
			}
		}
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
        return 0;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int updateDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);

		super.commonDao.queryForObject("s_mpo080ukrv_shServiceImpl.USP_MATRL_MPO070UKRV", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new Exception(errorDesc);
		}

		return 0;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int deleteDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		return 0;
	}


	/**
	 * 소요량계산 버튼 누를시
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> buttonSave(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		//1.로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String remark = ObjUtils.getSafeString(dataMaster.get("REMARK"));

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;

			String oprFlag = "N";
			if(paramData.get("method").equals("buttonInsert"))
				insertList = (List<Map>)paramData.get("data");

			if(insertList != null) {
				oprFlag = "N";
				this.insertLogButton(keyValue, oprFlag, remark, insertList, user);
				this.buttonInsert(keyValue, insertList, user, dataMaster);
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}


	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	private void insertLogButton(String keyValue, String oprFlag, String remark, List<Map> dataList, LoginVO user)throws Exception {
		for(Map param:  dataList) {
			Map checkOrder = (Map) super.commonDao.select("s_mpo080ukrv_shServiceImpl.checkOrder", param);

            if(ObjUtils.isNotEmpty(checkOrder) && ObjUtils.getSafeString(checkOrder.get("ORDER_YN")).equals("Y")){
                throw new  UniDirectValidateException("이미 발주확정된 데이터가 있습니다. 확인 후 다시 시도해 주십시오.");
            }else{

				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("REMARK", remark);
				param.put("COMP_CDOE", user.getCompCode());
				param.put("WORK_STEP", "M");  //'T':임시,'M':소요량
				if(ObjUtils.isEmpty(param.get("SER_NO"))){
					param.put("SER_NO", 0);
				}

				super.commonDao.insert("s_mpo080ukrv_shServiceImpl.insertLogMaster", param);
            }
		}

		return;
	}


	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int buttonInsert(String keyValue, List<Map> dataList, LoginVO user, Map dataMaster) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);

		super.commonDao.queryForObject("s_mpo080ukrv_shServiceImpl.USP_CALC_PL", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new Exception(errorDesc);
		}else{
			dataMaster.put("RtnMrpNum", ObjUtils.getSafeString(spParam.get("RtnMrpNum")));
		}

		return 0;
	}



	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
        return 0;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int updateMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int deleteMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		for(Map param : dataList) {
			int res = super.commonDao.update("s_mpo080ukrv_shServiceImpl.deleteMaster", param);
			if(res > 0) {
				super.commonDao.update("s_mpo080ukrv_shServiceImpl.deleteDetail", param);
			}
		}
		return 0;
	}
}
