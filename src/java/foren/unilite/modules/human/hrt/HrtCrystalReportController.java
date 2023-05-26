package foren.unilite.modules.human.hrt;

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
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;

@Controller
public class HrtCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

	 
  @RequestMapping(value = "/human/hrt510crkr.do", method = RequestMethod.GET)
   public ModelAndView hum960crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

	  String sql="";
	  

		dao.update("hrt510rkrServiceImpl.createTable", param);
	  
		Map wagesMap = new HashMap();
		
		List<Map> wList = (List<Map>) dao.list("hrt510rkrServiceImpl.selectWages", param);
		
		for(Map wCode : wList) {
			 
			wCode.put("W_SEQ",      wCode.get("W_SEQ"));
			wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
			wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
			wCode.put("WAGES_SEQ",  wCode.get("WAGES_SEQ"));
			 
			 dao.insert("hrt510rkrServiceImpl.insertWages", wCode);

		 }
		 
		
	  try{
		  sql = dao.mappedSqlString("hrt510rkrServiceImpl.selectMaster", param);
		  
		  List subReports = new ArrayList();
		  
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "hrt510p_sub1.rpt");
          subMap.put("SQL", dao.mappedSqlString("hrt510rkrServiceImpl.ds_sub01", param));
          subReports.add(subMap);
          
          Map<String, String> subMap2 = new HashMap<String, String>();
          subMap2.put("NAME", "hrt510p_sub2.rpt");
          subMap2.put("SQL", dao.mappedSqlString("hrt510rkrServiceImpl.ds_sub02", param));
          subReports.add(subMap2);
          
          Map<String, String> subMap3 = new HashMap<String, String>();
          subMap3.put("NAME", "hrt510p_sub3.rpt");
          subMap3.put("SQL", dao.mappedSqlString("hrt510rkrServiceImpl.ds_sub03", param));
          subReports.add(subMap3);
          
          Map<String, String> subMap4 = new HashMap<String, String>();
          subMap4.put("NAME", "hrt510p_sub4.rpt");
          subMap4.put("SQL", dao.mappedSqlString("hrt510rkrServiceImpl.ds_sub04", param));
          subReports.add(subMap4);
		  
		  clientDoc = cDoc.generateReport(RPT_PATH+"/hrt510p", "hrt510p", param,  sql ,subReports, request);
	  }catch (Throwable e2)	{
          logger.debug("   >>>>>>>  queryId : hrt510rkrServiceImpl.selectMaster" + sql);
          e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("hrt510crkr");
	  clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
 
}
