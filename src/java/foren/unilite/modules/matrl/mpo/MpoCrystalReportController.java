package foren.unilite.modules.matrl.mpo;

import java.sql.ResultSet;
import java.util.ArrayList;
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
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class MpoCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Matrl";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

  /**
   * 발주서 등록 - 발주서 출력(개별)
   * */
  @RequestMapping(value = "/matrl/mpo501cukrv.do", method = RequestMethod.GET)
   public ModelAndView mpo501cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	  String sql="";
	  
	  try{
		  sql = dao.mappedSqlString("mpo501ukrvServiceImpl.printList", param);
		  List subReports = new ArrayList();
		  clientDoc = cDoc.generateReport(RPT_PATH+"/mpo501ukrv", "mpo501ukrv", param,  sql ,null, request);
	  }catch (Throwable e2)	{
          e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("mpo501cukrv");
	  clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
  
  /**
   * 발주서 출력(기간별)
   * */
  @RequestMapping(value = "/matrl/mpo150crkrv.do", method = RequestMethod.GET)
   public ModelAndView mpo150crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      Map param = _req.getParameterMap();
      ReportUtils.setCreportPram(user, param, dao);
      ReportUtils.setCreportSanctionParam(param, dao);
     
      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";
      
      try{
          sql = dao.mappedSqlString("mpo150rkrvServiceImpl.printList", param);
          List subReports = new ArrayList();
          /**
           * 결재란관련     san_top_sub.rpt
           */
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "san_top_sub.rpt");
          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
          subReports.add(subMap);
          clientDoc = cDoc.generateReport(RPT_PATH+"/mpo150rkrv", "mpo150rkrv", param,  sql ,subReports, request);
      }catch (Throwable e2) {
          e2.getStackTrace();
      }
      clientDoc.setPrintFileName("mpo150crkrv");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
   

}
