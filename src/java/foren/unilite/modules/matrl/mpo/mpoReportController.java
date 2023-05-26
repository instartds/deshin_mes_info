package foren.unilite.modules.matrl.mpo;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

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
public class mpoReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name="mpo210skrvService")
	private Mpo210skrvServiceImpl mpo210skrvService;
    
    @Resource(name="mpo150rkrvService")
    private Mpo150rkrvServiceImpl mpo150rkrvService;
    
    
    @RequestMapping(value = "/mpo/mpo150rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView mpo150rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {"top_Payment"};
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        param.put("S_USER_ID", user.getUserID());
        
        
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        JasperFactory jf  = jasperService.createJasperFactory("mpo150rkr", param);
        jf.setReportType(reportType);
        
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // Primary data source
        jf.setList(jasperService.selectList("mpo150rkrvServiceImpl.selectList", param));  
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
        return ViewHelper.getJasperView(jf);
    }
    
    
    
    
    /**
     * 발 주 서 (정규)
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/mpo/mpo501rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView mpo501rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
        		  "mpo501rkr_sub01",
        		//   "mpo501rkr_sub02",
        		//   "mpo501rkr_sub03"

           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("mpo501rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
            //jf.addParam("pos_IMAGE_PATH", ConfigUtil.getUploadBasePath(PosController.FILE_TYPE_OF_PHOTO) + File.separator);
            jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            // Primary data source
            jf.setList(jasperService.selectList("mpo501rkrServiceImpl.selectPrimaryDataList", param));
            
            // sub report data sources
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            
            
            jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
         //   jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
          //  jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

            return ViewHelper.getJasperView(jf);
        }
       
       /**
        * 발 주 서 (연세대)
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/mpo/mpo502rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView mpo502rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = {
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               //param.put("DIV_CODE", user.getDivCode());
               
               
               
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("mpo502rkr", param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               
               // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
               //jf.addParam("pos_IMAGE_PATH", ConfigUtil.getUploadBasePath(PosController.FILE_TYPE_OF_PHOTO) + File.separator);
               jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
               
               // Primary data source
               jf.setList(jasperService.selectList("mpo502rkrServiceImpl.selectPrimaryDataList", param));
               
               // sub report data sources
               
               // 레포트 자체의 SQL 사용시에만 사용 
               //super.jasperService.setDbConnection(jParam);
               
               //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
              // jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
              // jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

               return ViewHelper.getJasperView(jf);
           }
          
          
          
          /**
           * 발 주 서 (FAX 전송용 Report)
           * @param _req
           * @return
           * @throws Exception
           */
             @RequestMapping(value = "/mpo/mpo503rkrPrint.do", method = RequestMethod.GET)
              public ModelAndView mpo503rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
                 String[] subReportFileNames = {
                 };
                 
                 // Report와 SQL용 파라미터 구성
                  Map param = _req.getParameterMap();
                  param.put("COMP_CODE", user.getCompCode());
                  
                  
                  // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                  // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                  JasperFactory jf  = jasperService.createJasperFactory("mpo503rkr", param);
                  jf.setReportType(reportType);
                  
                  // SubReport 파일명 목록을 전달
                  // 레포트 수행시 compile을 상황에 따라 수행함.
                  jf.setSubReportFiles(subReportFileNames);
                  
                  jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
                  
                  // Primary data source
                  jf.setList(jasperService.selectList("mpo503rkrServiceImpl.selectPrimaryDataList", param));
                  
                  return ViewHelper.getJasperView(jf);
              }
         /**
          * 발주서 - Fax 전송
          * @param _req
          * @param user
          * @param request
          * @throws Exception
          */
          @RequestMapping(value = "/mpo/mpo503rkrFax.do", method = RequestMethod.POST)
          public ModelAndView  mpo503rkrFax(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request) throws Exception {
            	 String[] subReportFileNames = {
                 };
                 
                 // Report와 SQL용 파라미터 구성
                  //Map params = _req.getParameterMap();
                  
                  ObjectMapper mapper = new ObjectMapper();
                  List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
          				TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));

                  
                  for( Map param : paramList )	{
	                  param.put("S_COMP_CODE", user.getCompCode());
	                  param.put("FILE_NAME", "mpo503rkr_"+ObjUtils.getSafeString(param.get("ORDER_NUM"))+".pdf");
	                  param.put("FAX_TITLE", "발주서 ("+ObjUtils.getSafeString(param.get("CUSTOM_NAME"))+")");
	                  // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
	                  // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
	                  JasperFactory jf  = jasperService.createJasperFactory("mpo503rkr", param);
	                  
	                  // SubReport 파일명 목록을 전달
	                  // 레포트 수행시 compile을 상황에 따라 수행함.
	                  jf.setSubReportFiles(subReportFileNames);
	                  
	                  jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
	                  
	                  // Primary data source
	                  jf.setList(jasperService.selectList("mpo503rkrServiceImpl.selectPrimaryDataList", param));
	                 
	                  ReportUtils.savePdf(jf, ObjUtils.getSafeString(param.get("ORDER_NUM")));
	                 
                 }
                  
                 paramList = mpo210skrvService.insertSend(paramList);
                  
                 
                 return ViewHelper.getJsonView(paramList);
          }
       
}
