package foren.unilite.modules.sales.sof;

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
public class SofCrystalReportController extends UniliteCommonController{
	@InjectLogger
	 public static   Logger  logger  ;
	 final static String            RPT_PATH           = "/WEB-INF/Reports2011/Sales";
	 @Resource(name = "tlabAbstractDAO") 
	 protected TlabAbstractDAO dao;
	 /**
	  * sof100rkrv
	  * @param _req
	  * @param user
	  * @param reportType
	  * @param request
	  * @param response
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value = "/sales/sof100crkrv.do", method = RequestMethod.GET)
	 public ModelAndView sof100crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param, dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
	       String aa= (String) param.get("FR_DATE");
	       String bb= (String) param.get("TO_DATE");
	      if(aa==null || bb==null){
	    	  param.put("FrToDate", "");
	      }else{
	    	  String farDate = param.get("FR_DATE").toString();
	    	  String toDate = param.get("TO_DATE").toString();
	    	  String cc = farDate.substring(0, 4) +"."+ farDate.substring(4, 6)+"."+ farDate.substring(6, 8);
	    	  String dd = toDate.substring(0, 4) +"." + toDate.substring(4, 6)+"." + toDate.substring(6, 8);
	    	  String farToD = cc + "~" + dd;
	    	  param.put("FrToDate", farToD);
	      }
	      param.put("TradeYN", param.get("OPT_SELECT"));
	      param.put("TradeYN_Name", param.get("TradeYN_Name"));
	      param.put("SalePrsn", param.get("ORDER_NAME"));
	      param.put("DivCode", param.get("DIV_NAME"));
	      param.put("CustomName", param.get("CUSTOM_NAME"));
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("sof100rkrvServiceImpl.printList", param);
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
	      clientDoc.setPrintFileName("sof100crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }  
	 /**
	  * sof200rkrv
	  * @param _req
	  * @param user
	  * @param reportType
	  * @param request
	  * @param response
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value = "/sales/sof200crkrv.do", method = RequestMethod.GET)
	 public ModelAndView sof200crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param, dao);
          ReportUtils.setCreportSanctionParam(param, dao);
	      String aa= (String) param.get("FR_DATE");
	       String bb= (String) param.get("TO_DATE");
	      if(aa==null || bb==null){
	    	  param.put("FrToDate", "");
	      }else{
	    	  String farDate = param.get("FR_DATE").toString();
	    	  String toDate = param.get("TO_DATE").toString();
	    	  String cc = farDate.substring(0, 4) +"."+ farDate.substring(4, 6)+"."+ farDate.substring(6, 8);
	    	  String dd = toDate.substring(0, 4) +"." + toDate.substring(4, 6)+"." + toDate.substring(6, 8);
	    	  String farToD = cc + "~" + dd;
	    	  param.put("FrToDate", farToD);
	      }
    	  param.put("TradeYN", param.get("tradeYN"));
    	  param.put("TradeYN_Name", param.get("tradeYNAME"));
	      param.put("SalePrsn", param.get("ORDER_NAME"));
	      param.put("CustomName", param.get("CUSTOM_NAME"));
	      param.put("DivCode", param.get("DIV_NAME"));
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("sof200rkrvServiceImpl.printList", param);
	          List subReports = new ArrayList();
              /**
             * 결재란관련     san_top_sub.rpt
             */
            Map<String, String> subMap = new HashMap<String, String>();
            subMap.put("NAME", "san_top_sub.rpt");
            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
            subReports.add(subMap);
	          clientDoc = cDoc.generateReport(RPT_PATH+"/sof200rkrv", "sof200rkrv", param,  sql,subReports, request);
	      }catch (Throwable e2) {
	          e2.getStackTrace();
	      }
	      clientDoc.setPrintFileName("sof200crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
	 	 
}
