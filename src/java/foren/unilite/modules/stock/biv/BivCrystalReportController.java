package foren.unilite.modules.stock.biv;

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
public class BivCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Stock";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @RequestMapping(value = "/stock/biv120crkrv.do", method = RequestMethod.GET)
  public ModelAndView biv120crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      
      Map param = _req.getParameterMap();

      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql = "";
      
      try{
          sql = dao.mappedSqlString("biv120rkrvServiceImpl.selectList", param);

          if(param.get("gsSumTypeCell").equals("Y")) {
              clientDoc = cDoc.generateReport(RPT_PATH + "/biv120rkrv3", "biv120rkrv", param,  sql ,null, request);
              clientDoc.setPrintFileName("biv120rkrv3");
          } else if(param.get("gsSumTypeLot").equals("Y") || param.get("gsSumTypeCell").equals("N")) {
              clientDoc = cDoc.generateReport(RPT_PATH + "/biv120rkrv2", "biv120rkrv", param,  sql ,null, request);
              clientDoc.setPrintFileName("biv120rkrv2");
          }
          else {
              clientDoc = cDoc.generateReport(RPT_PATH + "/biv120rkrv1", "biv120rkrv", param,  sql ,null, request);
              clientDoc.setPrintFileName("biv120rkrv1");
          }
      }catch (Throwable e2) {
            logger.debug("   >>>>>>>  queryId : biv120rkrvServiceImpl.selectList " + sql);
            e2.getStackTrace();
      }
      
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
}
