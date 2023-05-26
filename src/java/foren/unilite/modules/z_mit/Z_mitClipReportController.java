package foren.unilite.modules.z_mit;

import java.io.File;
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
import foren.framework.utils.ArrayUtil;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.accnt.agc.Agc170rkrServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.human.hpa.Hpa900rkrServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_mitClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	final static String CRF_PATH = "Clipreport4/Z_mit/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "s_pmp110ukrv_mitService" )
	private S_pmp110ukrv_mitServiceImpl s_pmp110ukrv_mitService;

	@Resource( name = "s_pmp111ukrv_mitService" )
	private S_pmp111ukrv_mitServiceImpl s_pmp111ukrv_mitService;
	
	@Resource( name = "s_pms500rkrv_mitService" )
	private S_pms500rkrv_mitServiceImpl s_pms500rkrv_mitService;

	@Resource(name = "s_hpa900rkr_mitService")
	private S_Hpa900rkr_mitServiceImpl s_hpa900rkr_mitService;

	@Resource( name = "s_sof130skrv_mitService" )
	private S_sof130skrv_mitServiceImpl s_sof130skrv_mitService;

	@Resource( name = "s_sof120ukrv_mitService" )
	private S_sof120ukrv_mitServiceImpl s_sof120ukrv_mitService;
	
	@Resource( name = "s_str320skrv_mitService" )
	private S_str320skrv_mitServiceImpl s_str320skrv_mitService;

	@Resource( name = "s_str330skrv_mitService" )
	private S_str330skrv_mitServiceImpl s_str330skrv_mitService;

	@Resource( name = "s_str340skrv_mitService" )
	private S_str340skrv_mitServiceImpl s_str340skrv_mitService;

	@Resource( name = "s_agj270rkr_mitService" )
	private S_agj270rkr_mitServiceImpl s_agj270rkr_mitService;

	//20200619 추가: 월별재무재표 출력(MIT)
	@Resource( name = "s_agc170rkr_mitService" )
	private S_agc170rkr_mitServiceImpl s_agc170rkr_mitService;

	@Resource( name = "s_sas100ukrv_mitService" )
	private S_sas100ukrv_mitServiceImpl s_sas100ukrv_mitService;

	@Resource( name = "s_sas200ukrv_mitService" )
	private S_sas200ukrv_mitServiceImpl s_sas200ukrv_mitService;

	@Resource( name = "s_sas300ukrv_mitService" )
	private S_sas300ukrv_mitServiceImpl s_sas300ukrv_mitService;

	@Resource( name = "s_out300ukrv_mitService" )
	private S_out300ukrv_mitServiceImpl s_out300ukrv_mitService;
	
	/**
	 * 월별재무제표 출력(MIT) (s_agc170rkr_mit) - 20200619 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_agc170clrkr_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc170clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));

		int frMon = Integer.parseInt(param.get("START_DATE").toString().substring(4, 6));
		int toMon = Integer.parseInt(param.get(  "END_DATE").toString().substring(4, 6));
		if(toMon - frMon < 6) {
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
		}
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = s_agc170rkr_mitService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 긴급작업지시서등록 - 작업지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp110clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp110clrkrv_mitPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		connectionName ="JDBC1";
		datasetName ="SQLDS1";

//		ServletContext context = request.getServletContext();
//		String path = context.getRealPath("/");
//		String imagePathFirst = path.split(":")[0] + ":" ;
//		param.put("IMAGE_PATH_FIRST",imagePathFirst);
		
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		param.put("IMAGE_PATH", drive +   basePath + contextName +  configPath +  "images\\sign_mit\\");
		
		List<Map<String, Object>> report_data = null;
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		
		if(param.get("SHIFT_CD").equals("D")){
			crfFile = CRF_PATH+ "s_pmp110clukrv_mit_B.crf";
			
			report_data = s_pmp110ukrv_mitService.selectList1(param);

			List<Map<String, Object>> subReport_data1 = s_pmp110ukrv_mitService.selectList2_B(param); //소요자재관련
			Map<String, Object> subReportMap1 = new HashMap<String ,Object>();

			subReportMap1.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B1.crf");
			subReportMap1.put("DATA_SET", "SQLDS2");
			subReportMap1.put("SUB_DATA", subReport_data1);

			subReports.add(subReportMap1);
			
			List<Map<String, Object>> subReport_data2 = s_pmp110ukrv_mitService.selectList2(param);  //중간검사서관련
			Map<String, Object> subReportMap2 = new HashMap<String ,Object>();

			subReportMap2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B2.crf");
			subReportMap2.put("DATA_SET", "SQLDS3");
			subReportMap2.put("SUB_DATA", subReport_data2);
			
			subReports.add(subReportMap2);
			
			Map<String, Object> subReportMap3 = new HashMap<String ,Object>();

			subReportMap3.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B3.crf");
			subReportMap3.put("DATA_SET", "SQLDS3");
			subReportMap3.put("SUB_DATA", subReport_data2);
			
			subReports.add(subReportMap3);
			
			Map<String, Object> subReportMap4 = new HashMap<String ,Object>();

			subReportMap4.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B4.crf");
			subReportMap4.put("DATA_SET", "SQLDS3");
			subReportMap4.put("SUB_DATA", subReport_data2);
			
			subReports.add(subReportMap4);
		}else{

			report_data = s_pmp110ukrv_mitService.selectList1(param);

			List<Map<String, Object>> subReport_data = s_pmp110ukrv_mitService.selectList2(param);
			
			Map<String, Object> subReportMap = new HashMap<String ,Object>();

			subReportMap.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_A.crf");
			subReportMap.put("DATA_SET", "SQLDS2");
			subReportMap.put("SUB_DATA", subReport_data);

			subReports.add(subReportMap);
			
			List<Map<String, Object>> subReport_data1_2 = s_pmp110ukrv_mitService.selectList1_2(param);
			Map<String, Object> subReportMap1_2 = new HashMap<String ,Object>();

			subReportMap1_2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub.crf");
			subReportMap1_2.put("DATA_SET", "SQLDS3");
			subReportMap1_2.put("SUB_DATA", subReport_data1_2);
			
			subReports.add(subReportMap1_2);
			
			
			crfFile = CRF_PATH+ "s_pmp110clukrv_mit_A.crf";
			
		}

		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 반제품, 완제품 작업지시 - 작업지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp111clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp111clrkrv_mitPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		connectionName ="JDBC1";
		datasetName ="SQLDS1";

		param.put("ARR_GUBUN", "Y");
		
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		param.put("IMAGE_PATH", drive +   basePath + contextName +  configPath +  "images\\sign_mit\\");

		List<Map<String, Object>> report_data = null;
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		
		List wkordNumList = new ArrayList();
		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");
		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);
		
		Map<String, Object> gubunValue = new HashMap<String ,Object>();
		gubunValue = s_pmp110ukrv_mitService.selectFormType(param);
		param.put("SHIFT_CD", gubunValue.get("SHIFT_CD"));
		
		if(gubunValue.get("FORM_TYPE").equals("S")){
			if(gubunValue.get("SHIFT_CD").equals("D")){
				crfFile = CRF_PATH+ "s_pmp110clukrv_mit_B.crf";
				report_data = s_pmp110ukrv_mitService.selectList1(param);
	
				List<Map<String, Object>> subReport_data1 = s_pmp110ukrv_mitService.selectList2_B(param); //소요자재관련
				Map<String, Object> subReportMap1 = new HashMap<String ,Object>();
				subReportMap1.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B1.crf");
				subReportMap1.put("DATA_SET", "SQLDS2");
				subReportMap1.put("SUB_DATA", subReport_data1);
				subReports.add(subReportMap1);

				//20200305 추가: 중간검사성적서_세척 한장으로 표시하기 위해 수정(HEADER_MERGE_YN 값 생성)
				param.put("HEADER_MERGE_YN", "Y");
				List<Map<String, Object>> subReport_data2 = s_pmp110ukrv_mitService.selectList2(param);  //중간검사서관련
				Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
				subReportMap2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B2.crf");
				subReportMap2.put("DATA_SET", "SQLDS3");
				subReportMap2.put("SUB_DATA", subReport_data2);
				subReports.add(subReportMap2);
				
				Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
				subReportMap3.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B3.crf");
				subReportMap3.put("DATA_SET", "SQLDS3");
				subReportMap3.put("SUB_DATA", subReport_data2);
				subReports.add(subReportMap3);
				
				Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
				subReportMap4.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B4.crf");
				subReportMap4.put("DATA_SET", "SQLDS3");
				subReportMap4.put("SUB_DATA", subReport_data2);
				subReports.add(subReportMap4);
			}else{
				crfFile = CRF_PATH+ "s_pmp110clukrv_mit_A.crf";
				report_data = s_pmp110ukrv_mitService.selectList1(param);

				List<Map<String, Object>> subReport_data = s_pmp110ukrv_mitService.selectList2(param);
				Map<String, Object> subReportMap = new HashMap<String ,Object>();
				subReportMap.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_A.crf");
				subReportMap.put("DATA_SET", "SQLDS2");
				subReportMap.put("SUB_DATA", subReport_data);
				subReports.add(subReportMap);
				
				List<Map<String, Object>> subReport_data1_2 = s_pmp110ukrv_mitService.selectList1_2(param);
				Map<String, Object> subReportMap1_2 = new HashMap<String ,Object>();
				subReportMap1_2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub.crf");
				subReportMap1_2.put("DATA_SET", "SQLDS3");
				subReportMap1_2.put("SUB_DATA", subReport_data1_2);
				subReports.add(subReportMap1_2);
			}
		}else{
			crfFile = CRF_PATH+ "pmp110clrkrv.crf";
			connectionName ="JDBC1";
			datasetName ="PMP110CL1";
			report_data = s_pmp111ukrv_mitService.mainReport(param);

			subReports = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> subReport_data = s_pmp111ukrv_mitService.subReport(param);
			Map<String, Object> subReportMap = new HashMap<String ,Object>();

			subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
			subReportMap.put("DATA_SET", "PMP110CL1_SUB");
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);
		}
		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 반제품, 완제품 작업지시 - 재작업지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp112clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp112clrkrv_mitPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		connectionName ="JDBC1";
		datasetName ="SQLDS1";

		param.put("ARR_GUBUN", "Y");
		
		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		param.put("IMAGE_PATH", drive +   basePath + contextName +  configPath +  "images\\sign_mit\\");

		List<Map<String, Object>> report_data = null;
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		
		List wkordNumList = new ArrayList();
		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");
		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);
		
//		Map<String, Object> gubunValue = new HashMap<String ,Object>();
//		gubunValue = s_pmp110ukrv_mitService.selectFormType(param);
//		param.put("SHIFT_CD", gubunValue.get("SHIFT_CD"));
//		
//		if(gubunValue.get("FORM_TYPE").equals("S")){
//			if(gubunValue.get("SHIFT_CD").equals("D")){
				crfFile = CRF_PATH+ "s_pmp110clukrv_mit_C.crf";
				report_data = s_pmp110ukrv_mitService.selectList1(param);
	
				List<Map<String, Object>> subReport_data1 = s_pmp110ukrv_mitService.selectList2_B(param); //소요자재관련
				Map<String, Object> subReportMap1 = new HashMap<String ,Object>();
				subReportMap1.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B1.crf");
				subReportMap1.put("DATA_SET", "SQLDS2");
				subReportMap1.put("SUB_DATA", subReport_data1);
				subReports.add(subReportMap1);

				//20200305 추가: 중간검사성적서_세척 한장으로 표시하기 위해 수정(HEADER_MERGE_YN 값 생성)
				param.put("HEADER_MERGE_YN", "Y");
				List<Map<String, Object>> subReport_data2 = s_pmp110ukrv_mitService.selectList2(param);  //중간검사서관련
//				Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
//				subReportMap2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B2.crf");
//				subReportMap2.put("DATA_SET", "SQLDS3");
//				subReportMap2.put("SUB_DATA", subReport_data2);
//				subReports.add(subReportMap2);
//				
//				Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
//				subReportMap3.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B3.crf");
//				subReportMap3.put("DATA_SET", "SQLDS3");
//				subReportMap3.put("SUB_DATA", subReport_data2);
//				subReports.add(subReportMap3);
				
				Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
				subReportMap4.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_B4.crf");
				subReportMap4.put("DATA_SET", "SQLDS3");
				subReportMap4.put("SUB_DATA", subReport_data2);
				subReports.add(subReportMap4);
//			}else{
//				crfFile = CRF_PATH+ "s_pmp110clukrv_mit_A.crf";
//				report_data = s_pmp110ukrv_mitService.selectList1(param);
//
//				List<Map<String, Object>> subReport_data = s_pmp110ukrv_mitService.selectList2(param);
//				Map<String, Object> subReportMap = new HashMap<String ,Object>();
//				subReportMap.put("REPORT_FILE", "s_pmp110clukrv_mit_sub_A.crf");
//				subReportMap.put("DATA_SET", "SQLDS2");
//				subReportMap.put("SUB_DATA", subReport_data);
//				subReports.add(subReportMap);
//				
//				List<Map<String, Object>> subReport_data1_2 = s_pmp110ukrv_mitService.selectList1_2(param);
//				Map<String, Object> subReportMap1_2 = new HashMap<String ,Object>();
//				subReportMap1_2.put("REPORT_FILE", "s_pmp110clukrv_mit_sub.crf");
//				subReportMap1_2.put("DATA_SET", "SQLDS3");
//				subReportMap1_2.put("SUB_DATA", subReport_data1_2);
//				subReports.add(subReportMap1_2);
//			}
//		}else{
//			crfFile = CRF_PATH+ "pmp110clrkrv.crf";
//			connectionName ="JDBC1";
//			datasetName ="PMP110CL1";
//			report_data = s_pmp111ukrv_mitService.mainReport(param);
//
//			subReports = new ArrayList<Map<String, Object>>();
//			List<Map<String, Object>> subReport_data = s_pmp111ukrv_mitService.subReport(param);
//			Map<String, Object> subReportMap = new HashMap<String ,Object>();
//
//			subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
//			subReportMap.put("DATA_SET", "PMP110CL1_SUB");
//			subReportMap.put("SUB_DATA", subReport_data);
//			subReports.add(subReportMap);
//		}
		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 작업지시 태그출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp110clukrv2_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp110clrkrv2_mitPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		crfFile = CRF_PATH+ "s_pmp110clukrv_mit_T.crf";
		
		connectionName ="JDBC1";
		datasetName ="SQLDS1";

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);
		
		if(param.get("ARR_GUBUN").equals("Y")){
			List wkordNumList = new ArrayList();
			String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");
			for(String wkordNum : wkordNums) {
				wkordNumList.add(wkordNum);
			}
			param.put("WKORD_NUM"	, wkordNumList);
		}
		

		List<Map<String, Object>> report_data = s_pmp110ukrv_mitService.selectList_t(param);

		
		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/z_mit/s_pms500clrkrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pms500clrkrv_mitPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
		String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
		String[] directory = path.split(":");
		String drive = "";
		if(directory != null && directory.length >= 2)	{
			drive = directory[0]+":";
		}
		String basePath = ConfigUtil.getString("common.clipreport.basePath");
		String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
		if(basePath != null)	{
			basePath = basePath.replace("/",File.separator);
		}
		if(configPath != null)	{
			configPath = configPath.replace("/",File.separator);
		}
		param.put("IMAGE_PATH", drive +   basePath + contextName +  configPath +  "images\\stent_images\\Images\\");  ;
		
		String labelType = (String) param.get("LABEL_TYPE");
		String labelTypeFirst = labelType.substring(0,1);
		String crfFile = null;
		List<Map<String, Object>> report_data = null;
		
		if(labelTypeFirst.equals("A")){
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_AA.crf";
			report_data = s_pms500rkrv_mitService.printList_A(param);
		}else if(labelTypeFirst.equals("B")){
			if(labelType.equals("B1")){
				crfFile = CRF_PATH + "s_pms500clrkrv_mit_B1.crf";
			}else if(labelType.equals("B2")){
				crfFile = CRF_PATH + "s_pms500clrkrv_mit_B2.crf";
			}
			
			report_data = s_pms500rkrv_mitService.printList_B(param);
		}
		/*if(labelType.equals("A1")){	//해외
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_A1.crf";
		}else if(labelType.equals("A2")){	//국내
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_A2.crf";
		}else if(labelType.equals("A3")){	//일본
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_A3.crf";
		}else if(labelType.equals("B1")){	//NEEDLE
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_B1.crf";
		}else if(labelType.equals("B2")){	//GUIDE WIRE
			crfFile = CRF_PATH + "s_pms500clrkrv_mit_B2.crf";
		}*/
		//Main Report
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/z_mit/s_hpa900clrkr_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa900clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		// 사번 Array to String
		if(!ObjUtils.isEmpty(param.get("PERSON_NUMB")))	{
			param.put("PERSON_NUMB" , "'"+GStringUtils.replace(ObjUtils.getSafeString(param.get("PERSON_NUMB")), ",", "','")+"'");
		}
		//급여명세서 : 4
		if(param.get("DOC_KIND").equals("4")) {
			
			crfFile = CRF_PATH + "s_hpa900clrkrv4_mit.crf";
			
			//Main Report
			List<Map<String, Object>> report_data = s_hpa900rkr_mitService.selectListPrint4(param);
			
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = s_hpa900rkr_mitService.selectSubListPrint4(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
			
		} 
		//급여대장(사업장별) : 3
		else if(param.get("DOC_KIND").equals("3")) {
			crfFile = CRF_PATH + "s_hpa900clrkrv3_mit.crf";
			
			//Main Report
			List<Map<String, Object>> report_data = s_hpa900rkr_mitService.selectListPrint3(param);
			
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = s_hpa900rkr_mitService.selectSubListPrint(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		//급여대장(사원별) : 2
		else if(param.get("DOC_KIND").equals("2")) {
			crfFile = CRF_PATH + "s_hpa900clrkrv2_mit.crf";
			
			//Main Report
			List<Map<String, Object>> report_data = s_hpa900rkr_mitService.selectListPrint2(param);
			
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = s_hpa900rkr_mitService.selectSubListPrint(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		//급여대장(부서별) : 1
		else {
			crfFile = CRF_PATH + "s_hpa900clrkrv1_mit.crf";
			
			List<Map<String, Object>> report_data = s_hpa900rkr_mitService.selectListPrint1(param);
			
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = s_hpa900rkr_mitService.selectSubListPrint(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
			
		}
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 주문의뢰서 출력(MIT) (s_sof130skrv_mit) - 20191022 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sof130clskrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sof130clskrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_sof130clskrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = s_sof130skrv_mitService.printList(param);

		
		//Sub Report 있을 경우
//		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap = new HashMap<String ,Object>();
//		subReportMap.put("DATA_SET", "SQLDS2");
//		
//		List<Map<String, Object>> subReport_data = s_str320skrv_mitService.printList(param);
//		subReportMap.put("SUB_DATA", subReport_data);
//		subReports.add(subReportMap);

//		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 반품의뢰서 출력(MIT) (s_str320skrv_mit) - 20191004 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str320clskrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str320clskrv_mitPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_str320clskrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = s_str320skrv_mitService.printList(param);

		//Sub Report
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("DATA_SET", "SQLDS2");

		//210200525 수정: MAIN_DATE 하나만 사용 (s_str320skrv_mitService.printList)
//		List<Map<String, Object>> subReport_data = s_str320skrv_mitService.printList(param);
//		subReportMap.put("SUB_DATA", subReport_data);
//		subReports.add(subReportMap);
//
//		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 출고확인서 출력(MIT) (s_str330skrv_mit) - 20191106 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str330clskrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str330clskrv_mitPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//출력할 리포트 파일명
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "s_str330clskrv_mit.crf";
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);

		//Image 경로
//		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		//20200514 추가: 한글 변환
		String msgName = (String) param.get("RECIEVER");
		//param.put("RECIEVER", new String(msgName.getBytes("ISO-8859-1"), "UTF-8"));
		List<Map<String, Object>> report_data = s_str330skrv_mitService.printMainData(param);

		//Sub Report
//		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap = new HashMap<String ,Object>();
//		subReportMap.put("DATA_SET", "SQLDS2");
		
//		List<Map<String, Object>> subReport_data = s_str330skrv_mitService.printList(param);
//		subReportMap.put("SUB_DATA", subReport_data);
//		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 월별반품현황 조회(MIT) (s_str340skrv_mit) - 20191015 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str340clskrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str340clskrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_str340clskrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = s_str340skrv_mitService.printChartReport(param);

		//Sub Report
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		Map<String, Object> subReportMap1		= new HashMap<String ,Object>();

		subReportMap.put("DATA_SET"	, "SQLDS1");
		subReportMap1.put("DATA_SET", "SQLDS2");

		List<Map<String, Object>> subReport_data	= s_str340skrv_mitService.printSubReport(param);
		List<Map<String, Object>> subReport_data1	= s_str340skrv_mitService.printSubReport1(param);

		subReportMap.put("SUB_DATA"	, subReport_data);
		subReportMap1.put("SUB_DATA", subReport_data1);

		subReports.add(subReportMap);
		subReports.add(subReportMap1);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 출고예정표(MIT) (s_sof120ukrv_mit) - 20191205 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sof120clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sof120clukrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_sof120clukrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = s_sof120ukrv_mitService.printList(param);

		
		//Sub Report 있을 경우
//		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap = new HashMap<String ,Object>();
//		subReportMap.put("DATA_SET", "SQLDS2");
//		
//		List<Map<String, Object>> subReport_data = s_str320skrv_mitService.printList(param);
//		subReportMap.put("SUB_DATA", subReport_data);
//		subReports.add(subReportMap);

//		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	//소즉자료제출집계표
	@RequestMapping(value = "/z_mit/s_agj270clrkrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_agj270clrkrv_mitPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();

		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		List<String> slipnumLite = new ArrayList<String>();
		String acDate	= "";
		String acDate2	= "";
		String slipnum	= "";
		
		if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
			acDate2 = ObjUtils.getSafeString(param.get("AC_DATE"));
		}
		if(ObjUtils.isNotEmpty(param.get("FR_AC_DATE"))){
			acDate = ObjUtils.getSafeString(param.get("FR_AC_DATE"));
		}
		if(ObjUtils.isNotEmpty(param.get("FR_SLIP_NUM"))){
			slipnum = ObjUtils.getSafeString(param.get("FR_SLIP_NUM"));
		}

		String[] arry1	= acDate2.split(",");
		String[] arry	= acDate.split(",");
		String[] arry2	= slipnum.split(",");
		
		for(int i = 0 ; i < arry2.length ; i++){
			slipnumLite.add(arry2[i]);
		}
		
		param.put("AC_DATE"		, arry1);
		param.put("FR_AC_DATE"	, arry[0]);
		param.put("FR_SLIP_NUM"	, slipnumLite);
		
		String crfFile = CRF_PATH + "s_agj270clrkrv_mit.crf";
		
		List<Map<String, Object>> report_data = s_agj270rkr_mitService.selectPrintList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 접수증 출력 (s_sas100ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas100clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas100clukrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_sas100clukrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		Map<String, Object> report_data = (Map<String, Object>) s_sas100ukrv_mitService.selectMaster(param, user);

		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 견적서 출력 (s_sas200ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas200clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas200clukrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		 
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//출력할 리포트 파일명
		String crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));

		List<Map<String, Object>> report_data = s_sas200ukrv_mitService.selectPrint(param, user);

		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 견적양식 출력 (s_sas200ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas200clukrv2_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas200clukrv2_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		 
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//출력할 리포트 파일명
		String crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));

		List<Map<String, Object>> report_data = s_sas200ukrv_mitService.selectPrint(param, user);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 수리완료보고서 출력 (s_sas300ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas300clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas300clukrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = null;
		
		//출력할 리포트 파일명
		if(param.get("S_COMP_CODE").equals("LNK")){
			crfFile = CRF_PATH + "s_sas300clukrv_mit_agent.crf";
		}else{
			crfFile = CRF_PATH + "s_sas300clukrv_mit.crf";
		}

		//Image 경로
		String imagePath = doc.getImagePath();

		List<Map<String, Object>> report_data =  s_sas300ukrv_mitService.selectPrint(param, user);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 수리완료보고서(2) 출력 (s_sas300ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas300clukrv2_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas300clukrv2_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = null;
		
		//출력할 리포트 파일명
		if(param.get("S_COMP_CODE").equals("LNK")){
			crfFile = CRF_PATH + "s_sas300clukrv2_mit_agent.crf";
		}else{
			crfFile = CRF_PATH + "s_sas300clukrv2_mit.crf";
		}
		

		//Image 경로
		String imagePath = doc.getImagePath();

		List<Map<String, Object>> report_data =  s_sas300ukrv_mitService.selectPrint(param, user);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 자재출고요철서 출력 (s_sas300ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sas300clukrv3_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_sas300clukrv3_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_sas300clukrv3_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		List<Map<String, Object>> report_data =  s_sas300ukrv_mitService.selectPrintMOutReq(param, user);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
//	@RequestMapping(value = "/z_mit/s_out300clukrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
//	public ModelAndView s_out300clukrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
//		ClipReportDoc doc = new ClipReportDoc();
//		Map param = _req.getParameterMap();
//		
//		//출력할 리포트 파일명
//		String crfFile = CRF_PATH + "s_out300clukrv_mit.crf";
//		//List<Map<String, Object>> report_data = new ArrayList<Map<String, Object>>();
//		List<Map<String, Object>> subreport_data = new ArrayList<Map<String, Object>>();
//		
////		if(ObjUtils.isNotEmpty(param.get("WORKERS")))	{
////			String[] workers = (String[]) param.get("WORKERS");
////			param.put("WORKER_CODE" , workers[0]);
////		}
//		//작업내역 라벨
//		List<Map<String, Object>> report_table_header = s_out300ukrv_mitService.selectReportLabel(param);
//		
//		//작업내역
//		List<Map<String, Object>> report_data1 =  s_out300ukrv_mitService.selectReportByItemCode(param);
//		
//		//당월부적합
//		List<Map<String, Object>> report_data2 =  s_out300ukrv_mitService.selectReportBadWorkQ(param);
//		
//		//수당내역
//		List<Map<String, Object>> report_data3 =  s_out300ukrv_mitService.selectReportAllowance(param);
//		
//		//소급적용내역
//		List<Map<String, Object>> report_data4 =  s_out300ukrv_mitService.selectReportRetroAmt(param);
//		
//		//비용내역
//		List<Map<String, Object>> report_data5 =  s_out300ukrv_mitService.selectReportSummary(param);
//		
//		//report_data.addAll(report_data1);
//		/*report_data.add(report_data2);
//		report_data.add(report_data3);
//		report_data.addAll(report_data4);
//		report_data.add(report_data5);*/
//				
//		// 20201103 추가
//		//Sub Report 작업내역 라벨
//		//List<Map<String, Object>> subReports2 = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
//		subReportMap2.put("sub_rpt1", "SQLDS2");
//
//		subReportMap2.put("SUB_DATA", report_table_header);
//		//subReports2.add(subReportMap2);
//
//		//Sub Report 당월부적합
//		//List<Map<String, Object>> subReports3 = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
//		subReportMap3.put("sub_rpt2", "SQLDS3");
//
//		subReportMap3.put("SUB_DATA", report_data2);
//		//subReports3.add(subReportMap3);
//		
//		//Sub Report 수당내역
//		//List<Map<String, Object>> subReports6 = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap6 = new HashMap<String ,Object>();
//		subReportMap6.put("sub_rpt3", "SQLDS4");
//
//		subReportMap6.put("SUB_DATA", report_data3);
//		//subReports6.add(subReportMap6);
//		
//		//Sub Report 소급적용내역
//		//List<Map<String, Object>> subReports4 = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
//		subReportMap4.put("sub_rpt4", "SQLDS5");
//
//		subReportMap4.put("SUB_DATA", report_data4);
//		//subReports4.add(subReportMap4);
//		
//		//Sub Report 비용내역
//		//List<Map<String, Object>> subReports5 = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap5 = new HashMap<String ,Object>();
//		subReportMap5.put("sub_rpt5", "SQLDS6");
//
//		subReportMap5.put("SUB_DATA", report_data5);
//		//subReports5.add(subReportMap5);
//		
//		
//		
//		subreport_data.add(subReportMap2);
//		subreport_data.add(subReportMap3);
//		subreport_data.add(subReportMap4);
//		subreport_data.add(subReportMap5);
//		subreport_data.add(subReportMap6);
//		
//		
//		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data1, subreport_data, request);
//
//		
//		
//		Map<String, Object> rMap = new HashMap<String, Object>();
//		rMap.put("success", "true");
//		rMap.put("resultKey", resultKey);
//		return ViewHelper.getJsonView(rMap);
//	}

	/**
	 * 자재출고요철서 출력 (s_sas300ukrv_mit)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_out300clrkrv_mit.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_out300clrkrv_mit(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		//출력할 리포트 파일명
		String crfFile = CRF_PATH + "s_out300clukrv_mit.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		List<Map<String, Object>> report_data =  s_out300ukrv_mitService.selectPrintMaster(param);

		//Sub Report
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		subReportMap.put("DATA_SET"	, "SQLDS2");

		List<Map<String, Object>> subReport_data	= s_out300ukrv_mitService.selectPrintDetail(param);

		subReportMap.put("SUB_DATA"	, subReport_data);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
}