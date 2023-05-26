package foren.unilite.modules.human.had;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
@Controller
public class HadCrystalReportController extends UniliteCommonController {
	@InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
	
	final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";
	  
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	   /**
	    * 근로소득영수증출력
	    * @param _req
	    * @param user
	    * @param reportType
	    * @return
	    * @throws Exception
	    */
       @RequestMapping(value = "/human/had840crkr.do", method = RequestMethod.GET)
       public ModelAndView had840crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {        
       //public String had840crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {        
            CrystalReportDoc cDoc = new CrystalReportDoc();
 		  CrystalReportFactory clientDoc = null;
 		  
 		  Map param = _req.getParameterMap();
 		  param.put("sReceDate", param.get("RECE_DATE"));
 		  
 		  param.put("sCompCode", user.getCompCode());
 		  param.put("sCompCodeImgYN", "N");
 		  
 		  String output = ObjUtils.getSafeString(param.get("OUTPUT"));
 		  if("0".equals(output))	{
 			 param.put("sTitle", "(발행자보고용)");
 		  } else if("1".equals(output)) {
 			  param.put("sTitle", "(소득자용)");
 		  } else if("2".equals(output)) {
 			 param.put("sTitle", "(발행자보관용)");
 		  }
 		  String year = ObjUtils.getSafeString(param.get("YEAR_YYYY"));
 		  int yyyy = ObjUtils.parseInt(param.get("YEAR_YYYY"));
 		  
 		  String sql="";
 		  String sub_sql="";
 		
 		  try{
 			  
 			  if(yyyy >= 2016) {
 				  
 				  sql = dao.mappedSqlString("had840rkrServiceImpl.selectList2016_Query1", param);
 	 			  sub_sql= dao.mappedSqlString("had840rkrServiceImpl.selectList2016_Query2", param);
 	 			  
 	 			  List subReports = new ArrayList();
 	 			  Map<String, String> subMap = new HashMap<String, String>();
 	 			  subMap.put("NAME",  "had840_2016_sub");
 	 			  subMap.put("SQL", sub_sql);
 	 			  subReports.add(subMap);
 	 			  
 	 			  clientDoc = cDoc.generateReport(RPT_PATH+"/had840_2016", "had850rkr", param,  sql ,subReports, request);
 			  }
 			  
 		  }catch (Throwable e2)	{
 	          logger.debug("   >>>>>>>  queryId : had840rkrServiceImpl.selectList2016_Query1" + sql);
 	          e2.getStackTrace();
 		  }
 		
 		  clientDoc.setPrintFileName("had840crkr");
 		  clientDoc.setReportType(reportType);
 		  logger.debug("   >>>>>>>  queryId : had840rkrServiceImpl.selectList2016_Query1");
 		  //session.setAttribute("ReportSource", clientDoc.getReportClientDocument().getReportSource());
 	      return ViewHelper.getCrystalReportView(clientDoc);
          // return "/com/report/CrystalReportViewer";
       }
       
       /**
        * 근로소득원천징수부출력
        * @param _req
        * @param user
        * @param reportType
        * @return
        * @throws Exception
        */
       @RequestMapping(value = "/human/had850crkr.do", method = RequestMethod.GET)
       public ModelAndView had850crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	  CrystalReportDoc cDoc = new CrystalReportDoc();
		  CrystalReportFactory clientDoc = null;
		  
		  Map param = _req.getParameterMap();
		 
		  String sql="";
		  
		  try{
			  sql = dao.mappedSqlString("had850rkrServiceImpl.selectlist2010", param);
			  //List subReports = new ArrayList();
			  
			  clientDoc = cDoc.generateReport(RPT_PATH+"/had850_2010", "hum850rkr", param,  sql ,null, request);
		  }catch (Throwable e2)	{
	          logger.debug("   >>>>>>>  queryId : had850rkrServiceImpl.selectlist2010 " + sql);
	          e2.getStackTrace();
		  }
		  clientDoc.setPrintFileName("had850crkr");
		  clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
    	   
       }
       
}
