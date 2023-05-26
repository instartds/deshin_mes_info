package foren.unilite.modules.human.hat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
public class HatReportController extends UniliteCommonController {
    @InjectLogger
    public static Logger         logger;              // = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "hat530rkrService" )
    private Hat530rkrServiceImpl hat530rkrServiceImpl;
    
    /**
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/human/hat820rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView hat820rkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf = jasperService.createJasperFactory("hat820rkr", param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        List<Map<String, Object>> DUTY_CODE = jasperService.selectList("hat820rkrServiceImpl.fnHat820nQ", param);
        List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
        if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
            int num = DUTY_CODE.size();
            for (int i = 0; i <= 9; i++) {
                if (i >= num) {
                    jf.addParam("Field" + ( i + 1 ), "");
                    DUTY_CODE_SUPPLY.add(i + 1);
                } else {
                    Map<String, Object> map = DUTY_CODE.get(i);
                    jf.addParam("Field" + ( i + 1 ), map.get("CODE_NAME"));
                }
                
            }
            param.put("DUTY_CODE_SIZE", num);
            //            	DUTY_CODE.addAll(DUTY_CODE);
            //            	DUTY_CODE.add(DUTY_CODE.get(0));
            param.put("DUTY_CODE", DUTY_CODE);
            param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);//补充   小于10
        }
        
        // Primary data source
        jf.setList(jasperService.selectList("hat820rkrServiceImpl.selectToPrint", param));
        
        // sub report data sources
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/hat/hat530rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView hat530rkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        String dutyInputRuleStr = "N";
        List<Map<String, Object>> dutyInputRuleList = jasperService.selectList("hat530rkrServiceImpl.selectHBS400T", param);
        if (dutyInputRuleList != null && dutyInputRuleList.size() > 0) {
            Map<String, Object> map = dutyInputRuleList.get(0);
            if (map.get("DUTY_INPUT_RULE") != null) {
                dutyInputRuleStr = map.get("DUTY_INPUT_RULE").toString();
            }
        }
        String reportFile = "hat530rkr1";
        int fieldNum = 0;
        if (dutyInputRuleStr.equals("Y")) {
            fieldNum = 14;
            if ("1".equals(param.get("DOC_KIND"))) {
                reportFile = "hat530rkr1";
            } else {
                reportFile = "hat530rkr2";
            }
        } else {
            if ("1".equals(param.get("DOC_KIND"))) {
                fieldNum = 19;
                reportFile = "hat530rkr3";
            } else {
                fieldNum = 17;
                reportFile = "hat530rkr4";
            }
        }
        param.put("DUTY_INPUT_RULE", dutyInputRuleStr);
        JasperFactory jf = jasperService.createJasperFactory("hat530rkr", reportFile, param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        List<Map<String, Object>> DUTY_CODE = jasperService.selectList("hat530rkrServiceImpl.selectDutyCode", param);
        List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
        if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
            int num = DUTY_CODE.size();
            for (int i = 0; i <= fieldNum; i++) {
                if (i >= num) {
                    jf.addParam("Field" + ( i + 1 ), "");
                    DUTY_CODE_SUPPLY.add(i);
                } else {
                    Map<String, Object> map = DUTY_CODE.get(i);
                    jf.addParam("Field" + ( i + 1 ), map.get("CODE_NAME"));
                }
            }
            param.put("DUTY_CODE_SIZE", num);
            param.put("DUTY_CODE", DUTY_CODE);
            param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
            param.put("FIELD_NUM", fieldNum);
            List<Integer> fieldNumList = new ArrayList<Integer>();
            for (int i = 0; i <= fieldNum; i++) {
                fieldNumList.add(i);
            }
            param.put("FIELD_NUM_LIST", fieldNumList);
        }
        
        // Primary data source
        jf.setList(jasperService.selectList("hat530rkrServiceImpl.selectToPrint", param));
        
        // sub report data sources
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        return ViewHelper.getJasperView(jf);
    }
    
    /**
     * add by zhongshl
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/hat/hat540rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView hat540rkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        String dutyInputRuleStr = "N";
        List<Map<String, Object>> dutyInputRuleList = jasperService.selectList("hat540rkrServiceImpl.selectHBS400T", param);
        if (dutyInputRuleList != null && dutyInputRuleList.size() > 0) {
            Map<String, Object> map = dutyInputRuleList.get(0);
            if (map.get("DUTY_INPUT_RULE") != null) {
                dutyInputRuleStr = map.get("DUTY_INPUT_RULE").toString();
            }
        }
        String reportFile = "hat540rkr1";
        int fieldNum = 0;
        fieldNum = 19;
        if ("1".equals(param.get("DOC_KIND"))) {
            reportFile = "hat540rkr1";
        } else {
            reportFile = "hat540rkr2";
        }
        param.put("DUTY_INPUT_RULE", dutyInputRuleStr);
        JasperFactory jf = jasperService.createJasperFactory("hat540rkr", reportFile, param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        param.put("USE_YN", "Y");
        List<Map<String, Object>> DUTY_CODE = jasperService.selectList("hat540rkrServiceImpl.selectDutyCode", param);
        List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
        if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
            int num = DUTY_CODE.size();
            for (int i = 0; i <= fieldNum; i++) {
                if (i >= num) {
                    jf.addParam("Field" + ( i + 1 ), "");
                    DUTY_CODE_SUPPLY.add(i + 1);
                } else {
                    Map<String, Object> map = DUTY_CODE.get(i);
                    jf.addParam("Field" + ( i + 1 ), map.get("CODE_NAME"));
                }
            }
            param.put("DUTY_CODE_SIZE", num);
            param.put("DUTY_CODE", DUTY_CODE);
            param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
            param.put("FIELD_NUM", fieldNum);
        }
        param.put("USE_YN", "N");
        List<Map<String, Object>> dutyCodeN = jasperService.selectList("hat540rkrServiceImpl.selectDutyCode", param);
        param.put("DUTY_CODE_N", dutyCodeN);
        // Primary data source
        jf.setList(jasperService.selectList("hat540rkrServiceImpl.selectToPrint", param));
        
        // sub report data sources
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        return ViewHelper.getJasperView(jf);
    }

    /**
     * add by zhongshl
     * 
     * @param _req
     * @return
     * @throws Exception
     */
    @RequestMapping( value = "/hat/hat920rkrPrint.do", method = RequestMethod.GET )
    public ModelAndView hat920rkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam( value = "reportType", required = false, defaultValue = "pdf" ) String reportType ) throws Exception {
        String[] subReportFileNames = { "top_Payment" };
        
        // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        String dutyInputRuleStr = "N";
        List<Map<String, Object>> dutyInputRuleList = jasperService.selectList("hat920rkrServiceImpl.selectHBS400T", param);
        if (dutyInputRuleList != null && dutyInputRuleList.size() > 0) {
            Map<String, Object> map = dutyInputRuleList.get(0);
            if (map.get("DUTY_INPUT_RULE") != null) {
                dutyInputRuleStr = map.get("DUTY_INPUT_RULE").toString();
            }
        }
        String reportFile = "hat920rkr1";
        int fieldNum = 0;
        fieldNum = 19;
        if ("1".equals(param.get("DOC_KIND"))) {
            reportFile = "hat920rkr1";
        } else {
            reportFile = "hat920rkr2";
        }
        param.put("DUTY_INPUT_RULE", dutyInputRuleStr);
        JasperFactory jf = jasperService.createJasperFactory("hat920rkr", reportFile, param);
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        param.put("USE_YN", "Y");
        List<Map<String, Object>> DUTY_CODE = jasperService.selectList("hat920rkrServiceImpl.selectDutyCode", param);
        List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
        if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
            int num = DUTY_CODE.size();
            for (int i = 0; i <= fieldNum; i++) {
                if (i >= num) {
                    jf.addParam("Field" + ( i + 1 ), "");
                    DUTY_CODE_SUPPLY.add(i + 1);
                } else {
                    Map<String, Object> map = DUTY_CODE.get(i);
                    jf.addParam("Field" + ( i + 1 ), map.get("CODE_NAME"));
                }
            }
            param.put("DUTY_CODE_SIZE", num);
            param.put("DUTY_CODE", DUTY_CODE);
            param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
            param.put("FIELD_NUM", fieldNum);
        }
        param.put("USE_YN", "N");
        List<Map<String, Object>> dutyCodeN = jasperService.selectList("hat920rkrServiceImpl.selectDutyCode", param);
        param.put("DUTY_CODE_N", dutyCodeN);
        // Primary data source
        jf.setList(jasperService.selectList("hat920rkrServiceImpl.selectToPrint", param));
        
        // sub report data sources
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        
        // 레포트 자체의 SQL 사용시에만 사용 
        //super.jasperService.setDbConnection(jParam);
        
        return ViewHelper.getJasperView(jf);
    }
}
