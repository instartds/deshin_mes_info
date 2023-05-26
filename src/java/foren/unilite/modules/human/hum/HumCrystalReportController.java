package foren.unilite.modules.human.hum;

import java.io.File;
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

@Controller
public class HumCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

  @Resource( name = "hum920skrService" )
  private Hum920skrServiceImpl   hum920skrService;
	 
  @RequestMapping(value = "/human/hum960crkr.do", method = RequestMethod.GET)
   public ModelAndView hum960crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	  //rsMap.put("command", rs);
	  String sql="";
	  
	  //List rsList = hum920skrService.select960(param);
		 
	  try{
		  sql = dao.mappedSqlString("hum960rkrServiceImpl.selectPrimaryDataList", param);
		  List subReports = new ArrayList();
		  /*Map<String, String> subMap = new HashMap<String, String>();
		  subMap.put("NAME", "hum960rkr_sub1");
		  subMap.put("SQLID", "ds_sub01");
		  subReports.add(subMap);
		   clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,subReports, request);
		  */
		  clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,null, request);
	  }catch (Throwable e2)	{
          logger.debug("   >>>>>>>  queryId : um960rkrServiceImpl.selectPrimaryDataList " + sql);
          e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("hum960crkr");
	  clientDoc.setReportType(reportType);
      return ViewHelper.getCrystalReportView(clientDoc);
   }
  /**
   * 인사기록카드 (성남도시개발공사)
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/human/hum963crkrPrint.do", method = RequestMethod.GET)
  public ModelAndView hum963crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;
     
     //omegaPlus설치 경로를 가져옴
     String path = request.getSession().getServletContext().getRealPath("/");
	 String[] directories = path.split(":");
	 String drive = "";
	 if(directories != null && directories.length >= 2)	{
		drive = directories[0]+":";
	 }
	 else {
		 drive = "C:";
	 }
	 
     Map param = _req.getParameterMap();
    
     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     
   //레포트 제목 출력 관련
     if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
         param.put("PT_TITLENAME", "");
     }
     //레포트 회사명 출력 관련
     if(ObjUtils.isEmpty(user.getCompName())){
         param.put("S_COMP_NAME", "");
     }else{
         param.put("S_COMP_NAME", user.getCompName());
     }
     //레포트 출력일 출력 관련
     Date nDate = new Date();
     String sDate = "";
     SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
     sDate = sdf.format(nDate);
     
     if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
         param.put("PT_OUTPUTDATE", sDate);
     }
     
     param.put("S_COMP_CODE", user.getCompCode());
     
     try{
      // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)  
         String imagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
         File directory = new File(imagePath);
         if (!directory.exists()) {
             directory.mkdirs();
         }
         param.put("HUMAN_IMAGE_PATH", imagePath);
         
         sql = dao.mappedSqlString("hum963rkrServiceImpl.selectPrimaryDataList", param);
         
         List subReports = new ArrayList();
         Map<String, String> subMap = new HashMap<String, String>();
         subMap.put("NAME", "hum963rkr_sub1.rpt");
         //subMap.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub01", param));
         subReports.add(subMap);
         
         Map<String, String> subMap2 = new HashMap<String, String>();
         subMap2.put("NAME", "hum963rkr_sub2.rpt");
         //subMap2.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub02", param));
         subReports.add(subMap2);
         
         Map<String, String> subMap3 = new HashMap<String, String>();
         subMap3.put("NAME", "hum963rkr_sub3.rpt");
         //subMap3.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub03", param));
         subReports.add(subMap3);
         
         Map<String, String> subMap4 = new HashMap<String, String>();
         subMap4.put("NAME", "hum963rkr_sub4.rpt");
         //subMap4.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub04", param));
         subReports.add(subMap4);
         
         Map<String, String> subMap5 = new HashMap<String, String>();
         subMap5.put("NAME", "hum963rkr_sub5.rpt");
         //subMap5.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub05", param));
         subReports.add(subMap5);
         
         Map<String, String> subMap6 = new HashMap<String, String>();
         subMap6.put("NAME", "hum963rkr_sub6.rpt");
         //subMap6.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub06", param));
         subReports.add(subMap6);
         
         Map<String, String> subMap7 = new HashMap<String, String>();
         subMap7.put("NAME", "hum963rkr_sub7.rpt");
         //subMap7.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub07", param));
         subReports.add(subMap7);
         
         Map<String, String> subMap8 = new HashMap<String, String>();
         subMap8.put("NAME", "hum963rkr_sub8.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap8);
         
         Map<String, String> subMap9 = new HashMap<String, String>();
         subMap9.put("NAME", "hum963rkr_sub9.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap9);
         
         Map<String, String> subMap10 = new HashMap<String, String>();
         subMap10.put("NAME", "hum963rkr_sub10.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap10);
         
         clientDoc = cDoc.generateReport(RPT_PATH+"/hum963rkr", "hum963rkr", param,  sql ,subReports, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : hum963rkrServiceImpl.selectPrimaryDataList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("hum963rkr");
     clientDoc.setReportType(reportType);
     
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  
  /**
   * 인사기록카드 (성남도시개발공사 - 인사변동 내역 전체)
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/human/hum964crkrPrint.do", method = RequestMethod.GET)
  public ModelAndView hum964crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;
     
     Map param = _req.getParameterMap();
    
     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     
   //레포트 제목 출력 관련
     if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
         param.put("PT_TITLENAME", "");
     }
     //레포트 회사명 출력 관련
     if(ObjUtils.isEmpty(user.getCompName())){
         param.put("S_COMP_NAME", "");
     }else{
         param.put("S_COMP_NAME", user.getCompName());
     }
     //레포트 출력일 출력 관련
     Date nDate = new Date();
     String sDate = "";
     SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
     sDate = sdf.format(nDate);
     
     if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
         param.put("PT_OUTPUTDATE", sDate);
     }
     
     param.put("S_COMP_CODE", user.getCompCode());
     
     try{
      // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)  
         String imagePath = "C:" + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
         File directory = new File(imagePath);
         if (!directory.exists()) {
             directory.mkdirs();
         }
         param.put("HUMAN_IMAGE_PATH", imagePath);
         
         sql = dao.mappedSqlString("hum964rkrServiceImpl.selectPrimaryDataList", param);
         
         List subReports = new ArrayList();
         Map<String, String> subMap = new HashMap<String, String>();
         subMap.put("NAME", "hum964rkr_sub1.rpt");
         //subMap.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub01", param));
         subReports.add(subMap);
         
         Map<String, String> subMap2 = new HashMap<String, String>();
         subMap2.put("NAME", "hum964rkr_sub2.rpt");
         //subMap2.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub02", param));
         subReports.add(subMap2);
         
         Map<String, String> subMap3 = new HashMap<String, String>();
         subMap3.put("NAME", "hum964rkr_sub3.rpt");
         //subMap3.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub03", param));
         subReports.add(subMap3);
         
         Map<String, String> subMap4 = new HashMap<String, String>();
         subMap4.put("NAME", "hum964rkr_sub4.rpt");
         //subMap4.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub04", param));
         subReports.add(subMap4);
         
         Map<String, String> subMap5 = new HashMap<String, String>();
         subMap5.put("NAME", "hum964rkr_sub5.rpt");
         //subMap5.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub05", param));
         subReports.add(subMap5);
         
         Map<String, String> subMap6 = new HashMap<String, String>();
         subMap6.put("NAME", "hum964rkr_sub6.rpt");
         //subMap6.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub06", param));
         subReports.add(subMap6);
         
         Map<String, String> subMap7 = new HashMap<String, String>();
         subMap7.put("NAME", "hum964rkr_sub7.rpt");
         //subMap7.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub07", param));
         subReports.add(subMap7);
         
         Map<String, String> subMap8 = new HashMap<String, String>();
         subMap8.put("NAME", "hum964rkr_sub8.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap8);
         
         Map<String, String> subMap9 = new HashMap<String, String>();
         subMap9.put("NAME", "hum964rkr_sub9.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap9);
         
         Map<String, String> subMap10 = new HashMap<String, String>();
         subMap10.put("NAME", "hum964rkr_sub10.rpt");
         //subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap10);
         
         clientDoc = cDoc.generateReport(RPT_PATH+"/hum964rkr", "hum964rkr", param,  sql ,subReports, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : hum964rkrServiceImpl.selectPrimaryDataList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("hum964rkr");
     clientDoc.setReportType(reportType);
     
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  
  //재직퇴직증명서 출력
  @RequestMapping(value = "/human/hum970crkr.do", method = RequestMethod.GET)
  public ModelAndView hum970crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	  //rsMap.put("command", rs);
	  String sql="";
	  
	  //List rsList = hum920skrService.select960(param);
		 
	  try{
		  sql = dao.mappedSqlString("hum970rkrServiceImpl.PrintList1", param);
		  
		  
		  List subReports = new ArrayList();
		  /*Map<String, String> subMap = new HashMap<String, String>();
		  subMap.put("NAME", "hum960rkr_sub1");
		  subMap.put("SQLID", "ds_sub01");
		  subReports.add(subMap);
		   clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,subReports, request);
		  */
		  clientDoc = cDoc.generateReport(RPT_PATH+"/hum970rkr", "hum970rkr", param,  sql ,null, request);
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : hum970rkrServiceImpl.PrintList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setPrintFileName("hum970rkr");
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  /**
   * 증명서발급(성남도시개발공사)
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/human/hum973crkr.do", method = RequestMethod.GET)
  public ModelAndView hum973crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
      CrystalReportDoc cDoc = new CrystalReportDoc();
      CrystalReportFactory clientDoc = null;
      
      Map param = _req.getParameterMap();
     
      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
      //rsMap.put("command", rs);
      String sql="";
      
      //List rsList = hum920skrService.select960(param);
         
      //레포트 제목 출력 관련
      if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
          param.put("PT_TITLENAME", "");
      }
      //레포트 회사명 출력 관련
      if(ObjUtils.isEmpty(user.getCompName())){
          param.put("S_COMP_NAME", "");
      }else{
          param.put("S_COMP_NAME", user.getCompName());
      }
      //레포트 출력일 출력 관련
      Date nDate = new Date();
      String sDate = "";
      SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
      sDate = sdf.format(nDate);
      
      if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
          param.put("PT_OUTPUTDATE", sDate);
      }
      try{
          String imagePath = "C:" + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
          File directory = new File(imagePath);
          if (!directory.exists()) {
              directory.mkdirs();
          }
          param.put("HUMAN_IMAGE_PATH", imagePath);
          
          
          sql = dao.mappedSqlString("hum973rkrServiceImpl.PrintList1", param);
          
          
      //    List subReports = new ArrayList();
          /*Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "hum960rkr_sub1");
          subMap.put("SQLID", "ds_sub01");
          subReports.add(subMap);
           clientDoc = cDoc.generateReport(RPT_PATH+"/hum960rkr_tmp16", "hum960rkr", param,  sql ,subReports, request);
          */
 /*         List subReports = new ArrayList();
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "baseSetSubReport1.rpt");
          subMap.put("SQL", "");
          subReports.add(subMap);*/
          
          clientDoc = cDoc.generateReport(RPT_PATH+"/hum973rkr", "hum973rkr", param,  sql, null, request);
      }catch (Throwable e2) {
            logger.debug("   >>>>>>>  queryId : hum973rkrServiceImpl.PrintList1 " + sql);
            e2.getStackTrace();
      }
      clientDoc.setPrintFileName("hum973rkr");
      clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }  
/**
 * 사원명부(성남도시개발공사)
 * @param _req
 * @param user
 * @param reportType
 * @param request
 * @param response
 * @return
 * @throws Exception
 */
  @RequestMapping(value = "/human/hum953crkr.do", method = RequestMethod.GET)
  public ModelAndView hum953crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;
     
     Map param = _req.getParameterMap();
    
     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";
     
   //레포트 제목 출력 관련
     if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
         param.put("PT_TITLENAME", "");
     }
     //레포트 회사명 출력 관련
     if(ObjUtils.isEmpty(user.getCompName())){
         param.put("S_COMP_NAME", "");
     }else{
         param.put("S_COMP_NAME", user.getCompName());
     }
     //레포트 출력일 출력 관련
     Date nDate = new Date();
     String sDate = "";
     SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
     sDate = sdf.format(nDate);
     
     if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
         param.put("PT_OUTPUTDATE", sDate);
     }
     
     
     try{
    	 if(param.get("DEPTS") != null)	{
    		 String deptTemp = ObjUtils.getSafeString(param.get("DEPTS"));
    		 String[] deptCodes = deptTemp.split(",");
    		 String deptCodeStr = "";

    		 for(String deptCode : deptCodes )	{
    			 deptCodeStr += "'"+deptCode+"',";
    		 }
    		 if(!"".equals(deptCodeStr))	{	 
    			 param.put("DEPT_ARR_STR", deptCodeStr.substring(0, deptCodeStr.length()-1)); 
    		 }
    	 }
         sql = dao.mappedSqlString("hum953rkrServiceImpl.selectPrimaryDataList", param);
         if(param.get("optPrintGb").equals("1")){
             clientDoc = cDoc.generateReport(RPT_PATH+"/hum953rkr1", "hum953rkr1", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum953rkr1");
         }else if(param.get("optPrintGb").equals("2")){
             clientDoc = cDoc.generateReport(RPT_PATH+"/hum953rkr2", "hum953rkr2", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum953rkr2");
         }else if(param.get("optPrintGb").equals("3")){
             clientDoc = cDoc.generateReport(RPT_PATH+"/hum953rkr3", "hum953rkr3", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum953rkr3");
         }
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : hum963rkrServiceImpl.selectPrimaryDataList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setReportType(reportType);
     
     return ViewHelper.getCrystalReportView(clientDoc);
  }
  
  //기간별인원현황 출력
  @RequestMapping(value = "/human/hum260crkr.do", method = RequestMethod.GET)
  public ModelAndView hum260crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  CrystalReportDoc cDoc = new CrystalReportDoc();
	  CrystalReportFactory clientDoc = null;
	  
	  Map param = _req.getParameterMap();
	 
	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	  //rsMap.put("command", rs);
	  String sql="";
	  
	  //List rsList = hum920skrService.select960(param);
	  
	  
	  
	  String strDateFrom = (String)param.get("YYYYMM_FR");
	  String strDateTo   = (String)param.get("YYYYMM_TO");
		
	  // 조회 월집합
	  List calDateList = new ArrayList<Map>();
		
	  // 시작 년월
	  int DateFrom      = Integer.parseInt(strDateFrom);
	  int DateFromYear  = Integer.parseInt(strDateFrom.substring(0, 4));
	  int DateFromMonth = Integer.parseInt(strDateFrom.substring(4, 6));
		
	  // 종료 년월
	  int DateTo      = Integer.parseInt(strDateTo);
	  int DateToYear  = Integer.parseInt(strDateTo.substring(0, 4));
	  int DateToMonth = Integer.parseInt(strDateTo.substring(4, 6));
		
	  // 두 기간 사이의 월수 구하기
	  int dateItv = (DateToYear - DateFromYear) * 12 + (DateToMonth - DateFromMonth);
		
	  for (int i = 0; i <= dateItv; i++) {
		Map calDate = new HashMap();
			
		DateFormat format = new SimpleDateFormat("yyyyMM");
		Date date = format.parse(String.valueOf(strDateFrom));
	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
	
		calendar.add(Calendar.MONTH, i);
		String dateMontFrom = format.format(calendar.getTime());
			
		calendar.add(Calendar.MONTH, i+1);
		String dateMontTo = format.format(calendar.getTime());
		
		calDate.put("YEAR", dateMontFrom.substring(0, 4));
		calDate.put("MONTH", dateMontFrom.substring(4, 6));
		calDate.put("DATE_MONT_FROM", dateMontFrom+"01");
		calDate.put("DATE_MONT_TO", dateMontTo+"01");
		
		calDateList.add(calDate);
 	   }
		
      param.put("CAL_DATE_LIST", calDateList);
      if(ObjUtils.isEmpty(user.getCompName())){
          param.put("COMP_NAME", "");
      }else{
          param.put("COMP_NAME", user.getCompName());
      }
	  
		 
	  try{
		  sql = dao.mappedSqlString("hum260rkrServiceImpl.PrintList1", param);
		  
		  if(param.get("DOC_KIND").equals("0")){
	         clientDoc = cDoc.generateReport(RPT_PATH+"/hum260kr1", "hum260kr1", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum260kr1");
          }else if(param.get("DOC_KIND").equals("1")){
             clientDoc = cDoc.generateReport(RPT_PATH+"/hum260kr2", "hum260kr2", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum260kr2");
          }else if(param.get("DOC_KIND").equals("2")){
             clientDoc = cDoc.generateReport(RPT_PATH+"/hum260kr3", "hum260kr3", param,  sql ,null, request);
             clientDoc.setPrintFileName("hum260kr3");
          }
		  
          
	  }catch (Throwable e2)	{
			logger.debug("   >>>>>>>  queryId : hum260rkrServiceImpl.PrintList1 " + sql);
			e2.getStackTrace();
	  }
	  clientDoc.setReportType(reportType);
     return ViewHelper.getCrystalReportView(clientDoc);
  }
}
