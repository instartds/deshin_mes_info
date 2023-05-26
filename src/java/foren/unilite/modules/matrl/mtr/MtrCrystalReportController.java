package foren.unilite.modules.matrl.mtr;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
 


import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
@Controller
public class MtrCrystalReportController extends UniliteCommonController{
	@InjectLogger
	 public static   Logger  logger  ;
	 final static String            RPT_PATH           = "/WEB-INF/Reports2011/Matrl";
	 @Resource(name = "tlabAbstractDAO") 
	 protected TlabAbstractDAO dao;
	 @RequestMapping(value = "/matrl/mtr130crkrv.do", method = RequestMethod.GET)
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
	          sql = dao.mappedSqlString("mtr130rkrvServiceImpl.printList", param);
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
	      clientDoc.setPrintFileName("mtr130crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
	 
	 @RequestMapping(value = "/matrl/mtr202crkrv.do", method = RequestMethod.GET)
	 public ModelAndView mtr202crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param, dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
//	      String str = (String) param.get("FR_DATE");
//	      String str1 = (String)param.get("TO_DATE");
//	      if(str.length()>=8 && str1.length()>=8){
//	    	  String st = str.substring(0, 4)+"-"+ str.substring(4, 6)+"-"+str.substring(6, 8);
//	    	  String st1 = str1.substring(0, 4)+"-"+ str1.substring(4, 6)+"-"+str1.substring(6, 8);
//	    	  param.put("txtFrDate", st);
//		      param.put("txtToDate", st1);
//	      }
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("mtr202ukrvServiceImpl.printList", param);
	          List subReports = new ArrayList();
	          /**
	           * 결재란관련     san_top_sub.rpt
	           */
	          Map<String, String> subMap = new HashMap<String, String>();
	          subMap.put("NAME", "san_top_sub.rpt");
	          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	          subReports.add(subMap);
	          if(param.get("USER_LANG").equals("VI")){

	        	  param.put("sTxtValue2_fileTitle", "Giấy tờ Phiếu xuất kho");
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"mtr202rkrv_vi", "mtr202rkrv_vi", param,  sql,subReports, request);
	          }else{
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+ObjUtils.getSafeString(param.get("RPT_ID1")), ObjUtils.getSafeString(param.get("RPT_ID1")), param,  sql,subReports, request);
	          }
	      }catch (Throwable e2) {
	          e2.getStackTrace();
	      }
	      clientDoc.setPrintFileName("mtr202crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
}
