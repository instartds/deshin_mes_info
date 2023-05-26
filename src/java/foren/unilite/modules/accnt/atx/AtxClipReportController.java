package foren.unilite.modules.accnt.atx;

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
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.accnt.atx.Atx300ukrServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class AtxClipReportController  extends UniliteCommonController {

	final static String	CRF_PATH	= "/clipreport4/crf/accnt/";
	final static String	CRF_PATH2	= "Clipreport4/Accnt/";

	//20200724 추가
	@Resource( name = "atx110skrService" )
	private Atx110skrServiceImpl atx110skrService;

	//20200728 추가: 세금계산서합계표 (atx130skr)
	@Resource( name = "atx130skrService" )
	private Atx130skrServiceImpl atx130skrService;

	//20200728 추가: 계산서합계표 (atx140skr)
	@Resource( name = "atx140skrService" )
	private Atx140skrServiceImpl atx140skrService;
	
	// 20210726 추가
	@Resource( name = "atx425ukrService" )
	private Atx425ukrServiceImpl atx425ukrService;

	@Resource( name = "atx300ukrService" )
	private Atx300ukrServiceImpl atx300ukrService;
	
	@Resource( name = "atx301ukrService" )
	private Atx301ukrServiceImpl atx301ukrService;
	
	@Resource( name = "atx315ukrService" )
	private Atx315ukrServiceImpl atx315ukrService;	
	
	@Resource( name = "atx330ukrService" )
	private Atx330ukrServiceImpl atx330ukrService;		

	@Resource( name = "atx326rkrService" )
	private Atx326rkrServiceImpl atx326rkrService;
	
	// 20210726 추가
	@Resource( name = "atx450rkrService" )
	private Atx450rkrServiceImpl atx450rkrService;
	
	// 20210726 추가
	@Resource( name = "atx460ukrService" )
	private Atx460ukrServiceImpl atx460ukrService;

	//20200624 추가
	@Resource( name = "atx470ukrService" )
	private Atx470ukrServiceImpl atx470ukrService;

	@Resource( name = "atx500rkrService" )
	private Atx500rkrServiceImpl atx500rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	/**
	 * 매입매출장 출력 (atx110skr) - 20200724 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx110clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx110clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = atx110skrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 세금계산서합계표 (atx130skr) - 20200728 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx130clskrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx130clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = atx130skrService.fnAtx130QRp1(param);

		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("ATX130SKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = atx130skrService.selectPrintList(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 계산서합계표 (atx140skr) - 20200728 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx140clskrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx140clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = atx130skrService.fnAtx130QRp1(param);

		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("ATX140SKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = atx140skrService.selectPrintList(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/atx300clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx300clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"atx300clukr.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data = atx300ukrService.dataCheck(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("atx300sub1", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = atx300ukrService.mainCheck(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/accnt/atx301clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx301clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"atx301clukr.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data = atx301ukrService.dataCheck(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("atx300sub1", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = atx301ukrService.mainCheck(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/accnt/atx315clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx315clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"atx315clukr.crf";

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data = atx315ukrService.selectPrint(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}	

	@RequestMapping(value = "/accnt/atx330clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx330clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"atx330clukr.crf";

		//Image 경로 
		String imagePath = doc.getImagePath();		

		List<Map<String, Object>> report_data = atx330ukrService.selectPrint(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	@RequestMapping(value = "/accnt/atx326clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx326clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		String crfFile = "";
		String resultKey = "";
		
		if(param.containsKey("PROOF_KIND") && (("E").equals(param.get("PROOF_KIND")) || ("F").equals(param.get("PROOF_KIND")))) {
			crfFile = CRF_PATH2 + "atx326clrkrv2.crf";

			List<Map<String, Object>> report_data = atx326rkrService.selectPrintList2(param);
			resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		}
		else {
			crfFile = CRF_PATH2 + "atx326clrkrv.crf";

			List<Map<String, Object>> report_data = atx326rkrService.selectPrintList1(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("리포트1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = atx326rkrService.selectPrintDetail1(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		}
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/atx326clrkrv2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx326clrkrv2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + "atx326clrkrv2.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data = atx326rkrService.selectPrintList2(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/accnt/atx450clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx450clukr(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		param.put("DECLARE_DATE", param.get("FR_PUB_DATE").toString().substring(0, 4));
        int term = Integer.valueOf(param.get("TO_PUB_DATE").toString().substring(4, 6));
        param.put("sGisu", term > 7 ? "2" : "1");
		
		//Main Report
		List<Map<String, Object>> report_data = atx450rkrService.selectList1(param);


		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = atx450rkrService.selectList2(param);
		subReportMap.put("DATA_SET", "List2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = atx450rkrService.selectList3(param);
		subReportMap2.put("DATA_SET", "List3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);
		
		//SUB REPORT 3
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = atx450rkrService.selectList4(param);
		subReportMap3.put("DATA_SET", "List4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);
		
		//SUB REPORT 4
		Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data4 = atx450rkrService.selectList5(param);
		subReportMap4.put("DATA_SET", "List5");
		subReportMap4.put("SUB_DATA", subReport_data4);
		subReports.add(subReportMap4);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "List1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 건물등 감가상각자산 취득명세서(합계표) - 20210726 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx420clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx420clukr(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = atx425ukrService.selectListTo420Print(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 건물등 감가상각자산 취득명세서(명세서) - 20210726 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx425clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx425clukr(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID6"));
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data = atx425ukrService.selectListTo425Print(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("atx425sub", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = atx425ukrService.selectListTo425PrintSub1(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 사업자 단위 과세 사업장 별 부가가치세 과세표 - 20210726 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx460clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx460clukr(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = atx460ukrService.selectListToPrint(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고명세서 (atx470ukr) - 20200624 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/atx470clukr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx470clukr(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = atx470ukrService.selectListPrint(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/atx500clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView atx500clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		String crfFile = CRF_PATH2 + "atx500clrkrv.crf";
		
		List<Map<String, Object>> report_data = atx500rkrService.selectPrintMaster(param);
		
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("SUB_REPORT", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = atx500rkrService.selectPrintDetail(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}