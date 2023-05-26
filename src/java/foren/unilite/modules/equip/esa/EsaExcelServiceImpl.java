package foren.unilite.modules.equip.esa;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
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

@Service( "esaExcelService" )
public class EsaExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "esa100rkrvService" )
    private Esa100rkrvServiceImpl esa100rkrvService;
    
    public Workbook makeExcel( Map param ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "esa100rkrv-201806.xlsx"));
        
        //Get the workbook instance for XLS file 
        Workbook workbook = new XSSFWorkbook(file);
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
        
        Map<Object, String> dataMap = (Map<Object, String>)super.commonDao.select("esa100ukrvServiceImpl.selectExcelMaster", param);
                        
         //sheet1.getRow(4).getCell(B).setCellValue(dataMap.get(""));
        
        //접수번호
        sheet1.getRow(8).getCell(D).setCellValue(dataMap.get("AS_NUM"));
      //접수번호
        sheet1.getRow(9).getCell(D).setCellValue(dataMap.get("ORDER_PRSN"));
      //접수번호
        sheet1.getRow(10).getCell(D).setCellValue(dataMap.get("PERSON_NAME"));
        //처리구분
        sheet1.getRow(11).getCell(D).setCellValue(dataMap.get("AS_TYPE"));
        //유무상(접수):
        sheet1.getRow(12).getCell(D).setCellValue(dataMap.get("BEFORE_PAY_YN"));
        //유무상(처리):
        sheet1.getRow(12).getCell(O).setCellValue(dataMap.get("PAY_YN"));
        
        // 접수자
        sheet1.getRow(13).getCell(G).setCellValue(dataMap.get("ACCEPT_PRSN"));
        // 접수일시
        sheet1.getRow(13).getCell(N).setCellValue(dataMap.get("ACCEPT_DATE"));
        // AS현장/요구자(연락처)
        sheet1.getRow(14).getCell(G).setCellValue(ObjUtils.getSafeString(dataMap.get("WORK_PLACE")) + "/" + ObjUtils.getSafeString(dataMap.get("AS_CUSTOMER_NM")) + "(" + ObjUtils.getSafeString(dataMap.get("PHONE")) + ")");
        // Project No :
        sheet1.getRow(14).getCell(S).setCellValue(dataMap.get("ORDER_NUM"));
        // AS요구대상
        sheet1.getRow(16).getCell(B).setCellValue(dataMap.get("ACCEPT_REMARK"));
        
        
      //조치사항
        List<Map> list4 = super.commonDao.list("esa200ukrvServiceImpl.selectList1", param);
        String closeName = null;
        for(int i = 0; i < 1; i++) {
        	closeName = ObjUtils.getSafeString(list4.get(i).get("CLOSE_NAME"));
        }
        if(list4.size() >= 2) {
        	closeName = closeName + "외 " + ObjUtils.getSafeString(list4.size() - 1) + " 건";
        }
        sheet1.getRow(23).getCell(D).setCellValue(closeName);
        //완료일(처리기간)
        sheet1.getRow(24).getCell(I).setCellValue(ObjUtils.getSafeString(dataMap.get("CLOSE_DATE")) + "(" + ObjUtils.getSafeString(dataMap.get("DAY_COUNT"))  +"일)");
        //처리자
        sheet1.getRow(24).getCell(P).setCellValue(dataMap.get("PERSON_NAME"));

        //조치사항
        List<Map> list0 = super.commonDao.list("esa100ukrvServiceImpl.selectExcelDetail4", param);
        if(list0.size() > 3) {
        	sheet1.getRow(29).getCell(B).setCellValue("상기 외" + ObjUtils.getSafeString(list0.size() - 2) + "건");
        	sheet1.getRow(29).getCell(G).setCellValue("");
        	for(int i = 0; i < 2; i++) {
        		String remarkInfo = ObjUtils.getSafeString(list0.get(i).get("ITEM_NAME"));
            	if(!ObjUtils.getSafeString(list0.get(i).get("MANAGE_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("MANAGE_REMARK"));
            	}
            	if(!ObjUtils.getSafeString(list0.get(i).get("CAUSES_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("CAUSES_REMARK"));
            	}
            	if(!ObjUtils.getSafeString(list0.get(i).get("PREVENT_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("PREVENT_REMARK"));
            	}
            	sheet1.getRow(27 + i).getCell(B).setCellValue(remarkInfo);
            }
        }else{
        	for(int i = 0; i < list0.size(); i++) {
        		String remarkInfo = ObjUtils.getSafeString(list0.get(i).get("ITEM_NAME"));
            	if(!ObjUtils.getSafeString(list0.get(i).get("MANAGE_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("MANAGE_REMARK"));
            	}
            	if(!ObjUtils.getSafeString(list0.get(i).get("CAUSES_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("CAUSES_REMARK"));
            	}
            	if(!ObjUtils.getSafeString(list0.get(i).get("PREVENT_REMARK")).isEmpty()){
            		remarkInfo = remarkInfo + " // " + ObjUtils.getSafeString(list0.get(i).get("PREVENT_REMARK"));
            	}
            	sheet1.getRow(27 + i).getCell(B).setCellValue(remarkInfo);
            }
        }
        
        //자  재  비 (원)
        List<Map> list1 = super.commonDao.list("esa100ukrvServiceImpl.selectExcelDetail1", param);
        double sum1 = 0, sum2 = 0, sum3 = 0, sum4 = 0, sum5 = 0 ,sum6 = 0, sum7 = 0;
        
        if(list1.size() > 6) {
        	sheet1.getRow(37).getCell(B).setCellValue("상기 외" + ObjUtils.getSafeString(list1.size() - 5) + "건");
        	for(int i = 0; i < 5; i++) {
            	sheet1.getRow(32 + i).getCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PART_CODE")));
            	sheet1.getRow(32 + i).getCell(D).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_NAME")));
            	sheet1.getRow(32 + i).getCell(F).setCellValue(ObjUtils.parseDouble(list1.get(i).get("AS_Q")));
            	sheet1.getRow(32 + i).getCell(H).setCellValue(ObjUtils.parseDouble(list1.get(i).get("AS_O")));
            }
        	for(int i = 5; i < list1.size(); i++) {
            	sum7 += ObjUtils.parseDouble(list1.get(i).get("AS_O"));
            }
        	sheet1.getRow(37).getCell(H).setCellValue(sum7);
        }else{
        	for(int i = 0; i < list1.size(); i++) {
            	sheet1.getRow(32 + i).getCell(B).setCellValue(ObjUtils.getSafeString(list1.get(i).get("PART_CODE")));
            	sheet1.getRow(32 + i).getCell(D).setCellValue(ObjUtils.getSafeString(list1.get(i).get("ITEM_NAME")));
            	sheet1.getRow(32 + i).getCell(F).setCellValue(ObjUtils.parseDouble(list1.get(i).get("AS_Q")));
            	sheet1.getRow(32 + i).getCell(H).setCellValue(ObjUtils.parseDouble(list1.get(i).get("AS_O")));
            }
        }
        for(int i = 0; i < list1.size(); i++) {
        	sum2 += ObjUtils.parseDouble(list1.get(i).get("AS_O"));
        }
        sheet1.getRow(38).getCell(H).setCellValue(sum2);
        
        //노 무 비 (원)
        List<Map> list2 = super.commonDao.list("esa100ukrvServiceImpl.selectExcelDetail2", param);
        
        if(list2.size() > 6) {
        	sheet1.getRow(37).getCell(J).setCellValue("상기 외" + ObjUtils.getSafeString(list2.size() - 5) + "건");
        	for(int i = 0; i < 5; i++) {
            	sheet1.getRow(32 + i).getCell(J).setCellValue(ObjUtils.getSafeString(list2.get(i).get("PERSON_NAME")));
            	sheet1.getRow(32 + i).getCell(L).setCellValue(ObjUtils.parseDouble(list2.get(i).get("MAN_HOUR")));
            	sheet1.getRow(32 + i).getCell(N).setCellValue(ObjUtils.parseDouble(list2.get(i).get("LABOR_COST")));
            }
        	for(int i = 5; i < list2.size(); i++) {
        		sum4 += ObjUtils.parseDouble(list2.get(i).get("LABOR_COST"));
            }
        	sheet1.getRow(37).getCell(N).setCellValue(sum4);
        }else{
        	for(int i = 0; i < list2.size(); i++) {
            	sheet1.getRow(32 + i).getCell(J).setCellValue(ObjUtils.getSafeString(list2.get(i).get("PERSON_NAME")));
            	sheet1.getRow(32 + i).getCell(L).setCellValue(ObjUtils.parseDouble(list2.get(i).get("MAN_HOUR")));
            	sheet1.getRow(32 + i).getCell(N).setCellValue(ObjUtils.parseDouble(list2.get(i).get("LABOR_COST")));
            }
        }
        for(int i = 0; i < list2.size(); i++) {
        	sum3 += ObjUtils.parseDouble(list2.get(i).get("LABOR_COST"));
        }
        sheet1.getRow(38).getCell(N).setCellValue(sum3);
        
        //기타경비(원)
        List<Map> list3 = super.commonDao.list("esa100ukrvServiceImpl.selectExcelDetail3", param);
        
        if(list3.size() > 6) {
        	sheet1.getRow(37).getCell(P).setCellValue("상기 외" + ObjUtils.getSafeString(list3.size() - 5) + "건");
        	for(int i = 0; i < 5; i++) {
            	sheet1.getRow(32 + i).getCell(P).setCellValue(ObjUtils.getSafeString(list3.get(i).get("EXPENSE_NAME")));
            	sheet1.getRow(32 + i).getCell(R).setCellValue(ObjUtils.parseDouble(list3.get(i).get("EXPENSE_COST")));
            }
        	for(int i = 5; i < list3.size(); i++) {
        		sum5 += ObjUtils.parseDouble(list3.get(i).get("EXPENSE_COST"));
            }
        	sheet1.getRow(37).getCell(R).setCellValue(sum5);
        }else{
        	for(int i = 0; i < list3.size(); i++) {
            	sheet1.getRow(32 + i).getCell(P).setCellValue(ObjUtils.getSafeString(list3.get(i).get("EXPENSE_NAME")));
            	sheet1.getRow(32 + i).getCell(R).setCellValue(ObjUtils.parseDouble(list3.get(i).get("EXPENSE_COST")));
            }
        }
        for(int i = 0; i < list3.size(); i++) {
        	sum6 += ObjUtils.parseDouble(list3.get(i).get("EXPENSE_COST"));
        }
        sheet1.getRow(38).getCell(R).setCellValue(sum6);
        
        //비용합계(원)
        sheet1.getRow(35).getCell(T).setCellValue(sum2 + sum3 + sum6);
        
        return workbook;
    }
}
