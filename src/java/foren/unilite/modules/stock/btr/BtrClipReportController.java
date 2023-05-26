package foren.unilite.modules.stock.btr;

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
import foren.unilite.modules.stock.btr.Btr111ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class BtrClipReportController extends UniliteCommonController {
	final static String CRF_PATH = "Clipreport4/Stock/";

	@InjectLogger
	public static Logger logger;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Stock";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "btr111ukrvService" )
	private Btr111ukrvServiceImpl btr111ukrvService;

	//20201207 추가
	@Resource( name = "btr130rkrvService" )
	private Btr130rkrvServiceImpl btr130rkrvService;

	//20201130 추가
	@Resource( name = "btr160rkrvService" )
	private Btr160rkrvServiceImpl btr160rkrvService;


	@RequestMapping(value = "/btr/btr111clukrv_partition.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView btr111clukrv_partitionPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String sDivCode = (String) param.get("DIV_CODE");
		String crfFile = null;
//		if( sDivCode.equals("01")){//사업장이 김천일 경우
//			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
//		}else if(sDivCode.equals("02")){//사업장이 화성일 경우
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
//		}else{// 그외
//			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
//		}
		String[] SeqArry		= param.get("seqList").toString().split(",");
		String[] printQtyArry	= param.get("PRINT_QTY").toString().split(",");
		String[] packQtyArry	= param.get("PACK_QTY").toString().split(",");

		List<Map> seqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map					= new HashMap();
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
		List<Map<String, Object>> report_data = btr111ukrvService.partitionPrintList(param);

		//String resultKey = doc.generateReport(crfFile, connectionName, datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/btr/btr111clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView btr111clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String sDivCode	= (String) param.get("DIV_CODE");
		String crfFile	= null;

		if( sDivCode.equals("01")){//사업장이 김천일 경우
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
		}else if(sDivCode.equals("02")){//사업장이 화성일 경우
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
		}else{// 그외
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
		}

		//Image 경로 
		String imagePath = doc.getImagePath();
		param.put("USER_NAME", user.getUserName());
		//Main Report
		List<Map<String, Object>> report_data = btr111ukrvService.printList(param);

		//String resultKey = doc.generateReport(crfFile, connectionName, datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 재고이동명세서 출력 (btr130rkrv) - 20201207 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/btr/btr130clrkrv.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView btr130clrkrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("inoutInfo"))) {
			String[] inoutInfoArry	= param.get("inoutInfo").toString().split(",");
			List<Map> inoutInfoList	= new ArrayList<Map>();
	
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("INOUT_INFO", inoutInfoArry[i]);
				inoutInfoList.add(map);
			}
			param.put("INOUT_INFO_LIST"	, inoutInfoList);
		}

		//Main Report
		List<Map<String, Object>> report_data = btr130rkrvService.selectMasterList(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = btr130rkrvService.selectDetailList(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);
/*
		//추가 SUB Report 있을 때,
		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = s_mba200rkrv_wmService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);

		//SUB REPORT 3
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = s_mba200rkrv_wmService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 재고이동요청현황 출력 (btr160rkrv) - 20201130 추가, 20210128 수정: 재고이동요청 등록 (btr101ukrv)에서 출력 기능 같이 사용
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/btr/btr160rkrv.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView btr160clrkrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//20210128 수정: 재고이동요청 등록 (btr101ukrv)에서 출력 기능 같이 사용하기 위해 로직 수정
		if(ObjUtils.isNotEmpty(param.get("reqInfo"))) {
			String[] reqInfoArry	= param.get("reqInfo").toString().split(",");
			List<Map> reqInfoList	= new ArrayList<Map>();
	
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("REQ_INFO", reqInfoArry[i]);
				reqInfoList.add(map);
			}
			param.put("REQ_INFO_LIST"	, reqInfoList);
		}
		param.put("PRINT_FLAG"		, "Y");

		//Main Report
		List<Map<String, Object>> report_data = btr160rkrvService.selectMasterList(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = btr160rkrvService.selectList(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);
/*
		//추가 SUB Report 있을 때,
		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = s_mba200rkrv_wmService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);

		//SUB REPORT 3
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = s_mba200rkrv_wmService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}