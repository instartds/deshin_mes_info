package foren.unilite.modules.accnt.agj;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;

import com.crystaldecisions.report.web.viewer.CrPrintMode;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.exception.BaseException;
import foren.framework.exception.http.PageNotFoundException;
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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class AgjCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Accnt";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   
        
    //전표출력
    @RequestMapping(value = "/accnt/agj270crkr.do", method = RequestMethod.GET)
    public ModelAndView agj270crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception, IOException {
  	  CrystalReportDoc cDoc = new CrystalReportDoc();
  	  CrystalReportFactory clientDoc = null;
  	  
  	  Map param = _req.getParameterMap();
   	 
  	  
  	  ReportUtils.setCreportPram(user, param, dao);
  	  ReportUtils.setCreportSanctionParam(param, dao);
	
  	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
  	  List<String> slipnumLite = new ArrayList<String>();
  	  String sql="";
  	  String acDate  = "";
  	  String acDate2  = "";
  	  String slipnum = "";
  	  
  	  if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
    	acDate2 = ObjUtils.getSafeString(param.get("AC_DATE"));      	
      }
      if(ObjUtils.isNotEmpty(param.get("FR_AC_DATE"))){
    	acDate = ObjUtils.getSafeString(param.get("FR_AC_DATE"));      	
      }
      if(ObjUtils.isNotEmpty(param.get("FR_SLIP_NUM"))){
    	slipnum = ObjUtils.getSafeString(param.get("FR_SLIP_NUM"));      	
      }
      
      String[] arry1  = acDate2.split(",");
  	  String[] arry  = acDate.split(",");
  	  String[] arry2 = slipnum.split(",");
  	  for(int i = 0 ; i < arry2.length ; i++){
  		slipnumLite.add(arry2[i]); 
  		
  	  }
  	 param.put("AC_DATE"  , arry1);
 	 param.put("FR_AC_DATE"  , arry[0]);
 	 param.put("FR_SLIP_NUM", slipnumLite);
      //map에 list를 넣는다
  	
  	  try{
  		
  		  sql = dao.mappedSqlString("agj270rkrServiceImpl.selectPrimaryDataList2", param);
  		  
  		  List subReports = new ArrayList();
  		  
  		  /**
           * 결재란관련     san_top_sub.rpt
           */
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "san_top_sub.rpt");
          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
          subReports.add(subMap);
  		  
  		if(param.get("PRINT_TYPE").equals("P1")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_P1", "agj270kr_P1", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P2")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_P2", "agj270kr_P2", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P3")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_P3", "agj270kr_P3", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("P4")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_P4", "agj270kr_P4", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("L1")){

  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_L1", "agj270kr_L1", param,  sql ,subReports, request);
  		  
  		  } else if (param.get("PRINT_TYPE").equals("L2")){

  	  		  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_L2", "agj270kr_L2", param,  sql ,subReports, request);
  		  } else {
  			  clientDoc = cDoc.generateReport(RPT_PATH+"/agj270kr_P1", "agj270kr_P1", param,  sql ,subReports, request);
  		  }
  		
  	  } catch (Throwable e2)	{
  			logger.debug("   >>>>>>>  queryId : agj270rkrServiceImpl.selectPrimaryDataList2 " + sql);
  			e2.getStackTrace();
  	  }
  	  if(clientDoc == null)	{
  		  logger.error("보고서 양식이 없습니다.");
  		  response.sendRedirect(request.getContextPath() + "/error/code404.jsp");
  		  return null;
  	  }
  	  clientDoc.setPrintFileName("agj270kr_L1");
  	  clientDoc.setReportType(reportType);
       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
  
}
