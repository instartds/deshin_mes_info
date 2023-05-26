package foren.unilite.modules.accnt.atx;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class AtxReportController extends UniliteCommonController {
    @InjectLogger
    public static Logger         logger;                                            // = LoggerFactory.getLogger(this.getClass());
    private final Logger         logger1 = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "atx330ukrService" )
    private Atx330ukrServiceImpl atx330ukrService;
    
    @Resource( name = "atx400ukrService" )
    private Atx400ukrServiceImpl atx400ukrService;
    
    @Resource( name = "atx315ukrService" )
    public Atx315ukrServiceImpl  atx315ukrService;
    
    /**
     * add by Chen.Rd
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx110rkr.do", method = RequestMethod.GET )
    public ModelAndView atx110rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        Map<String, Object> param = _req.getParameterMap();
        //		param.put("DIV_CODE", user.getDivCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx110rkr", param);
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        String fr_date = param.get("txtFrDate").toString();
        String to_date = param.get("txtToDate").toString();
        jf.addParam("FR_PUB_DATE", fr_date.substring(0, 4) + "." + fr_date.substring(4, 6) + "." + fr_date.substring(6));
        jf.addParam("TO_PUB_DATE", to_date.substring(0, 4) + "." + to_date.substring(4, 6) + "." + to_date.substring(6));
        
        jf.addParam("COMP_NAME", user.getCompName());
        jf.setList(jasperService.selectList("atx110skrServiceImpl.selectList", param));
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl 세금계산서 합계표 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx130rkr.do", method = RequestMethod.GET )
    public ModelAndView atx130rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "atx130rkrSub1" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
        
        JasperFactory jf = jasperService.createJasperFactory("atx130rkr", "atx130rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> map = (Map<String, Object>)jasperService.getDao().select("atx130skrServiceImpl.fnAtx130QRp1", param);
        List<Map<String, Object>> list = jasperService.selectList("atx130skrServiceImpl.selectListToPrint", param);
        List<Map<String, Object>> vRtnList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> vRtnSubList = new ArrayList<Map<String, Object>>();
        
        get130PrintData1(list, vRtnList, vRtnSubList);
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
        //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        String divi = param.get("INOUT_DIVI") + "";
        String docuDivi = "1";
        String titleEqual1 = "", titleMore1 = "";
        jf.addParam("DIVI", divi);
        jf.addParam("DOCU_DIVI", docuDivi);
        if ("1".equals(docuDivi) && "1".equals(divi)) {
            titleEqual1 = "매입처별세금계산서합계표(갑)";
            titleMore1 = "매입처별세금계산서합계표(을)";
        } else if ("1".equals(docuDivi) && "2".equals(divi)) {
            titleEqual1 = "매출처별세금계산서합계표(갑)";
            titleMore1 = "매출처별세금계산서합계표(을)";
        } else if ("2".equals(docuDivi) && "1".equals(divi)) {
            titleEqual1 = "매입처별계산서합계표(갑)";
            titleMore1 = "매입처별계산서합계표(을)";
        } else if ("2".equals(docuDivi) && "2".equals(divi)) {
            titleEqual1 = "매출처별계산서합계표(갑)";
            titleMore1 = "매출처별계산서합계표(을)";
        } else if ("1".equals(docuDivi) && "3".equals(divi)) {
            titleEqual1 = "매입자발행세금계산서합계표(갑)";
            titleMore1 = "매입자발행세금계산서합계표(을)";
        }
        jf.addParam("titleEqual1", titleEqual1);
        jf.addParam("titleMore1", titleMore1);
        
        jf.addParam("PUB_DATE_FR", param.get("PUB_DATE_FR"));
        jf.addParam("PUB_DATE_TO", param.get("PUB_DATE_TO"));
        jf.addParam("WRITE_DATE", param.get("WRITE_DATE"));
        
        //      jf.addParam("P_SUB_TITLE","[보조원장]");
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        //blank column begin
        int listSize = 0;
        int firstPageCount = 8;
        int pageCount = 19;
        if (vRtnList != null) {
            listSize = vRtnList.size();
        }
        if (listSize < firstPageCount) {
            int tempSize = firstPageCount - listSize;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                vRtnList.add(nullMap);
            }
        } else if (listSize > firstPageCount) {
            int tempSize = pageCount - ( listSize - firstPageCount ) % pageCount;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                vRtnList.add(nullMap);
            }
        }
        //end
        jflist.addAll(vRtnList);
        jf.addSubDS("DS_SUB01", vRtnSubList);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl 계산서 합계표 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx140rkr.do", method = RequestMethod.GET )
    public ModelAndView atx140rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = new String[1];
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용        
        JasperFactory jf;
        if ("1".equals(param.get("INOUT_DIVI"))) {
            jf = jasperService.createJasperFactory("atx140rkr", "atx140rkr", param);
            subReportFileNames[0] = "atx140rkrSub1";
        } else {
            jf = jasperService.createJasperFactory("atx140rkr", "atx140rkr2", param);
            subReportFileNames[0] = "atx140rkrSub2";
        }
        // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> map = (Map<String, Object>)jasperService.getDao().select("atx130skrServiceImpl.fnAtx130QRp1", param);
        List<Map<String, Object>> list = jasperService.selectList("atx140skrServiceImpl.selectListToPrint", param);
        List<Map<String, Object>> vRtnList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> vRtnSubList = new ArrayList<Map<String, Object>>();
        
        get130PrintData(list, vRtnList, vRtnSubList);
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
        //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        String divi = param.get("INOUT_DIVI") + "";
        String docuDivi = "2";
        String titleEqual1 = "", titleMore1 = "";
        jf.addParam("DIVI", divi);
        jf.addParam("DOCU_DIVI", docuDivi);
        if ("1".equals(docuDivi) && "1".equals(divi)) {
            titleEqual1 = "매입처별세금계산서합계표(갑)";
            titleMore1 = "매입처별세금계산서합계표(을)";
        } else if ("1".equals(docuDivi) && "2".equals(divi)) {
            titleEqual1 = "매출처별세금계산서합계표(갑)";
            titleMore1 = "매출처별세금계산서합계표(을)";
        } else if ("2".equals(docuDivi) && "1".equals(divi)) {
            titleEqual1 = "매입처별계산서합계표(갑)";
            titleMore1 = "매입처별계산서합계표(을)";
        } else if ("2".equals(docuDivi) && "2".equals(divi)) {
            titleEqual1 = "매출처별계산서합계표(갑)";
            titleMore1 = "매출처별계산서합계표(을)";
        } else if ("1".equals(docuDivi) && "3".equals(divi)) {
            titleEqual1 = "매입자발행세금계산서합계표(갑)";
            titleMore1 = "매입자발행세금계산서합계표(을)";
        }
        jf.addParam("titleEqual1", titleEqual1);
        jf.addParam("titleMore1", titleMore1);
        
        jf.addParam("PUB_DATE_FR", param.get("PUB_DATE_FR"));
        jf.addParam("PUB_DATE_TO", param.get("PUB_DATE_TO"));
        jf.addParam("WRITE_DATE", param.get("WRITE_DATE"));
        
        //     jf.addParam("P_SUB_TITLE","[보조원장]");
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
      //blank column begin
        int listSize = 0;
        int firstPageCount = 8;
        int pageCount = 19;
        if (vRtnList != null) {
            listSize = vRtnList.size();
        }
        if (listSize < firstPageCount) {
            int tempSize = firstPageCount - listSize;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                vRtnList.add(nullMap);
            }
        } else if (listSize > firstPageCount) {
            int tempSize = pageCount - ( listSize - firstPageCount ) % pageCount;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                vRtnList.add(nullMap);
            }
        }
        //end
        jflist.addAll(vRtnList);
        jf.addSubDS("DS_SUB01", vRtnSubList);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    /**
     * add by zhongshl
     * 
     * @param list
     * @param vRtnList
     * @param vRtnSubList
     */
    private void get130PrintData1( List<Map<String, Object>> list, List<Map<String, Object>> vRtnList, List<Map<String, Object>> vRtnSubList ) {
        if (list != null && list.size() > 0) {
            
            Object CUST_COUNT_2Y = BigDecimal.ZERO, NUM_2Y = BigDecimal.ZERO, SUPPLY_AMT_I_2Y = BigDecimal.ZERO, TAX_AMT_I_2Y = BigDecimal.ZERO, CUST_COUNT_2N = BigDecimal.ZERO, NUM_2N = BigDecimal.ZERO, SUPPLY_AMT_I_2N = BigDecimal.ZERO, TAX_AMT_I_2N = BigDecimal.ZERO, CUST_COUNT_3Y = BigDecimal.ZERO, NUM_3Y = BigDecimal.ZERO, SUPPLY_AMT_I_3Y = BigDecimal.ZERO, TAX_AMT_I_3Y = BigDecimal.ZERO, CUST_COUNT_3N = BigDecimal.ZERO, NUM_3N = BigDecimal.ZERO, SUPPLY_AMT_I_3N = BigDecimal.ZERO, TAX_AMT_I_3N = BigDecimal.ZERO, CUST_COUNT_4A = BigDecimal.ZERO, NUM_4A = BigDecimal.ZERO, SUPPLY_AMT_I_4A = BigDecimal.ZERO, TAX_AMT_I_4A = BigDecimal.ZERO;
            
            for (Map<String, Object> dataMap : list) {
                String gubun = dataMap.get("GUBUN") + "";
                switch (gubun) {
                    case "1":
                        Map<String, Object> vRtnMap = new HashMap<String, Object>();
                        vRtnMap.put("CUSTOM_NAME", dataMap.get("CUSTOM_NAME"));
                        vRtnMap.put("COMPANY_NUM", dataMap.get("COMPANY_NUM"));
                        vRtnMap.put("NUM", dataMap.get("NUM"));
                        vRtnMap.put("NUM1", dataMap.get("NUM1"));
                        vRtnMap.put("NUM2", dataMap.get("NUM2"));
                        vRtnMap.put("SUPPLY_AMT_I", dataMap.get("SUPPLY_AMT_I"));
                        vRtnMap.put("SUPPLY_AMT_I1", dataMap.get("SUPPLY_AMT_I1"));
                        vRtnMap.put("SUPPLY_AMT_I2", dataMap.get("SUPPLY_AMT_I2"));
                        vRtnMap.put("TAX_AMT_I", dataMap.get("TAX_AMT_I"));
                        vRtnMap.put("TAX_AMT_I1", dataMap.get("TAX_AMT_I1"));
                        vRtnMap.put("TAX_AMT_I2", dataMap.get("TAX_AMT_I2"));
                        vRtnMap.put("EB_YN", dataMap.get("EB_YN"));
                        vRtnMap.put("CNT1", dataMap.get("CUST_COUNT1"));
                        vRtnMap.put("CNT2", dataMap.get("CUST_COUNT2"));
                        vRtnList.add(vRtnMap);
                    break;
                    case "2Y":                                               //'사업자등록(발행) 합계
                        CUST_COUNT_2Y = dataMap.get("CUST_COUNT1");
                        NUM_2Y = dataMap.get("NUM1");
                        SUPPLY_AMT_I_2Y = dataMap.get("SUPPLY_AMT_I1");
                        TAX_AMT_I_2Y = dataMap.get("TAX_AMT_I1");
                    break;
                    case "2N":                                               //'사업자등록(미발행) 합계
                        CUST_COUNT_2N = dataMap.get("CUST_COUNT2");
                        NUM_2N = dataMap.get("NUM2");
                        SUPPLY_AMT_I_2N = dataMap.get("SUPPLY_AMT_I2");
                        TAX_AMT_I_2N = dataMap.get("TAX_AMT_I2");
                    break;
                    case "3Y":                                              //'주민등록분(발행) 합계
                        CUST_COUNT_3Y = dataMap.get("CUST_COUNT1");
                        NUM_3Y = dataMap.get("NUM1");
                        SUPPLY_AMT_I_3Y = dataMap.get("SUPPLY_AMT_I1");
                        TAX_AMT_I_3Y = dataMap.get("TAX_AMT_I1");
                    break;
                    case "3N":                                              //'주민등록분(미발행) 합계
                        CUST_COUNT_3N = dataMap.get("CUST_COUNT2");
                        NUM_3N = dataMap.get("NUM2");
                        SUPPLY_AMT_I_3N = dataMap.get("SUPPLY_AMT_I2");
                        TAX_AMT_I_3N = dataMap.get("TAX_AMT_I2");
                    break;
                    case "4":                                               //'총계
                        CUST_COUNT_4A = dataMap.get("CUST_COUNT");
                        NUM_4A = dataMap.get("NUM");
                        SUPPLY_AMT_I_4A = dataMap.get("SUPPLY_AMT_I");
                        TAX_AMT_I_4A = dataMap.get("TAX_AMT_I");
                    break;
                }
            }
            Map<String, Object> vRtn1 = new HashMap<String, Object>();
            vRtn1.put("CUST_COUNT_2Y", CUST_COUNT_2Y);
            vRtn1.put("NUM_2Y", NUM_2Y);
            vRtn1.put("SUPPLY_AMT_I_2Y", SUPPLY_AMT_I_2Y);
            vRtn1.put("TAX_AMT_I_2Y", TAX_AMT_I_2Y);
            
            vRtn1.put("CUST_COUNT_2N", CUST_COUNT_2N);
            vRtn1.put("NUM_2N", NUM_2N);
            vRtn1.put("SUPPLY_AMT_I_2N", SUPPLY_AMT_I_2N);
            vRtn1.put("TAX_AMT_I_2N", TAX_AMT_I_2N);
            
            vRtn1.put("CUST_COUNT_3Y", CUST_COUNT_3Y);
            vRtn1.put("NUM_3Y", NUM_3Y);
            vRtn1.put("SUPPLY_AMT_I_3Y", SUPPLY_AMT_I_3Y);
            vRtn1.put("TAX_AMT_I_3Y", TAX_AMT_I_3Y);
            
            vRtn1.put("CUST_COUNT_3N", CUST_COUNT_3N);
            vRtn1.put("NUM_3N", NUM_3N);
            vRtn1.put("SUPPLY_AMT_I_3N", SUPPLY_AMT_I_3N);
            vRtn1.put("TAX_AMT_I_3N", TAX_AMT_I_3N);
            
            vRtn1.put("CUST_COUNT_4", CUST_COUNT_4A);
            vRtn1.put("NUM_4", NUM_4A);
            vRtn1.put("SUPPLY_AMT_I_4", SUPPLY_AMT_I_4A);
            vRtn1.put("TAX_AMT_I_4", TAX_AMT_I_4A);
            vRtnSubList.add(vRtn1);
        }
    }
    /**
     * add by zhongshl
     * 
     * @param list
     * @param vRtnList
     * @param vRtnSubList
     */
    private void get130PrintData( List<Map<String, Object>> list, List<Map<String, Object>> vRtnList, List<Map<String, Object>> vRtnSubList ) {
        if (list != null && list.size() > 0) {
            
            Object CUST_COUNT_2Y = BigDecimal.ZERO, NUM_2Y = BigDecimal.ZERO, SUPPLY_AMT_I_2Y = BigDecimal.ZERO, TAX_AMT_I_2Y = BigDecimal.ZERO, CUST_COUNT_2N = BigDecimal.ZERO, NUM_2N = BigDecimal.ZERO, SUPPLY_AMT_I_2N = BigDecimal.ZERO, TAX_AMT_I_2N = BigDecimal.ZERO, CUST_COUNT_3Y = BigDecimal.ZERO, NUM_3Y = BigDecimal.ZERO, SUPPLY_AMT_I_3Y = BigDecimal.ZERO, TAX_AMT_I_3Y = BigDecimal.ZERO, CUST_COUNT_3N = BigDecimal.ZERO, NUM_3N = BigDecimal.ZERO, SUPPLY_AMT_I_3N = BigDecimal.ZERO, TAX_AMT_I_3N = BigDecimal.ZERO, CUST_COUNT_4A = BigDecimal.ZERO, NUM_4A = BigDecimal.ZERO, SUPPLY_AMT_I_4A = BigDecimal.ZERO, TAX_AMT_I_4A = BigDecimal.ZERO;
            
            for (Map<String, Object> dataMap : list) {
                String gubun = dataMap.get("GUBUN") + "";
                switch (gubun) {
                    case "1":
                        Map<String, Object> vRtnMap = new HashMap<String, Object>();
                        vRtnMap.put("CUSTOM_NAME", dataMap.get("CUSTOM_NAME"));
                        vRtnMap.put("COMPANY_NUM", dataMap.get("COMPANY_NUM"));
                        vRtnMap.put("NUM", dataMap.get("NUM"));
                        vRtnMap.put("NUM1", dataMap.get("NUM1"));
                        vRtnMap.put("NUM2", dataMap.get("NUM2"));
                        vRtnMap.put("SUPPLY_AMT_I", dataMap.get("SUPPLY_AMT_I"));
                        vRtnMap.put("SUPPLY_AMT_I1", dataMap.get("SUPPLY_AMT_I1"));
                        vRtnMap.put("SUPPLY_AMT_I2", dataMap.get("SUPPLY_AMT_I2"));
                        vRtnMap.put("TAX_AMT_I", dataMap.get("TAX_AMT_I"));
                        vRtnMap.put("TAX_AMT_I1", dataMap.get("TAX_AMT_I1"));
                        vRtnMap.put("TAX_AMT_I2", dataMap.get("TAX_AMT_I2"));
                        vRtnMap.put("EB_YN", dataMap.get("EB_YN"));
                        vRtnMap.put("CNT1", dataMap.get("CUST_COUNT1"));
                        vRtnMap.put("CNT2", dataMap.get("CUST_COUNT2"));
                        vRtnList.add(vRtnMap);
                    break;
                    case "2Y":                                               //'사업자등록(발행) 합계
                        CUST_COUNT_2Y = dataMap.get("CUST_COUNT1");
                        NUM_2Y = dataMap.get("NUM1");
                        SUPPLY_AMT_I_2Y = dataMap.get("SUPPLY_AMT_I1");
                        TAX_AMT_I_2Y = dataMap.get("TAX_AMT_I1");
                    break;
                    case "2N":                                               //'사업자등록(미발행) 합계
                        CUST_COUNT_2N = dataMap.get("CUST_COUNT2");
                        NUM_2N = dataMap.get("NUM2");
                        SUPPLY_AMT_I_2N = dataMap.get("SUPPLY_AMT_I2");
                        TAX_AMT_I_2N = dataMap.get("TAX_AMT_I2");
                    break;
                    case "3Y":                                              //'주민등록분(발행) 합계
                        CUST_COUNT_3Y = dataMap.get("CUST_COUNT1");
                        NUM_3Y = dataMap.get("NUM1");
                        SUPPLY_AMT_I_3Y = dataMap.get("SUPPLY_AMT_I1");
                        TAX_AMT_I_3Y = dataMap.get("TAX_AMT_I1");
                    break;
                    case "3N":                                              //'주민등록분(미발행) 합계
                        CUST_COUNT_3N = dataMap.get("CUST_COUNT2");
                        NUM_3N = dataMap.get("NUM2");
                        SUPPLY_AMT_I_3N = dataMap.get("SUPPLY_AMT_I2");
                        TAX_AMT_I_3N = dataMap.get("TAX_AMT_I2");
                    break;
                    case "4":                                               //'총계
                        CUST_COUNT_4A = dataMap.get("CUST_COUNT");
                        NUM_4A = dataMap.get("NUM");
                        SUPPLY_AMT_I_4A = dataMap.get("SUPPLY_AMT_I");
                        TAX_AMT_I_4A = dataMap.get("TAX_AMT_I");
                    break;
                }
            }
            Map<String, Object> vRtn1 = new HashMap<String, Object>();
            vRtn1.put("CUST_COUNT_2Y", CUST_COUNT_2Y);
            vRtn1.put("NUM_2Y", NUM_2Y);
            vRtn1.put("SUPPLY_AMT_I_2Y", SUPPLY_AMT_I_2Y);
            vRtn1.put("TAX_AMT_I_2Y", TAX_AMT_I_2Y);
            
            vRtn1.put("CUST_COUNT_2N", CUST_COUNT_2N);
            vRtn1.put("NUM_2N", NUM_2N);
            vRtn1.put("SUPPLY_AMT_I_2N", SUPPLY_AMT_I_2N);
            vRtn1.put("TAX_AMT_I_2N", TAX_AMT_I_2N);
            
            vRtn1.put("CUST_COUNT_3Y", CUST_COUNT_3Y);
            vRtn1.put("NUM_3Y", NUM_3Y);
            vRtn1.put("SUPPLY_AMT_I_3Y", SUPPLY_AMT_I_3Y);
            vRtn1.put("TAX_AMT_I_3Y", TAX_AMT_I_3Y);
            
            vRtn1.put("CUST_COUNT_3N", CUST_COUNT_3N);
            vRtn1.put("NUM_3N", NUM_3N);
            vRtn1.put("SUPPLY_AMT_I_3N", SUPPLY_AMT_I_3N);
            vRtn1.put("TAX_AMT_I_3N", TAX_AMT_I_3N);
            
            vRtn1.put("CUST_COUNT_4", CUST_COUNT_4A);
            vRtn1.put("NUM_4", NUM_4A);
            vRtn1.put("SUPPLY_AMT_I_4", SUPPLY_AMT_I_4A);
            vRtn1.put("TAX_AMT_I_4A", TAX_AMT_I_4A);
            vRtnSubList.add(vRtn1);
        }
    }
    
    /**
     * add by chenaibo
     **/
    @RequestMapping( value = "/atx/atx300ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx300ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        AES256DecryptoUtils  decrypto = new AES256DecryptoUtils();
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용     
        String type = param.get("type").toString();
        JasperFactory jf = null;
        String strQuery = "";
        
        if (type.equals("1")) {
            String[] subReportFileNames = { "atx300ukr_sub1" };
            jf = jasperService.createJasperFactory("atx300ukr", "atx300ukr", param);   // "폴더명" , "파일명" , "파라미터
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            jf.addParam("FR_PUB_DATE", param.get("txtFrPubDate"));
            jf.addParam("TO_PUB_DATE", param.get("txtToPubDate"));
            if (param.get("txtFrPubDate") != null) {
                Map termCode = (Map)jasperService.getDao().select("atx300ukrServiceImpl.selectTermCode", param);
                jf.addParam("COMP_NAME", termCode.get("COMP_NAME"));
                jf.addParam("COMPANY_NUM", termCode.get("COMPANY_NUM"));
                jf.addParam("REPRE_NAME", termCode.get("REPRE_NAME"));
                jf.addParam("REPRE_NUM", termCode.get("REPRE_NUM"));
                jf.addParam("REPRE_NO", termCode.get("REPRE_NO"));
                jf.addParam("ADDR", termCode.get("ADDR"));
                jf.addParam("TELEPHON", termCode.get("TELEPHON"));
                jf.addParam("TELEPHON", termCode.get("HANDPHONE"));
                jf.addParam("TAX_NAME", termCode.get("TAX_NAME"));
                jf.addParam("TAX_NUM", termCode.get("TAX_NUM"));
                jf.addParam("TAX_TEL", termCode.get("TAX_TEL"));
                jf.addParam("SAFFER_TAX_NM", termCode.get("SAFFER_TAX_NM"));
                jf.addParam("TERM_CODE", termCode.get("TERM_CODE"));
                
            }
            
            if (param.get("RE_REFERENCE") != null && param.get("RE_REFERENCE").equals("Y")) {
                strQuery = "atx300ukrServiceImpl.selectListSecond";
            } else {
                if (jasperService.selectList("atx300ukrServiceImpl.selectListFirst", param) == null) {
                    strQuery = "atx300ukrServiceImpl.selectListSecond";
                } else {
                    strQuery = "atx300ukrServiceImpl.selectListFirst";
                }
            }
            
            jf.addSubDS("DS_SUB01", jasperService.selectList("atx300ukrServiceImpl.fnAtx300Init", param));
            
        } else {
            jf = jasperService.createJasperFactory("atx300ukr", "atx300ukr_bill", param);   // "폴더명" , "파일명" , "파라미터
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            // 	        jf.setSubReportFiles(subReportFileNames);
            
            jf.addParam("FR_PUB_DATE", param.get("txtFrPubDate"));
            jf.addParam("TO_PUB_DATE", param.get("txtToPubDate"));
            
            //DUE_DATE:TO_PUB_DATE'S NEXT MONTH ,DAY 25.
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Calendar rightNow = Calendar.getInstance();
            Date date = sdf.parse(param.get("txtToPubDate").toString());
            rightNow.setTime(date);
            rightNow.add(Calendar.MONTH, 1);
            rightNow.set(Calendar.DATE, 25);
            Date newDate = rightNow.getTime();
            String strDueDate = sdf.format(newDate);
            jf.addParam("DUE_DATE", strDueDate);
            strQuery = "atx300ukrServiceImpl.selectPrintBillList";
            
        }
        
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        
        List<Map<String, Object>> rsltList = jasperService.selectList(strQuery, param);
        //계좌번호 복호화
        if(!ObjUtils.isEmpty(rsltList)){
            for (Map rsltMap : rsltList) {
                String accntBank = (String)rsltMap.get("BANK_ACCOUNT");
                if (ObjUtils.isNotEmpty(accntBank)) {
                    accntBank = decrypto.getDecrypto("1", accntBank);
//                    accntBank = accntBank.substring(0, 6) + "-" + accntBank.substring(6, 13);
                    rsltMap.put("BANK_ACCOUNT", accntBank);
                } else {
                    rsltMap.put("BANK_ACCOUNT", "");
                }
            } 
        }
        
        jflist.addAll(rsltList);
        jf.setList(jflist);
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx315rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx315rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
        
        JasperFactory jf = jasperService.createJasperFactory("atx315rkr", "atx315rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> map = (Map<String, Object>)jasperService.getDao().select("atx315ukrServiceImpl.fnatx315q", param);
        List<Map<String, Object>> list = jasperService.selectList("atx315ukrServiceImpl.selectListToPrint", param);
        //       Map sumTabMap = (Map) atx315ukrService.selectSumTable(param);
        //       List<Map<String,Object>> list = new ArrayList();
        //       list.add(sumTabMap);
        jf.addParam("FR_PUB_DATE", param.get("FR_PUB_DATE"));
        jf.addParam("TO_PUB_DATE", param.get("TO_PUB_DATE"));
        
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        jflist.addAll(list);
        //jf.addSubDS("DS_SUB01", vRtnSubList);	
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    @RequestMapping( value = "/atx/atx326ukr.do", method = RequestMethod.GET )
    public ModelAndView atx326ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        
        String fr_date = param.get("FR_PUB_DATE").toString();
        String to_date = param.get("TO_PUB_DATE").toString();
        
        JasperFactory jf = null;
        if(param.get("PROOF_KIND")!=null&&(param.get("PROOF_KIND").equals("E")||param.get("PROOF_KIND").equals("F"))){
        	jf = jasperService.createJasperFactory("atx326ukr","atx326ukr2", param);
        }else{
        	jf = jasperService.createJasperFactory("atx326ukr","atx326ukr", param);
        }
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        jf.addParam("DECLARE_DATE", fr_date.substring(0, 4));
        jf.addParam("FR_PUB_DATE", fr_date);
        jf.addParam("TO_PUB_DATE", to_date);
        int term = Integer.valueOf(to_date.substring(4, 6));
        jf.addParam("TERM_DIVI", term > 7 ? "2" : "1");
        if(param.get("PROOF_KIND")!=null&&(param.get("PROOF_KIND").equals("E")||param.get("PROOF_KIND").equals("F"))){
        	jf.addParam("PROOF_KIND", param.get("PROOF_KIND"));
        	jf.setList(jasperService.selectList("atx326ukrServiceImpl.selectList2", param));
        }else{
	        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
	        List<Map<String, Object>> list = jasperService.selectList("atx326ukrServiceImpl.selectFormHeader", param);
	        for (String key : list.get(0).keySet())
	            jf.addParam(key, list.get(0).get(key));
	        
	        jf.setList(jasperService.selectList("atx326ukrServiceImpl.selectCompInfo", param));
        }
        return ViewHelper.getJasperView(jf);
    }
    
    @RequestMapping( value = "/atx/atx330ukr.do", method = RequestMethod.GET )
    public ModelAndView atx330ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        Map param = _req.getParameterMap();
        
        param.put("USER_ID", user.getUserID());
        List<Map<String, Object>> taxList = atx330ukrService.selectselectTAXBaseInfoList(param);
        param.put("TAX_BASE", taxList.isEmpty() ? "" : taxList.get(0).get("TAX_BASE"));
        param.put("REFER_CODE", param.get("FR_PUB_DATE").toString().substring(4));
        //		param.put("DIV_CODE", user.getDivCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx330ukr", param);
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        
        //插入营业区信息
        List<Map<String, Object>> infoList = jasperService.selectList("atx330ukrServiceImpl.selectPageHeaderList", param);
        if (!infoList.isEmpty()) {
            jf.addParam("COMP_NAME", infoList.get(0).get("COMP_NAME"));
            jf.addParam("COMP_NUM", infoList.get(0).get("COMPANY_NUM"));
            jf.addParam("REPRE_NAME", infoList.get(0).get("REPRE_NAME"));
            jf.addParam("COMP_CLASS", infoList.get(0).get("COMP_CLASS"));
            jf.addParam("COMP_TYPE", infoList.get(0).get("COMP_TYPE"));
            jf.addParam("ADDR", infoList.get(0).get("ADDR"));
            jf.addParam("TELEPHON", infoList.get(0).get("TELEPHON"));
            jf.addParam("TERM_CODE", infoList.get(0).get("TERM_CODE"));
            jf.addParam("YEAR", param.get("FR_PUB_DATE").toString().substring(0, 4));
        }
        String wirteDate = param.get("WRITE_DATE").toString();
        jf.addParam("WRITE_DATE", wirteDate.substring(0, 4) + "." + wirteDate.substring(4, 6) + "." + wirteDate.substring(6, 8));
        List<Map<String, Object>> list = jasperService.selectList("atx330ukrServiceImpl.selectInfoForPrint", param);
        Map<String, Object> map = new HashMap<>();
        int size = list.size();
        if(list.size()<14){
        	for(int i=0;i<13-size;i++)
        		list.add(map);
        }else{
        	int remainder = (size-12)%20;
        	for(int i=0;i<20-remainder;i++)
        		list.add(map);
        }
        jf.setList(list);
        
        // sub report data sources
        
        // 레포트 자체의 SQL 사용시에만 사용
        // super.jasperService.setDbConnection(jParam);
        
        // jf.addSubDS("DS_SUB01",
        // jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
        // jf.addSubDS("DS_SUB02",
        // jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
        // jf.addSubDS("DS_SUB03",
        // jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));
        return ViewHelper.getJasperView(jf);
    }
    
    @RequestMapping( value = "/atx/atx400ukr.do", method = RequestMethod.GET )
    public ModelAndView atx400ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        Map param = _req.getParameterMap();
        String fr_date = param.get("FR_PUB_DATE").toString();
        String to_date = param.get("TO_PUB_DATE").toString();
        param.put("FN_DATE", fr_date.substring(4, 6));
        param.put("TO_DATE", to_date.substring(4, 6));
        
        //		param.put("DIV_CODE", user.getDivCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx400ukr", param);
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        jf.addParam("DECLARE_DATE", fr_date.substring(0, 4));
        int term = Integer.valueOf(to_date.substring(4, 6));
        jf.addParam("TERM_DIVI", term > 7 ? "2" : "1");
        
        //		jf.addParam("FR_PUB_DATE", fr_date.substring(0, 4)+"."+fr_date.substring(4, 6)+"."+fr_date.substring(6));
        //		jf.addParam("TO_PUB_DATE", to_date.substring(0, 4)+"."+to_date.substring(4, 6)+"."+to_date.substring(6));
        List<Map<String, Object>> totalList = atx400ukrService.selectList2(param);
        for (Map.Entry<String, Object> entry : totalList.get(0).entrySet())
            jf.addParam(entry.getKey(), entry.getValue());
        
        Map<String, Object> borMap = atx400ukrService.selectBor120List(param).get(0);
        for (Map.Entry<String, Object> entry : borMap.entrySet())
            jf.addParam(entry.getKey(), entry.getValue());
        
        jf.setList(jasperService.selectList("atx400ukrServiceImpl.selectList", param));
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx420rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx420rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
        
        JasperFactory jf = jasperService.createJasperFactory("atx420rkr", "atx420rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        List<Map<String, Object>> list = jasperService.selectList("atx425ukrServiceImpl.selectListTo420Print", param);
        jf.addParam("FR_PUB_DATE", param.get("PUB_DATE_FR"));
        jf.addParam("TO_PUB_DATE", param.get("PUB_DATE_TO"));
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        String dateString = formatter.format(date);
        jf.addParam("SYS_DATE", dateString);
        jflist.addAll(list);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx425rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx425rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "atx425rkrSub1" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx425rkr", "atx425rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        List<Map<String, Object>> list = jasperService.selectList("atx425ukrServiceImpl.selectListTo425Print", param);
        List<Map<String, Object>> sublist1 = jasperService.selectList("atx425ukrServiceImpl.selectListTo425PrintSub1", param);
        jf.addParam("FR_PUB_DATE", param.get("PUB_DATE_FR"));
        jf.addParam("TO_PUB_DATE", param.get("PUB_DATE_TO"));
        
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        String dateString = formatter.format(date);
        jf.addParam("SYS_DATE", dateString);
        jf.addSubDS("DS_SUB01", sublist1);
        jflist.addAll(list);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx340rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx340rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {
        
        };
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx340rkr", "atx340rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> param1 = (Map<String, Object>)jasperService.getDao().select("atx340ukrServiceImpl.selectMaster", param);
        if (param1 != null) {
            for (Map.Entry<String, Object> entry : param1.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        Map<String, Object> param2 = (Map<String, Object>)jasperService.getDao().select("atx340ukrServiceImpl.selectReportParam", param);
        if (param2 != null) {
            for (Map.Entry<String, Object> entry : param2.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
        String dateString = formatter.format(date);
        jf.addParam("WRITE_DATE", dateString);
        
        List<Map<String, Object>> list = jasperService.selectList("atx340ukrServiceImpl.selectDetail", param);
        Map<String, Object> sumParam = (Map<String, Object>)jasperService.getDao().select("atx340ukrServiceImpl.selectListTo340PrintSum", param);
        if (sumParam != null) {
            for (Map.Entry<String, Object> entry : sumParam.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        //blank column begin
        int listSize = 0;
        int firstPageCount = 13;
        int pageCount = 24;
        if (list != null) {
            listSize = list.size();
        }
        if (listSize < firstPageCount) {
            int tempSize = firstPageCount - listSize;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                list.add(nullMap);
            }
        } else if (listSize > firstPageCount) {
            int tempSize = pageCount - ( listSize - firstPageCount ) % pageCount;
            for (int i = 1; i <= tempSize; i++) {
                Map nullMap = new HashMap();
                list.add(nullMap);
            }
        }
        //end
        jflist.addAll(list);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by chenaibo 20161124
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx355ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx355ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        
        JasperFactory jf = jasperService.createJasperFactory("atx355ukr", "atx355ukr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        jf.addParam("TO_PUB_DATE", param.get("TO_PUB_DATE"));
        jf.addParam("WRITE_DATE", param.get("WRITE_DATE"));
        jf.addParam("FSETQ", param.get("FSetQ"));
        
        if (param.get("FR_PUB_DATE") != null) {
            Map termCode = (Map)jasperService.getDao().select("atx355ukrServiceImpl.selectTermCode", param);
            jf.addParam("COMP_NAME", termCode.get("COMP_NAME"));
            jf.addParam("COMPANY_NUM", termCode.get("COMPANY_NUM"));
            jf.addParam("REPRE_NAME", termCode.get("REPRE_NAME"));
            jf.addParam("ADDR", termCode.get("ADDR"));
            jf.addParam("SAFFER_TAX_NM", termCode.get("SAFFER_TAX_NM"));
            jf.addParam("TERM_CODE", termCode.get("TERM_CODE"));
            
        }
        
        List<Map<String, Object>> list1 = jasperService.selectList("atx355ukrServiceImpl.selectrptlist", param);
        List<Map<String, Object>> sublist1 = jasperService.selectList("atx355ukrServiceImpl.selectsublist1", param);
        List<Map<String, Object>> sublist2 = jasperService.selectList("atx355ukrServiceImpl.selectsublist2", param);
        jf.setList(list1);
        jf.addSubDS("DS_SUB01", sublist1);
        jf.addSubDS("DS_SUB02", sublist2);
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by chenaibo 20161124
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx520ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx520ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        
        JasperFactory jf = jasperService.createJasperFactory("atx520ukr", "atx520ukr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        Calendar cal = Calendar.getInstance();
        cal.set(cal.YEAR, Integer.parseInt(param.get("TO_PUB_DATE").toString().substring(0, 4)));
        cal.set(cal.MONTH, Integer.parseInt(param.get("TO_PUB_DATE").toString().substring(4, 6)) - 1);
        Integer lastDay = cal.getActualMaximum(cal.DAY_OF_MONTH);
        param.put("FR_PUB_DATE", param.get("FR_PUB_DATE") + "01");
        param.put("TO_PUB_DATE", param.get("TO_PUB_DATE") + lastDay.toString());
        
        jf.addParam("FR_PUB_DATE", param.get("FR_PUB_DATE"));
        
        Map termCode = (Map)jasperService.getDao().select("atx520ukrServiceImpl.selectTermCode", param);
        
        jf.addParam("COMP_NAME", termCode.get("COMP_NAME"));
        jf.addParam("COMPANY_NUM", termCode.get("COMPANY_NUM"));
        jf.addParam("REPRE_NAME", termCode.get("REPRE_NAME"));
        jf.addParam("ADDR", termCode.get("ADDR"));
        jf.addParam("TERM_CODE", termCode.get("TERM_CODE"));
        jf.addParam("COMP_TYPE", termCode.get("COMP_TYPE"));
        jf.addParam("COMP_CLASS", termCode.get("COMP_CLASS"));
        
        List<Map<String, Object>> list1 = jasperService.selectList("atx520ukrServiceImpl.selectForm", param);
        jf.setList(list1);
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by ChenRongdong
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx360ukr.do", method = RequestMethod.GET )
    public ModelAndView atx360ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {
        		"subAtx360ukr_1","subAtx360ukr_2","subAtx360ukr_3","subAtx360ukr_4"
        };
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        
        JasperFactory jf = jasperService.createJasperFactory("atx360ukr", "atx360ukr", param);   // "폴더명" , "파일명" , "파라미터
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        jf.setList(jasperService.selectList("atx360ukrServiceImpl.fnatx360q", param));
        List<Map<String, Object>> sub1 = jasperService.selectList("atx360ukrServiceImpl.selectList3", param);
        List<Map<String, Object>> sub2 = jasperService.selectList("atx360ukrServiceImpl.selectList4", param);
        Map<String, Object> map = new HashMap<>();
        map.put("DEBT_DATE", "");
        map.put("SUPPLY_AMT_I", new BigDecimal(0));
        map.put("SUBTRACT_RATE", "");
        map.put("TAX_AMT_I", new BigDecimal(0));
        map.put("CUSTOM_CODE", "");
        map.put("PERSON_NUM", "");
        map.put("COMPANY_NUM", "");
        map.put("DEBT_REASON", "");
        if (sub1.size() <= 8) {
            jf.addSubDS("DS_SUB02", sub1);
            jf.addParam("SUBSIZE01", sub1.size());
        } else {
            int len = 51 - ( sub1.size() % 50 );
            for (int i = 0; i < len; i++)
                sub1.add(map);
            jf.addSubDS("DS_SUB03", sub1);
            jf.addParam("SUBSIZE01", sub1.size());
        }
        if (sub2.size() <= 8) {
            for (int i = sub2.size(); i < 8; i++)
                sub2.add(map);
            jf.addSubDS("DS_SUB01", sub2);
            jf.addParam("SUBSIZE02", sub2.size());
        } else {
            int len = 51 - ( sub2.size() % 51 );
            for (int i = 0; i < len; i++)
                sub2.add(map);
            jf.addSubDS("DS_SUB04", sub2);
            jf.addParam("SUBSIZE02", sub2.size());
        }
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx450rkr.do", method = RequestMethod.GET )
    public ModelAndView atx450rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "sub2_atx450rkr", "sub3_atx450rkr", "sub4_atx450rkr", "sub5_atx450rkr" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        
        param.put("DECLARE_DATE", param.get("FR_PUB_DATE").toString().substring(0, 4));
        int term = Integer.valueOf(param.get("TO_PUB_DATE").toString().substring(4, 6));
        param.put("sGisu", term > 7 ? "2" : "1");
        
        JasperFactory jf = jasperService.createJasperFactory("atx450rkr", "atx450rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        List<Map<String, Object>> list1 = jasperService.selectList("atx450rkrServiceImpl.selectList1", param);
        List<Map<String, Object>> list2 = jasperService.selectList("atx450rkrServiceImpl.selectList2", param);
        List<Map<String, Object>> list3 = jasperService.selectList("atx450rkrServiceImpl.selectList3", param);
        List<Map<String, Object>> list4 = jasperService.selectList("atx450rkrServiceImpl.selectList4", param);
        List<Map<String, Object>> list5 = jasperService.selectList("atx450rkrServiceImpl.selectList5", param);
        Map<String, Object> map = new HashMap<>();
        int size3 = list3.size();
        int size4 = list4.size();
        int size5 = list5.size();
        for(int i=0;i<5-size3;i++)
        	list3.add(map);
        for(int i=0;i<2-size4;i++)
        	list4.add(map);
        for(int i=0;i<2-size5;i++)
        	list5.add(map);
        jf.addSubDS("DS_SUB02", list2);
        jf.addSubDS("DS_SUB03", list3);
        jf.addSubDS("DS_SUB04", list4);
        jf.addSubDS("DS_SUB05", list5);
        jf.setList(list1);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @param user
     * @param request
     * @param reportType
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx460rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx460rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {
        
        };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        
        JasperFactory jf = jasperService.createJasperFactory("atx460rkr", "atx460rkr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        if (param.get("COMPANY_NUM") != null) {
            String companyNum = param.get("COMPANY_NUM").toString();
            companyNum = companyNum.substring(0, 3) + "-" + companyNum.substring(4, 6) + "-" + companyNum.substring(7, 12);
            jf.addParam("P_COMPANY_NUM", companyNum);
        }
        
        List<Map<String, Object>> list = jasperService.selectList("atx460ukrServiceImpl.selectListToPrint", param);
        
        jflist.addAll(list);
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
    
    @RequestMapping( value = "/atx/atx480ukr.do", method = RequestMethod.GET )
    public ModelAndView atx480rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "atx471ukr" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        JasperFactory jf = jasperService.createJasperFactory("atx480ukr", param);   // "폴더명" , "파일명" , "파라미터
        jf.setReportType(reportType);
        jf.setSubReportFiles(subReportFileNames);
        
        List<Map<String, Object>> subList = jasperService.selectList("atx480ukrServiceImpl.selectList", param);
        if (subList.size() < 12) {
            for (int i = subList.size(); i < 12; i++) {
                Map<String, Object> map = new HashMap<>();
                map.put("AC_YYYYMM", "");
                map.put("ITEM_NAME", "");
                map.put("REMARK", "");
                map.put("SALE_AMT", new BigDecimal(0));
                subList.add(map);
            }
            jf.addSubDS("DS_SUB01", subList);
        } else {
            jf.addSubDS("DS_SUB01", subList.subList(0, 11));
        }
        
        jf.setList(jasperService.selectList("atx480ukrServiceImpl.fnatx480qstd", param));
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl 현급출납장 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx530ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx530ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        // Report와 SQL용 파라미터 구성
        Map<String, Object> param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = jasperService.createJasperFactory("atx530ukr", "atx530ukr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> map = (Map<String, Object>)jasperService.getDao().select("atx530ukrServiceImpl.fnGetDivCodeInfo", param);
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
        String dateString = formatter.format(date);
        jf.addParam("P_DATE", dateString);
        jflist.addAll(jasperService.selectList("atx530ukrServiceImpl.selectListToPrint", param));
        jf.setList(jflist);
        return ViewHelper.getJasperView(jf);
    }
    /**
     * add by zhongshl 현급출납장 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx540ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx540ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        // Report와 SQL용 파라미터 구성
        Map<String, Object> param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = jasperService.createJasperFactory("atx540ukr", "atx540ukr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        jflist.addAll(jasperService.selectList("atx540ukrServiceImpl.selectListToPrint", param));
        jf.setList(jflist);
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl 현급출납장 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx500ukrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx500ukrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = {};
        // Report와 SQL용 파라미터 구성
        Map<String, Object> param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = jasperService.createJasperFactory("atx500ukr", "atx500ukr", param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        Map<String, Object> map = (Map<String, Object>)jasperService.getDao().select("atx500ukrServiceImpl.selectListInit", param);
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jf.addParam(entry.getKey(), entry.getValue());
            }
        }
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        String dateString = formatter.format(date);
        jf.addParam("SYS_DATE", dateString);
        jflist.addAll(jasperService.selectList("atx500ukrServiceImpl.selectList", param));
        jf.setList(jflist);
        return ViewHelper.getJasperView(jf);
    }
    /**
     * 수입집계표 출력
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/atx/atx550rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView atx550rkrPrint( ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
     //   String[] subReportFileNames = new String[1];
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("COMP_NAME", user.getCompName());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용        
        JasperFactory jf = null;
//        jf = jasperService.createJasperFactory("atx550rkr", "atx550rkr", param);
        if ("1".equals(param.get("TERM_DIVI"))) {
            jf = jasperService.createJasperFactory("atx550rkr", "atx550rkr", param);
        }else if("2".equals(param.get("TERM_DIVI"))) {
            jf = jasperService.createJasperFactory("atx550rkr", "atx550rkr2", param);
        }else if("3".equals(param.get("TERM_DIVI"))) {
            jf = jasperService.createJasperFactory("atx550rkr", "atx550rkr3", param);
        }else if("4".equals(param.get("TERM_DIVI"))) {
            jf = jasperService.createJasperFactory("atx550rkr", "atx550rkr4", param);
        }
        // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        
        String termDivi = param.get("TERM_DIVI") + "";
        jf.addParam("termDivi", termDivi);
        jf.addParam("COMP_NAME", param.get("COMP_NAME"));
        
        jflist.addAll(jasperService.selectList("atx550ukrServiceImpl.selectList", param));
        jf.setList(jflist);
        
        return ViewHelper.getJasperView(jf);
    }
}
