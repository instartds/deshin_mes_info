package foren.unilite.modules.accnt.agb;

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
public class AgbCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Accnt";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   
        
  /**
   * 보조부 출력
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
    @RequestMapping(value = "/accnt/agb110crkr.do",  method = { RequestMethod.GET, RequestMethod.POST })
    public ModelAndView agb110crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;
              
       Map param = _req.getParameterMap();
       
       ReportUtils.setCreportPram(user, param,dao);
	   ReportUtils.setCreportSanctionParam(param, dao);
       
       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";
       String accntDivCode  = "";

       if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))){
     	  accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));      	
       }
     
   	  String[] arry  = accntDivCode.split(",");
  	  param.put("ACCNT_DIV_CODE"  , arry);

       try{
    	   
           //세로양식
    	   if(param.get("RPT_SIZE").equals("2")){
    		   sql = dao.mappedSqlString("agb110skrServiceImpl.selectListTo110rkrPrint", param);
    		   
    		   List subReports = new ArrayList();
    		   
    		  /**
              * 결재란관련     san_top_sub.rpt
              */
	      	   Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "san_top_sub.rpt");
	           subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	           subReports.add(subMap);

    		   clientDoc = cDoc.generateReport(RPT_PATH+"/agb110kr_p1", "agb110kr_p1", param,  sql ,subReports, request);
    	   }
    	   
    	   //가로양식
    	   if(param.get("RPT_SIZE").equals("1")){
    		   sql = dao.mappedSqlString("agb110skrServiceImpl.selectListTo110rkrPrint", param);   
    		   
    		   List subReports = new ArrayList();
    		   
    		   Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "san_top_sub.rpt");
	           subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	           subReports.add(subMap);

  		       clientDoc = cDoc.generateReport(RPT_PATH+"/agb110kr_p2", "agb110kr_p2", param,  sql ,subReports, request);
  		   
    	   }
    	 

       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : agb110skrServiceImpl.selectListTo110rkrPrint" + sql);
             e2.getStackTrace();
       }
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
  
}
