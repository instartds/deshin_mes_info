package foren.unilite.modules.accnt.aha;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.DevFreeUtils;

@Service( "ahaExcelService" )
public class AhaExcelServiceImpl extends TlabAbstractServiceImpl {
    private final Logger         logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "aha990ukrService" )
    private Aha990ukrServiceImpl aha990ukrService;
    
    public Workbook makeExcel( Map param ) throws Exception {
        FileInputStream file = new FileInputStream(new File(ConfigUtil.getUploadBasePath("ExcelFrame") + File.separatorChar + "hpa960az-201602.xls"));
        
        //Get the workbook instance for XLS file 
        Workbook workbook = new HSSFWorkbook(file);
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        //Get first sheet from the workbook
        Sheet sheet1 = workbook.getSheetAt(0);
        Sheet sheet2 = workbook.getSheetAt(1);
        Sheet sheet3 = workbook.getSheetAt(2);
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
        boolean strBuChk = false;
        double sJuminAmt = 0;
        
        List<Map<Object, String>> dataList1 = super.commonDao.list("aha990ukrServiceImpl.selectExcelView1", param);
        Map<Object, String> dataMap = (Map<Object, String>)super.commonDao.select("aha990ukrServiceImpl.selectExcelView2", param);
        
        //주민번호 복호화
        //        for(Map repreMap: dataList1){
        //            repreMap.put("REPRE_NO", decryp.getDecrypto("1", repreMap.get("REPRE_NO").toString()));
        //        }
        
        if (!ObjUtils.isEmpty(dataList1)) {
            Map<Object, String> dataMap1 = dataList1.get(0);
            sheet1.getRow(2).getCell(N).setCellValue(DevFreeUtils.getOrDefault(param.get("PAY_YYYYMM"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("PAY_YYYYMM"), "").toString().substring(4, 6) + "월");          //귀속년월
            sheet1.getRow(3).getCell(N).setCellValue(DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(4, 6) + "월");    //지급년월
            
            sheet1.getRow(7).getCell(N).setCellValue(dataMap1.get("TELEPHON"));         //전화번호
            sheet1.getRow(8).getCell(P).setCellValue(dataMap1.get("COMP_OWN_NO"));      //법인등록번호
            sheet1.getRow(5).getCell(E).setCellValue(dataMap1.get("DIV_FULL_NAME"));    //법인명(상호)
            sheet1.getRow(5).getCell(I).setCellValue(dataMap1.get("REPRE_NAME"));       //대표자성명
            sheet1.getRow(7).getCell(E).setCellValue(dataMap1.get("COMPANY_NUM"));      //사업자(주민)등록번호
            sheet1.getRow(7).getCell(I).setCellValue(dataMap1.get("ADDR"));             //사업장소재지
            
            sheet1.getRow(48).getCell(G).setCellValue(DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(0, 4) + "년   " + DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(4, 6) + "월   " + DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(6, 8) + "일");   //서류날짜
            sheet1.getRow(49).getCell(G).setCellValue(dataMap1.get("DIV_FULL_NAME"));   //원천징수 의무자                   
            sheet1.getRow(54).getCell(C).setCellValue(dataMap1.get("SAFFER_TAX_NM") + "세무서장 귀하");   //세무서명      
            sheet1.getRow(55).getCell(P).setCellValue(dataMap1.get("SAFFER_TAX_NM"));
            sheet1.getRow(55).getCell(A).setCellValue(dataMap1.get("SAFFER_TAX"));                    //세무서코드
            
            sheet1.getRow(53).getCell(P).setCellValue(dataMap1.get("SAFFER_BANK_NUM"));               //세무서코드
            
            sheet1.getRow(52).getCell(G).setCellValue(dataMap1.get("TAX_NAME"));       //세무대리인이름
            sheet1.getRow(8).getCell(N).setCellValue(dataMap1.get("EMAIL"));           //전자우편주소
            sheet1.getRow(49).getCell(N).setCellValue(dataMap1.get("TAX_NAME"));
            try {
                sheet1.getRow(50).getCell(N).setCellValue(DevFreeUtils.getOrDefault(dataMap1.get("TAX_NUM"), "").substring(0, 3) + "-" + DevFreeUtils.getOrDefault(dataMap1.get("TAX_NUM"), "").substring(3, 5) + "-" + DevFreeUtils.getOrDefault(dataMap1.get("TAX_NUM"), "").substring(5, 10));   //세무대리인 사업자등록번호   
            } catch (Exception e) {
                sheet1.getRow(50).getCell(N).setCellValue("");
            }
            sheet1.getRow(51).getCell(N).setCellValue(dataMap1.get("TAX_TEL"));     //세무대리인 전화번호
            //            row = sheet1.getRow(2);    cell = row.getCell(Q);    cell.setCellValue(dataMap1.get(""));
            sheet1.getRow(2).getCell(Q).setCellValue(DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(4, 6) + "월" + DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(6, 8) + "일");   //지급일자
            sheet1.getRow(3).getCell(Q).setCellValue(DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(4, 6) + "월" + DevFreeUtils.getOrDefault(param.get("WRITE_YYYYMMDD"), "").toString().substring(6, 8) + "일");//작성일자
            
            sheet1.getRow(5).getCell(Q).setCellValue(decrypto.getDecrypto("1", dataMap1.get("REPRE_NO").toString())); //대표자 주민등록번호
            sheet1.getRow(8).getCell(Q).setCellValue(dataMap1.get("DIV_NAME")); //사업장명
            sheet1.getRow(9).getCell(Q).setCellValue(dataMap1.get("FAX_NUM"));  //FAX번호
            sheet1.getRow(10).getCell(Q).setCellValue(ObjUtils.parseDouble(dataMap1.get("SCOUNT")));  //인원(사업소세)  
            
            sheet1.getRow(11).getCell(Q).setCellValue(ObjUtils.parseDouble(dataMap1.get("TOTAL_I")));//과세표준액합계(사업소세)
            sheet1.getRow(5).getCell(R).setCellValue(ObjUtils.parseDouble(dataMap1.get("TAX_AMOUNT_I")));    //과세표준액비과세대상(사업소세)
            sheet1.getRow(3).getCell(R).setCellValue(ObjUtils.parseDouble(dataMap1.get("TAX_EXEMPTION_I"))); //과세표준액과세대상(사업소세)
            sheet1.getRow(2).getCell(R).setCellValue(dataMap1.get("LOCAL_TAX_GOV"));   //신고시.군.구청
            
            //sheet1 저장..
            for (Map paramMap : dataList1) {
                switch (DevFreeUtils.getOrDefault(paramMap.get("INCCODE"), "").toString()) {
                    //**********************************************************************************
                    // 근로소득
                    //********************************************************************************** 
                    case "A01":
                        this.setSheetValue(sheet1, E, 14, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                //간이세액 인원       
                        this.setSheetValue(sheet1, G, 14, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));       //간이세액 총지급액     
                        this.setSheetValue(sheet1, H, 14, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));              //간이세액 소득세      
                        this.setSheetValue(sheet1, I, 14, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));              //농어촌특별세        
                        this.setSheetValue(sheet1, J, 14, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));                 //가산세           
                        this.setSheetValue(sheet1, Q, 14, ObjUtils.parseDouble(paramMap.get("LOCAL_TAX_I")));               //간이세액 주민세      
                        this.setSheetValue(sheet1, Q, 22, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                //간이세액 주민세 납부인원 
                    break;
                    
                    case "A02":
                        this.setSheetValue(sheet1, E, 15, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                //간이세액 인원   
                        this.setSheetValue(sheet1, G, 15, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));       //간이세액 총지급액 
                        this.setSheetValue(sheet1, H, 15, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));              //간이세액 소득세  
                        this.setSheetValue(sheet1, I, 15, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));              //농어촌특별세    
                        this.setSheetValue(sheet1, J, 15, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));                 //가산세       
                        this.setSheetValue(sheet1, Q, 15, ObjUtils.parseDouble(paramMap.get("LOCAL_TAX_I")));               //중도퇴사 주민세  
                    break;
                    
                    case "A03":
                        this.setSheetValue(sheet1, E, 16, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                 //간이세액 인원   
                        this.setSheetValue(sheet1, G, 16, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));        //간이세액 총지급액 
                        this.setSheetValue(sheet1, H, 16, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));               //간이세액 소득세  
                        this.setSheetValue(sheet1, J, 16, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));                  //가산세       
                        this.setSheetValue(sheet1, Q, 16, ObjUtils.parseDouble(paramMap.get("LOCAL_TAX_I")));                //일용근로 주민세  
                        this.setSheetValue(sheet1, R, 11, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                 //일용근로 인원   
                        this.setSheetValue(sheet1, R, 12, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));        //일용근로 총지급액            
                    break;
                    
                    case "A04":
                        this.setSheetValue(sheet1, E, 17, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                  //간이세액 인원   
                        this.setSheetValue(sheet1, G, 17, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));         //간이세액 총지급액 
                        this.setSheetValue(sheet1, H, 17, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));                //간이세액 소득세  
                        this.setSheetValue(sheet1, I, 17, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 17, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) == 0) {
                            sheet1.getRow(3).getCell(A).setCellValue("(매월)");
                            sheet1.getRow(3).getCell(D).setCellValue("연말");
                        } else {
                            sheet1.getRow(3).getCell(A).setCellValue("(매월)");
                            sheet1.getRow(3).getCell(D).setCellValue("(연말)");
                        }
                    break;
                    
                    case "A05":
                        this.setSheetValue(sheet1, E, 18, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                   //간이세액 인원   
                        this.setSheetValue(sheet1, G, 18, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));          //간이세액 총지급액 
                        this.setSheetValue(sheet1, H, 18, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));                 //간이세액 소득세  
                        this.setSheetValue(sheet1, I, 18, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 18, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                    break;
                    
                    case "A06":
                        //                    this.setSheetValue(sheet1, , , ObjUtils.parseDouble(paramMap.get
                        this.setSheetValue(sheet1, E, 19, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                   //간이세액 인원   
                        this.setSheetValue(sheet1, G, 19, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));          //간이세액 총지급액 
                        this.setSheetValue(sheet1, H, 19, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));                 //간이세액 소득세  
                        this.setSheetValue(sheet1, I, 19, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 19, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                    break;
                    
                    case "A10":
                        this.setSheetValue(sheet1, E, 20, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                    //간이세액 인원    
                        this.setSheetValue(sheet1, G, 20, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));           //간이세액 총지급액  
                        this.setSheetValue(sheet1, H, 20, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));                  //간이세액 소득세   
                        this.setSheetValue(sheet1, I, 20, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 20, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 20, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 20, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 20, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                        
                        sJuminAmt = ObjUtils.parseDouble(paramMap.get("LOCAL_TAX_I"));
                    break;
                    //**********************************************************************************
                    // 퇴직소득
                    //**********************************************************************************     
                    case "A21":
                        this.setSheetValue(sheet1, E, 21, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 21, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 21, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 21, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 21, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 21, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                    break;
                    
                    case "A22":
                        this.setSheetValue(sheet1, E, 22, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 22, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 22, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 22, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 22, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 22, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                    break;
                    
                    case "A20":
                        this.setSheetValue(sheet1, E, 23, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 23, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 23, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 23, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 23, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 23, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                    break;
                    //**********************************************************************************
                    // 사업소득
                    //**********************************************************************************
                    case "A25":
                        this.setSheetValue(sheet1, E, 24, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 24, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 24, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 24, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        
                    break;
                    
                    case "A26":
                        this.setSheetValue(sheet1, E, 25, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 25, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 25, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, I, 25, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 25, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                    break;
                    
                    case "A30":
                        this.setSheetValue(sheet1, E, 26, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 26, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 26, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, I, 26, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 26, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 26, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 26, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 26, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                        this.setSheetValue(sheet1, P, 26, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                      //사업소득 주민세 납부인원
                    break;
                    //**********************************************************************************
                    // 기타소득
                    //**********************************************************************************     
                    case "A41":
                        this.setSheetValue(sheet1, E, 27, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 27, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 27, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 27, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 27, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 27, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 27, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                    break;
                    
                    case "A42":
                        this.setSheetValue(sheet1, E, 28, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 28, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 28, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 28, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 28, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 28, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 28, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                    break;
                    
                    case "A40":
                        this.setSheetValue(sheet1, E, 29, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        this.setSheetValue(sheet1, G, 29, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));
                        this.setSheetValue(sheet1, H, 29, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));
                        this.setSheetValue(sheet1, J, 29, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 29, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 29, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 29, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                    break;
                    //**********************************************************************************
                    // 연금소득
                    //**********************************************************************************     
                    case "A48":
                        this.setSheetValue(sheet1, E, 30, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원            
                        this.setSheetValue(sheet1, G, 30, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액          
                        this.setSheetValue(sheet1, H, 30, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세           
                        this.setSheetValue(sheet1, J, 30, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 30, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 30, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 30, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //연금소득 주민세 납부인원      
                    break;
                    
                    case "A45":
                        this.setSheetValue(sheet1, E, 31, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원      
                        this.setSheetValue(sheet1, G, 31, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액    
                        this.setSheetValue(sheet1, H, 31, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세     
                        this.setSheetValue(sheet1, J, 31, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 31, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 31, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 31, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //연금소득 주민세 납부인원
                    break;
                    
                    case "A46":
                        this.setSheetValue(sheet1, E, 32, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원      
                        this.setSheetValue(sheet1, G, 32, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액    
                        this.setSheetValue(sheet1, H, 32, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세     
                        this.setSheetValue(sheet1, J, 32, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 32, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 32, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 32, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //연금소득 주민세 납부인원
                    break;
                    
                    case "A47":
                        this.setSheetValue(sheet1, E, 33, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원       
                        this.setSheetValue(sheet1, G, 33, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액     
                        this.setSheetValue(sheet1, H, 33, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세      
                        this.setSheetValue(sheet1, J, 33, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 33, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 33, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 33, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //연금소득 주민세 납부인원 
                    break;
                    //**********************************************************************************
                    // 이자소득
                    //**********************************************************************************    
                    case "A50":
                        this.setSheetValue(sheet1, E, 34, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원      
                        this.setSheetValue(sheet1, G, 34, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액    
                        this.setSheetValue(sheet1, H, 34, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세     
                        this.setSheetValue(sheet1, I, 34, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 34, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 34, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 34, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 34, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                        this.setSheetValue(sheet1, P, 34, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //이자소득 주민세 납부인원
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) != 0) {
                            strBuChk = true;
                        }
                    break;
                    //**********************************************************************************
                    // 배당소득
                    //**********************************************************************************   
                    case "A60":
                        this.setSheetValue(sheet1, E, 35, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원      
                        this.setSheetValue(sheet1, G, 35, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액    
                        this.setSheetValue(sheet1, H, 35, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세     
                        this.setSheetValue(sheet1, I, 35, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 35, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 35, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 35, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 35, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                        this.setSheetValue(sheet1, P, 35, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //배당소득 주민세 납부인원
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) != 0) {
                            strBuChk = true;
                        }
                    break;
                    //**********************************************************************************
                    // 저축해지 추징세액
                    //**********************************************************************************   
                    case "A69":
                        this.setSheetValue(sheet1, E, 36, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원         
                        this.setSheetValue(sheet1, H, 36, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세        
                        this.setSheetValue(sheet1, J, 36, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 36, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 36, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) != 0) {
                            strBuChk = true;
                        }
                    break;
                    //**********************************************************************************
                    // 비거주자양도소득
                    //**********************************************************************************     
                    case "A70":
                        this.setSheetValue(sheet1, E, 37, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원          
                        this.setSheetValue(sheet1, G, 37, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액        
                        this.setSheetValue(sheet1, H, 37, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세         
                        this.setSheetValue(sheet1, J, 37, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 37, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 37, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) != 0) {
                            strBuChk = true;
                        }
                    break;
                    //**********************************************************************************
                    // 내외국법인원천
                    //**********************************************************************************
                    case "A80":
                        this.setSheetValue(sheet1, E, 38, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원          
                        this.setSheetValue(sheet1, G, 38, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액        
                        this.setSheetValue(sheet1, H, 38, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세         
                        this.setSheetValue(sheet1, J, 38, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 38, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 38, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, P, 38, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));
                        if (ObjUtils.parseDouble(paramMap.get("INCOME_CNT")) != 0) {
                            strBuChk = true;
                        }
                    break;
                    //**********************************************************************************
                    // 수정신고(세액)
                    //**********************************************************************************  
                    case "A90":
                        this.setSheetValue(sheet1, H, 39, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세       
                        this.setSheetValue(sheet1, I, 39, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 39, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 39, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 39, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 39, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                    break;
                    //**********************************************************************************
                    // 총합계
                    //**********************************************************************************
                    case "A99":
                        this.setSheetValue(sheet1, E, 40, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //간이세액 인원          
                        this.setSheetValue(sheet1, G, 40, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //간이세액 총지급액        
                        this.setSheetValue(sheet1, H, 40, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //간이세액 소득세         
                        this.setSheetValue(sheet1, I, 40, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));
                        this.setSheetValue(sheet1, J, 40, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));
                        this.setSheetValue(sheet1, L, 40, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));
                        this.setSheetValue(sheet1, M, 40, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));
                        this.setSheetValue(sheet1, N, 40, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));
                    break;
                    
                    default:
                    break;
                }
            }
            
            this.setSheetValue(sheet1, S, 20, sJuminAmt);  //주민세액
            if (strBuChk) {
                sheet2.getRow(1).getCell(A).setCellValue("사업자등록번호" + dataMap1.get("COMPANY_NUM"));
                sheet1.getRow(47).getCell(L).setCellValue("○");
            }
            
            //sheet2, 3 저장..
            for (Map paramMap : dataList1) {
                switch (DevFreeUtils.getOrDefault(paramMap.get("INCCODE"), "").toString()) {
                    
                    //sheet1 저장
                    case "C01":
                        //                        this.setSheetValue(sheet2, E, 14, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));                //간이세액 인원
                        this.setSheetValue(sheet2, H, 5, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원  
                        this.setSheetValue(sheet2, I, 5, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액
                    break;
                    
                    case "C02":
                        this.setSheetValue(sheet2, H, 6, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원  
                        this.setSheetValue(sheet2, I, 6, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액
                    break;
                    
                    case "C03":
                        this.setSheetValue(sheet2, H, 7, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원  
                        this.setSheetValue(sheet2, I, 7, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액
                    break;
                    
                    case "C05":
                        this.setSheetValue(sheet2, H, 8, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원  
                        this.setSheetValue(sheet2, I, 8, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액
                    break;
                    
                    case "C06":
                        this.setSheetValue(sheet2, H, 9, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원       
                        this.setSheetValue(sheet2, I, 9, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액     
                        this.setSheetValue(sheet2, K, 9, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //농어촌 특별세       
                        this.setSheetValue(sheet2, L, 9, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //가산세           
                    break;
                    
                    case "C07":
                        this.setSheetValue(sheet2, H, 10, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 10, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                    break;
                    
                    case "C08":
                        this.setSheetValue(sheet2, H, 11, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 11, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        
                    break;
                    
                    case "C10":
                        this.setSheetValue(sheet2, H, 12, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 12, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        
                    break;
                    
                    case "C20":
                        this.setSheetValue(sheet2, H, 13, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 13, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        
                    break;
                    
                    case "C23":
                        this.setSheetValue(sheet2, H, 14, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 14, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        
                    break;
                    
                    case "C28":
                        this.setSheetValue(sheet2, H, 15, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, I, 15, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        
                    break;
                    
                    case "C40":
                        this.setSheetValue(sheet2, H, 16, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 16, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, K, 16, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 16, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C19":
                        this.setSheetValue(sheet2, H, 17, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 17, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, K, 17, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 17, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C29":
                        this.setSheetValue(sheet2, H, 18, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 18, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, K, 18, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 18, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C11":
                        this.setSheetValue(sheet2, H, 19, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원        
                        this.setSheetValue(sheet2, I, 19, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액      
                        this.setSheetValue(sheet2, J, 19, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세       
                        this.setSheetValue(sheet2, K, 19, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세    
                        this.setSheetValue(sheet2, L, 19, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세       
                        
                    break;
                    
                    case "C31":
                        this.setSheetValue(sheet2, H, 20, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 20, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, J, 20, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세      
                        this.setSheetValue(sheet2, K, 20, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 20, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C33":
                        this.setSheetValue(sheet2, H, 21, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 21, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, J, 21, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세      
                        this.setSheetValue(sheet2, K, 21, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 21, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C34":
                        this.setSheetValue(sheet2, H, 22, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 22, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, J, 22, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세      
                        this.setSheetValue(sheet2, K, 22, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 22, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C54":
                        this.setSheetValue(sheet2, H, 23, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 23, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 23, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 23, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C55":
                        this.setSheetValue(sheet2, H, 24, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 24, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 24, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 24, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C56":
                        this.setSheetValue(sheet2, H, 25, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 25, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, J, 25, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세      
                        this.setSheetValue(sheet2, K, 25, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 25, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C57":
                        this.setSheetValue(sheet2, H, 26, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원        
                        this.setSheetValue(sheet2, I, 26, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액      
                        this.setSheetValue(sheet2, J, 26, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세       
                        this.setSheetValue(sheet2, K, 26, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세    
                        this.setSheetValue(sheet2, L, 26, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세       
                        
                    break;
                    
                    case "C12":
                        this.setSheetValue(sheet2, H, 27, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원        
                        this.setSheetValue(sheet2, I, 27, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액      
                        this.setSheetValue(sheet2, J, 27, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세       
                        this.setSheetValue(sheet2, K, 27, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세    
                        this.setSheetValue(sheet2, L, 27, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세       
                        
                    break;
                    
                    case "C22":
                        this.setSheetValue(sheet2, H, 28, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원       
                        this.setSheetValue(sheet2, I, 28, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액     
                        this.setSheetValue(sheet2, J, 28, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세      
                        this.setSheetValue(sheet2, K, 28, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세   
                        this.setSheetValue(sheet2, L, 28, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세      
                        
                    break;
                    
                    case "C13":
                        this.setSheetValue(sheet2, H, 29, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 29, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 29, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 29, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C18":
                        this.setSheetValue(sheet2, H, 30, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원      
                        this.setSheetValue(sheet2, I, 30, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액    
                        this.setSheetValue(sheet2, J, 30, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세     
                        this.setSheetValue(sheet2, L, 30, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세     
                        
                    break;
                    
                    case "C36":
                        this.setSheetValue(sheet2, H, 31, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원        
                        this.setSheetValue(sheet2, I, 31, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액      
                        this.setSheetValue(sheet2, J, 31, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세       
                        this.setSheetValue(sheet2, L, 31, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세       
                        
                    break;
                    
                    case "C37":
                        this.setSheetValue(sheet2, H, 32, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 32, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 32, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 32, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C38":
                        this.setSheetValue(sheet2, H, 33, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 33, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 33, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 33, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C52":
                        this.setSheetValue(sheet2, H, 34, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원     
                        this.setSheetValue(sheet2, I, 34, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액   
                        this.setSheetValue(sheet2, J, 34, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세    
                        this.setSheetValue(sheet2, L, 34, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세    
                        
                    break;
                    
                    case "C58":
                        this.setSheetValue(sheet2, H, 35, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원     
                        this.setSheetValue(sheet2, I, 35, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액   
                        this.setSheetValue(sheet2, J, 35, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세    
                        this.setSheetValue(sheet2, L, 35, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세    
                        
                    break;
                    
                    case "C39":
                        this.setSheetValue(sheet2, H, 36, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 36, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 36, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 36, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C14":
                        this.setSheetValue(sheet2, H, 37, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원     
                        this.setSheetValue(sheet2, I, 37, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액   
                        this.setSheetValue(sheet2, J, 37, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세    
                        this.setSheetValue(sheet2, L, 37, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세    
                        
                    break;
                    
                    case "C24":
                        this.setSheetValue(sheet2, H, 38, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 38, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 38, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 38, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C15":
                        this.setSheetValue(sheet2, H, 39, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원      
                        this.setSheetValue(sheet2, I, 39, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액    
                        this.setSheetValue(sheet2, J, 39, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세     
                        this.setSheetValue(sheet2, L, 39, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세     
                        
                    break;
                    
                    case "C25":
                        this.setSheetValue(sheet2, H, 40, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원     
                        this.setSheetValue(sheet2, I, 40, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액   
                        this.setSheetValue(sheet2, J, 40, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세    
                        this.setSheetValue(sheet2, L, 40, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세    
                        
                    break;
                    
                    case "C16":
                        this.setSheetValue(sheet2, H, 41, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 41, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 41, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 41, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C26":
                        this.setSheetValue(sheet2, H, 42, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet2, I, 42, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet2, J, 42, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet2, L, 42, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        
                    break;
                    
                    case "C30":
                        this.setSheetValue(sheet2, H, 43, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원    
                        this.setSheetValue(sheet2, I, 43, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액  
                        this.setSheetValue(sheet2, J, 43, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세   
                        this.setSheetValue(sheet2, K, 43, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세
                        this.setSheetValue(sheet2, L, 43, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세   
                        this.setSheetValue(sheet2, M, 43, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액     
                        this.setSheetValue(sheet2, N, 43, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등  
                        this.setSheetValue(sheet2, O, 43, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));              //납부세액 농어촌특별세
                        
                    break;
                    
                    case "C41":
                        this.setSheetValue(sheet2, H, 44, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 44, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 44, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C42":
                        this.setSheetValue(sheet2, H, 45, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 45, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 45, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C43":
                        this.setSheetValue(sheet2, H, 46, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 46, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 46, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C44":
                        this.setSheetValue(sheet2, H, 47, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 47, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 47, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C45":
                        this.setSheetValue(sheet2, H, 48, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 48, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 48, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C46":
                        this.setSheetValue(sheet2, H, 49, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원 
                        this.setSheetValue(sheet2, J, 49, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세
                        this.setSheetValue(sheet2, L, 49, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세
                        
                    break;
                    
                    case "C50":
                        this.setSheetValue(sheet2, H, 50, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet2, J, 50, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet2, L, 50, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet2, M, 50, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet2, N, 50, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    //sheet 3 저장
                    
                    case "C61":
                        this.setSheetValue(sheet3, H, 4, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원    
                        this.setSheetValue(sheet3, I, 4, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액  
                        this.setSheetValue(sheet3, J, 4, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세   
                        this.setSheetValue(sheet3, K, 4, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세
                        this.setSheetValue(sheet3, L, 4, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세   
                        this.setSheetValue(sheet3, M, 4, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액     
                        this.setSheetValue(sheet3, N, 4, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등  
                        this.setSheetValue(sheet3, O, 4, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세
                        
                    break;
                    
                    case "C62":
                        this.setSheetValue(sheet3, H, 5, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원     
                        this.setSheetValue(sheet3, I, 5, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액   
                        this.setSheetValue(sheet3, J, 5, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세    
                        this.setSheetValue(sheet3, K, 5, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세 
                        this.setSheetValue(sheet3, L, 5, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세    
                        this.setSheetValue(sheet3, M, 5, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액      
                        this.setSheetValue(sheet3, N, 5, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등   
                        this.setSheetValue(sheet3, O, 5, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세 
                        
                    break;
                    
                    case "C63":
                        this.setSheetValue(sheet3, H, 6, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원     
                        this.setSheetValue(sheet3, I, 6, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액   
                        this.setSheetValue(sheet3, J, 6, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세    
                        this.setSheetValue(sheet3, K, 6, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세 
                        this.setSheetValue(sheet3, L, 6, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세    
                        this.setSheetValue(sheet3, M, 6, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액      
                        this.setSheetValue(sheet3, N, 6, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등   
                        this.setSheetValue(sheet3, O, 6, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세 
                        
                    break;
                    
                    case "C64":
                        this.setSheetValue(sheet3, H, 7, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원      
                        this.setSheetValue(sheet3, I, 7, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액    
                        this.setSheetValue(sheet3, J, 7, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세     
                        this.setSheetValue(sheet3, K, 7, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세  
                        this.setSheetValue(sheet3, L, 7, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세     
                        this.setSheetValue(sheet3, M, 7, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액       
                        this.setSheetValue(sheet3, N, 7, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등    
                        this.setSheetValue(sheet3, O, 7, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세  
                        
                    break;
                    
                    case "C65":
                        this.setSheetValue(sheet3, H, 8, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원     
                        this.setSheetValue(sheet3, I, 8, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액   
                        this.setSheetValue(sheet3, J, 8, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세    
                        this.setSheetValue(sheet3, K, 8, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세 
                        this.setSheetValue(sheet3, L, 8, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세    
                        this.setSheetValue(sheet3, M, 8, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액      
                        this.setSheetValue(sheet3, N, 8, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등   
                        this.setSheetValue(sheet3, O, 8, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세 
                        
                    break;
                    
                    case "C66":
                        this.setSheetValue(sheet3, H, 9, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));             //소득지급 인원       
                        this.setSheetValue(sheet3, I, 9, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));    //소득지급 총지급액     
                        this.setSheetValue(sheet3, J, 9, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));           //징수세액 소득세      
                        this.setSheetValue(sheet3, K, 9, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));           //징수세액 농어촌특별세   
                        this.setSheetValue(sheet3, L, 9, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));              //징수세액 가산세      
                        this.setSheetValue(sheet3, M, 9, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));           //조징환급세액        
                        this.setSheetValue(sheet3, N, 9, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));               //납부세액 소득세등     
                        this.setSheetValue(sheet3, O, 9, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));               //납부세액 농어촌특별세   
                        
                    break;
                    
                    case "C67":
                        this.setSheetValue(sheet3, H, 10, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원        
                        this.setSheetValue(sheet3, I, 10, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액      
                        this.setSheetValue(sheet3, J, 10, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세       
                        this.setSheetValue(sheet3, K, 10, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세    
                        this.setSheetValue(sheet3, L, 10, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세       
                        this.setSheetValue(sheet3, M, 10, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액         
                        this.setSheetValue(sheet3, N, 10, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등      
                        this.setSheetValue(sheet3, O, 10, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));              //납부세액 농어촌특별세    
                        
                    break;
                    
                    case "C68":
                        this.setSheetValue(sheet3, H, 11, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원      
                        this.setSheetValue(sheet3, I, 11, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액    
                        this.setSheetValue(sheet3, J, 11, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세     
                        this.setSheetValue(sheet3, K, 11, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세  
                        this.setSheetValue(sheet3, L, 11, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세     
                        this.setSheetValue(sheet3, M, 11, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액       
                        this.setSheetValue(sheet3, N, 11, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등    
                        this.setSheetValue(sheet3, O, 11, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));              //납부세액 농어촌특별세  
                        
                    break;
                    
                    case "C70":
                        this.setSheetValue(sheet3, H, 12, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원      
                        this.setSheetValue(sheet3, I, 12, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액    
                        this.setSheetValue(sheet3, J, 12, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세     
                        this.setSheetValue(sheet3, K, 12, ObjUtils.parseDouble(paramMap.get("DEF_SP_TAX_I")));          //징수세액 농어촌특별세  
                        this.setSheetValue(sheet3, L, 12, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세     
                        this.setSheetValue(sheet3, M, 12, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액       
                        this.setSheetValue(sheet3, N, 12, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등    
                        this.setSheetValue(sheet3, O, 12, ObjUtils.parseDouble(paramMap.get("SP_TAX_I")));              //납부세액 농어촌특별세  
                        
                    break;
                    
                    case "C71":
                        this.setSheetValue(sheet3, H, 13, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원    
                        this.setSheetValue(sheet3, I, 13, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액  
                        this.setSheetValue(sheet3, J, 13, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세   
                        this.setSheetValue(sheet3, L, 13, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세   
                        this.setSheetValue(sheet3, M, 13, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액     
                        this.setSheetValue(sheet3, N, 13, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등  
                        
                    break;
                    
                    case "C72":
                        this.setSheetValue(sheet3, H, 14, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원    
                        this.setSheetValue(sheet3, I, 14, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액  
                        this.setSheetValue(sheet3, J, 14, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세   
                        this.setSheetValue(sheet3, L, 14, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세   
                        this.setSheetValue(sheet3, M, 14, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액     
                        this.setSheetValue(sheet3, N, 14, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등  
                        
                    break;
                    
                    case "C73":
                        this.setSheetValue(sheet3, H, 15, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet3, I, 15, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        this.setSheetValue(sheet3, J, 15, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet3, L, 15, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet3, M, 15, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet3, N, 15, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    case "C74":
                        this.setSheetValue(sheet3, H, 16, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet3, I, 16, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet3, J, 16, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet3, L, 16, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        this.setSheetValue(sheet3, M, 16, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액    
                        this.setSheetValue(sheet3, N, 16, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등 
                        
                    break;
                    
                    case "C75":
                        this.setSheetValue(sheet3, H, 17, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet3, I, 17, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        this.setSheetValue(sheet3, J, 17, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet3, L, 17, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet3, M, 17, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet3, N, 17, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    case "C76":
                        this.setSheetValue(sheet3, H, 18, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet3, I, 18, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        
                    break;
                    
                    case "C81":
                        this.setSheetValue(sheet3, H, 19, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet3, I, 19, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        this.setSheetValue(sheet3, J, 19, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet3, L, 19, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet3, M, 19, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet3, N, 19, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    case "C82":
                        this.setSheetValue(sheet3, H, 20, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원    
                        this.setSheetValue(sheet3, I, 20, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액  
                        this.setSheetValue(sheet3, J, 20, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세   
                        this.setSheetValue(sheet3, L, 20, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세   
                        this.setSheetValue(sheet3, M, 20, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액     
                        this.setSheetValue(sheet3, N, 20, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등  
                        
                    break;
                    
                    case "C83":
                        this.setSheetValue(sheet3, H, 21, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet3, I, 21, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet3, J, 21, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet3, L, 21, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        this.setSheetValue(sheet3, M, 21, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액    
                        this.setSheetValue(sheet3, N, 21, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등 
                        
                    break;
                    
                    case "C84":
                        this.setSheetValue(sheet3, H, 22, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원     
                        this.setSheetValue(sheet3, I, 22, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액   
                        this.setSheetValue(sheet3, J, 22, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세    
                        this.setSheetValue(sheet3, L, 22, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세    
                        this.setSheetValue(sheet3, M, 22, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액      
                        this.setSheetValue(sheet3, N, 22, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등   
                        
                    break;
                    
                    case "C85":
                        this.setSheetValue(sheet3, H, 23, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet3, I, 23, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        this.setSheetValue(sheet3, J, 23, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet3, L, 23, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet3, M, 23, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet3, N, 23, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    case "C86":
                        this.setSheetValue(sheet3, H, 24, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet3, I, 24, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet3, J, 24, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet3, L, 24, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        this.setSheetValue(sheet3, M, 24, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액    
                        this.setSheetValue(sheet3, N, 24, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등 
                        
                    break;
                    
                    case "C87":
                        this.setSheetValue(sheet3, H, 25, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원  
                        this.setSheetValue(sheet3, I, 25, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액
                        this.setSheetValue(sheet3, J, 25, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세 
                        this.setSheetValue(sheet3, L, 25, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세 
                        this.setSheetValue(sheet3, M, 25, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액   
                        this.setSheetValue(sheet3, N, 25, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등
                        
                    break;
                    
                    case "C88":
                        this.setSheetValue(sheet3, H, 26, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원    
                        this.setSheetValue(sheet3, I, 26, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액  
                        this.setSheetValue(sheet3, J, 26, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세   
                        this.setSheetValue(sheet3, L, 26, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세   
                        this.setSheetValue(sheet3, M, 26, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액     
                        this.setSheetValue(sheet3, N, 26, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등  
                        
                    break;
                    
                    case "C90":
                        this.setSheetValue(sheet3, H, 27, ObjUtils.parseDouble(paramMap.get("INCOME_CNT")));            //소득지급 인원   
                        this.setSheetValue(sheet3, I, 27, ObjUtils.parseDouble(paramMap.get("INCOME_SUPP_TOTAL_I")));   //소득지급 총지급액 
                        this.setSheetValue(sheet3, J, 27, ObjUtils.parseDouble(paramMap.get("DEF_IN_TAX_I")));          //징수세액 소득세  
                        this.setSheetValue(sheet3, L, 27, ObjUtils.parseDouble(paramMap.get("ADD_TAX_I")));             //징수세액 가산세  
                        this.setSheetValue(sheet3, M, 27, ObjUtils.parseDouble(paramMap.get("RET_IN_TAX_I")));          //조징환급세액    
                        this.setSheetValue(sheet3, N, 27, ObjUtils.parseDouble(paramMap.get("IN_TAX_I")));              //납부세액 소득세등 
                        
                    break;
                    
                    default:
                    break;
                }
            }
            if (!ObjUtils.isEmpty(dataMap)) {
                this.setSheetValue(sheet1, A, 45, ObjUtils.parseDouble(dataMap.get("LAST_IN_TAX_I")));            //전월미환급액       
                this.setSheetValue(sheet1, D, 45, ObjUtils.parseDouble(dataMap.get("BEFORE_IN_TAX_I")));          //기환급신청한세액     
                this.setSheetValue(sheet1, G, 45, ObjUtils.parseDouble(dataMap.get("BAL_AMT")));                  //차감잔액         
                this.setSheetValue(sheet1, H, 45, ObjUtils.parseDouble(dataMap.get("RET_AMT")));                  //일반환급         
                this.setSheetValue(sheet1, I, 45, ObjUtils.parseDouble(dataMap.get("TRUST_AMT")));                //신탁재산         
                this.setSheetValue(sheet1, J, 45, ObjUtils.parseDouble(dataMap.get("FIN_COMP_AMT")));             //금융회사등        
                this.setSheetValue(sheet1, K, 45, ObjUtils.parseDouble(dataMap.get("MERGER_AMT")));               //합병등          
                this.setSheetValue(sheet1, L, 45, ObjUtils.parseDouble(dataMap.get("ROW_IN_TAX_I")));             //조정대상환급세액     
                this.setSheetValue(sheet1, M, 45, ObjUtils.parseDouble(dataMap.get("TOTAL_IN_TAX_I")));           //당월조정환급세액계    
                this.setSheetValue(sheet1, N, 45, ObjUtils.parseDouble(dataMap.get("NEXT_IN_TAX_I")));            //차월이월환급세액     
                this.setSheetValue(sheet1, O, 45, ObjUtils.parseDouble(dataMap.get("RET_IN_TAX_I")));             //환급신청액        
                
                this.setSheetValue(sheet1, P, 13, ObjUtils.parseDouble(dataMap.get("LAST_IN_TAX_I")));  //전월미환급액 과세표준  
            }
            
            sheet1.getRow(2).getCell(N).setCellValue(DevFreeUtils.getOrDefault(param.get("PAY_YYYYMM"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("PAY_YYYYMM"), "").toString().substring(4, 6) + "월");          //귀속년월
            sheet1.getRow(3).getCell(N).setCellValue(DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(0, 4) + "년" + DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(4, 6) + "월");    //지급년월
            
            sheet1.getRow(3).getCell(P).setCellValue(DevFreeUtils.getOrDefault(param.get("SUPP_YYYYMMDD"), "").toString().substring(6, 8) + "일");   //지급일
            
            workbook.getCreationHelper().createFormulaEvaluator().evaluateAll();
        }
        String title = "원천징수이행상황신고서";
        return workbook;
    }
    
    /**
     * 시트에 Set하는 메서드..
     */
    private void setSheetValue( Sheet sheet, int cell, int row, Double value ) throws Exception {
        sheet.getRow(row - 1).getCell(cell).setCellValue(value);
    }
    
}
