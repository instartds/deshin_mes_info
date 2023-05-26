package foren.unilite.modules.coop.cpa;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.*;
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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;


@Controller
public class cpaReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    

    
    /**
     * 출자확인서
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/cpa/cpa100rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView cpa100rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("cpa100rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)        
            
            jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            // Primary data source
            jf.setList(jasperService.selectList("cpa100rkrServiceImpl.selectPrimaryDataList", param));
            
            // sub report data sources
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            
           // jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
         //   jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
          //  jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

            return ViewHelper.getJasperView(jf);
        }
       
       /**
        * 조합원배당 현황 확정
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/cpa/cpa310rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView cpa310rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = {
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("S_COMP_CODE", user.getCompCode());
               
               
               
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("cpa310rkr", param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               
               // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)        
               
               jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
               
               List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

	           	Map dataParam = new HashMap();
	           	
	   		    	dataParam.put("COOP_YYYY"		, param.get("COOP_YYYY"));
	   		    	dataParam.put("COOP_SEQ"		, param.get("COOP_SEQ"));
	   		    	dataParam.put("CONFIRM_DATE"	, param.get("CONFIRM_DATE"));
               // Primary data source
               jf.setList(jasperService.selectList("cpa310rkrServiceImpl.selectPrimaryDataList", param));

               return ViewHelper.getJasperView(jf);
           }
}
