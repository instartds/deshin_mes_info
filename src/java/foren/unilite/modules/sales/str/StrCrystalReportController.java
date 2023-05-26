package foren.unilite.modules.sales.str;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
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
@SuppressWarnings("rawtypes")
public class StrCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Sales";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
  
  
  @RequestMapping(value = "/sales/str103cukrv.do", method = RequestMethod.GET)
  public ModelAndView str103cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      
      Map param = _req.getParameterMap();
     
      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";
      
      try{
          sql = dao.mappedSqlString("str103ukrvServiceImpl.printList", param);
          
          clientDoc = cDoc.generateReport(RPT_PATH+"/str103ukrv", "str103ukrv", param,  sql ,null, request);
      }catch (Throwable e2) {
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("str103ukrv");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
  
  
  @RequestMapping(value = "/sales/str104cukrv.do", method = RequestMethod.GET)
  public ModelAndView str104cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      
      Map param = _req.getParameterMap();
     
      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";
      
      try{
          sql = dao.mappedSqlString("str104ukrvServiceImpl.printList", param);
          
          clientDoc = cDoc.generateReport(RPT_PATH+"/str104ukrv", "str104ukrv", param,  sql ,null, request);
      }catch (Throwable e2) {
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("str104ukrv");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
  
  
  
  
  @RequestMapping(value = "/sales/str105crkrv.do", method = RequestMethod.GET)
  public ModelAndView str105crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      
      Map param = _req.getParameterMap();

      ReportUtils.setCreportPram(user, param, dao);
      ReportUtils.setCreportSanctionParam(param, dao);
      
      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";
      
      try{
          sql = dao.mappedSqlString("str105ukrvServiceImpl.printList", param);
          List subReports = new ArrayList();
          /**
           * 결재란관련     san_top_sub.rpt
           */
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "san_top_sub.rpt");
          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
          subReports.add(subMap);
          
          clientDoc = cDoc.generateReport(RPT_PATH+"/"+ObjUtils.getSafeString(param.get("RPT_ID1")), ObjUtils.getSafeString(param.get("RPT_ID1")), param,  sql,subReports, request);
      }catch (Throwable e2) {
          e2.getStackTrace();
      }
      clientDoc.setPrintFileName("str105crkrv");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }

}
