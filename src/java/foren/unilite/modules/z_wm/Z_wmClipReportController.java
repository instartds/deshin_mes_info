package foren.unilite.modules.z_wm;

import java.sql.ResultSet;
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

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_wmClipReportController	extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String CRF_PATH	= "Clipreport4/Z_wm/";
	final static String CRF_PATH2	= "Clipreport4/matrl/";		//20210222 추가: 정규 path 추가

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@Resource(name = "s_esa100rkrv_wmService")					//20201203 추가: A/S접수등록(WM) (s_esa100ukrv_wm)의 AS요청서, A/S접수현황/출력(WM) (s_esa100rkrv_wm)
	private S_Esa100rkrv_wmServiceImpl s_esa100rkrv_wmService;

	@Resource(name = "s_esa100ukrv_wmService")					//20210119 추가: A/S접수등록(WM) (s_esa100ukrv_wm) 운송장 출력
	private S_Esa100ukrv_wmServiceImpl s_esa100ukrv_wmService;

	@Resource(name = "s_map110skrv_wmService")					//20210222 추가: 외상매입현황 조회(WM) (s_map110skrv_wm) 
	private S_Map110skrv_wmServiceImpl s_map110skrv_wmService;

	@Resource(name = "s_mba200rkrv_wmService")					//20201013 추가: 견적서 출력(WM) (s_mba200rkrv_wm)
	private S_Mba200rkrv_wmServiceImpl s_mba200rkrv_wmService;

	@Resource(name = "s_mms200ukrv_wmService")					//20201021 추가: 검사등록(WM) (s_mms200ukrv_wm) - 검사결과서 출력
	private S_Mms200ukrv_wmServiceImpl s_mms200ukrv_wmService;

	@Resource(name = "s_mms510ukrv_wmService")					//20210415 추가: 입고등록(WM) (s_mms510ukrv_wm) - 매입명세표 출력
	private S_Mms510ukrv_wmServiceImpl s_mms510ukrv_wmService;

	@Resource(name = "s_mms520ukrv_wmService")					//20210209 추가: 매입 등록(WM) (s_mms520ukrv_wm) - 매입명세표 출력
	private S_Mms520ukrv_wmServiceImpl s_mms520ukrv_wmService;

	@Resource(name = "s_mpo015ukrv_wmService")					//20210331 추가: 매입접수(개인)(WM) (s_mpo015ukrv_wm)
	private S_Mpo015ukrv_wmServiceImpl s_mpo015ukrv_wmService;

	@Resource(name = "s_pmp110rkrv_wmService")					//20201019 추가: 작업지시서 출력(WM) (s_pmp110rkrv_wm)
	private S_Pmp110rkrv_wmServiceImpl s_pmp110rkrv_wmService;

	@Resource(name = "s_srq100ukrv_wmService")					//20201223 추가: 출하지시등록(WM) (s_srq100ukrv_wm) - 출하지시서, 운송장 출력 관련
	private S_Srq100ukrv_wmServiceImpl s_srq100ukrv_wmService;



	/**
	 * A/S접수등록(WM) (s_esa100ukrv_wm)의 AS요청서, A/S접수현황/출력(WM) (s_esa100rkrv_wm) - 20201203 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_esa100clrkrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_esa100clrkrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("AsInfo"))) {
			String[] AsInfoArry		= param.get("AsInfo").toString().split(",");
			List<Map> AsInfoList	= new ArrayList<Map>();
	
			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				map.put("AS_INFO", AsInfoArry[i]);
				AsInfoList.add(map);
			}
			param.put("AS_INFO_LIST", AsInfoList);
		}

		//Main Report
		List<Map<String, Object>> report_data = s_esa100rkrv_wmService.printASMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_esa100rkrv_wmService.printASDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = s_esa100rkrv_wmService.printASOutLineData(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * A/S접수등록(WM) (s_esa100ukrv_wm) (운송장) - 20210119 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_esa100clukrv_wm(C).do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_esa100clukrv_wm_C(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report 데이터 정제
		List<Map<String, Object>> report_data = s_esa100ukrv_wmService.getData(param);
		if(report_data != null) {
			for(Map data: report_data) {
				data.put("P_CLNTNUM"		, "30292070");
				data.put("P_CLNTMGMCUSTCD"	, "30292070");
				data.put("P_PRNGDIVCD"		, "01");
				data.put("P_CGOSTS"			, "91");
				Map<String, Object> cjAddress = s_pmp110rkrv_wmService.printCarriageBillData(data);
				if(ObjUtils.isNotEmpty(cjAddress)) {
					if("0".equals(cjAddress.get("P_ERRORCD"))) {		//정제성공일 경우
						data.put("P_CLSFADDR"		, (String) cjAddress.get("P_CLSFADDR"));										//주소약칭
						data.put("P_CLLDLVBRANNM"	, (String) cjAddress.get("P_CLLDLVBRANNM"));									//배송집배점명
						data.put("P_CLLDLVEMPNM"	, (String) cjAddress.get("P_CLLDLVEMPNM"));										//배송SM명
						data.put("P_CLLDLVEMPNICKNM", (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//SM분류코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD"));											//도착지코드
						data.put("P_SUBCLSFCD"		, (String) cjAddress.get("P_SUBCLSFCD"));										//도착지서브코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD") + (String) cjAddress.get("P_SUBCLSFCD"));	//분류코드
						data.put("P_19"				, (String) cjAddress.get("P_CLLDLCBRANSHORTNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//배달점소+배송사원+별칭
					} else {											//정제성공일 경우
						logger.debug(">>>>>>> 정제데이터를 가지고 올 수 없습니다.: " + cjAddress.get("P_ERRORMSG"));
					}
				}
			}
		}
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 외상매입현황 조회(WM) (s_map110skrv_wm) - 20210222 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_map110clskrv_wm.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView map110clskrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		List<Map<String, Object>> report_data = s_map110skrv_wmService.selectMainReportList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 견적서 출력(WM) (s_mba200rkrv_wm) - 20201013 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba200clrkrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_mba200clrkrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] receipInfoArry		= param.get("receipInfo").toString().split(",");
		List<Map> receipInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("RECEIP_INFO", receipInfoArry[i]);
			receipInfoList.add(map);
		}
		param.put("RECEIP_INFO_LIST", receipInfoList);

		//Main Report
		List<Map<String, Object>> report_data = s_mba200rkrv_wmService.printMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_mba200rkrv_wmService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

/*		//추가 SUB Report 있을 때,
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
*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 검사등록(WM) (s_mms200ukrv_wm) - 검사결과서 출력: 20201021 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mms200clukrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_mms200clukrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//20210104 추가: 화면 로직 전체 변경으로 출력로직도 변경
		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("WORK_ORDER_INFO", workOrderInfoArry[i]);
			workOrderInfoList.add(map);
		}
		param.put("WORK_ORDER_LIST", workOrderInfoList);

		//Main Report
		List<Map<String, Object>> report_data = s_mms200ukrv_wmService.printMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_mms200ukrv_wmService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 매입 등록(WM) (s_mms520ukrv_wm) - 매입명세표 출력: 20210209 추가
	 * 매입접수등록(개인) (WM), 입고등록(WM) 같이 사용하도록 수정 - 20210415 수정
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mms520clukrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_mms520clukrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report, 매입접수등록(개인) (WM), 입고등록(WM) 같이 사용하도록 수정 - 20210415 수정
		List<Map<String, Object>> report_data = new ArrayList<Map<String, Object>>();;
		if(ObjUtils.isEmpty(param.get("CALL_PGM"))) {
			report_data = s_mms520ukrv_wmService.printMasterData(param);
		} else if("s_mpo015ukrv_wm".equals(param.get("CALL_PGM"))) {
			report_data = s_mpo015ukrv_wmService.printMasterData2(param);
		} else if("s_mms510ukrv_wm".equals(param.get("CALL_PGM"))) {
			report_data = s_mms510ukrv_wmService.printMasterData(param);
		}

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String, Object>();

		//SUB REPORT 1, 매입접수등록(개인) (WM), 입고등록(WM) 같이 사용하도록 수정 - 20210415 수정
		List<Map<String, Object>> subReport_data1 = new ArrayList<Map<String, Object>>();;
		if(ObjUtils.isEmpty(param.get("CALL_PGM"))) {
			subReport_data1 = s_mms520ukrv_wmService.printDetailData(param);
		} else if("s_mpo015ukrv_wm".equals(param.get("CALL_PGM"))) {
			subReport_data1 = s_mpo015ukrv_wmService.printDetailData2(param);
		} else if("s_mms510ukrv_wm".equals(param.get("CALL_PGM"))) {
			subReport_data1 = s_mms510ukrv_wmService.printDetailData(param);
		}
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 매입접수(개인)(WM) (s_mpo015ukrv_wm) - 20210331 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpo015clukrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_mpo015clukrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = s_mpo015ukrv_wmService.printMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_mpo015ukrv_wmService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 작업지시서 출력(WM) (s_pmp110rkrv_wm) (작업지시서) - 20201019 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmp110clrkrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_pmp110clrkrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("WORK_ORDER_INFO", workOrderInfoArry[i]);
			workOrderInfoList.add(map);
		}
		param.put("WORK_ORDER_LIST", workOrderInfoList);

		//Main Report
		List<Map<String, Object>> report_data = s_pmp110rkrv_wmService.printMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_pmp110rkrv_wmService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 작업지시서 출력(WM) (s_pmp110rkrv_wm) (운송장) - 20201112 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmp110clrkrv_wm(C).do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_pmp110clrkrv_wm_C(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++) {
			Map map = new HashMap();
			map.put("WORK_ORDER_INFO", workOrderInfoArry[i]);
			workOrderInfoList.add(map);
		}
		param.put("WORK_ORDER_LIST", workOrderInfoList);

		//Main Report 데이터 정제
		List<Map<String, Object>> report_data = s_pmp110rkrv_wmService.getData(param);
		if(report_data != null) {
			for(Map data: report_data) {
				data.put("P_CLNTNUM"		, "30292070");
				data.put("P_CLNTMGMCUSTCD"	, "30292070");
				data.put("P_PRNGDIVCD"		, "01");
				data.put("P_CGOSTS"			, "91");
				Map<String, Object> cjAddress = s_pmp110rkrv_wmService.printCarriageBillData(data);
				if(ObjUtils.isNotEmpty(cjAddress)) {
					if("0".equals(cjAddress.get("P_ERRORCD"))) {		//정제성공일 경우
						data.put("P_CLSFADDR"		, (String) cjAddress.get("P_CLSFADDR"));										//주소약칭
						data.put("P_CLLDLVBRANNM"	, (String) cjAddress.get("P_CLLDLVBRANNM"));									//배송집배점명
						data.put("P_CLLDLVEMPNM"	, (String) cjAddress.get("P_CLLDLVEMPNM"));										//배송SM명
						data.put("P_CLLDLVEMPNICKNM", (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//SM분류코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD"));											//도착지코드
						data.put("P_SUBCLSFCD"		, (String) cjAddress.get("P_SUBCLSFCD"));										//도착지서브코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD") + (String) cjAddress.get("P_SUBCLSFCD"));	//분류코드
						data.put("P_19"				, (String) cjAddress.get("P_CLLDLCBRANSHORTNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//배달점소+배송사원+별칭
					} else {											//정제성공일 경우
						logger.debug(">>>>>>> 정제데이터를 가지고 올 수 없습니다.: " + cjAddress.get("P_ERRORMSG"));
					}
				}
			}
		}

//		//Sub Report use data
//		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
//
//		//SUB REPORT 1
//		List<Map<String, Object>> subReport_data1 = s_pmp110rkrv_wmService.printDetailData(param);
//		subReportMap.put("DATA_SET", "SQLDS2");
//		subReportMap.put("SUB_DATA", subReport_data1);
//		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 작업지시서 출력(WM) (s_pmp110rkrv_wm) (라벨) - 20201102 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmp110clrkrv_wm(L).do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_pmp110clrkrv_wm_L(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] workOrderInfoArry	= param.get("workOrderInfo").toString().split(",");
		List<Map> workOrderInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("WORK_ORDER_INFO", workOrderInfoArry[i]);
			workOrderInfoList.add(map);
		}
		param.put("WORK_ORDER_LIST", workOrderInfoList);

		//Main Report
		List<Map<String, Object>> report_data = s_pmp110rkrv_wmService.printLabelData(param);

//		//Sub Report use data
//		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
//
//		//SUB REPORT 1
//		List<Map<String, Object>> subReport_data1 = s_pmp110rkrv_wmService.printDetailData(param);
//		subReportMap.put("DATA_SET", "SQLDS2");
//		subReportMap.put("SUB_DATA", subReport_data1);
//		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 출하지시등록(WM) (s_srq100ukrv_wm) 출하지시서 출력 - 20201223 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_srq100clukrv_wm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_srq100clukrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] orderReqInfoArry	= param.get("orderReqInfo").toString().split(",");
		List<Map> orderReqInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++) {
			Map map = new HashMap();
			map.put("ORDER_REQ_INFO", orderReqInfoArry[i]);
			orderReqInfoList.add(map);
		}
		param.put("ORDER_REQ_LIST", orderReqInfoList);

		//Main Report
		List<Map<String, Object>> report_data = s_srq100ukrv_wmService.orderReqMPrintList(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_srq100ukrv_wmService.orderReqPrintList(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

/*		//추가 SUB Report 있을 때,
		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = s_srq100ukrv_wmService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);

		//SUB REPORT 3
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = s_srq100ukrv_wmService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);
*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 출하지시등록(WM) (s_srq100ukrv_wm) 운송장 출력 - 20201223 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_srq100clukrv_wm(C).do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_srq100clukrv_wm_C(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] orderReqInfoArry	= param.get("orderReqInfo").toString().split(",");
		List<Map> orderReqInfoList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++) {
			Map map = new HashMap();
			map.put("ORDER_REQ_INFO", orderReqInfoArry[i]);
			orderReqInfoList.add(map);
		}
		param.put("ORDER_REQ_LIST", orderReqInfoList);

		//Main Report 데이터 정제
		List<Map<String, Object>> report_data = s_srq100ukrv_wmService.getData(param);
		if(report_data != null) {
			for(Map data: report_data) {
				data.put("P_CLNTNUM"		, "30292070");
				data.put("P_CLNTMGMCUSTCD"	, "30292070");
				data.put("P_PRNGDIVCD"		, "01");
				data.put("P_CGOSTS"			, "91");
				Map<String, Object> cjAddress = s_srq100ukrv_wmService.printCarriageBillData(data);
				if(ObjUtils.isNotEmpty(cjAddress)) {
					if("0".equals(cjAddress.get("P_ERRORCD"))) {		//정제성공일 경우
						data.put("P_CLSFADDR"		, (String) cjAddress.get("P_CLSFADDR"));										//주소약칭
						data.put("P_CLLDLVBRANNM"	, (String) cjAddress.get("P_CLLDLVBRANNM"));									//배송집배점명
						data.put("P_CLLDLVEMPNM"	, (String) cjAddress.get("P_CLLDLVEMPNM"));										//배송SM명
						data.put("P_CLLDLVEMPNICKNM", (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//SM분류코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD"));											//도착지코드
						data.put("P_SUBCLSFCD"		, (String) cjAddress.get("P_SUBCLSFCD"));										//도착지서브코드
						data.put("P_CLSFCD"			, (String) cjAddress.get("P_CLSFCD") + (String) cjAddress.get("P_SUBCLSFCD"));	//분류코드
						data.put("P_19"				, (String) cjAddress.get("P_CLLDLCBRANSHORTNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNM") + "-"
													+ (String) cjAddress.get("P_CLLDLVEMPNICKNM"));									//배달점소+배송사원+별칭
					} else {											//정제성공일 경우
						logger.debug(">>>>>>> 정제데이터를 가지고 올 수 없습니다.: " + cjAddress.get("P_ERRORMSG"));
					}
				}
			}
		}

//		//Sub Report use data
//		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
//
//		//SUB REPORT 1
//		List<Map<String, Object>> subReport_data1 = s_pmp110rkrv_wmService.printDetailData(param);
//		subReportMap.put("DATA_SET", "SQLDS2");
//		subReportMap.put("SUB_DATA", subReport_data1);
//		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}