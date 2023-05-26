package foren.unilite.modules.pos.pos;

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
public class PosReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
    /**
     * 거래명세서
     * (거래건별 매출현황조회 - 영수증별 상세내역조회 )
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/pos/pos100rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView pos100rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("pos100rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            
            jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

        	Map dataParam = new HashMap();
        	
		    	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
		    	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
		    	dataParam.put("SALE_DATE"	, param.get("SALE_DATE"));
		    	dataParam.put("POS_NO"		, param.get("POS_NO"));
		    	dataParam.put("POS_NAME"	, param.get("POS_NAME"));
		    	dataParam.put("RECEIPT_NO"	, param.get("RECEIPT_NO"));
		    	dataParam.put("CUSTOM_NAME"	, param.get("CUSTOM_NAME"));
        	//logger1.debug("jasper arry : " + arry[i]);
        	
        	jflist.addAll(jasperService.selectList("pos100rkrServiceImpl.selectPrimaryDataList", dataParam));

        
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
        * 시간대별 매출현황 조회
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/pos/pos110rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView pos110rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = {
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               param.put("COMP_NAME", user.getCompName());
               
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("pos110rkr", param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               
               
               String posCode = ObjUtils.getSafeString(param.get("POS_CODE"));
               
               List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
               
               	Map dataParam = new HashMap();
               	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
               	dataParam.put("COMP_NAME"	, param.get("COMP_NAME"));
               	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
               	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
               	dataParam.put("SALE_DATE_FR", param.get("SALE_DATE_FR"));
               	dataParam.put("SALE_DATE_TO", param.get("SALE_DATE_TO"));             	
                if(posCode != null){
             	   String[] arry  = posCode.split(",");
             	   dataParam.put("POS_CODE" 	, arry);
                }	
           	
           	jflist.addAll(jasperService.selectList("pos110rkrServiceImpl.selectPrimaryDataList", dataParam));

           
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
           * 신용카드사별 승인내역 조회
           * @param _req
           * @return
           * @throws Exception
           */
             @RequestMapping(value = "/pos/pos210rkrPrint.do", method = RequestMethod.GET)
              public ModelAndView pos210rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
                 String[] subReportFileNames = {
                 };
                 
                 // Report와 SQL용 파라미터 구성
                  Map param = _req.getParameterMap();
                  param.put("COMP_CODE", user.getCompCode());
                  
                  
                  // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                  // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                  JasperFactory jf  = jasperService.createJasperFactory("pos210rkr", param);
                  jf.setReportType(reportType);
                  // SubReport 파일명 목록을 전달
                  // 레포트 수행시 compile을 상황에 따라 수행함.
                  jf.setSubReportFiles(subReportFileNames);
                  
                  
                  String posCode = ObjUtils.getSafeString(param.get("POS_CODE"));
                  
                  List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
                  
                  	Map dataParam = new HashMap();
                  	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
                  	dataParam.put("DIV_CODE"		, param.get("DIV_CODE"));
                  	dataParam.put("SHOP_CLASS"		, param.get("SHOP_CLASS"));
                  	dataParam.put("COLLECT_DATE_FR"	, param.get("COLLECT_DATE_FR"));
                  	dataParam.put("COLLECT_DATE_TO"	, param.get("COLLECT_DATE_TO"));
                  	
                   if(posCode != null){
                	   String[] arry  = posCode.split(",");
                	   dataParam.put("POS_CODE" 	, arry);
                   }	
              	
              	jflist.addAll(jasperService.selectList("pos210rkrServiceImpl.selectPrimaryDataList", dataParam));

              
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
