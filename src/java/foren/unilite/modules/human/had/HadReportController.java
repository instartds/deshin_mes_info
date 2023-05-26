package foren.unilite.modules.human.had;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
public class HadReportController extends UniliteCommonController {
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
	
	/**
     * 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/human/had421rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView had421rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
    	   
            String[] subReportFileNames = { "had421rkr_sub1","had421rkr_sub2" };
           
            // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("had421rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
         
            // Primary data source
            jf.setList(jasperService.selectList("had421rkrServiceImpl.selectListToPrint", param));
            jf.addSubDS("DS_SUB01", jasperService.selectList("had421rkrServiceImpl.selectListToPrintSub1", param));
            jf.addSubDS("DS_SUB02", jasperService.selectList("had421rkrServiceImpl.selectListToPrintSub2", param));
            return ViewHelper.getJasperView(jf);
        }
       
       @RequestMapping(value = "/human/had840rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView had840rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());
           
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = null;
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           
           // Primary data source
           int yyyy = Integer.valueOf(param.get("YEAR_YYYY").toString());
           if( yyyy >= 2015 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2015",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2015sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2015Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2015Query2",param));
           }
           else if( yyyy >=2014 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2014",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2014sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2014Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2014Query2",param));
           }
           else if( yyyy >=2013 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2013",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2013sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2013Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2013Query2",param));
           }
           else if( yyyy >=2012 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2012",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2012sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2012Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2012Query2",param));
           }
           else if( yyyy >=2011 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2011",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2011sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2011Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2011Query2",param));
           }
           else if( yyyy >=2010 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2010",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2010sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2010Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2010Query2",param));
           }
           else if( yyyy >=2009 ){
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2009",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2009sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2009Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2009Query2",param));
           }
           else	{
        	   jf = jasperService.createJasperFactory("had840rkr","had840rkr2008",param);
        	   jf.setReportType(reportType);
        	   String[] subReportFileNames = {"had840_2007sub"};
               jf.setSubReportFiles(subReportFileNames);
        	   jf.setList(jasperService.selectList("had840rkrServiceImpl.selectList2008Query1", param));
        	   jf.addSubDS("DS_SUB01", jasperService.selectList("had840rkrServiceImpl.selectList2008Query2",param));
           }
           return ViewHelper.getJasperView(jf);
       }
       
       
       
       
       @RequestMapping(value = "/human/had850rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView had850rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {  };
          
           // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());
           
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = jasperService.createJasperFactory("had850rkr",param);
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           // Primary data source
           int yyyy = Integer.valueOf(param.get("YEAR_YYYY").toString());
           if( yyyy >= 2010 )
        	   jf.setList(jasperService.selectList("had850rkrServiceImpl.selectlist2010", param));
           else if( yyyy >=2009 )
        	   jf.setList(jasperService.selectList("had850rkrServiceImpl.selectlist2009", param));
           else	jf.setList(jasperService.selectList("had850rkrServiceImpl.selectlist2008", param));
           
           return ViewHelper.getJasperView(jf);
       }
       
       
	 /**
     * 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/human/had900rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView had900rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
            String[] subReportFileNames = {  };
           
            // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("had900rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
         
            // Primary data source
            jf.setList(jasperService.selectList("had900rkrServiceImpl.selectToPrint", param));
         
            return ViewHelper.getJasperView(jf);
        }
       
       /**
        * 
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/human/had910rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView had910rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
               String[] subReportFileNames = {  };
              
               // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               String retrType = param.get("RETR_TYPE")+"";
               String fileName = "had910p";
               
               if("N".equals(retrType)){
            	   fileName = "had910p";
               }else if("Y".equals(retrType)){
            	   fileName = "had911p";
               }else if("R".equals(retrType)){
            	   fileName = "had912p";
               }else if("I".equals(retrType) 
            		   || "D".equals(retrType) 
            		   || "SR".equals(retrType) 
            		   || "OR".equals(retrType) 
            		   || "SU".equals(retrType) 
            		   || "OU".equals(retrType)){
            	   fileName = "had913p";
               }
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("had910rkr",fileName, param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               String sqlStr = "";
               if("R".equals(retrType)){
            	   sqlStr = "had910rkrServiceImpl.selectToPrintR";
               }else if("N".equals(retrType) || "Y".equals(retrType)){
            	   sqlStr = "had910rkrServiceImpl.selectToPrintYN";
               }else if("I".equals(retrType) 
            		   || "D".equals(retrType) 
            		   || "SR".equals(retrType) 
            		   || "OR".equals(retrType) 
            		   || "SU".equals(retrType) 
            		   || "OU".equals(retrType)){
            	   sqlStr = "had910rkrServiceImpl.selectToPrintOther";
               }
               // Primary data source
               jf.setList(jasperService.selectList(sqlStr, param));
            
               return ViewHelper.getJasperView(jf);
           }
}
