package foren.unilite.modules.matrl.mpo;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.matrl.mpo.Mpo150rkrvServiceImpl;
import foren.unilite.modules.matrl.mpo.Mpo502ukrvServiceImpl;


@Controller
public class MpoClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "Clipreport4/Matrl/";

  @Resource( name = "mpo150rkrvService" )
  private Mpo150rkrvServiceImpl mpo150rkrvService;

  @Resource( name = "mpo502ukrvService" )
  private Mpo502ukrvServiceImpl mpo502ukrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @Resource( name = "mpo080ukrvService" )
  private Mpo080ukrvServiceImpl mpo080ukrvService;

  @Resource( name = "mpo090ukrvService" )
  private Mpo090ukrvServiceImpl mpo090ukrvService;

  @Resource( name = "mpo150skrvService" )
  private Mpo150skrvServiceImpl mpo150skrvService;

  @Resource( name = "mpo152rkrvService" )
  private Mpo152rkrvServiceImpl mpo152rkrvService;

  @Resource( name = "mpo151rkrvService" )
  private Mpo151rkrvServiceImpl mpo151rkrvService;

  @RequestMapping(value = "/matrl/mpo150clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView mpo150clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
	  //로고, 스탬프 패스 추가
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  if(ObjUtils.isNotEmpty(param.get("ORDER_NUMS"))){
		  logger.debug("[[NotEmpty]]");
		  String[] orderNumsArry	= param.get("ORDER_NUMS").toString().split(",");
		  List<Map> orderNumsList = new ArrayList<Map>();

		  for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				Object SELECT_ORDER_NUM =  orderNumsArry[i];
				map.put("ORDER_NUM", SELECT_ORDER_NUM);
				orderNumsList.add(map);
			}
		  param.put("SEL_ORDER_NUMS", orderNumsList);
	  }


	  //Main Report
	  List<Map<String, Object>> report_data = mpo150rkrvService.mainReport(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }
  @RequestMapping(value = "/matrl/mpo151clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void mpo151clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mpo150rkrvService.mainReport(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     doc.exportPDFReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request,response,"test.pdf");

  }

  @RequestMapping(value = "/matrl/mpo502clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView mpo502clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));//공통코드 관련6 데이터를 가져오기 위함

	  //로고, 스탬프 패스 추가
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mpo502ukrvService.mainReport(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
  }

	@RequestMapping(value = "/matrl/mpo080_1clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mpo080_1clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	ClipReportDoc doc = new ClipReportDoc();

	Map param = _req.getParameterMap();
	ReportUtils.setCreportPram(user, param, dao);
	ReportUtils.setCreportSanctionParam(param, dao);
	String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));

	//로고, 스탬프 패스 추가
	ReportUtils.clipReportLogoPath(param, dao, request);
	ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	String imagePath = doc.getImagePath();

	//Main Report
	List<Map<String, Object>> report_data = mpo080ukrvService.selectDetailList1_Print(param);

	//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	Map<String, Object> rMap = new HashMap<String, Object>();
	rMap.put("success", "true");
	rMap.put("resultKey", resultKey);
	return ViewHelper.getJsonView(rMap);
}
	@RequestMapping(value = "/matrl/mpo080_2clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mpo080_2clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	ClipReportDoc doc = new ClipReportDoc();

	Map param = _req.getParameterMap();
	ReportUtils.setCreportPram(user, param, dao);
	ReportUtils.setCreportSanctionParam(param, dao);
	String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));

	//로고, 스탬프 패스 추가
	ReportUtils.clipReportLogoPath(param, dao, request);
	ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	String imagePath = doc.getImagePath();

	String[] mrpControlNumArry	= param.get("MRP_CONTROL_NUM").toString().split(",");

	String[] prodItemCodeArry	= param.get("PROD_ITEM_CODE").toString().split(",");
	String[] wkPlanNumArry	= param.get("WK_PLAN_NUM").toString().split(",");

	List<Map> prodWkList = new ArrayList<Map>();

	for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
		Map map = new HashMap();

		Object SELECT_MRP_CONTROL_NUM =  mrpControlNumArry[i];

		Object SELECT_PROD_ITEM_CODE =  prodItemCodeArry[i];

		Object SELECT_WK_PLAN_NUM =  "";

		if(!ObjUtils.getSafeString(wkPlanNumArry[i]).equals("EMPTY")){
			SELECT_WK_PLAN_NUM =  wkPlanNumArry[i];
		}
		map.put("MRP_CONTROL_NUM", SELECT_MRP_CONTROL_NUM);

		map.put("PROD_ITEM_CODE", SELECT_PROD_ITEM_CODE);
		map.put("WK_PLAN_NUM", SELECT_WK_PLAN_NUM);

		prodWkList.add(map);
	}

	param.put("PROD_WK_LIST", prodWkList);



	//Main Report
	List<Map<String, Object>> report_data = mpo080ukrvService.selectDetailList3_Print(param);

	//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	Map<String, Object> rMap = new HashMap<String, Object>();
	rMap.put("success", "true");
	rMap.put("resultKey", resultKey);
	return ViewHelper.getJsonView(rMap);
  }
	@RequestMapping(value = "/matrl/mpo090_1clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mpo090_1clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	ClipReportDoc doc = new ClipReportDoc();

	Map param = _req.getParameterMap();
	ReportUtils.setCreportPram(user, param, dao);
	ReportUtils.setCreportSanctionParam(param, dao);
	String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));

	//로고, 스탬프 패스 추가
	ReportUtils.clipReportLogoPath(param, dao, request);
	ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	String imagePath = doc.getImagePath();

	//Main Report
	List<Map<String, Object>> report_data = mpo090ukrvService.selectDetailList1_Print(param);

	//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	Map<String, Object> rMap = new HashMap<String, Object>();
	rMap.put("success", "true");
	rMap.put("resultKey", resultKey);
	return ViewHelper.getJsonView(rMap);
}
	@RequestMapping(value = "/matrl/mpo090_2clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mpo090_2clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	ClipReportDoc doc = new ClipReportDoc();

	Map param = _req.getParameterMap();
	ReportUtils.setCreportPram(user, param, dao);
	ReportUtils.setCreportSanctionParam(param, dao);
	String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));

	//로고, 스탬프 패스 추가
	ReportUtils.clipReportLogoPath(param, dao, request);
	ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	String imagePath = doc.getImagePath();

	String[] mrpControlNumArry	= param.get("MRP_CONTROL_NUM").toString().split(",");

	String[] prodItemCodeArry	= param.get("PROD_ITEM_CODE").toString().split(",");

	List<Map> prodWkList = new ArrayList<Map>();

	for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
		Map map = new HashMap();

		Object SELECT_MRP_CONTROL_NUM =  mrpControlNumArry[i];

		Object SELECT_PROD_ITEM_CODE =  prodItemCodeArry[i];

		map.put("MRP_CONTROL_NUM", SELECT_MRP_CONTROL_NUM);

		map.put("PROD_ITEM_CODE", SELECT_PROD_ITEM_CODE);

		prodWkList.add(map);
	}

	param.put("PROD_WK_LIST", prodWkList);



	//Main Report
	List<Map<String, Object>> report_data = mpo090ukrvService.selectDetailList3_Print(param);

	//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	Map<String, Object> rMap = new HashMap<String, Object>();
	rMap.put("success", "true");
	rMap.put("resultKey", resultKey);
	return ViewHelper.getJsonView(rMap);
  }

	@RequestMapping(value = "/matrl/mpo150clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView mpo150clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = null;
		  //로고, 스탬프 패스 추가
		  ReportUtils.clipReportLogoPath(param, dao, request);
		  ReportUtils.clipReportSteampPath(param, dao, request);
		  String mailFormat  =  "1"; //기본값 국문
		  if(ObjUtils.isNotEmpty((String) param.get("MAIL_FORMAT"))){
			  mailFormat = (String) param.get("MAIL_FORMAT");
		  }
		  if(mailFormat.endsWith("1")){//국문일때
			  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
		  }else{
			  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
		  }
		//Image 경로 
		  String imagePath = doc.getImagePath();
		  String[] orderNumArry	= param.get("ORDER_NUM").toString().split(",");
		  if(ObjUtils.isEmpty(param.get("ORDER_PRSNS"))){
			  param.put("ORDER_PRSNS", "");
		  }
		  logger.debug("[[param]]" + param);
		  logger.debug("[[test]]" + param.get("ORDER_PRSNS"));
		  String[] orderPrsnArry	= param.get("ORDER_PRSNS").toString().split(",");
		  param.put("MAIL_FORM", mailFormat);
		  List<Map> orderNumSeqList = new ArrayList<Map>();
		  List<Map> orderPrsnList = new ArrayList<Map>();
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				Object SELECT_ORDER_NUM = orderNumArry[i];
				Object SELECT_ORDER_PRSN= orderPrsnArry[i];

				map.put("ORDER_NUM", SELECT_ORDER_NUM);
				map.put("ORDER_PRSN_EDIT", SELECT_ORDER_PRSN);

				orderNumSeqList.add(map);
				orderPrsnList.add(map);
			}

		    param.put("ORDER_NUMS",  orderNumSeqList);
		    param.put("ORDER_PRSNS", orderPrsnList);

		  //Main Report
		  List<Map<String, Object>> report_data = mpo150skrvService.mainReport2(param);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }

	@RequestMapping(value = "/mpo/mpo152clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView mpo152clrkrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String sDivCode = (String) param.get("DIV_CODE");
		  String crfFile = null;

		  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));

			String[] orderNumArry	= param.get("ORDER_NUM").toString().split(",");
			String[] orderSeqArry	= param.get("ORDER_SEQ").toString().split(",");
			String[] printCntArry	= param.get("PRINT_CNT").toString().split(",");
			String[] instockQArry	= param.get("INSTOCK_Q").toString().split(",");
			String[] lotNoArry		= param.get("LOT_NO").toString().split(",");


			List<Map> orderNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_ORDER_NUM =  orderNumArry[i];
				Object SELECT_ORDER_SEQ =  orderSeqArry[i];
				Object SELECT_PRINT_CNT =  printCntArry[i];
				Object SELECT_INSTOCK_Q =  instockQArry[i];
				Object SELECT_LOT_NO 	=  lotNoArry[i];

				map.put("ORDER_NUM", SELECT_ORDER_NUM);
				map.put("ORDER_SEQ", SELECT_ORDER_SEQ);
				map.put("PRINT_CNT", SELECT_PRINT_CNT);
				map.put("INSTOCK_Q", SELECT_INSTOCK_Q);
				map.put("LOT_NO"   , SELECT_LOT_NO);

				orderNumSeqList.add(map);
			}

		    param.put("ORDER_NUM_SEQ", orderNumSeqList);


		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = mpo152rkrvService.printList(param);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }

	@RequestMapping(value = "/matrl/mpo151_clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView mpo151clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = "" ;
		  if(param.get("ORDER_TYPE").equals("2") || param.get("ORDER_TYPE").equals("4")){//내수, 20200626 수정: 외주일 때도 내수와 동일한 출력양식 사용하도록 수정
			  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
		  }else{	//수입
			  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
		  }

		  //로고, 스탬프 패스 추가
		  ReportUtils.clipReportLogoPath(param, dao, request);
		  ReportUtils.clipReportSteampPath(param, dao, request);

		//Image 경로 
		  String imagePath = doc.getImagePath();
		  String[] orderNumArry	= param.get("ORDER_NUM").toString().split(",");

		  List<Map> orderNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_ORDER_NUM = orderNumArry[i];

				map.put("ORDER_NUM", SELECT_ORDER_NUM);

				orderNumSeqList.add(map);
			}

		    param.put("ORDER_NUMS", orderNumSeqList);

		  //Main Report
		  List<Map<String, Object>> report_data = mpo150skrvService.mainReport(param);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }

	@RequestMapping(value = "/matrl/mpo151_2clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView mpo151clskrv2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID3"));
		  //로고, 스탬프 패스 추가
		  ReportUtils.clipReportLogoPath(param, dao, request);
		  ReportUtils.clipReportSteampPath(param, dao, request);

		//Image 경로 
		  String imagePath = doc.getImagePath();
		  String[] orderNumArry	= param.get("ORDER_NUM").toString().split(",");

		  List<Map> orderNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_ORDER_NUM = orderNumArry[i];

				map.put("ORDER_NUM", SELECT_ORDER_NUM);

				orderNumSeqList.add(map);
			}

		    param.put("ORDER_NUMS", orderNumSeqList);

		  //Main Report
		  List<Map<String, Object>> report_data = mpo151rkrvService.selectMasterList(param);

		 List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		 Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 List<Map<String, Object>> subReport_data = mpo150skrvService.mainReport(param);
		 //subReportMap.put("mpo151clrkrv2_mit_sub", "SQLDS2");
		 subReportMap.put("mpo151clrkrv2_mit_sub", "SQLDS2");
		 subReportMap.put("SUB_DATA", subReport_data);
		 subReports.add(subReportMap);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);


	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }



}
