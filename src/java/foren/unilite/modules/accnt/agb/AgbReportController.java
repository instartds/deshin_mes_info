package foren.unilite.modules.accnt.agb;

import java.io.File;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

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
public class AgbReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
    
    
    /**
     * 현급출납장 출력
     * @param _req
     * @return
     * @throws Exception
     */
   @RequestMapping(value = "/agb/agb100rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView agb100rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
    		   "top_Payment"
       };
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = jasperService.createJasperFactory("agb100rkr", "agb100rkr",  param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
        //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        //
        
        //parameter handle
//        if (param.get("DIV_CODE")!=null){
//	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
	        jf.addParam("DIV_NAME", param.get("DIV_NAME"));
//        }
//        if (param.get("AC_DATE_FR")!=null)
//	        param.put("AC_DATE_FR", param.get("AC_DATE_FR").toString().substring(0, 4)
//		               +param.get("AC_DATE_FR").toString().substring(5, 7)
//		               +param.get("AC_DATE_FR").toString().substring(8, 10));
//		               
//	        param.put("AC_DATE_TO", param.get("AC_DATE_TO").toString().substring(0, 4)
//		               +param.get("AC_DATE_TO").toString().substring(5, 7)
//		               +param.get("AC_DATE_TO").toString().substring(8, 10));
//		               
//	        param.put("START_DATE", param.get("START_DATE").toString().substring(0, 4)
//		               +param.get("START_DATE").toString().substring(5, 7));
	        
	        String accntDivCode = ObjUtils.getSafeString(param.get("DIV_CODE"));
	        if(accntDivCode != null){
	        	String[] arry = accntDivCode.split(",");
	        	param.put("DIV_CODE" , arry);
	        }
	        
	        jf.addParam("AC_DATE", param.get("AC_DATE_FR").toString().substring(0, 4)
			          +"."+param.get("AC_DATE_FR").toString().substring(4, 6)
			          +"."+param.get("AC_DATE_FR").toString().substring(6, 8)+"~"
			          +param.get("AC_DATE_TO").toString().substring(0, 4)
			          +"."+param.get("AC_DATE_TO").toString().substring(4, 6)
			          +"."+param.get("AC_DATE_TO").toString().substring(6, 8));
	        
	        jf.addParam("GROUP_YN",Boolean.parseBoolean(param.get("GROUP_YN").toString()));
	        jf.addParam("P_COMP_NAME",user.getCompName());
	        
	        //
	        
	        // Primary data source
	        	jflist.addAll(jasperService.selectList("agb100skrServiceImpl.selectList", param));
		        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
  
    	
       
        jf.setList(jflist);

        return ViewHelper.getJasperView(jf);
    }
   /**
    * 현급출납장 출력
    * @param _req
    * @return
    * @throws Exception
    */
  @RequestMapping(value = "/agb/agb110rkrPrint.do", method = RequestMethod.GET)
   public ModelAndView agb110rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
    		  "top_Payment"
      };
      
      // Report와 SQL용 파라미터 구성
       Map param = _req.getParameterMap();
       param.put("S_COMP_CODE", user.getCompCode());
       
       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
       
       JasperFactory jf = jasperService.createJasperFactory("agb110rkr", "agb110rkr",  param);   // "폴더명" , "파일명" , "파라미터
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
       jf.setReportType(reportType);
       // SubReport 파일명 목록을 전달
       // 레포트 수행시 compile을 상황에 따라 수행함.
       jf.setSubReportFiles(subReportFileNames);
       
       // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
       //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
       //
       
       //parameter handle
//       if (param.get("S_DIV_CODE")!=null){
//    	    param.put("DIV_CODE", param.get("S_DIV_CODE"));
//	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
//	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
//       }
       String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
       if(accntDivCode != null){
       	String[] arry = accntDivCode.split(",");
       	param.put("ACCNT_DIV_CODE" , arry);
       }
	        // Primary data source
       if(param.get("AC_DATE_FR")!=null){
    	   jf.addParam("AC_DATE", param.get("AC_DATE_FR").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_FR").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_FR").toString().substring(6, 8)+"~"
		          +param.get("AC_DATE_TO").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_TO").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_TO").toString().substring(6, 8));
       }
       jf.addParam("P_SUB_TITLE","보조장");
	   jflist.addAll(jasperService.selectList("agb110skrServiceImpl.selectListTo110rkrPrint", param));
       jf.setList(jflist);
       param.put("PGM_ID","agb110rkr");
       jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

       return ViewHelper.getJasperView(jf);
   }
  /**
   * 현급출납장 출력
   * @param _req
   * @return
   * @throws Exception
   */
 @RequestMapping(value = "/agb/agb111rkrPrint.do", method = RequestMethod.GET)
  public ModelAndView agb111rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
     String[] subReportFileNames = {
    		 "top_Payment"
     };
     
     // Report와 SQL용 파라미터 구성
      Map param = _req.getParameterMap();
      param.put("S_COMP_CODE", user.getCompCode());
      
      // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
      // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
      
      JasperFactory jf = jasperService.createJasperFactory("agb111rkr", "agb111rkr",  param);   // "폴더명" , "파일명" , "파라미터
      List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
      jf.setReportType(reportType);
      // SubReport 파일명 목록을 전달
      // 레포트 수행시 compile을 상황에 따라 수행함.
      jf.setSubReportFiles(subReportFileNames);
      
      // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
      //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
      //
      
      //parameter handle
      if (param.get("S_DIV_CODE")!=null){
   	    param.put("DIV_CODE", param.get("S_DIV_CODE"));
	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
      }
	        // Primary data source
      if(param.get("AC_DATE_FR")!=null){
   	   jf.addParam("AC_DATE", param.get("AC_DATE_FR").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_FR").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_FR").toString().substring(6, 8)+"~"
		          +param.get("AC_DATE_TO").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_TO").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_TO").toString().substring(6, 8));
      }
      
      jf.addParam("P_SUB_TITLE","[보조원장]");
	  jflist.addAll(jasperService.selectList("agb111rkrServiceImpl.selectListTo111rkrPrint", param));
	  param.put("PGM_ID","agb111rkr");
      jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
      jf.setList(jflist);

      return ViewHelper.getJasperView(jf);
  }
 
 @RequestMapping(value = "/agb/agb120rkr.do", method = RequestMethod.GET)
 public ModelAndView agb120rkr(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
    String[] subReportFileNames = {
    		"top_Payment"
    };
    // Report와 SQL용 파라미터 구성
    Map param = _req.getParameterMap();
    param.put("S_COMP_CODE", user.getCompCode());
    
    // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
    // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
    
    JasperFactory jf = jasperService.createJasperFactory("agb120rkr", "agb120rkr",  param);   // "폴더명" , "파일명" , "파라미터
    List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
    jf.setReportType(reportType);
    // SubReport 파일명 목록을 전달
    // 레포트 수행시 compile을 상황에 따라 수행함.
    jf.setSubReportFiles(subReportFileNames);
    
    // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
    //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
    //
    //parameter handle
    if (param.get("S_DIV_CODE")!=null){
 	    param.put("DIV_CODE", param.get("S_DIV_CODE"));
	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
    }
	        // Primary data source
    if(param.get("AC_DATE_FR")!=null){
 	   jf.addParam("AC_DATE", param.get("AC_DATE_FR").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_FR").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_FR").toString().substring(6, 8)+"~"
		          +param.get("AC_DATE_TO").toString().substring(0, 4)
		          +"."+param.get("AC_DATE_TO").toString().substring(4, 6)
		          +"."+param.get("AC_DATE_TO").toString().substring(6, 8));
    }
    
    List<Map<String, Object>> result = jasperService.selectList("agb120skrServiceImpl.selectList", param);
    jf.setList(result);
    jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
    
    return ViewHelper.getJasperView(jf);
 }
 @RequestMapping(value = "/agb/agb101rkr.do", method = RequestMethod.GET)
 public ModelAndView agb101rkr(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
    String[] subReportFileNames = {
            "top_Payment"
    };
    // Report와 SQL용 파라미터 구성
    Map param = _req.getParameterMap();
    param.put("S_COMP_CODE", user.getCompCode());
    
    // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
    // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용           
    
    JasperFactory jf = jasperService.createJasperFactory("agb120rkr", "agb120rkr",  param);   // "폴더명" , "파일명" , "파라미터
    List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
    jf.setReportType(reportType);
    // SubReport 파일명 목록을 전달
    // 레포트 수행시 compile을 상황에 따라 수행함.
    jf.setSubReportFiles(subReportFileNames);
    
    // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
    //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
    //
    //parameter handle
    if (param.get("S_DIV_CODE")!=null){
        param.put("DIV_CODE", param.get("S_DIV_CODE"));
            Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
            jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
    }
            // Primary data source
    if(param.get("AC_DATE_FR")!=null){
       jf.addParam("AC_DATE", param.get("AC_DATE_FR").toString().substring(0, 4)
                  +"."+param.get("AC_DATE_FR").toString().substring(4, 6)
                  +"."+param.get("AC_DATE_FR").toString().substring(6, 8)+"~"
                  +param.get("AC_DATE_TO").toString().substring(0, 4)
                  +"."+param.get("AC_DATE_TO").toString().substring(4, 6)
                  +"."+param.get("AC_DATE_TO").toString().substring(6, 8));
    }
    
    String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
    if(ObjUtils.isNotEmpty(accntDivCode)){
        String[] arry = accntDivCode.split(",");
        param.put("ACCNT_DIV_CODE" , arry);
    }
    
    List<Map<String, Object>> result = jasperService.selectList("agb101skrServiceImpl.selectList", param);
    jf.setList(result);
    jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
    jf.addParam("PT_TITLENAME","총  계  정  원  장");
    
    
    return ViewHelper.getJasperView(jf);
 }
 
    /**
     * 현급출납장 출력
     * @param _req
     * @return
     * @throws Exception
     */
   @RequestMapping(value = "/agb/agb130rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView agb130rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
    		   "top_Payment"
       };
       
       // Report와 SQL용 파라미터 구성
        Map param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());

        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        
        JasperFactory jf = jasperService.createJasperFactory("agb130rkr", "agb130rkr",  param);   // "폴더명" , "파일명" , "파라미터

        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        //jf.setSubReportFiles(subReportFileNames);
        
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
        //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        
        jf.addParam("AC_DATE_FR", param.get("AC_DATE_FR"));
        jf.addParam("AC_DATE_TO", param.get("AC_DATE_TO"));
        jf.addParam("S_COMP_NAME", param.get("S_COMP_NAME"));
        
        String divCode = ObjUtils.getSafeString(param.get("DIV_CODE"));
        if(ObjUtils.isNotEmpty(divCode)){
            String[] arry = divCode.split(",");
            param.put("DIV_CODE" , arry);
        }
        if (param.get("DIV_CODE")!=null){
	        Map divi = (Map) jasperService.getDao().select("agb130skrServiceImpl.selectDivCode", param);
	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
        }
        
        // Primary data source
        jf.setList(jasperService.selectList("agb130skrServiceImpl.selectPrintList", param));
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

        return ViewHelper.getJasperView(jf);
    }
   /**
    * add by zhongshl
    * 현급출납장 출력
    * @param _req
    * @return
    * @throws Exception
    */
  @RequestMapping(value = "/agb/agb140rkrPrint.do", method = RequestMethod.GET)
   public ModelAndView agb140rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
    		  "top_Payment"
      };
      
      // Report와 SQL용 파라미터 구성
       Map param = _req.getParameterMap();
       param.put("S_COMP_CODE", user.getCompCode());

       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용       
       String fileName = "agb140rkr";
       if(param.get("SUM") != null && "2".equals(param.get("SUM"))){
    	   fileName = "agb141rkr";
       }
       JasperFactory jf = jasperService.createJasperFactory("agb140rkr", fileName,  param);   // "폴더명" , "파일명" , "파라미터

       jf.setReportType(reportType);
    
       jf.addParam("FR_DATE", param.get("FR_DATE"));
       jf.addParam("TO_DATE", param.get("TO_DATE"));
       
       if(param.get("FR_DATE")!=null){
      	   jf.addParam("SLIP_DATE", param.get("FR_DATE").toString().substring(0, 4)
     		          +"."+param.get("FR_DATE").toString().substring(4, 6)
     		          +"."+param.get("FR_DATE").toString().substring(6, 8)+"~"
     		          +param.get("TO_DATE").toString().substring(0, 4)
     		          +"."+param.get("TO_DATE").toString().substring(4, 6)
     		          +"."+param.get("TO_DATE").toString().substring(6, 8));
       }
       
       String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
       if(accntDivCode != null){
       	String[] arry = accntDivCode.split(",");
       	param.put("ACCNT_DIV_CODE" , arry);
       }
       
       String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
       if(accntDivName != null){
       	String[] arry1 = accntDivName.split(",");
       	param.put("ACCNT_DIV_NAME" , arry1);
       }
       
      
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
       jflist.addAll(jasperService.selectList("agb140rkrServiceImpl.selectListToPrint", param));
       jf.setList(jflist);
       param.put("PGM_ID","agb140rkr");
       jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

       return ViewHelper.getJasperView(jf);
   }
   /**
    * 미결현황 출력
    * @param _req
    * @return
    * @throws Exception
    */
   @RequestMapping(value = "/accnt/agb160rkrPrint.do", method = RequestMethod.GET)
   public ModelAndView agb160rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
   		  "top_Payment"
   		   
      };
      
      // Report와 SQL용 파라미터 구성
       Map param = _req.getParameterMap();
       
       
       JasperFactory jf = null;
       
       // 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
       
       if(param.get("CHECK").equals("Y")) {
    	   jf  = jasperService.createJasperFactory("agb160rkr", "agb161rkr",  param);  // 폴더명 , 파일명, 파라미터
    	   
       } else if(param.get("CHECK").equals("N")) {
    	   jf  = jasperService.createJasperFactory("agb160rkr", "agb160rkr",  param);
       }
       
       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
       jf.setReportType(reportType);
       // SubReport 파일명 목록을 전달
       // 레포트 수행시 compile을 상황에 따라 수행함.
       jf.setSubReportFiles(subReportFileNames);
       
       
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

//       	Map dataParam = new HashMap();
//       	
//       	dataParam.put("S_COMP_CODE"			, param.get("COMP_CODE"));
//    	dataParam.put("FR_DATE"				, param.get("FR_DATE"));
//    	dataParam.put("TO_DATE"				, param.get("TO_DATE"));
    	String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
        if(accntDivCode != null){
        	String[] arry = accntDivCode.split(",");
        	param.put("ACCNT_DIV_CODE" , arry);
        }
//        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
//        if(accntDivName != null){
//        	String[] arry1 = accntDivName.split(",");
//        	param.put("ACCNT_DIV_NAME" , arry1);
//        }
		    	
       	//logger1.debug("jasper arry : " + arry[i]);
       	jflist.addAll(jasperService.selectList("agb160skrServiceImpl.fnAgb160QRpt", param));
       	param.put("PGM_ID","agb160rkr");
       	jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
        
       	jf.setList(jflist);
       
       return ViewHelper.getJasperView(jf);
   }
   
   
   @RequestMapping(value = "/agb/agb165rkr.do", method = RequestMethod.GET)
   public ModelAndView agb165rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
   		   "top_Payment"
      };
      // Report와 SQL용 파라미터 구성
       Map<String,Object> param = _req.getParameterMap();
       
       JasperFactory jf = null;
       
       // 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
       
       if(param.get("CHECK").equals("Y")) {
    	   jf  = jasperService.createJasperFactory("agb165rkr", "agb166rkr",  param);  // 폴더명 , 파일명, 파라미터
    	   param.put("PRINT_PAGE", 1);
       } else if(param.get("CHECK").equals("N")) {
    	   jf  = jasperService.createJasperFactory("agb165rkr", "agb165rkr",  param);
       }
       
       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
       jf.setReportType(reportType);
       // SubReport 파일명 목록을 전달
       // 레포트 수행시 compile을 상황에 따라 수행함.
       jf.setSubReportFiles(subReportFileNames);
       
       
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

       	Map dataParam = new HashMap();
       	
       	dataParam.put("S_COMP_CODE"			, param.get("COMP_CODE"));
    	dataParam.put("FR_DATE"				, param.get("FR_DATE"));
    	dataParam.put("TO_DATE"				, param.get("TO_DATE"));
    	String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
        if(accntDivCode != null){
        	String[] arry = accntDivCode.split(",");
        	param.put("ACCNT_DIV_CODE" , arry);
        }
        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
        if(accntDivName != null){
        	String[] arry1 = accntDivName.split(",");
        	param.put("ACCNT_DIV_NAME" , arry1);
        }
        for (Map.Entry<String, Object> entry : param.entrySet()) {  
        	dataParam.put(entry.getKey(), entry.getValue());
          
        }  
    	jf.addParam("DIV_NAME", accntDivName);
		    	
       	//logger1.debug("jasper arry : " + arry[i]);
       	
       	jflist.addAll(jasperService.selectList("agb165rkrServiceImpl.selectPrintList", dataParam));
       	jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
       
       	jf.setList(jflist);
       
       return ViewHelper.getJasperView(jf);
   }
   
   @RequestMapping(value = "/agb/agb170rkr.do", method = RequestMethod.GET)
	public ModelAndView agb170rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = {
		 "top_Payment"
		};
		// Report와 SQL용 파라미터 구성
		Map<String, Object> param = _req.getParameterMap();
		param.put("FR_DATE", param.get("FR_MONTH"));
		param.put("TO_DATE", param.get("TO_MONTH"));
		String[] arr = param.get("ACCNT_DIV_CODE").toString().split(",");
		param.put("ACCNT_DIV_CODE", arr);
		
		
		JasperFactory jf = null;

		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌

		jf = jasperService.createJasperFactory("agb170rkr", param); // 폴더명 ,
																	// 파일명, 파라미터

		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);
		jf.setList(jasperService.selectList("agb170skrServiceImpl.selectList",
				param));
		param.put("PGM_ID", "agb170rkr");
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		
		//add by chenaibo 20161129
		jf.addParam("DIV_NAME", param.get("ACCNT_DIV_NAME"));

		
		jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
		
		
		return ViewHelper.getJasperView(jf);
	}
   
   
   /**
    * 관리항목별 집계표 출력
    * @param _req
    * @return
    * @throws Exception
    */
      @RequestMapping(value = "/accnt/agb180rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView agb180rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
       		  // "top_Payment"
       		   
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           
           
           JasperFactory jf = null;
           
           // 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
           
           if(param.get("OUTPUT_TYPE").equals("N") && param.get("CHECK").equals("B")){
        	   jf  = jasperService.createJasperFactory("agb180rkr", "agb180rkr",  param);  // 폴더명 , 파일명, 파라미터
        	   
           }else if(param.get("OUTPUT_TYPE").equals("N") && param.get("CHECK").equals("A")){
        	   jf  = jasperService.createJasperFactory("agb180rkr", "agb180rkr_check",  param);
           }
           else if(param.get("OUTPUT_TYPE").equals("Y") && param.get("CHECK").equals("B")){
        	   jf  = jasperService.createJasperFactory("agb180rkr", "agb181rkr",  param);
           }
           else if(param.get("OUTPUT_TYPE").equals("Y") && param.get("CHECK").equals("A")){
        	   jf  = jasperService.createJasperFactory("agb180rkr", "agb181rkr_check",  param);
           }
           
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           
           
           List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

	       	Map dataParam = new HashMap();
	       	
	    	dataParam.put("FR_DATE"			, param.get("FR_DATE"));
	    	dataParam.put("TO_DATE"			, param.get("TO_DATE"));
	    	
	    	
	    	String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
	        if(accntDivCode != null){
	        	String[] arry = accntDivCode.split(",");
	        	param.put("ACCNT_DIV_CODE" , arry);
	        }
	        
	        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
	        if(accntDivName != null){
	        	String[] arry1 = accntDivName.split(",");
	        	param.put("ACCNT_DIV_NAME" , arry1);
	        }
	        
	    	dataParam.put("ACCNT_CODE_FR"	, param.get("ACCNT_CODE_FR"));
	    	dataParam.put("ACCNT_NAME_FR"	, param.get("ACCNT_NAME_FR"));
	    	dataParam.put("ACCNT_CODE_TO"	, param.get("ACCNT_CODE_TO"));
	    	dataParam.put("ACCNT_NAME_TO"	, param.get("ACCNT_NAME_TO"));
	    	
	    	dataParam.put("DIV_LABEL"		, param.get("DIV_LABEL"));
	    	
	    	dataParam.put("MANAGE_CODE"		, param.get("MANAGE_CODE"));
	    	dataParam.put("DYNAMIC_CODE_FR"	, param.get("DYNAMIC_CODE_FR"));
	    	dataParam.put("DYNAMIC_CODE_TO"	, param.get("DYNAMIC_CODE_TO"));
	    	dataParam.put("ACCOUNT_NAME"	, param.get("ACCOUNT_NAME"));
	    	dataParam.put("START_DATE"		, param.get("START_DATE"));
	    	dataParam.put("SUM"				, param.get("SUM"));
	    	//dataParam.put("JAN"				, param.get("JAN"));
	    	//dataParam.put("ACCOUNT_LEVEL"	, param.get("ACCOUNT_LEVEL"));
	    	dataParam.put("COMP_NUM_YN"		, param.get("COMP_NUM_YN"));
	    	
	    	dataParam.put("S_COMP_CODE"	, param.get("COMP_CODE"));
	    	
	    	dataParam.put("S_PEND_CODE"	, param.get("S_PEND_CODE"));
	    	dataParam.put("S_PEND_NAME"	, param.get("S_PEND_NAME"));
	    	
	    	dataParam.put("CHECK"		, param.get("CHECK"));
	    	
			    	
	       	//logger1.debug("jasper arry : " + arry[i]);
	       	
	       	jflist.addAll(jasperService.selectList("agb180skrService.selectList", dataParam));
	       	jf.addSubDS("DS_SUB01", jasperService.selectList("agb180skrService.fnAgb180Init", param));	
	       
	       	jf.setList(jflist);
           
           return ViewHelper.getJasperView(jf);
       }
    
    /**
     * add by ChenRd
     * 거래처별 집계표
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/accnt/agb200rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView agb200rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
        		   "top_Payment"
        		   
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            
            
            JasperFactory jf = null;
            
            // 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
            
            if(param.get("OUTPUT_TYPE").equals("N")){
            	jf  = jasperService.createJasperFactory("agb200rkr", "agb200rkr",  param);  // 폴더명 , 파일명, 파라미터
            }else if(param.get("OUTPUT_TYPE").equals("Y")){
            	jf  = jasperService.createJasperFactory("agb200rkr", "agb201rkr",  param);
            }
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

        	Map dataParam = new HashMap();
        	
		    	dataParam.put("FR_DATE"			, param.get("FR_DATE"));
		    	dataParam.put("TO_DATE"			, param.get("TO_DATE"));
		    	
		    	
		    	String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
		        if(accntDivCode != null){
		        	String[] arry = accntDivCode.split(",");
		        	param.put("ACCNT_DIV_CODE" , arry);
		        	dataParam.put("ACCNT_DIV_CODE" , arry);
		        }
		        
		        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
		        if(accntDivName != null){
		        	String[] arry1 = accntDivName.split(",");
		        	param.put("ACCNT_DIV_NAME" , arry1);
		        	dataParam.put("ACCNT_DIV_NAME" , arry1);
		        }
		        
		    	dataParam.put("ACCNT_CODE_FR"	, param.get("ACCNT_CODE_FR"));
		    	dataParam.put("ACCNT_NAME_FR"	, param.get("ACCNT_NAME_FR"));
		    	dataParam.put("ACCNT_CODE_TO"	, param.get("ACCNT_CODE_TO"));
		    	dataParam.put("ACCNT_NAME_TO"	, param.get("ACCNT_NAME_TO"));
		    	
		    	dataParam.put("DIV_LABEL"		, param.get("DIV_LABEL"));
		    	
		    	dataParam.put("CUST_CODE_FR"	, param.get("CUST_CODE_FR"));
		    	dataParam.put("CUST_NAME_FR"	, param.get("CUST_NAME_FR"));
		    	dataParam.put("CUST_CODE_TO"	, param.get("CUST_CODE_TO"));
		    	dataParam.put("CUST_NAME_TO"	, param.get("CUST_NAME_TO"));
		    	dataParam.put("ACCOUNT_NAME"	, param.get("ACCOUNT_NAME"));
		    	dataParam.put("START_DATE"		, param.get("START_DATE"));
		    	dataParam.put("SUM"				, param.get("SUM"));
		    	dataParam.put("JAN"				, param.get("JAN"));
		    	dataParam.put("ACCOUNT_LEVEL"	, param.get("ACCOUNT_LEVEL"));
		    	dataParam.put("COMP_NUM_YN"		, param.get("COMP_NUM_YN"));
		    	
		    	dataParam.put("S_COMP_CODE"	, param.get("COMP_CODE"));
		    	
        	//logger1.debug("jasper arry : " + arry[i]);
        	
        	jflist.addAll(jasperService.selectList("agb200skrServiceImpl.selectDetailList", dataParam));
        	jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
        
        	jf.setList(jflist);
            
            return ViewHelper.getJasperView(jf);
        }
       
       
       /**
        * 거래처별원장출력
        * @param _req
        * @return
        * @throws Exception
        */
      @RequestMapping(value = "/accnt/agb210rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView agb210rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
        		 "top_payment"
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());

           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           
           JasperFactory jf = null;
           
           // 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
           
           if(param.get("OUTPUT_TYPE").equals("HORIZON")){  // 세로모드
           	jf  = jasperService.createJasperFactory("agb210rkr", "agb210rkr",  param);  // 폴더명 , 파일명, 파라미터
           }else if(param.get("OUTPUT_TYPE").equals("VERTICAL")){ // 가로모드
           	jf  = jasperService.createJasperFactory("agb210rkr", "agb211rkr",  param);
           } 

           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           
           // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
           //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
           
           // Primary data source
           
           Map dataParam = new HashMap();
           
           String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
	        if(accntDivCode != null){
	        	String[] arry = accntDivCode.split(",");
	        	param.put("ACCNT_DIV_CODE" , arry);
	        }
	        
	        String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
	        if(accntDivName != null){
	        	String[] arry1 = accntDivName.split(",");
	        	param.put("ACCNT_DIV_NAME" , arry1);
	        }
           
	       
           jf.setList(jasperService.selectList("agb210skrServiceImpl.selectList", param));
           param.put("PGM_ID","agb210rkr");
           jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

           return ViewHelper.getJasperView(jf);
       }
      
      
      @RequestMapping(value = "/accnt/agb270skrPrint.do", method = RequestMethod.GET)
      public ModelAndView agb270skrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
         String[] subReportFileNames = {};
         
         // Report와 SQL용 파라미터 구성
          Map param = _req.getParameterMap();
          param.put("S_COMP_CODE", user.getCompCode());

          // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
          // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
          
          JasperFactory jf = jasperService.createJasperFactory("agb270skr", "agb270skr",  param);
          
          jf.setReportType(reportType);
          Map dataParam = new HashMap();
          Object custom = param.get("CUSTOM_NAME");
          if(custom!=null)
        	  dataParam.put("CUSTOM_NAME", param.get("CUSTOM_NAME"));
          else {
			dataParam.put("CUSTOM_NAME", "");
          }
          
	      List<Map<String,Object>> list = new ArrayList<>();
	      list.add(dataParam);
	      jf.addParam("S_COMP_CODE", user.getCompCode());
          jf.setList(list);

          return ViewHelper.getJasperView(jf);
      }
      
}
