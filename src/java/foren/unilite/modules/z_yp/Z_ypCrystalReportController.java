package foren.unilite.modules.z_yp;

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
public class Z_ypCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Z_yp";

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  //거래명세서 출력(출하지시등록)
  @RequestMapping(value = "/z_yp/s_srq100cukrv_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_srq100cukrv_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     try{
         if(param.get("PRINT_CONDITION").equals("1")){      //일반
             sql = dao.mappedSqlString("s_srq100ukrv_ypServiceImpl.printList1", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_srq100ukrv_yp1", "s_srq100ukrv_yp1", param,  sql ,null, request);
         }else{ //선납제외
             sql = dao.mappedSqlString("s_srq100ukrv_ypServiceImpl.printList2", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_srq100ukrv_yp2", "s_srq100ukrv_yp2", param,  sql ,null, request);
         }
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_srq100ukrv_ypServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_srq100ukrv_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//구매입고현황 출력(상세)
  @RequestMapping(value = "/z_yp/mtr130cskrv_yp1.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView mtr130cskrv_yp1Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_mtr130rkrv_ypServiceImpl.printList1", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_mtr130skrv_yp1", "s_mtr130skrv_yp1", param,  sql ,null, request);
     }catch (Throwable e2) {
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_mtr130skrv_yp1");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//구매입고 현황 출력(집계현황)
  @RequestMapping(value = "/z_yp/mtr130cskrv_yp2.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView mtr130cskrv_yp2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_mtr130rkrv_ypServiceImpl.printList2", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_mtr130skrv_yp2", "s_mtr130skrv_yp2", param,  sql ,null, request);
     }catch (Throwable e2) {
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_mtr130skrv_yp2");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//견적서 출력
  @RequestMapping(value = "/z_yp/s_spp100cukrv_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_spp100cukrv_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_spp100ukrv_ypServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_spp100ukrv_yp", "s_spp100ukrv_yp", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_spp100ukrv_ypServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_spp100ukrv_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//작업지시등록(양평) 검수리스트 출력
  @RequestMapping(value = "/z_yp/s_pmp110cukrv_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_pmp110cukrv_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_pmp110ukrv_ypServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_pmp110ukrv_yp", "s_pmp110ukrv_yp", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_pmp110ukrv_ypServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_pmp110ukrv_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//구매품 작업지시등록(양평) 검수리스트 출력
  @RequestMapping(value = "/z_yp/s_pmp111cukrv_yp1.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_pmp111cukrv_ypPrint1(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_pmp111ukrv_ypServiceImpl.printList1", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_pmp111ukrv_yp1", "s_pmp111ukrv_yp1", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_pmp111ukrv_ypServiceImpl.printList1 " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_pmp111ukrv_yp1");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

 //구매품 작업지시등록(양평) 배송분류표A4
  @RequestMapping(value = "/z_yp/s_pmp111cukrv_yp2.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_pmp111cukrv_ypPrint2(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_pmp111ukrv_ypServiceImpl.printList2", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_pmp111ukrv_yp2", "s_pmp111ukrv_yp2", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_pmp111ukrv_ypServiceImpl.printList2 " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_pmp111ukrv_yp2");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //매출집계내역 출력
  @RequestMapping(value = "/z_yp/s_ssa450cukrv_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_ssa450cukrv_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;
     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     try{
         if(param.get("PRINT_CONDITION").equals("1")){      //상세
             sql = dao.mappedSqlString("s_ssa450rkrv_ypServiceImpl.printList1", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_ssa450rkrv_yp1", "s_ssa450rkrv_yp1", param,  sql ,null, request);
         }else if(param.get("PRINT_CONDITION").equals("2")){ //집계
             sql = dao.mappedSqlString("s_ssa450rkrv_ypServiceImpl.printList2", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_ssa450rkrv_yp2", "s_ssa450rkrv_yp2", param,  sql ,null, request);
         }else{ //일자별
             sql = dao.mappedSqlString("s_ssa450rkrv_ypServiceImpl.printList3", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_ssa450rkrv_yp3", "s_ssa450rkrv_yp3", param,  sql ,null, request);
         }
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : S_ssa450rkrv_ypServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_ssa450rkrv_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  //주간 발주현황 조회 : 구매발주서 출력
  @RequestMapping(value = "/z_yp/s_mpo131cskrv_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_mpo131cskrv_yp(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

     try{
         sql = dao.mappedSqlString("s_mpo131skrv_ypServiceImpl.printList", param);

         clientDoc = cDoc.generateReport(RPT_PATH+"/s_mpo131skrv_yp", "s_mpo131skrv_yp", param,  sql ,null, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : s_mpo131skrv_ypServiceImpl.printList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_mpo131cskrv_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

//거래명세서 출력(출하지시등록)
  @RequestMapping(value = "/z_yp/s_hpa930crkr_yp.do", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView s_hpa930crkr_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     try{
         if(param.get("PRINT_CONDITION").equals("1")){      //일반
             sql = dao.mappedSqlString("s_hpa930rkr_ypServiceImpl.printList1", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa930rkr_yp1", "s_hpa930rkr_yp1", param,  sql ,null, request);
         }else{ //선납제외
             sql = dao.mappedSqlString("s_hpa930rkr_ypServiceImpl.printList2", param);
             clientDoc = cDoc.generateReport(RPT_PATH+"/s_hpa930rkr_yp2", "s_hpa930rkr_yp2", param,  sql ,null, request);
         }
     }catch (Throwable e2) {
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("s_hpa930rkr_yp");
     clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }






  @RequestMapping(value = "/z_yp/s_str103cukrv_yp.do", method = RequestMethod.GET)
  public ModelAndView str103cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;

      Map param = _req.getParameterMap();

      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";

      try{
          sql = dao.mappedSqlString("s_str103ukrv_ypServiceImpl.printList", param);

          clientDoc = cDoc.generateReport(RPT_PATH+"/s_str103ukrv_yp", "s_str103ukrv_yp", param,  sql ,null, request);
      }catch (Throwable e2) {
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("s_str103ukrv_yp");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }


  @RequestMapping(value = "/z_yp/s_str104cukrv_yp.do", method = RequestMethod.GET)
  public ModelAndView str104cukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;

      Map param = _req.getParameterMap();

      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";

      try{
          sql = dao.mappedSqlString("s_str104ukrv_ypServiceImpl.printList", param);

          clientDoc = cDoc.generateReport(RPT_PATH+"/s_str104ukrv_yp", "s_str104ukrv_yp", param,  sql ,null, request);
      }catch (Throwable e2) {
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("s_str104ukrv_yp");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }

  //재직퇴직증명서 출력
  @RequestMapping(value = "/z_yp/s_hum970crkr_yp.do", method = RequestMethod.GET)
  public ModelAndView s_hum970crkrPrint_yp(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;

	  Map param = _req.getParameterMap();

	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

	  String sql="";


	  try{
		  sql = dao.mappedSqlString("s_hum970rkr_ypServiceImpl.PrintList1", param);


		  List subReports = new ArrayList();


		  if(param.get("DOC_KIND").equals("1")){
			  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr1_yp", "s_hum970rkr1_yp", param,  sql ,null, request);
		  } else {
			  clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr2_yp", "s_hum970rkr2_yp", param,  sql ,null, request);
		  }

		  //clientDoc = cDoc.generateReport(RPT_PATH+"/s_hum970rkr1_yp", "s_hum970rkr1_yp", param,  sql ,null, request);
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : s_hum970rkr_ypServiceImpl.PrintList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("s_hum970rkr_yp");
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }

  @RequestMapping(value = "/z_yp/s_str400cukrv_yp.do", method = RequestMethod.GET)
  public ModelAndView s_str400cukrv_ypPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;

      Map param = _req.getParameterMap();

      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      String sql="";

      try{
    	  if(param.get("PRINT_CONDITION").equals("1")){      //출고건
    		  sql = dao.mappedSqlString("s_str400rkrv_ypServiceImpl.printList1", param);
    	  }else{																	//거래처
    		  sql = dao.mappedSqlString("s_str400rkrv_ypServiceImpl.printList2", param);
    	  }

          clientDoc = cDoc.generateReport(RPT_PATH+"/s_str400rkrv_yp", "s_str400rkrv_yp", param,  sql ,null, request);
      }catch (Throwable e2) {
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("s_str400rkrv_yp");
      clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
}
