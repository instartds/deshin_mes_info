package foren.unilite.modules.sales.spp;

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

@Controller
public class SppCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Sales";

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


//견적서 출력
  @RequestMapping(value = "/sales/spp100cukrv.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView spp100cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("spp100ukrvServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/spp100ukrv", "spp100ukrv", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : spp100ukrvServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("spp100ukrv");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  
}
