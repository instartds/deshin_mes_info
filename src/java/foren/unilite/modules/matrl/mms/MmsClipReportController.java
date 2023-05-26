package foren.unilite.modules.matrl.mms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import foren.unilite.com.code.CodeInfo;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.prodt.pmp.Pmp100ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;
import foren.unilite.modules.matrl.mms.Mms110ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MmsClipReportController  extends UniliteCommonController {
	final static String CRF_PATH = "Clipreport4/Matrl/";

	@InjectLogger
	public static Logger logger;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "mms210skrvService" )
	private Mms210skrvServiceImpl mms210skrvService;

	@Resource( name = "mms110ukrvService" )
	private Mms110ukrvServiceImpl mms110ukrvService;

	@Resource( name = "mms120skrvService" )
	private Mms120skrvServiceImpl mms120skrvService;

	@Resource( name = "mms200ukrvService" )
	private Mms200ukrvServiceImpl mms200ukrvService;

	@Resource( name = "mms510ukrvService" )
	private Mms510ukrvServiceImpl mms510ukrvService;
	/**
	 * 수입검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mms210clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms210clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		String[] inspecNumArry = null;
		String[] inspecSeqArry = null;
		String[] itemCodeArry = null;

		String inspecNum = ObjUtils.getSafeString(param.get("INSPEC_NUMS"));
		if(ObjUtils.isNotEmpty(inspecNum)){
			inspecNumArry = inspecNum.split(",");
		}

		String inspecSeq = ObjUtils.getSafeString(param.get("INSPEC_SEQS"));
		if(ObjUtils.isNotEmpty(inspecSeq)){
			inspecSeqArry = inspecSeq.split(",");
		}

		List<Map> inspecNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_INSPEC_NUMS =  inspecNumArry[i] + inspecSeqArry[i];

			map.put("INSPEC_NUMS", SELECT_INSPEC_NUMS);

			inspecNumSeqList.add(map);
		}
		param.put("INSPEC_NUM_SEQ", inspecNumSeqList);

		String itemCodes = ObjUtils.getSafeString(param.get("ITEM_CODES"));
		if(ObjUtils.isNotEmpty(itemCodes)){
			itemCodeArry = itemCodes.split(",");
		}
		List<Map>  itemCodeList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_ITEM_CODES =  itemCodeArry[i];

			map.put("ITEM_CODES", SELECT_ITEM_CODES);

			itemCodeList.add(map);
		}
		param.put("SEL_ITEM_CODE", itemCodeList);

		List<Map<String, Object>> report_data =  mms210skrvService.mainReport(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
		subReportMap.put("mms210clrkrv_sub", "SQLDS2");
		subReportMap2.put("mms210clrkrv_sub1-2", "SQLDS2");
		subReportMap3.put("mms210clrkrv_sub2", "SQLDS2");
		 subReportMap4.put("mms210clrkrv_sub22", "SQLDS2");
		List<Map<String, Object>> subReport_data = mms210skrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReportMap2.put("SUB_DATA", subReport_data);
		subReportMap3.put("SUB_DATA", subReport_data);
		subReportMap4.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		subReports.add(subReportMap2);
		subReports.add(subReportMap4);
		subReports.add(subReportMap3);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/mms/mms110clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms110clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= null;
		String sDivCode		= (String) param.get("DIV_CODE");
		//20210616 추가:  출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경
		if(ObjUtils.isNotEmpty(param.get("RPT_INFO"))) {
			crfFile = "Clipreport4/" + ObjUtils.getSafeString(param.get("RPT_INFO"));
		} else {
			if( sDivCode.equals("01")){			//사업장이 김천일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}else if(sDivCode.equals("02")){	//사업장이 화성일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
			}else{// 그외
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}
		}
		//Image 경로 
		String imagePath = doc.getImagePath();
		param.put("USER_NAME", user.getUserName());
		//Main Report
		List<Map<String, Object>> report_data = mms110ukrvService.printList(param);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 수입검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mms110clukrv_2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms110clukrv_2( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		CodeDetailVO cdo = null;
		String siteName = "STANDARD";
		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		String[] receiptNumArry = null;
		String[] receiptSeqArry = null;
		String[] itemCodeArry = null;

		String receiptNum = ObjUtils.getSafeString(param.get("RECEIPT_NUMS"));
		if(ObjUtils.isNotEmpty(receiptNum)){
			receiptNumArry = receiptNum.split(",");
		}
		String receiptSeq = ObjUtils.getSafeString(param.get("RECEIPT_SEQS"));
		if(ObjUtils.isNotEmpty(receiptSeq)){
			receiptSeqArry = receiptSeq.split(",");
		}
		String itemCodes = ObjUtils.getSafeString(param.get("ITEM_CODES"));
		if(ObjUtils.isNotEmpty(itemCodes)){
			itemCodeArry = itemCodes.split(",");
		}
		List<Map>  receiptNumList = new ArrayList<Map>();
		List<Map>  receiptSeqList = new ArrayList<Map>();
		List<Map>  itemCodeList = new ArrayList<Map>();


		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			//Map map1 = new HashMap();
			Map map2 = new HashMap();

			Object SELECT_RECEIPT_NUM =  receiptNumArry[i] + receiptSeqArry[i];
			//Object SELECT_RECEIPT_SEQ =  receiptSeqArry[i];
			Object SELECT_ITEM_CODES  =  itemCodeArry[i];

			map.put("RECEIPT_NUM", SELECT_RECEIPT_NUM);
			//map1.put("RECEIPT_SEQ", SELECT_RECEIPT_SEQ);
			map2.put("ITEM_CODES", SELECT_ITEM_CODES);

			receiptNumList.add(map);
			//receiptSeqList.add(map1);
			itemCodeList.add(map2);
		}
		param.put("RECEIPT_NUMS", receiptNumList);
	   // param.put("RECEIPT_SEQS", receiptSeqList);
		param.put("SEL_ITEM_CODE", itemCodeList);


		List<Map<String, Object>> report_data =  mms110ukrvService.mainReport(param);

		 cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	siteName = cdo.getCodeName().toUpperCase();
			 }
		 }
		 if(siteName.equals("NOVIS")){//노비스용 쿼리 (ITEM_CODE, LOT_NO별 쿼리
			  report_data = mms120skrvService.printListItemLotGroup2(param);
		  }
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 subReportMap.put("mms210clrkrv_sub", "SQLDS2");
		 subReportMap.put("mms210clrkrv_sub2", "SQLDS2");


		List<Map<String, Object>> subReport_data = mms110ukrvService.subReport(param);
		 if(siteName.equals("MIT")){//엠아이텍용 서브리포트 쿼리
			 subReport_data = mms110ukrvService.mainReport(param);
			 subReportMap.put("mms110clukrv_mit_sub", "SQLDS2");
		 }
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/mms/mms120clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView mms120clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		  CodeDetailVO cdo = null;
		  String siteName = "STANDARD";

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String sDivCode = (String) param.get("DIV_CODE");
		  String crfFile = null;
			if( sDivCode.equals("01")){//사업장이 김천일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}else if(sDivCode.equals("02")){//사업장이 화성일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
			}else{// 그외
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}


			String[] receiptNumArry	= param.get("RECEIPT_NUM").toString().split(",");
			String[] receiptSeqArry	= param.get("RECEIPT_SEQ").toString().split(",");
			String[] printCntArry	= param.get("PRINT_CNT").toString().split(",");



			List<Map> receiptNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_RECEIPT_NUM =  receiptNumArry[i];
				Object SELECT_RECEIPT_SEQ =  receiptSeqArry[i];
				Object SELECT_PRINT_CNT =  printCntArry[i];

				map.put("RECEIPT_NUM", SELECT_RECEIPT_NUM);
				map.put("RECEIPT_SEQ", SELECT_RECEIPT_SEQ);
				map.put("PRINT_CNT", SELECT_PRINT_CNT);

				receiptNumSeqList.add(map);
			}

			param.put("RECEIPT_NUM_SEQ", receiptNumSeqList);


		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = mms120skrvService.printList(param);

		  cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
			 if(ObjUtils.isNotEmpty(cdo)){
				 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 	siteName = cdo.getCodeName().toUpperCase();
				 }
			 }

		  if(siteName.equals("NOVIS")){//노비스용 쿼리 (ITEM_CODE, LOT_NO별
			  report_data = mms120skrvService.printListItemLotGroup(param);
		  }
		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	   }

	@RequestMapping(value = "/mms/mms110clukrv_partition.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms110clukrv_partitionPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= null;
		String sDivCode		= (String) param.get("DIV_CODE");

		//20210616 추가:  출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경
		if(ObjUtils.isNotEmpty(param.get("RPT_INFO"))) {
			crfFile = "Clipreport4/" + ObjUtils.getSafeString(param.get("RPT_INFO"));
		} else {
			if( sDivCode.equals("01")){//사업장이 김천일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}else if(sDivCode.equals("02")){//사업장이 화성일 경우
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
			}else{// 그외
				crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
			}
		}

		String[] SeqArry		= param.get("seqList").toString().split(",");
		String[] printQtyArry	= param.get("PRINT_QTY").toString().split(",");
		String[] packQtyArry	= param.get("PACK_QTY").toString().split(",");

		List<Map> seqList = new ArrayList<Map>();
		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			Object SELECT_SEQ		= SeqArry[i];
			Object SELECT_PACK_QTY	= packQtyArry[i];
			Object SELECT_PRINT_QTY	= printQtyArry[i];

			map.put("PRINT_SEQ"	, SELECT_SEQ);
			map.put("PACK_QTY"	, SELECT_PACK_QTY);
			map.put("PRINT_QTY"	, SELECT_PRINT_QTY);
			seqList.add(map);
		}
		param.put("PRINT_DATA", seqList);

		//Image 경로 
		String imagePath = doc.getImagePath();
		//Main Report
		List<Map<String, Object>> report_data = mms110ukrvService.partitionPrintList(param);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 수입검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mms200clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms200clukrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);


		List<Map<String, Object>> report_data =  mms200ukrvService.mainReport(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		subReportMap.put("mms210clukrv_sub", "SQLDS2");

		List<Map<String, Object>> subReport_data = mms200ukrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);

		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mms510clukrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms510clukrv_label( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		String sDivCode = (String) param.get("DIV_CODE");
		CodeDetailVO cdo = null;
		String siteCode = (String) param.get("GUBUN");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				siteCode = cdo.getCodeName().toUpperCase();
			 }
		 }

		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		if(siteCode.equals("SHIN")){//신환용 후공정 가져오는 로직 적용
			Map paramAfterProg = new HashMap<String, Object>();
			List<Map<String, Object>> report_dataAfterProg =  mms510ukrvService.mainReport_label(param);
			paramAfterProg.put("COMP_CODE", param.get("S_COMP_CODE"));
			paramAfterProg.put("DIV_CODE", sDivCode);
			paramAfterProg.put("SOF_ITEM_CODE", report_dataAfterProg.get(0).get("SOF_ITEM_CODE"));
			paramAfterProg.put("ITEM_CODE", report_dataAfterProg.get(0).get("ITEM_CODE"));
			paramAfterProg.put("ORDER_NUM", report_dataAfterProg.get(0).get("ORDER_NUM"));
			paramAfterProg.put("ORDER_SEQ", report_dataAfterProg.get(0).get("ORDER_SEQ"));
			List<Map<String, Object>> report_dataAfterProg2 =  mms510ukrvService.mainReport_label_afterProg(paramAfterProg);
			if(report_dataAfterProg2.size() > 0){
				param.put("AFTER_PROG_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_NAME"));
				param.put("AFTER_PROG_CUSTOM_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_CUSTOM_NAME"));
			}
		}
		List<Map<String, Object>> report_data =  mms510ukrvService.mainReport_label(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}