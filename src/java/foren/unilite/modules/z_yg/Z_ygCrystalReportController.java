package foren.unilite.modules.z_yg;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crystaldecisions.report.web.viewer.CrPrintMode;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class Z_ygCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Z_yg";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

  //재직퇴직증명서 출력
  @RequestMapping(value = "/z_yg/s_hum970crkr_yg.do", method = RequestMethod.GET)
  public ModelAndView hum970crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

	  String sql="";

		 
	  try{
		  sql = dao.mappedSqlString("s_hum970rkr_ygServiceImpl.PrintList1", param);
		  
		  List subReports = new ArrayList();

		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr_yg", "s_hum970rkr_yg", param,  sql ,null, request);
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : s_hum970rkr_ygServiceImpl.PrintList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("s_hum970rkr_yg");
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
   
  
  //근태현황 리스트 출력
  @RequestMapping(value = "/z_yg/s_hat531crkr_yg.do", method = RequestMethod.GET)
  public ModelAndView hat531crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

	  String sql="";

		 
	  try{
		  sql = dao.mappedSqlString("s_hat531rkr_ygServiceImpl.selectToPrint", param);
		  
		  List subReports = new ArrayList();

		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hat531rkr_yg", "s_hat531rkr_yg", param,  sql ,null, request);
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : s_hat531rkr_ygServiceImpl.selectToPrint " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("s_hat531rkr_yg");
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  
  /**
   * 급여지급조서 출력
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
    @RequestMapping(value = "/z_yg/s_hpa900crkr_yg.do", method = RequestMethod.GET)
    public ModelAndView hpa900crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;

       Map param = _req.getParameterMap();

       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";

       dao.update("s_hpa900rkr_ygServiceImpl.createTable", param);

       Map wagesMap = new HashMap();

	   List<Map> wList1 = (List<Map>) dao.list("s_hpa900rkr_ygServiceImpl.selectWages1", param);

		for(Map wCode : wList1) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("s_hpa900rkr_ygServiceImpl.insertWages1", wCode);

		 }

		List<Map> wList2 = (List<Map>) dao.list("s_hpa900rkr_ygServiceImpl.selectWages2", param);

		for(Map wCode : wList2) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("s_hpa900rkr_ygServiceImpl.insertWages2", wCode);

		 }

		List<Map> wList3 = (List<Map>) dao.list("s_hpa900rkr_ygServiceImpl.selectWages3", param);

		for(Map wCode : wList3) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
			wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
			wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

      		dao.insert("s_hpa900rkr_ygServiceImpl.insertWages3", wCode);

		 }

       try{
    	   sql = dao.mappedSqlString("s_hpa900rkr_ygServiceImpl.selectListPrint5", param);

    	   if(param.get("DOC_KIND").equals("5")){

    		   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa910kr_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_ygServiceImpl.selectSubListPrint5", param));
               subReports.add(subMap);

               clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa910rkr_yg", "s_hpa910rkr_yg", param,  sql ,subReports, request);

           }


       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : s_hpa900rkr_ygServiceImpl.selectListPrint5 " + sql);
             e2.getStackTrace();
       }
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
    
   //지출집계표				
    @RequestMapping(value = "/z_yg/s_agj231crkr_yg.do", method = RequestMethod.GET)
    public ModelAndView agj231crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
  	  CrystalReportDoc cDoc = new CrystalReportDoc();
  	  CrystalReportFactory clientDoc = null;
  	  
  	  Map param = _req.getParameterMap();
  	 
  	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

  	  String sql="";

  		 
  	  try{
  		
  		  sql = dao.mappedSqlString("s_agj231rkr_ygServiceImpl.PrintList2", param);
  		  
  		  List subReports = new ArrayList();

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj231rkr_yg", "s_agj231rkr_yg", param,  sql ,null, request);
  	  }catch (Throwable e2)	{
  			logger.debug("   >>>>>>>  queryId : s_agj231rkr_ygServiceImpl.PrintList2 " + sql);
  			e2.getStackTrace();
  	  }
  	  clientDoc.setPrintFileName("s_agj231rkr_yg");
  	  clientDoc.setReportType(reportType);
       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
    //전표출력
    @RequestMapping(value = "/z_yg/s_agj270crkr_yg.do", method = RequestMethod.GET)
    public ModelAndView agj270crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
  	  CrystalReportDoc cDoc = new CrystalReportDoc();
  	  CrystalReportFactory clientDoc = null;
  	  
  	  Map param = _req.getParameterMap();
  	 
  	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

  	  String sql="";
  	  String acDate  = "";
    
      if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
    	acDate = ObjUtils.getSafeString(param.get("AC_DATE"));      	
      }
    
  	  String[] arry  = acDate.split(",");
 	  //param.put("AC_DATE"  , arry);
  	  String acData1 = "";
  	  for(String dData : arry)	{
  		  acData1 = acData1+"'"+dData+"',";
  	  }
  	  if(!"".equals(acData1))	{
  		  acData1 = acData1.substring(0, acData1.length()-1);
  		  param.put("AC_DATE"  , acData1);
  	  }
  	
  	  try{
  		
  		  sql = dao.mappedSqlString("s_agj270skr_ygServiceImpl.selectPrimaryDataList", param);
  		  
  		  List subReports = new ArrayList();
  		  
  		if(param.get("PRINT_TYPE").equals("P1")){
  			
  		  /**
           * 결재란관련     san_top_sub.rpt
           */
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "san_top_sub.rpt");
          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
          subReports.add(subMap);

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_P1_yg", "s_agj270kr_P1_yg", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P2")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_P2_yg", "s_agj270kr_P2_yg", param,  sql ,null, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P3")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_P3_yg", "s_agj270kr_P3_yg", param,  sql ,null, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P4")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_P4_yg", "s_agj270kr_P4_yg", param,  sql ,null, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("L1")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_L1_yg", "s_agj270kr_L1_yg", param,  sql ,null, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("L2")){

  	  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj270kr_L2_yg", "s_agj270kr_L2_yg", param,  sql ,null, request);
  		  }
  		
  	  } catch (Throwable e2)	{
  			logger.debug("   >>>>>>>  queryId : s_agj270skr_ygServiceImpl.selectPrimaryDataList " + sql);
  			e2.getStackTrace();
  	  }
  	  clientDoc.setPrintFileName("s_agj270kr_L1_yg");
  	  clientDoc.setReportType(reportType);
       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
    //분개장				
    @RequestMapping(value = "/z_yg/s_agj271crkr_yg.do", method = RequestMethod.GET)
    public ModelAndView agj271crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
  	  CrystalReportDoc cDoc = new CrystalReportDoc();
  	  CrystalReportFactory clientDoc = null;
  	  
  	  Map param = _req.getParameterMap();
  	 
  	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

  	  String sql="";

  		 
  	  try{
  		
  		  sql = dao.mappedSqlString("s_agj270skr_ygServiceImpl.selectPrimaryDataList2", param);
  		  
  		  List subReports = new ArrayList();

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_agj271kr_yg", "s_agj271kr_yg", param,  sql ,null, request);
  	  }catch (Throwable e2)	{
  			logger.debug("   >>>>>>>  queryId : s_agj270skr_ygServiceImpl.selectPrimaryDataList2 " + sql);
  			e2.getStackTrace();
  	  }
  	  clientDoc.setPrintFileName("s_agj271kr_yg");
  	  clientDoc.setReportType(reportType);
       return ViewHelper.getCrystalReportView(clientDoc);
    } 
    
    
    //입고현황 출력
    @RequestMapping(value = "/z_yg/s_mtr130crkrv_yg.do", method = RequestMethod.GET)
	 public ModelAndView mtr130crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param, dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
	      String str = (String) param.get("FR_DATE");
	      String str1 = (String)param.get("TO_DATE");
	      if(str.length()>=8 && str1.length()>=8){
	    	  String st = str.substring(0, 4)+"-"+ str.substring(4, 6)+"-"+str.substring(6, 8);
	    	  String st1 = str1.substring(0, 4)+"-"+ str1.substring(4, 6)+"-"+str1.substring(6, 8);
	    	  param.put("txtFrDate", st);
		      param.put("txtToDate", st1);
	      }
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("s_mtr130rkrv_ygServiceImpl.printList", param);
	          List subReports = new ArrayList();
	          /**
	           * 결재란관련     san_top_sub.rpt
	           */
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "san_top_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	          subReports.add(subMap);
	          clientDoc = cDoc.generateReport(RPT_PATH+"/"+ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param,  sql,subReports, request);
	      }catch (Throwable e2) {
	          e2.getStackTrace();
	      }
	      clientDoc.setPrintFileName("s_mtr130crkrv_yg");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
    
    
    /**
     * 외상매입금 내역출력
     * @param _req
     * @param user
     * @param reportType
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/z_yg/s_map130crkrv_yg.do", method = RequestMethod.GET)
	public ModelAndView map130crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			sql = dao.mappedSqlString("s_map130rkrv_ygServiceImpl.printList", param);
			List subReports = new ArrayList();
			/**
	         * 결재란관련     san_top_sub.rpt
	         */
	        Map<String, String> subMap = new HashMap<String, String>();
	        subMap.put("NAME", "san_top_sub.rpt");
	        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	        subReports.add(subMap);
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,subReports, request);

		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_map130crkrv_yg");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
    
  
}
