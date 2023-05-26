package foren.unilite.modules.human.hum;

import java.io.File;
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

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class HumClipReportController extends UniliteCommonController {
	final static String	CRF_PATH = "Clipreport4/human/";

	//20200806 추가: 기간별인원현황출력 (hum260rkr)
	@Resource(name = "hum260rkrService")
	private Hum260rkrServiceImpl hum260rkrService;

	//20200806 추가: 인원현황출력 (hum930rkr)
	@Resource(name = "hum930rkrService")
	private Hum930rkrServiceImpl hum930rkrService;

	//20200806 추가: 사원명부출력 (hum950rkr)
	@Resource(name = "hum950rkrService")
	private Hum950rkrServiceImpl hum950rkrService;

	@Resource(name = "hum963rkrService")
	private Hum963rkrServiceImpl hum963rkrService;

	@Resource(name = "hum970rkrService")
	private Hum970rkrServiceImpl hum970rkrService;
	
	@Resource(name = "hum976rkrService")
	private Hum976rkrServiceImpl hum976rkrService;

	//20200804 추가: 인사기록카드출력2 (hum980rkr)
	@Resource(name = "hum980rkrService")
	private Hum980rkrServiceImpl hum980rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;



	/**
	 * 기간별인원현황출력 (hum260rkr) - 20200806 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum260clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum260clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "hum260clrkr.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();


		//조회조건 기간 구하는 로직
		List calDateList	= new ArrayList<Map>();

		String strDateFrom	= (String) param.get("YYYYMM_FR");
		String strDateTo	= (String) param.get("YYYYMM_TO");
		//시작 년월
		int DateFrom		= Integer.parseInt(strDateFrom);
		int DateFromYear	= Integer.parseInt(strDateFrom.substring(0, 4));
		int DateFromMonth	= Integer.parseInt(strDateFrom.substring(4, 6));
		//종료 년월
		int DateTo			= Integer.parseInt(strDateTo);
		int DateToYear		= Integer.parseInt(strDateTo.substring(0, 4));
		int DateToMonth 	= Integer.parseInt(strDateTo.substring(4, 6));
		//두 기간 사이의 월수 구하기
		int dateItv			= (DateToYear - DateFromYear) * 12 + (DateToMonth - DateFromMonth);

		for (int i = 0; i <= dateItv; i++) {
			Calendar calendar = Calendar.getInstance();
			Map calDate			= new HashMap();
			DateFormat format	= new SimpleDateFormat("yyyyMM");
			Date date			= format.parse(String.valueOf(strDateFrom));

			calendar.setTime(date);
			calendar.add(Calendar.MONTH, i);
			String dateMontFrom = format.format(calendar.getTime());

			calendar.add(Calendar.MONTH, i+1);
			String dateMontTo = format.format(calendar.getTime());

			calDate.put("YEAR"			, dateMontFrom.substring(0, 4));
			calDate.put("MONTH"			, dateMontFrom.substring(4, 6));
			calDate.put("DATE_MONT_FROM", dateMontFrom + "01");
			calDate.put("DATE_MONT_TO"	, dateMontTo + "01");

			calDateList.add(calDate);
		}
		param.put("CAL_DATE_LIST", calDateList);

		List<Map<String, Object>> report_data	= hum260rkrService.selectClList(param);
		//sub report 있을 때 사용
/*		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data= hum980rkrService.selectHumDetailData(param);
		subReportMap.put("hum980clrkr_sub", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 인원현황출력 (hum930rkr) - 20200806 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum930clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum930clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "hum930clrkr.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();

		//인사 이미지 파일 가져오는 로직
/*		String path = request.getSession().getServletContext().getRealPath("/");
		String[] directories = path.split(":");
		String drive = "";
		if(directories != null && directories.length >= 2)	{
			drive = directories[0]+":";
		}
		else {
			drive = "C:";
		}
		String humanImagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
		File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
		param.put("HUMAN_IMAGE_PATH", humanImagePath);*/

		List<Map<String, Object>> report_data	= hum930rkrService.selectClList(param);
		//sub report 있을 때 사용
/*		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data= hum980rkrService.selectHumDetailData(param);
		subReportMap.put("hum980clrkr_sub", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 사원명부출력 (hum950rkr) - 20200806 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum950clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum950clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "hum950clrkr.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();

		//인사 이미지 파일 가져오는 로직
/*		String path = request.getSession().getServletContext().getRealPath("/");
		String[] directories = path.split(":");
		String drive = "";
		if(directories != null && directories.length >= 2)	{
			drive = directories[0]+":";
		}
		else {
			drive = "C:";
		}
		String humanImagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
		File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
		param.put("HUMAN_IMAGE_PATH", humanImagePath);*/

		List<Map<String, Object>> report_data	= hum950rkrService.selectClList(param);
		//sub report 있을 때 사용
/*		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data= hum980rkrService.selectHumDetailData(param);
		subReportMap.put("hum980clrkr_sub", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hum963clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum963clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		//String imagePath = doc.getImagePath();

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
		String imagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
		File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
		param.put("HUMAN_IMAGE_PATH", imagePath);
		
		crfFile = CRF_PATH + "hum963clrkrv.crf";
		//Main Report
		List<Map<String, Object>> report_data = hum963rkrService.selectPrintMaster(param);
		//Sub Report
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("SUB_SECTION1", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = hum963rkrService.selectPrintDetail(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hum964clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum964clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		//String imagePath = doc.getImagePath();

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
		String imagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
		File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
		param.put("HUMAN_IMAGE_PATH", imagePath);
		
		crfFile = CRF_PATH + "hum964clrkrv.crf";
		//Main Report
		List<Map<String, Object>> report_data = hum963rkrService.selectPrintMaster(param);
		//Sub Report
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("SUB_SECTION1", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = hum963rkrService.selectPrintDetail(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hum970clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum970clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		ReportUtils.clipReportSteampPath(param, dao, request);
		String crfFile;
		
		if (ObjUtils.isNotEmpty(param.get("RPT_ID5"))) {
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		}
		else {
			crfFile = CRF_PATH + "hum970clrkrv.crf";
		}
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hum970rkrService.selectPrintMaster(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/human/hum976clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum976clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		// 인장
		ReportUtils.clipReportSteampPath(param, dao, request);

		// 노비스 바이오
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID4"));

		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hum976rkrService.selectPrintMaster(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 인사기록카드출력2 (hum980rkr) - 20200804 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hum980clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hum980clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

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
		String humanImagePath = drive + ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
		File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
		param.put("HUMAN_IMAGE_PATH", humanImagePath);

		List<Map<String, Object>> report_data	= hum980rkrService.selectHumMasterData(param);
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data= hum980rkrService.selectHumDetailData(param);
		subReportMap.put("hum980clrkr_sub", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}