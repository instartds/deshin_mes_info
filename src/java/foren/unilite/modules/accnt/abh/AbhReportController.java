package foren.unilite.modules.accnt.abh;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class AbhReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
    /**
     * 이체지급확정
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/abh/abh220rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView abh220rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
                   
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("abh220rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

        	jflist.addAll(jasperService.selectList("abh220rkrServiceImpl.selectPrimaryDataList", param));
            
            jf.setList(jflist);

            return ViewHelper.getJasperView(jf);
        }
       /**
        * 
        * @param _req
        * @param user
        * @param request
        * @param reportType
        * @return
        * @throws Exception
        */
       @RequestMapping(value = "/abh/abh200rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView abh200rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
        		  "top_Payment"
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = jasperService.createJasperFactory("abh200rkr", param);
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           
           List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
           
           jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
           
       	   jflist.addAll(jasperService.selectList("abh200ukrServiceImpl.selectDetail", param));
       	   
       	   List<Map<String, Object>> masterList = jasperService.selectList("abh200ukrServiceImpl.selectMaster", param);
       	   if(masterList != null && masterList.size() > 0){
       		   Map<String, Object> map = masterList.get(0);
       		   for (Map.Entry<String, Object> entry : map.entrySet()) {
       			   jf.addParam(entry.getKey(), entry.getValue());
       		   }
   		   String payMeth = map.get("PAY_METH")+"";
   		   param.put("PAY_METH", payMeth);
   		   Map<String, Object> codeMap = (Map<String, Object>) jasperService.getDao().select("abh200ukrServiceImpl.selectCodeName",param);
   		   if(codeMap != null){
   			   jf.addParam("PAY_METH_NAME",codeMap.get("PAY_METH_NAME"));
   		   }
       	   }
       	
       	
       	   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
       	   jf.addParam("NOW_DATE", sdf.format(new Date()));
           jf.setList(jflist);

           return ViewHelper.getJasperView(jf);
       }
       
       /**
        * 이체결과 현황 출력
        * @param _req
        * @param user
        * @param request
        * @param reportType
        * @return
        * @throws Exception
        */
       @RequestMapping(value = "/abh/abh230rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView abh230rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           String[] subReportFileNames = {};
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = jasperService.createJasperFactory("abh230rkr", param);
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           
           List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

           jflist.addAll(jasperService.selectList("abh230rkrServiceImpl.selectReportList", param));
           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
           jf.addParam("NOW_DATE", sdf.format(new Date()));
           jf.setList(jflist);

           return ViewHelper.getJasperView(jf);

       }
       
}
