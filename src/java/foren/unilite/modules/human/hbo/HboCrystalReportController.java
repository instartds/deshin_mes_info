package foren.unilite.modules.human.hbo;

import java.io.File;
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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class HboCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @Resource(name = "hbo800rkrService")
  protected Hbo800rkrServiceImpl hbo800rkrService;

  /**
   * 상여명세서출력
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
    @RequestMapping(value = "/human/hbo800crkr.do", method = RequestMethod.GET)
    public ModelAndView hbo800crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;

       Map param = _req.getParameterMap();
       
       ReportUtils.setCreportPram(user, param,dao);
	   ReportUtils.setCreportSanctionParam(param, dao);
       
       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";

       try{  
    	   
    	   sql = dao.mappedSqlString("hbo800rkrServiceImpl.selectMainData", param);
    	   
    	   //부서별 지급대장
    	   if(param.get("DOC_KIND").equals("1")){

    		   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hbo800kr_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hbo800rkrServiceImpl.selectSubData", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hbo800kr", "hbo800kr", param,  sql ,subReports, request);

           //부서별 집계표
           } if(param.get("DOC_KIND").equals("2")){
        	   
        	   List subReports = new ArrayList();
        	   
        	   Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hbo801kr_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hbo800rkrServiceImpl.selectSubData", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hbo801kr", "hbo801kr", param,  sql ,subReports, request);
        	   
           //사업장별 지급대장
           } if(param.get("DOC_KIND").equals("3")){
        	   
        	   List subReports = new ArrayList();
        	   
        	   Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hbo800kr_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hbo800rkrServiceImpl.selectSubData", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hbo802kr", "hbo802kr", param,  sql ,subReports, request);
        	   
           //명세서
           } if(param.get("DOC_KIND").equals("4")){
        	   
        	   List subReports = new ArrayList();
        	   
        	   Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hbo810kr_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hbo800rkrServiceImpl.selectSubData", param));
               subReports.add(subMap);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hbo810kr", "hbo810kr", param,  sql ,subReports, request);
        	   

           } 



 		   /*List subReports = new ArrayList();

           Map<String, String> subMap = new HashMap<String, String>();
           subMap.put("NAME", "hpa913kr_sub.rpt");
           subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint5", param));
           subReports.add(subMap);*/


       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : hbo800rkrServiceImpl.selectMainData " + sql);
             e2.getStackTrace();
       }
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
}
