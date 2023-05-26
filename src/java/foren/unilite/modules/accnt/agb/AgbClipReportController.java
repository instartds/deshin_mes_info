package foren.unilite.modules.accnt.agb;

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
import foren.unilite.modules.com.report.ReportUtils;
import foren.framework.logging.InjectLogger;
import foren.unilite.modules.accnt.agb.Agb125rkrvServiceImpl;
import foren.unilite.modules.accnt.agb.Agb110skrServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class AgbClipReportController  extends UniliteCommonController {
	public static Logger logger;
	
	final static String CRF_PATH	= "Clipreport4/Accnt/";
	final static String CRF_PATH2	= "/clipreport4/crf/accnt/";

	//총계정원장 클립레포트(agb100rkr)  - 20200811 추가
	@Resource( name = "agb100skrService" )
	private Agb100skrServiceImpl agb100skrService;
	
	@Resource( name = "agb110skrService" )
	private Agb110skrServiceImpl agb110skrService;

	//일계표 출력 (agb120rkr) - 20200724 추가
	@Resource( name = "agb120skrService" )
	private Agb120skrServiceImpl agb120skrService;

	@Resource( name = "agb125rkrvService" )
	private Agb125rkrvServiceImpl agb125rkrvService;

	@Resource( name = "agb130rkrService" )
	private Agb130rkrServiceImpl agb130rkrService;

	@Resource( name = "agb140rkrService" )
	private Agb140rkrServiceImpl agb140rkrService;

	@Resource( name = "agb150rkrService" )
	private Agb150rkrServiceImpl agb150rkrService;

	//미결현황출력 (agb160rkr) - 20200803 추가
	@Resource( name = "agb160skrService" )
	private Agb160skrServiceImpl agb160skrService;

	//미결현황출력(2) (agb160rkr) - 20200804 추가
	@Resource( name = "agb165rkrService" )
	private Agb165rkrServiceImpl agb165rkrService;
	
	@Resource( name = "agb180rkrService" )
	private Agb180rkrServiceImpl agb180rkrService;	
	
	@Resource( name = "agb190rkrService" )
	private Agb190rkrServiceImpl agb190rkrService;		

	//거래처별집계표출력 (agb200rkr) - 20200727 추가
	@Resource( name = "agb200skrService" )
	private Agb200skrServiceImpl agb200skrService;

	//거래처별원장 출력 (agb210rkr) - 20200727 추가
	@Resource( name = "agb210skrService" )
	private Agb210skrServiceImpl agb210skrService;

	//계정별거래처원장 출력 (agb240rkr) - 20200723 추가
	@Resource( name = "agb240skrService" )
	private Agb240skrServiceImpl agb240skrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/accnt/agb100clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb100clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb100clrkr.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agb100skrService.selectList(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/accnt/agb110clrkr_1.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb110clrkr_1Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb110clrkr_1.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agb110skrService.selectListTo110rkrPrint(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agb110clrkr_2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb110clrkr_2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb110clrkr_2.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agb110skrService.selectListTo110rkrPrint(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agb110clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb110clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb110clrkr_1.crf";
		
		if("2".equals(param.get("RPT_SIZE"))) {
			crfFile = CRF_PATH + "agb110clrkr_2.crf";
		}
		/*if(param.get("RPT_SIZE").equals("2")) {
			crfFile = CRF_PATH + "agb110clrkr_2.crf";
		}*/
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agb110skrService.selectListTo110rkrPrint(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/*
	 * 보조원장 출력 (agb111rkr) - 20200910 추가
	 */
	@RequestMapping(value = "/accnt/agb111clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb111clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb111clrkr.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agb110skrService.selectListTo111rkrPrint(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 일계표 출력 (agb120rkr) - 20200724 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb120clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb120clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}
		//Main Report
		List<Map<String, Object>> report_data = agb120skrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agb125clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb125clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		
		//ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String crfFile = CRF_PATH+"agb125clrkrv.crf";

		List<Map<String, Object>> report_data = agb125rkrvService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 계정명세출력 (agb130rkr) - 20200803 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb130clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb130clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "agb130clrkr_1.crf";
		
		if("2".equals(param.get("RPT_SIZE"))) {
			crfFile = CRF_PATH + "agb130clrkr_2.crf";
		}
		
		if(ObjUtils.isNotEmpty(param.get("DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("DIV_CODE", divList);
		}

		List<Map<String, Object>> report_data = agb130rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 계정명세출력 (agb140rkr) - 20200728 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb140clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb140clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH+"agb140clrkr.crf";
		
		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}

		List<Map<String, Object>> report_data = agb140rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 계정명세출력(화폐단위별) (agb150rkr) - 20200729 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb150clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb150clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		
		param.put("PGM_ID", "agb150skr");
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH+"agb150clrkr.crf";
		
		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}		

		List<Map<String, Object>> report_data = agb150rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agb151clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb151clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH+"agb151clrkr.crf";

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}

		List<Map<String, Object>> report_data = agb150rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}	

	/**
	 * 미결현황출력 (agb160rkr) - 20200803 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb160clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb160clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}

		List<Map<String, Object>> report_data = agb160skrService.fnAgb160QRpt(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 미결현황출력(2) (agb165rkr) - 20200804 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb165clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb165clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("DIV_CODE", divList);
		}
		List<Map<String, Object>> report_data = agb165rkrService.selectClList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 관리항목별집계출력 (agb180rkr) - 20200804 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb180clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb180clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH+"agb180clrkr.crf";
		
		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}		

		List<Map<String, Object>> report_data = agb180rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}	
	
	@RequestMapping(value = "/accnt/agb181clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb181clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH+"agb181clrkr.crf";
		
		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}		

		List<Map<String, Object>> report_data = agb180rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}	

	
	/**
	 * 관리항목별원장출력 (agb190rkr) - 20200805 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb190clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb190clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH+"agb190clrkr.crf";
		
		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}		

		List<Map<String, Object>> report_data = agb190rkrService.selectList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}		
	/**
	 * 거래처별집계표출력 (agb200rkr) - 20200727 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb200clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb200clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}
		//Main Report
		List<Map<String, Object>> report_data = agb200skrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 거래처별원장 출력 (agb210rkr) - 20200727 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb210clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb210clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";

		if("A".equals(param.get("OUTPUT_TYPE"))) {		//출력형식이 세로이면
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		} else {									//출력형식이 가로이면
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
		}
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}
		//Main Report
		List<Map<String, Object>> report_data = agb210skrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 계정별거래처원장 출력 (agb240rkr) - 20200723 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb240clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agb240clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE"	, divList);
		}
		//Main Report
		List<Map<String, Object>> report_data = agb240skrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}