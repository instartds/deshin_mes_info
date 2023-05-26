package foren.unilite.modules.sales.str;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.str.Str400rkrvServiceImpl;
import foren.unilite.modules.sales.str.Str410skrvServiceImpl;
import foren.unilite.modules.sales.str.Str800ukrvServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class StrClipReportController	extends UniliteCommonController {

	final static String		CRF_PATH		= "/clipreport4/crf/human/";
	final static String		CRF_PATH2		= "Clipreport4/Sales/";
	final static String		CRF_PATH3		= "/clipreport4/Prodt/";		//20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
	final static String		CRF_PATH_S		= "Clipreport4/";
	 private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource( name = "str103ukrvService" )									//20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
	private Str103ukrvServiceImpl str103ukrvService;

	@Resource( name = "str105ukrvService" )
	private Str105ukrvServiceImpl str105ukrvService;

	@Resource( name = "str400rkrvServiceImpl" )
	private Str400rkrvServiceImpl str400rkrvService;

	@Resource( name = "str410skrvService" )
	private Str410skrvServiceImpl str410skrvService;

	@Resource( name = "str411ukrvService" )									//20200423 추가: 전자거래명세서 출력을 위해
	private Str411ukrvServiceImpl str411ukrvService;
	
	@Resource( name = "str414skrvService" )
	private Str414skrvServiceImpl str414skrvService;

	@Resource( name = "str800ukrvService" )
	private Str800ukrvServiceImpl str800ukrvService;

	@Resource( name = "str800skrvService" )
	private Str800skrvServiceImpl str800skrvService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

		/**
		 * 라벨출력  - 출고 등록 (건별) (str103ukrv) 20200311 추가: 라벨출력 컬럼 추가에 따른 로직 신규 추가 - 신환코스텍
		 * @param _req
		 * @param user
		 * @param reportType
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/sales/str103clukrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
		public ModelAndView str103clukrv_label(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			ClipReportDoc doc		= new ClipReportDoc();
			Map param				= _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);

			param.put("COMP_CODE", param.get("S_COMP_CODE"));
			List<Map<String, Object>> report_data = null;
			String resultKey		= "";
			String crfFile			= "";
			String connectionName	= "";
			String datasetName		= "";
			String sDivCode			= (String) param.get("DIV_CODE");
			String gubun			= (String) param.get("GUBUN");
			ServletContext context	= request.getServletContext();
			String path				= context.getRealPath("/");
			String imagePathFirst	= path.split(":")[0] + ":" ;

			crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID3"));

			param.put("IMAGE_PATH_FIRST", imagePathFirst);
			param.put("PAGE_START"		, 1);

			if(gubun.equals("SHIN")){					//신환용 라벨 후공정 가져오는 로직 적용
				Map paramAfterProg	= new HashMap<String, Object>();
				String labelType	= (String) param.get("LABEL_TYPE");

				if(labelType.equals("1")){				//사출
					 crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID3"));
				}else if(labelType.equals("2")){		//라벨1
					 crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID4"));
				}else if(labelType.equals("3")){		//라벨2
					 crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID5"));
				}else {									//제품표준 양식
					 crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID6"));
				}
				String fromCnt	= String.valueOf(param.get("LABEL_QTY"));
				String toCnt	= String.valueOf(param.get("LABEL_QTY2"));
				int printQty	= Integer.parseInt(toCnt) - Integer.parseInt(fromCnt) + 1;
				param.put("PRINT_CNT"	, printQty);
				param.put("PAGE_START"	, fromCnt);

				report_data =  str103ukrvService.mainReport_label(param);
//				if(param.get("LABEL_LOC").equals("PMP")){//작업지시 라벨인 경우
//					report_data	=  str103ukrvService.mainReport_label(param);
////					report_data	=  str103ukrvService.mainReport_basicLabel(param);
//				}
				paramAfterProg.put("COMP_CODE"		, param.get("S_COMP_CODE"));
				paramAfterProg.put("DIV_CODE"		, sDivCode);
				paramAfterProg.put("SOF_ITEM_CODE"	, report_data.get(0).get("SOF_ITEM_CODE"));
				paramAfterProg.put("ITEM_CODE"		, report_data.get(0).get("ITEM_CODE"));
				paramAfterProg.put("ORDER_NUM"		, report_data.get(0).get("ORDER_NUM"));
				paramAfterProg.put("ORDER_SEQ"		, report_data.get(0).get("ORDER_SEQ"));
				List<Map<String, Object>> report_dataAfterProg2 = str103ukrvService.mainReport_label_afterProg(paramAfterProg);
				if(report_dataAfterProg2.size() > 0){
					param.put("AFTER_PROG_NAME"			, report_dataAfterProg2.get(0).get("AFTER_PROG_NAME"));
					param.put("AFTER_PROG_CUSTOM_NAME"	, report_dataAfterProg2.get(0).get("AFTER_PROG_CUSTOM_NAME"));
				}
			}else{
				report_data =  str103ukrvService.mainReport_label(param);
			}

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
//			String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success", "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
		}

		/**
		 * 기본거래명세서 (str400clrkr)
		 * @param _req
		 * @param user
		 * @param reportType
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/sales/str400clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
		public ModelAndView str400clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();

		String crfFile = CRF_PATH2+"str400clrkrv.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = str400rkrvService.mainReport(param);

		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR400RKRV2_01", "SQLDS2");
		subReportMap.put("STR400RKRV2_02", "SQLDS2");
		subReportMap.put("STR400RKRV2_03", "SQLDS2");
		subReportMap.put("STR400RKRV2_04", "SQLDS2");
		subReportMap.put("STR400RKRV2_05", "SQLDS2");

		/* List<Map<String, Object>> subReport_data = str400rkrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);*/

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

		/**
		 * 기본거래명세서 (str410clskrv)
		 * @param _req
		 * @param user
		 * @param reportType
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/sales/str410clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
		public ModelAndView str410clskrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			ClipReportDoc doc = new ClipReportDoc();
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);
			//20210311 로직 수정
			String crfFile = "";
			if(ObjUtils.isEmpty(param.get("PATH"))) {
				crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID5"));
			} else {
				crfFile = CRF_PATH_S + param.get("PATH");
			}
			ReportUtils.clipReportLogoPath(param, dao, request);
			ReportUtils.clipReportSteampPath(param, dao, request);
			//Image 경로
			String imagePath = doc.getImagePath();

			//Report use data
			List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("STR410SKRV2_01", "SQLDS2");
			subReportMap.put("STR410SKRV2_02", "SQLDS2");
			subReportMap.put("STR410SKRV2_03", "SQLDS2");
			subReportMap.put("STR410SKRV2_04", "SQLDS2");
			subReportMap.put("STR410SKRV2_05", "SQLDS2");

			List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
			String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success", "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
		}

		/**
		 * 전자거래명세서 출력 (str411clukrv) - 20200423 추가
		 * @param _req
		 * @param user
		 * @param reportType
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/sales/str411clukrv.do", method = {RequestMethod.GET, RequestMethod.POST})
		public ModelAndView str411clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			ClipReportDoc doc	= new ClipReportDoc();
			Map param			= _req.getParameterMap();
			ReportUtils.setCreportPram(user				, param, dao);
			ReportUtils.setCreportSanctionParam(param	, dao);
			String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_FILE"));
			ReportUtils.clipReportLogoPath(param, dao, request);
			ReportUtils.clipReportSteampPath(param, dao, request);
			//Image 경로
			String imagePath = doc.getImagePath();

			//Report use data
			List<Map<String, Object>> report_data = str411ukrvService.fnPrintData(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("STR411UKRV", "SQLDS2");
//
			List<Map<String, Object>> subReport_data = str411ukrvService.fnPrintData(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

//			//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
			String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success"	, "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
		}

	/**
	 * 기본거래명세서II (str105clukrv)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str105clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str410clskr_2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = "";
//		String crfFile = CRF_PATH2 + "str105clukrv.crf";
		if(ObjUtils.isNotEmpty(param.get("FOLDER_NAME"))) {
			crfFile = CRF_PATH_S + param.get("FOLDER_NAME") + "/" + param.get("RPT_NAME") + ".crf";
		} else {
			crfFile = CRF_PATH2 + param.get("RPT_NAME") + ".crf";
		}

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKRV2_01", "SQLDS2");
		subReportMap.put("STR410SKRV2_02", "SQLDS2");
		subReportMap.put("STR410SKRV2_03", "SQLDS2");
		subReportMap.put("STR410SKRV2_04", "SQLDS2");
		subReportMap.put("STR410SKRV2_05", "SQLDS2");

		List<Map<String, Object>> subReport_data = str105ukrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 택배비명세서 (str410clskrv_5)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str410clskrv_5.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str410clskrv_5Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID6"));
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKR_5_01", "SQLDS2");

		List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 기본거래명세서(kodi) (str410clskrv_kodi)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str410clskrv_2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str410clskrv_2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"str410clskrv_2.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKRV_2_01", "SQLDS2");
		subReportMap.put("STR410SKRV_2_02", "SQLDS2");

		List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 기본거래명세서(cov) (str410clskrv_cov)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str410clskrv_cov.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str410clskrv_covPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"str410clskrv_cov.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKRV_cov_01", "SQLDS2");
		subReportMap.put("STR410SKRV_cov_02", "SQLDS2");
		subReportMap.put("STR410SKRV_cov_03", "SQLDS2");
		subReportMap.put("STR410SKRV_cov_04", "SQLDS2");

		List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 기본거래명세서 (str414clskrv)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str414clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str414clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
	
		// S148 공통 코드의 경로 가져오기
		String fileRoot = str414skrvService.getReportFileInfo(param);

		String crfFile = CRF_PATH2 + "str410clskrv_2.crf"; // default 경로 

		// 지정된 경로가 존재할 경우 그대로 레포트명만 있을경우 앞에 경로 추가
		if(!ObjUtils.isEmpty(fileRoot)){
			crfFile  = fileRoot.contains("/") ? fileRoot : CRF_PATH2 + fileRoot;
		}
		
		//Image 경로
		String imagePath = doc.getImagePath();
		
		//Report use data
		List<Map<String, Object>> report_data = str414skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		// sub report data
		List<Map<String, Object>> subReport_data = str414skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 기본거래명세서(kodi) (str410clskrv_kodi)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str410clskrv_kodi.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str410clskrv_kodiPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"str410clskrv_kodi.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKRV_KODI_01", "SQLDS2");
		subReportMap.put("STR410SKRV_KODI_02", "SQLDS2");

		List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/* 거래명세서 FAX 전송 */
	  @RequestMapping(value = "/sales/str410clskrv_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
	  public void str410clskrFax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();
		  ClipReportExport docPdf = new ClipReportExport();
		  Map param = _req.getParameterMap();
		  String crfFile = CRF_PATH2+"str410clskrv.crf";
		  String filePath = "";
		  String filePath2 = "";
		  String fileName = "";
		  String faxTitle = "";

		  SimpleDateFormat dateFormat;
		  Date today = new Date();
		  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

		  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		  CodeDetailVO cdo = null;
		  //pdf가 저장될 경로 가져오기
		  cdo = codeInfo.getCodeInfo("S148", (String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
		  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode3의 값)
		  filePath2 =  cdo.getRefCode4();//pdf파일 다운 경로 (S148의 refCode4의 값)
		  filePath = filePath + "\\";
		  faxTitle  = cdo.getCodeName();
		  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserName();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
		  param.put("FILE_NAME", fileName + ".pdf");//fax보낼 pdf파일명
		  param.put("FAX_TITLE", cdo.getCodeName());//팩스 제목
		  //Report use data
		  List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		 Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 subReportMap.put("STR410SKRV2_01", "SQLDS2");
		 subReportMap.put("STR410SKRV2_02", "SQLDS2");
		 subReportMap.put("STR410SKRV2_03", "SQLDS2");
		 subReportMap.put("STR410SKRV2_04", "SQLDS2");
		 subReportMap.put("STR410SKRV2_05", "SQLDS2");

		 List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		 subReportMap.put("SUB_DATA", subReport_data);
		 subReports.add(subReportMap);

	   //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	System.out.println(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	System.out.println(":::::param:::::- " + param);
	 	logger.debug(":::::fileFullPath:::::- " + filePath + fileName + ".pdf");
	 	logger.debug(":::::fileFullPath2:::::- " + filePath2 + fileName + ".pdf");

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		// String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

	 	//pdf파일 다운을 위한 oof생성
		 OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
		 File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")
		 FileOutputStream fileStream = new FileOutputStream(localFileSave);

		 PDFOption option = null;
		 docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
		 fileStream.close();
	  // 시간 출력 포맷(pdf저장 실행 후 5초 지연)
		 SimpleDateFormat fmt = new SimpleDateFormat("HH:mm:ss");
		 Calendar cal = Calendar.getInstance() ;
		 logger.debug(":::::TIME1:::::" + fmt.format(cal.getTime())) ;
		 Thread.sleep(5000);
		 Calendar cal2 = Calendar.getInstance() ;
		 logger.debug(":::::TIME2:::::" + fmt.format(cal2.getTime())) ;

		 FileInputStream fis = new FileInputStream(localFileSave);
		 NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication(null, "administrator", "tlsjwlERP_db2018");
		 //String copyPath = "smb://121.170.176.149/pdf_test/111111111122222223333333333333.pdf";
		 String copyPath = filePath2 + fileName + ".pdf";

   		 SmbFile sDestFile = null;
   		 //sDestFile = new SmbFile("smb://guest@192.168.1.90/pdf_test/"+ fileName + ".pdf");
   		 sDestFile = new SmbFile(copyPath, auth);
   		 SmbFileOutputStream smbfos = new SmbFileOutputStream(sDestFile);

   		BufferedInputStream bin = new BufferedInputStream(fis);
		BufferedOutputStream bout = new BufferedOutputStream(smbfos);

   	/*	 int data = 0;
		 while((data=fis.read())!=-1) {

			 smbfos.write(data);

		 }*/

		 int data = 0;
 		 byte[] buffer = new byte[1024];
		 while((data = bin.read(buffer, 0, 1024)) != -1) {
			 bout.write(buffer, 0, data);
		 }

		 bout.close();
		 bin.close();

		 fis.close();
		 smbfos.close();

		 Thread.sleep(8000);
		 str410skrvService.insertFax(param);

	  }

	/* 거래명세서 email 전송 */
	@RequestMapping(value = "/sales/str410clskrv_email.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String str410clskEmail(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();
		  ClipReportExport docPdf = new ClipReportExport();
		  Map param = _req.getParameterMap();
		  String crfFile = CRF_PATH2+"str410clskrv.crf";
		  String filePath = "";
		  String filePath2 = "";
		  String fileName = "";

		  SimpleDateFormat dateFormat;
		  Date today = new Date();
		  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

		  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		  CodeDetailVO cdo = null;
		  //pdf가 저장될 경로 가져오기
		  cdo = codeInfo.getCodeInfo("S148", (String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
		  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode4의 값)
		  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserName();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
		  logger.debug("::::::param:::::" + param);
		  //Report use data
		  List<Map<String, Object>> report_data = str410skrvService.clipselect(param);

		  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		 Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 subReportMap.put("STR410SKRV2_01", "SQLDS2");
		 subReportMap.put("STR410SKRV2_02", "SQLDS2");
		 subReportMap.put("STR410SKRV2_03", "SQLDS2");
		 subReportMap.put("STR410SKRV2_04", "SQLDS2");
		 subReportMap.put("STR410SKRV2_05", "SQLDS2");

		 List<Map<String, Object>> subReport_data = str410skrvService.clipselectsub(param);
		 subReportMap.put("SUB_DATA", subReport_data);
		 subReports.add(subReportMap);

	   //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	logger.debug(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	logger.debug(":::::fileFullPath:::::- " + filePath + fileName + ".pdf");

	 	//pdf파일 다운을 위한 oof생성
		 OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
		 File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")

		 FileOutputStream fileStream = new FileOutputStream(localFileSave);
 		 param.put("FILE_INFO", filePath + fileName + ".pdf");
 		 PDFOption option = null;
 		 docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
 		 fileStream.close();
 		 Thread.sleep(8000);
 		 param.put("FILE_INFO", filePath + fileName + ".pdf");
 		 //생성한 pdf파일(첨부)과 화면에서 입력한 내용들로 메일 전송
 		 str410skrvService.sendMail(param, user);
		 return "SUCCESS";
	}

	@RequestMapping(value = "/sales/str800clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str800clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = str800ukrvService.selectPrintList(param);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/sales/str800clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView str800clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		  String imagePath = doc.getImagePath();

		  //Main Report
		  List<Map<String, Object>> report_data = str800skrvService.selectPrintList2(param);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	}
}
