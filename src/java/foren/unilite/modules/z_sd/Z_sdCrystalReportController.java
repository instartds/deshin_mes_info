package foren.unilite.modules.z_sd;

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
public class Z_sdCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Z_sd";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

  //지급대장
  @RequestMapping(value = "/z_sd/s_hpa901crkr_sd.do", method = RequestMethod.GET)
  public ModelAndView hpa901crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

	  String sql="";

		 
	  try{
		  
		//정기급여 지급대장 부서별
		  if(param.get("SUPP_TYPE").equals("1")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList1", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr1_sd", "s_hpa901kr1_sd", param,  sql ,subReports, request);
	         //직원 기타복리후생비
		  } else if (param.get("SUPP_TYPE").equals("2")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList1", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr2_sd", "s_hpa901kr2_sd", param,  sql ,subReports, request);
	        //평가급 지급대장
		  } else if (param.get("SUPP_TYPE").equals("3")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList1", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr3_sd", "s_hpa901kr3_sd", param,  sql ,subReports, request);
	        
	        //급여인상소급
		  } else if (param.get("SUPP_TYPE").equals("5")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList2", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr5_sd", "s_hpa901kr5_sd", param,  sql ,subReports, request);
	        
	        //인센티브 평가급
		  } else if (param.get("SUPP_TYPE").equals("6")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList2", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr3_sd", "s_hpa901kr3_sd", param,  sql ,subReports, request);
	       
	        //재정인센티브 평가급
		  } else if (param.get("SUPP_TYPE").equals("8")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList2", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr3_sd", "s_hpa901kr3_sd", param,  sql ,subReports, request);
	        
	        //자체 평가급
		  } else if (param.get("SUPP_TYPE").equals("9")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList2", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr3_sd", "s_hpa901kr3_sd", param,  sql ,subReports, request);
	       
	        //정기급여 지급대장 부서별(직급보조비, 급식비, 효도휴가비 제외)
		  } else if (param.get("SUPP_TYPE").equals("4")){
			  sql = dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.selectList4", param);
			  
			  List subReports = new ArrayList();
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "hpa901az_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("s_hpa901rkr_sdServiceImpl.getSubList", param));
	          subReports.add(subMap);
	          
	          clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa901kr4_sd", "s_hpa901kr4_sd", param,  sql ,subReports, request);
		  }

	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : s_hpa901rkr_sdServiceImpl.selectList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("s_hpa901kr1_sd");
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
   
  
    
//재직퇴직증명서 출력
@RequestMapping(value = "/z_sd/s_hum970crkr_sd.do", method = RequestMethod.GET)
public ModelAndView hum970crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	  //rsMap.put("command", rs);
	  String sql="";
	  
	  //List rsList = hum920skrService.select960(param);
		 
	  try{
		  sql = dao.mappedSqlString("s_hum970rkr_sdServiceImpl.PrintList1", param);
		  
		  
		  List subReports = new ArrayList();
		  /*Map<String, String> subMap = new HashMap<String, String>();
		  subMap.put("NAME", "hum960rkr_sub1");
		  subMap.put("SQLID", "ds_sub01");
		  subReports.add(subMap);
		   clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,subReports, request);
		  */
		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr_sd", "s_hum970rkr_sd", param,  sql ,null, request);
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : s_hum970rkr_sdServiceImpl.PrintList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("hum970rkr");
	  clientDoc.setReportType(reportType);
   return ViewHelper.getCrystalReportView(clientDoc);
}    
   
    
 
    
  
}
