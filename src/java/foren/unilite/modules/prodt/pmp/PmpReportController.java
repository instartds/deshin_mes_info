package foren.unilite.modules.prodt.pmp;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
public class PmpReportController  extends UniliteCommonController {
    @InjectLogger
    public static Logger logger;
    
    @RequestMapping(value = "/prodt/pmp130rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView pmp130rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {"top_Payment"};
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("S_USER_ID", user.getUserID());
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
        JasperFactory jf = null;
        if("WKORDNUM".equals((String)param.get("sPrintFlag"))){
        	jf  = jasperService.createJasperFactory("pmp130rkr", param);
        }else{
        	jf  = jasperService.createJasperFactory("pmp130rkr", "pmp130rkr2", param);
        }
        jf.setReportType(reportType);
        
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // Primary data source
        jf.setList(jasperService.selectList("pmp130rkrvServiceImpl.selectList", param));  
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        return ViewHelper.getJasperView(jf);
    }   
}