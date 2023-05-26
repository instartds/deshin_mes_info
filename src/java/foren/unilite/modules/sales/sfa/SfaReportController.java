package foren.unilite.modules.sales.sfa;

import java.io.File;
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
public class SfaReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    /**
     * POS별 매출일보
     * @param _req
     * @return
     * @throws Exception
     * 최신버전 2015.11.11 dataParam 제거, 레포트 하단 법인명 파라미터화 처리 완료 
     */
       @RequestMapping(value = "/sfa/sfa210rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView sfa210rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
       
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
  
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("sfa210rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
            	
            jflist.addAll(jasperService.selectList("sfa210skrvServiceImpl.selectList", param)); /* 조회쿼리와 동일하게 바라봄  */

            jf.setList(jflist);

            return ViewHelper.getJasperView(jf);
        }
       
    /**
     * 부서별 매출일보
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/sfa/sfa211rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView sfa211rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("sfa211rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            // Primary data source

            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

            	Map dataParam = new HashMap();
            	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
            	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
            	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
            	dataParam.put("SALE_DATE_FR", param.get("SALE_DATE_FR"));
            	dataParam.put("SALE_DATE_TO", param.get("SALE_DATE_TO"));
            	dataParam.put("DEPT_NAME"	, param.get("DEPT_NAME"));

            	
            	
            	//logger1.debug("jasper arry : " + arry[i]);
            	
            	jflist.addAll(jasperService.selectList("sfa211rkrServiceImpl.selectPrimaryDataList", dataParam));

            
            jf.setList(jflist);
            
            
            // sub report data sources
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            
            //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
            //jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
            //jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

            return ViewHelper.getJasperView(jf);
        }
       
       
       /**
        * 매출 ABC 분석
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/sfa/sfa260rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView sfa260rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = {
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("sfa260rkr", param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               
               //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
               
               // Primary data source

               
               List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

               	Map dataParam = new HashMap();
               	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
               	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
               	dataParam.put("DEPT_NAME"	, param.get("DEPT_NAME"));
               	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
               	dataParam.put("WH_CODE"		, param.get("WH_CODE"));
               	dataParam.put("SALES_DATE_FR", param.get("SALES_DATE_FR"));
               	dataParam.put("SALES_DATE_TO", param.get("SALES_DATE_TO"));
               	dataParam.put("ITEM_LEVEL1"	, param.get("ITEM_LEVEL1"));
               	dataParam.put("ITEM_LEVEL2"	, param.get("ITEM_LEVEL2"));
               	dataParam.put("ITEM_LEVEL3"	, param.get("ITEM_LEVEL3"));

               	
               	
               	//logger1.debug("jasper arry : " + arry[i]);
               	
               	jflist.addAll(jasperService.selectList("sfa260rkrServiceImpl.selectPrimaryDataList", dataParam));

               
               jf.setList(jflist);
               
               
               // sub report data sources
               
               // 레포트 자체의 SQL 사용시에만 사용 
               //super.jasperService.setDbConnection(jParam);
               
               //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
               //jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
               //jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

               return ViewHelper.getJasperView(jf);
           }
          
          /**
           * 전사 매출집계 현황
           * @param _req
           * @return
           * @throws Exception
           */
             @RequestMapping(value = "/sfa/sfa300rkrPrint.do", method = RequestMethod.GET)
              public ModelAndView sfa300rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
                 String[] subReportFileNames = {
                 };
                 
                 // Report와 SQL용 파라미터 구성
                  Map param = _req.getParameterMap();
                  param.put("COMP_CODE", user.getCompCode());
                  
                  
                  // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                  // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                  JasperFactory jf  = jasperService.createJasperFactory("sfa300rkr", param);
                  jf.setReportType(reportType);
                  // SubReport 파일명 목록을 전달
                  // 레포트 수행시 compile을 상황에 따라 수행함.
                  jf.setSubReportFiles(subReportFileNames);
                  
                  //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
                  
                  // Primary data source

                  
                  List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

                  	Map dataParam = new HashMap();
                  	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
                  	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
                  	dataParam.put("SALE_DATE_FR", param.get("SALE_DATE_FR"));
                   	dataParam.put("SALE_DATE_TO", param.get("SALE_DATE_TO"));
                  	
                  	
                  	//logger1.debug("jasper arry : " + arry[i]);
                  	
                  	jflist.addAll(jasperService.selectList("sfa300rkrServiceImpl.selectPrimaryDataList", dataParam));

                  
                  jf.setList(jflist);
                  
                  
                  // sub report data sources
                  
                  // 레포트 자체의 SQL 사용시에만 사용 
                  //super.jasperService.setDbConnection(jParam);
                  
                  //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
                  //jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
                  //jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

                  return ViewHelper.getJasperView(jf);
              }
}
