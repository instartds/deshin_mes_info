package foren.unilite.modules.z_kd;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
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
import foren.unilite.modules.human.hbo.Hbo800rkrServiceImpl;
import foren.unilite.modules.human.hpa.Hpa900rkrServiceImpl;

@Controller
public class Z_kdCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Z_kd";

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
  
  @Resource(name = "s_hpa900rkr_kdService")
  protected S_Hpa900rkr_kdServiceImpl s_hpa900rkr_kdService;
  
  @Resource(name = "s_hbo800rkr_kdService")
  protected S_Hbo800rkr_kdServiceImpl s_hbo800rkr_kdService;

  //발주서출력
  @RequestMapping(value = "/z_kd/s_mpo150crkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView mpo150rkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     String sql = "";

     try{
         sql = dao.mappedSqlString("s_mpo150rkrv_kdServiceImpl.selectList", param);

         if(param.get("FORM").equals("K")) {
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_mpo150rkrv1_kd", "s_mpo150rkrv_kd", param,  sql ,null, request);
             clientDoc.setPrintFileName("s_mpo150rkrv1_kd");
         }else {
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_mpo150rkrv2_kd", "s_mpo150rkrv_kd", param,  sql ,null, request);
             clientDoc.setPrintFileName("s_mpo150rkrv2_kd");
         }
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : s_mpo150rkrv_kdServiceImpl.selectList " + sql);
           e2.getStackTrace();
     }

     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //발주서출력(외주)
  @RequestMapping(value = "/z_kd/s_opo110crkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView opo110rkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     String sql = "";

     try{
         sql = dao.mappedSqlString("s_opo110rkrv_kdServiceImpl.selectList", param);

         if(param.get("FORM").equals("1")) {
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_opo110rkrv1_kd", "s_opo110rkrv_kd", param,  sql ,null, request);
             clientDoc.setPrintFileName("s_opo110rkrv1_kd");
         }else {
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_opo110rkrv2_kd", "s_opo110rkrv_kd", param,  sql ,null, request);
             clientDoc.setPrintFileName("s_opo110rkrv2_kd");
         }
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : s_opo110rkrv_kdServiceImpl.selectList " + sql);
           e2.getStackTrace();
     }

     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //외주자재 출고요청서
  @RequestMapping(value = "/z_kd/s_otr100cukrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView otr100cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_otr100ukrv_kdServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_otr100ukrv_kd", "s_otr100ukrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : s_otr100ukrv_kdServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_otr100ukrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //년도별 수출실적 집계현황
  @RequestMapping(value = "/z_kd/s_tes900crkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView tes900cskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_tes900skrv_kdServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_tes900skrv_kd", "s_tes900skrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.error("   >>>>>>>  queryId : s_tes900skrv_kdServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_tes900skrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //기술료BOM출력
  @RequestMapping(value = "/z_kd/s_ryt300cukrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView ryt300cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_ryt300ukrv_kdService.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_ryt300ukrv_kd", "s_ryt300ukrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.error("   >>>>>>>  queryId : s_ryt300ukrv_kdService.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_ryt300ukrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //대상품목출력
  @RequestMapping(value = "/z_kd/s_ryt200cskrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView ryt200cskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_ryt200skrv_kdService.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_ryt200skrv_kd", "s_ryt200skrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.error("   >>>>>>>  queryId : s_ryt200skrv_kdService.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_ryt200skrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //재고실사부족표
  @RequestMapping(value = "/z_kd/s_biv121crkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView biv121crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();
     ReportUtils.setCreportPram(user, param, dao);
     ReportUtils.setCreportSanctionParam(param, dao);
     param.put("RP_STARTNUM", param.get("START_NUM"));
	 param.put("PR_PAGEQ", param.get("PAGE_Q"));
	 logger.debug("[[RP_STARTNUM1]]" + param.get("START_NUM") );
	 logger.debug("[[PR_PAGEQ1]]" + param.get("PAGE_Q") );
     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         //sql = dao.mappedSqlString("s_biv121rkrv_kdServiceImpl.printList1", param);
    	  sql = null;

    	  List subReports = new ArrayList();
		  Map<String, String> subMap = new HashMap<String, String>();
		  subMap.put("NAME", "s_biv121rkrv_kd_sub1.rpt");
		  subMap.put("SQL", dao.mappedSqlString("s_biv121rkrv_kdServiceImpl.printList1", param));
		  subReports.add(subMap);

		  Map<String, String> subMap2 = new HashMap<String, String>();
		  subMap2.put("NAME", "s_biv121rkrv_kd_sub2.rpt");
		  subMap2.put("SQL", dao.mappedSqlString("s_biv121rkrv_kdServiceImpl.printList2", param));
		  subReports.add(subMap2);

		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_biv121rkrv_kd", "s_biv121rkrv_kd", param,  sql ,subReports, request);
     }catch (Throwable e2) {
           logger.error("   >>>>>>>  queryId : s_biv121rkrv_kdServiceImpl.printList1 " + sql);
           logger.error("   >>>>>>>  params: s_biv121rkrv_kdServiceImpl.printList1 " + param);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_biv121rkrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //s_pmr928rkrv_kd
  @RequestMapping(value = "/z_kd/s_pmr928crkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
  public ModelAndView pmr928crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();
    logger.debug("[param]" + param);
     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{


    	 String[] words  =   ((String) param.get("LINE_SEQ")).split(",");
    	 List<Map<String, Object>> detailList =  (List<Map<String, Object>>) dao.list("s_pmr928rkrv_kdServiceImpl.selectList2", param);
    	 String reqNum = (String) dao.select("s_pmr928rkrv_kdServiceImpl.selectAutoReqNum", param);
    	 logger.debug("[reqNum]" + reqNum);
    	 
    	 int ii = 0;
    	 for(Map paramData: detailList) {

    		 paramData.put("REQ_NUM", reqNum);
    		 paramData.put("S_USER_ID", user.getUserID());

    		 logger.debug("[paramData]" + paramData);
    		 for(int i=0; i <= words.length-1; i++){

			 	String[] words2 = words[i].split("|");
    			if(words[i].equals( (String) paramData.get("BASIS_NUM") + (String) paramData.get("INSPEC_NUM") + String.valueOf(paramData.get("INSPEC_SEQ")))){
    				 ii =  ii +1;
    				 paramData.put("REQ_SEQ", ii );
    				 paramData.put("REMARK",words2[1]);
    				dao.insert("s_pmr928rkrv_kdServiceImpl.insertL_PMR928T_KD", paramData);

    			}

    		 }



    	 }

    	 param.put("S_REQ_NUM", reqNum);
         sql = dao.mappedSqlString("s_pmr928rkrv_kdServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_pmr928rkrv_kd", "s_pmr928rkrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.error("   >>>>>>>  queryId : s_pmr928rkrv_kdServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_pmr928rkrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//식권출력(극동)
  @RequestMapping(value = "/z_kd/s_hat920rkrv_kd.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_hat920rkrv_kdPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();
     ReportUtils.setCreportPram(user, param, dao);
     ReportUtils.setCreportSanctionParam(param, dao);

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     try{
    	 	String deptNm = (String)param.get("DEPT_NAME");
    	 	if(! ObjUtils.isEmpty(deptNm)){
    	 		param.put("DEPT_NAME",new String(deptNm.getBytes("iso-8859-1"), "utf-8"));
    	 	}

    	 	logger.debug("[[param]]" + param);

	    	 List<Map> paramList = dao.list("s_hat920ukr_kdService.selectFoodCouponList", param);
	    	 for(Map dataListMap : paramList){
	    		 	logger.debug("[[data]]" + dataListMap);
	    		 	if(ObjUtils.isEmpty(dataListMap.get("FOOD_COUPON_NO"))){
	    		 		dataListMap.put("S_USER_ID",user.getUserID());
	    		 		dao.update("s_hat920ukr_kdService.updateFoodCouponNo", dataListMap);
	    		 	}
	    	 }
	    	  sql = dao.mappedSqlString("s_hat920ukr_kdService.print", param);

		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hat920rkrv_kd", "s_hat920rkrv_kd", param,  sql ,null, request);
     }catch (Throwable e2) {
          e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_hat920rkrv_kd");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  
  
  /**
   * 급여지급조서출력(극동가스케트)
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
    @RequestMapping(value = "/z_kd/s_hpa900crkr_kd.do", method = RequestMethod.GET)
    public ModelAndView hpa900crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;

       Map param = _req.getParameterMap();
       
       ReportUtils.setCreportPram(user, param,dao);
	   ReportUtils.setCreportSanctionParam(param, dao);
       
       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";

       /*dao.update("hpa900rkrServiceImpl.createTable", param);

       Map wagesMap = new HashMap();

	   List<Map> wList1 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages1", param);

		for(Map wCode : wList1) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("hpa900rkrServiceImpl.insertWages1", wCode);

		 }

		List<Map> wList2 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages2", param);

		for(Map wCode : wList2) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("hpa900rkrServiceImpl.insertWages2", wCode);

		 }

		List<Map> wList3 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages3", param);

		for(Map wCode : wList3) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
			wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
			wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

      		dao.insert("hpa900rkrServiceImpl.insertWages3", wCode);

		 }
	   */
       try{
    	   
    	   /*if(param.get("DOC_KIND").equals("5")){
    		   sql = dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectListPrint15", param);   
    	   }if(param.get("DOC_KIND").equals("1")){
    		   sql = dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectListPrint15", param);   
    	   }if(param.get("DOC_KIND").equals("2")){
    		   sql = dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectListPrint2", param);   
    	   }*/
    	  
    	   sql = dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectListPrint15", param);   


    	   List subReports = new ArrayList();

           Map<String, String> subMap = new HashMap<String, String>();
           subMap.put("NAME", "hpa913kr_sub.rpt");
           subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectSubListPrint5", param));
           subReports.add(subMap);

           clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa913kr_kd", "s_hpa913kr_kd", param,  sql ,subReports, request);

    	   /*if(param.get("DOC_KIND").equals("5")){

    		   if(param.get("GUNTAE").equals("Y")){
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa910kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectSubListPrint5", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa910kr", "hpa910kr", param,  sql ,subReports, request);

    		   } else {
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa913kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectSubListPrint5", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa913kr", "hpa913kr", param,  sql ,subReports, request);
    		   }


           } if(param.get("DOC_KIND").equals("1")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectSubListPrint5", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa900kr", "hpa900kr", param,  sql ,subReports, request);
        	   

           } if(param.get("DOC_KIND").equals("2")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("s_hpa900rkr_kdServiceImpl.selectSubListPrint5", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa901kr", "hpa901kr", param,  sql ,subReports, request);
        	   

           }*/










 		   /*List subReports = new ArrayList();

           Map<String, String> subMap = new HashMap<String, String>();
           subMap.put("NAME", "hpa913kr_sub.rpt");
           subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint5", param));
           subReports.add(subMap);*/


       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : s_hpa900rkr_kdServiceImpl.selectListPrint5 " + sql);
             e2.getStackTrace();
       }
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
    /**
     * 상여명세서출력(극동가스케트)
     * @param _req
     * @param user
     * @param reportType
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
      @RequestMapping(value = "/z_kd/s_hbo800crkr_kd.do", method = RequestMethod.GET)
      public ModelAndView hbo800crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
         CrystalReportDoc cDoc = new CrystalReportDoc();
         CrystalReportFactory clientDoc = null;

         Map param = _req.getParameterMap();
         
         ReportUtils.setCreportPram(user, param,dao);
  	   	 ReportUtils.setCreportSanctionParam(param, dao);
         
         Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
         String sql="";

         try{  
      	   
      	   sql = dao.mappedSqlString("s_hbo800rkr_kdServiceImpl.selectMainData", param);
      	   
      	   //부서별 지급대장
      	   if(param.get("DOC_KIND").equals("1")){

      		   List subReports = new ArrayList();

                 Map<String, String> subMap = new HashMap<String, String>();
                 subMap.put("NAME", "hbo800kr_sub.rpt");
                 subMap.put("SQL", dao.mappedSqlString("s_hbo800rkr_kdServiceImpl.selectSubData", param));
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
                 subMap.put("SQL", dao.mappedSqlString("s_hbo800rkr_kdServiceImpl.selectSubData", param));
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
                 subMap.put("SQL", dao.mappedSqlString("s_hbo800rkr_kdServiceImpl.selectSubData", param));
                 subReports.add(subMap);
                 
                 Map<String, String> subMap2 = new HashMap<String, String>();
                 subMap2.put("NAME", "san_top_sub.rpt");
                 subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
   	           subReports.add(subMap2);

                 clientDoc = cDoc.generateReport(RPT_PATH+"/hbo802kr", "hbo802kr", param,  sql ,subReports, request);
          	   
             //명세서
             } if(param.get("DOC_KIND").equals("4")){
          	   
          	   List subReports = new ArrayList();
          	   
          	   //Map<String, String> subMap = new HashMap<String, String>();
               //subMap.put("NAME", "hbo810kr_sub.rpt");
               //subMap.put("SQL", dao.mappedSqlString("s_hbo800rkr_kdServiceImpl.selectSubData", param));
               //subReports.add(subMap);

               clientDoc = cDoc.generateReport(RPT_PATH+"/s_hbo810kr_kd", "s_hbo810kr_kd", param,  sql, null, request);
          	   

             } 



   		   /*List subReports = new ArrayList();

             Map<String, String> subMap = new HashMap<String, String>();
             subMap.put("NAME", "hpa913kr_sub.rpt");
             subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint5", param));
             subReports.add(subMap);*/


         }catch (Throwable e2) {
               logger.debug("   >>>>>>>  queryId : s_hbo800rkr_kdServiceImpl.selectMainData " + sql);
               e2.getStackTrace();
         }
         clientDoc.setReportType(reportType);

         return ViewHelper.getCrystalReportView(clientDoc);
      }
      
      //재직퇴직증명서 출력
      @RequestMapping(value = "/z_kd/s_hum970crkr_kd.do", method = RequestMethod.GET)
      public ModelAndView hum970crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	  CrystalReportDoc cDoc = new CrystalReportDoc();
    	  CrystalReportFactory clientDoc = null;
    	  
    	  Map param = _req.getParameterMap();
    	 
    	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
    	  //rsMap.put("command", rs);
    	  String sql="";
    	  
    	  //List rsList = hum920skrService.select960(param);
    		 
    	  try{
    		  sql = dao.mappedSqlString("s_hum970rkr_kdServiceImpl.PrintList1", param);
    		  
    		  
    		  List subReports = new ArrayList();
    		  /*Map<String, String> subMap = new HashMap<String, String>();
    		  subMap.put("NAME", "hum960rkr_sub1");
    		  subMap.put("SQLID", "ds_sub01");
    		  subReports.add(subMap);
    		   clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,subReports, request);
    		  */
    		  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr_kd", "s_hum970rkr_kd", param,  sql ,null, request);
    	  }catch (Throwable e2)	{
    			logger.debug("   >>>>>>>  queryId : s_hum970rkr_kdServiceImpl.PrintList1 " + sql);
    			e2.getStackTrace();
    	  }
    	  clientDoc.setPrintFileName("s_hum970rkr_kd");
    	  clientDoc.setReportType(reportType);
         return ViewHelper.getCrystalReportView(clientDoc);
      }
    
}