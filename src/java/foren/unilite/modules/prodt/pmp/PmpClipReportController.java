package foren.unilite.modules.prodt.pmp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class PmpClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Prodt/";
	final static String			CRF_PATH_NOVIS		= "Clipreport4/Z_novis/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "pmp100ukrvService" )
	private Pmp100ukrvServiceImpl pmp100ukrvService;

	@Resource( name = "pmp110ukrvService" )
	private Pmp110ukrvServiceImpl pmp110ukrvService;

	@Resource( name = "pmp130rkrvService" )
	private Pmp130rkrvServiceImpl pmp130rkrvService;

	@Resource( name = "pmp220rkrvService" )
	private Pmp220rkrvServiceImpl pmp220rkrvService;

	@Resource( name = "pmp190skrvService" )
	private Pmp190skrvServiceImpl pmp190skrvService;

	@Resource( name = "s_pmp130rkrv_jwService" )
	private S_pmp130rkrv_jwServiceImpl s_pmp130rkrv_jwService;

	@Resource( name = "pmp200ukrvService" )
	private Pmp200ukrvServiceImpl pmp200ukrvService;

	@Resource( name = "pmp260ukrvService" )
	private Pmp260ukrvServiceImpl pmp260ukrvService;

	@Resource( name = "pmp270skrvService" )
	private Pmp270skrvServiceImpl pmp270skrvService;

	@Resource( name = "pmp280ukrvService" )
	private Pmp280ukrvServiceImpl pmp280ukrvService;

	@Resource( name = "pmp281ukrvService" )
	private Pmp281ukrvServiceImpl pmp281ukrvService;
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
	@RequestMapping(value = "/prodt/pmp110clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp110clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		if(param.get("DEPT_NAME").equals("1")){  //JWORLD
			crfFile = "Clipreport4/Z_jw/"+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";
			ServletContext context = request.getServletContext();
			String path = context.getRealPath("/");
			String imagePathFirst = path.split(":")[0] + ":" ;
			param.put("IMAGE_PATH_FIRST",imagePathFirst);
			List<Map<String, Object>> report_data = pmp110ukrvService.mainReport(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			 subReportMap.put("s_pmp130rkrv_jw_sub1", "SQLDS2");

			List<Map<String, Object>> subReport_data = pmp110ukrvService.subReport(param);
			 subReportMap.put("SUB_DATA", subReport_data);
			 subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}else{
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";


			connectionName ="JDBC1";
			datasetName ="PMP110CL1";

			ServletContext context = request.getServletContext();
			String path = context.getRealPath("/");
			String imagePathFirst = path.split(":")[0] + ":" ;
			param.put("IMAGE_PATH_FIRST",imagePathFirst);

			List<Map<String, Object>> report_data = pmp110ukrvService.mainReport(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

			List<Map<String, Object>> subReport_data = pmp110ukrvService.subReport(param);
			Map<String, Object> subReportMap = new HashMap<String ,Object>();

			subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
			subReportMap.put("DATA_SET", "PMP110CL1_SUB");
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_pmp110clrkrv_sh")){	//신환
				List<Map<String, Object>> subReport_data_sh1 = pmp110ukrvService.subReport_sh1(param);
				List<Map<String, Object>> subReport_data_sh2_2 = new ArrayList<Map<String, Object>>();
				for(Map subReport_paramData : subReport_data_sh1) {
					subReport_paramData.put("S_COMP_CODE", user.getCompCode());
					subReport_paramData.put("S_USER_ID", user.getUserID());
					List<Map<String, Object>> subReport_data_sh2_1 = pmp110ukrvService.subReport_sh2(subReport_paramData);
					for(Map subReport_paramData2 : subReport_data_sh2_1){
						subReport_data_sh2_2.add(subReport_paramData2);
					}
				}
				Map<String, Object> subReportMap_sh2 = new HashMap<String ,Object>();
				subReportMap_sh2.put("REPORT_FILE", "s_pmp110clrkrv_sh_sub2.crf");
				subReportMap_sh2.put("DATA_SET", "S_PMP110CL1_SH_SUB2");
				subReportMap_sh2.put("SUB_DATA", subReport_data_sh2_2);
				subReports.add(subReportMap_sh2);
				crfFile = "Clipreport4/Z_sh/"+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";
			}
			resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		}

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	/**
	 * 일괄제조오더등록 - 작업지시서,출고요청서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp100clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp100clrkrvPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		List<Map<String, Object>> report_data = null;
		if(param.get("printGubun").equals("1")){		//작업지시서	긴급작업지시등록의 레포트와 동일함..
			if(param.get("DEPT_NAME").equals("1")){  //JWORLD
				crfFile = "Clipreport4/Z_jw/"+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";
				ServletContext context = request.getServletContext();
				String path = context.getRealPath("/");
				String imagePathFirst = path.split(":")[0] + ":" ;
				param.put("IMAGE_PATH_FIRST",imagePathFirst);
				if(param.get("S_COMP_NAME").equals("(주)제이월드")){//제이월드일 경우에만 메인 쿼리 변경
					 report_data = s_pmp130rkrv_jwService.printList1(param);
				}else{
					 report_data = pmp110ukrvService.mainReport(param);
				}

				List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
				Map<String, Object> subReportMap = new HashMap<String ,Object>();
				 subReportMap.put("s_pmp130rkrv_jw_sub1", "SQLDS2");

				List<Map<String, Object>> subReport_data =  s_pmp130rkrv_jwService.subPrintList1(param);
				 subReportMap.put("SUB_DATA", subReport_data);
				 subReports.add(subReportMap);

				resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
			}else{
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";

				connectionName ="JDBC1";
				datasetName ="PMP110CL1";

				ServletContext context = request.getServletContext();
				String path = context.getRealPath("/");
				String imagePathFirst = path.split(":")[0] + ":" ;
				param.put("IMAGE_PATH_FIRST",imagePathFirst);
				if(param.get("S_COMP_NAME").equals("(주)제이월드")){//제이월드일 경우에만 메인 쿼리 변경
					 report_data = s_pmp130rkrv_jwService.printList1(param);
				}else{
					 report_data = pmp110ukrvService.mainReport(param);
				}


				List<Map<String, Object>> subReport_data = pmp110ukrvService.subReport(param);
				List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
				Map<String, Object> subReportMap = new HashMap<String ,Object>();

				subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
				subReportMap.put("DATA_SET", "PMP110CL1_SUB");
				subReportMap.put("SUB_DATA", subReport_data);
				subReports.add(subReportMap);

				if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_pmp110clrkrv_sh")){	//신환
					List<Map<String, Object>> subReport_data_sh1 = pmp110ukrvService.subReport_sh1(param);
					List<Map<String, Object>> subReport_data_sh2_2 = new ArrayList<Map<String, Object>>();
					for(Map subReport_paramData : subReport_data_sh1) {
						subReport_paramData.put("S_COMP_CODE", user.getCompCode());
						subReport_paramData.put("S_USER_ID", user.getUserID());
						List<Map<String, Object>> subReport_data_sh2_1 = pmp110ukrvService.subReport_sh2(subReport_paramData);
						for(Map subReport_paramData2 : subReport_data_sh2_1){
							subReport_data_sh2_2.add(subReport_paramData2);
						}
					}
					Map<String, Object> subReportMap_sh2 = new HashMap<String ,Object>();
					subReportMap_sh2.put("REPORT_FILE", "s_pmp110clrkrv_sh_sub2.crf");
					subReportMap_sh2.put("DATA_SET", "S_PMP110CL1_SH_SUB2");
					subReportMap_sh2.put("SUB_DATA", subReport_data_sh2_2);
					subReports.add(subReportMap_sh2);
					crfFile = "Clipreport4/Z_sh/"+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";
				}

				resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
			}
		}else if(param.get("printGubun").equals("2")){		//출고요청서
			if(param.get("DEPT_NAME").equals("1")){	//JWORLD
				crfFile = "Clipreport4/Z_jw/"+ ObjUtils.getSafeString(param.get("RPT_ID2")) + ".crf";
				param.put("TOP_WKORD_NUM", param.get("WKORD_NUM"));
			    report_data = s_pmp130rkrv_jwService.printList2(param);

				resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
			}else{
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2")) + ".crf";

				connectionName ="JDBC1";
				datasetName ="PMP100CL1";

				 report_data = pmp100ukrvService.mainReport(param);

				resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, null, request);
			}
		}
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 긴급작업지시등록(코디) 포장지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp260clrkrv_1.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp260clrkrv_1( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ "pmp260clrkrv_1.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List wkordNumList		= new ArrayList();

		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");

		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);

		List<Map<String, Object>> report_data =  pmp260ukrvService.mainReport_1(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 subReportMap.put("pmp260clrkrv_sub", "SQLDS2");

		List<Map<String, Object>> subReport_data = pmp260ukrvService.subReport_1(param);
		 subReportMap.put("SUB_DATA", subReport_data);
		 subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);


		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 긴급작업지시등록(코디) 제조지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp260clrkrv_2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp260clrkrv_2( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ "pmp260clrkrv_2.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List wkordNumList		= new ArrayList();

		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");

		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);

		List<Map<String, Object>> report_data =  pmp260ukrvService.mainReport_2(param);

//			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//			Map<String, Object> subReportMap = new HashMap<String ,Object>();
//			 subReportMap.put("pmp260clrcod_sub", "SQLDS2");
//
//			List<Map<String, Object>> subReport_data = pmp260ucosService.subReport_2(param);
//			 subReportMap.put("SUB_DATA", subReport_data);
//			 subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);


		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 긴급작업지시등록(코디) 칭량지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp260clrkrv_3.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp260clrkrv_3( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		List wkordNumList		= new ArrayList();

		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");

		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);

		List<Map<String, Object>> report_data =  pmp270skrvService.mainReport1(param);

//			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//			Map<String, Object> subReportMap = new HashMap<String ,Object>();
//			 subReportMap.put("pmp260clrcod_sub", "SQLDS2");

//			List<Map<String, Object>> subReport_data = pmp260ucosService.subReport_1(param);
//			 subReportMap.put("SUB_DATA", subReport_data);
//			 subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);


		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 긴급작업지시등록(코디) 제조지시서(구)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp260clrkrv_4.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp260clrkrv_4( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ "pmp260clrkrv_4.crf";
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List wkordNumList		= new ArrayList();

		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");

		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);

		List<Map<String, Object>> report_data =  pmp260ukrvService.mainReport_4(param);

//			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//			Map<String, Object> subReportMap = new HashMap<String ,Object>();
//			 subReportMap.put("pmp260clrcod_sub", "SQLDS2");
//
//			List<Map<String, Object>> subReport_data = pmp260ucosService.subReport_2(param);
//			 subReportMap.put("SUB_DATA", subReport_data);
//			 subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);


		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 작업지시서출력(출력후 선택후 조회 프로그램)(pmp190skrv) - 작업지시서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp190clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp190clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();

		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		String crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";

		String connectionName ="JDBC1";
		String datasetName ="PMP110CL1";

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List wkordNumList		= new ArrayList();

		String[] wkordNums	= param.get("WKORD_NUM").toString().split(",");

		for(String wkordNum : wkordNums) {
			wkordNumList.add(wkordNum);
		}
		param.put("WKORD_NUM"	, wkordNumList);
	 /*String wkordNum = ObjUtils.getSafeString(param.get("WKORD_NUM"));
		if (wkordNum != null) {
			String[] arry = wkordNum.split(",");
			param.put("WKORD_NUM", arry);
		}

		*/
		List<Map<String, Object>> report_data = pmp190skrvService.mainReport(param);

		List<Map<String, Object>> subReport_data = pmp190skrvService.subReport(param);
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
		subReportMap.put("DATA_SET", "PMP110CL1_SUB");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);


		if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_pmp110clrkrv_sh")){	//신환
			List<Map<String, Object>> subReport_data_sh1 = pmp190skrvService.subReport_sh1(param);
			List<Map<String, Object>> subReport_data_sh2_2 = new ArrayList<Map<String, Object>>();
			for(Map subReport_paramData : subReport_data_sh1) {
				subReport_paramData.put("S_COMP_CODE", user.getCompCode());
				subReport_paramData.put("S_USER_ID", user.getUserID());
				List<Map<String, Object>> subReport_data_sh2_1 = pmp190skrvService.subReport_sh2(subReport_paramData);
				for(Map subReport_paramData2 : subReport_data_sh2_1){
					subReport_data_sh2_2.add(subReport_paramData2);
				}
			}
			Map<String, Object> subReportMap_sh2 = new HashMap<String ,Object>();
			subReportMap_sh2.put("REPORT_FILE", "s_pmp110clrkrv_sh_sub2.crf");
			subReportMap_sh2.put("DATA_SET", "S_PMP110CL1_SH_SUB2");
			subReportMap_sh2.put("SUB_DATA", subReport_data_sh2_2);
			subReports.add(subReportMap_sh2);
			crfFile = "Clipreport4/Z_sh/"+ ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";
		}


		String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	/**
	 *
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp130clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp130clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();

		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";

		String connectionName ="JDBC1";
		String datasetName ="PMP110CL1";


		ServletContext context = request.getServletContext();
		String path = "";
		if(ObjUtils.isNotEmpty(context)){
			path = context.getRealPath("/");
		}
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data = pmp130rkrvService.mainReport(param);

		List<Map<String, Object>> subReport_data = pmp130rkrvService.subReport(param);
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		subReportMap.put("REPORT_FILE", "pmp110clrkrv_sub.crf");
		subReportMap.put("DATA_SET", "PMP110CL1_SUB");
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);
		String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 *
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp130clrkrv_2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp130clrkrPrint_2( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();

		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2")) + ".crf";

		String connectionName ="JDBC1";
		String datasetName ="PMP130CLR_Q1";


		ServletContext context = request.getServletContext();
		String path = "";
		if(ObjUtils.isNotEmpty(context)){
			path = context.getRealPath("/");
		}
		//String imagePathFirst = path.split(":")[0] + ":";
		//param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data = pmp130rkrvService.selectPrintListByWorkShopCode(param);

		String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	@RequestMapping(value = "/prodt/pmp220clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp220clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = pmp220rkrvService.printList2(param);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	@RequestMapping(value = "/prodt/pmp200clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmp200clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report
		crfFile = "Clipreport4/Z_jw/"+ ObjUtils.getSafeString(param.get("RPT_ID4")) + ".crf";
		List<Map<String, Object>> report_data = pmp200ukrvService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/prodt/pmp280clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView pmp280clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String sDivCode = (String) param.get("DIV_CODE");
		  String selPrint = (String) param.get("SEL_PRINT");
		  String sInoutDate = (String) param.get("INOUT_DATE");
		  System.out.println("[[INOUT_DATE]]" + sInoutDate);
		  String crfFile = null;
		  List<Map<String, Object>> report_data = null;
		  param.put("INOUT_DATE", sInoutDate);
		  if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_pmp280clukrv_novis.crf")){
			  crfFile = CRF_PATH_NOVIS + "s_pmp280clukrv_novis.crf";
			  report_data = pmp280ukrvService.printList_novis(param);
		  }else{
			  if(selPrint.equals("TOSHIBA")){//선택한 프린터가 도시바이면 작은 라벨 출력
				  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
			  }else{
				  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
			  }
			  //Main Report
			  report_data = pmp280ukrvService.printList(param);
		  }

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }

	@RequestMapping(value = "/prodt/pmp281clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	   public ModelAndView pmp281clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  String sDivCode = (String) param.get("DIV_CODE");
		  String selPrint = (String) param.get("SEL_PRINT");
		  String sInoutDate = (String) param.get("INOUT_DATE");
		  String crfFile = null;
		  List<Map<String, Object>> report_data = null;

		  param.put("INOUT_DATE", sInoutDate);
		  String[] printDataArry = null;
		  String[] printDataArryDetail = null;
		  String printDatas = ObjUtils.getSafeString(param.get("PRINT_DATAS"));
		  String printDataDetail = null;

		    if(ObjUtils.isNotEmpty(printDatas)){
		    	printDataArry = printDatas.split(",");
		    }

		  List<Map> printDataList = new ArrayList<Map>();
		  for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				printDataDetail = ObjUtils.getSafeString(printDataArry[i]);
				printDataArryDetail= printDataDetail.split("\\^");
				for(int j=0; j< printDataArryDetail.length; j++){
					if(j==0){
						Object SELECT_ITEM_CODE =  printDataArryDetail[j];
					    map.put("ITEM_CODE", SELECT_ITEM_CODE);
					}else if(j==1){
						Object SELECT_WKORD_NUM =  printDataArryDetail[j];
						map.put("WKORD_NUM", SELECT_WKORD_NUM);
					}else if(j==2){
						Object SELECT_LOT_NO 	=  printDataArryDetail[j];
						map.put("LOT_NO", SELECT_LOT_NO);
					}else if(j==3){
						Object SELECT_INOUT_Q 	=  printDataArryDetail[j];
						map.put("INOUT_Q", SELECT_INOUT_Q);
					}else if(j==4){
						Object SELECT_INOUT_PRSN 	=  printDataArryDetail[j];
						map.put("INOUT_PRSN", SELECT_INOUT_PRSN);
					}else if(j==5){
						Object SELECT_STOCK_UNIT 	=  printDataArryDetail[j];
						map.put("STOCK_UNIT", SELECT_STOCK_UNIT);
					}else if(j==6){
						Object SELECT_PRINT_Q 	=  printDataArryDetail[j];
						map.put("PRINT_Q", SELECT_PRINT_Q);
					}else if(j==7){
						Object SELECT_OUTSTOCK_REQ_Q 	=  printDataArryDetail[j];
						map.put("OUTSTOCK_REQ_Q", SELECT_OUTSTOCK_REQ_Q);
					}else if(j==8){
						Object SELECT_JAN_INOUT_Q 	=  printDataArryDetail[j];
						map.put("JAN_INOUT_Q", SELECT_JAN_INOUT_Q);
					}else if(j==9){
						Object SELECT_WH_CODE 	=  printDataArryDetail[j];
						map.put("WH_CODE", SELECT_WH_CODE);
					}else if(j==10){
						Object SELECT_INOUT_DATE_2 	=  printDataArryDetail[j];
						map.put("INOUT_DATE_2", SELECT_INOUT_DATE_2);
					}
				}

				printDataList.add(map);
			}


		    param.put("PRINT_DATAS", printDataList);
		    if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_pmp280clukrv_novis.crf")){
				  crfFile = CRF_PATH_NOVIS + "s_pmp280clukrv_novis.crf";
				  report_data = pmp280ukrvService.printList_novis(param);
			  }else{
				  if(selPrint.equals("TOSHIBA")){//선택한 프린터가 도시바이면 작은 라벨 출력
					  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
				  }else{
					  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID1"));
				  }
				  //Main Report
				  report_data = pmp281ukrvService.printList(param);
			}
		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	      Map<String, Object> rMap = new HashMap<String, Object>();
	      rMap.put("success", "true");
	      rMap.put("resultKey", resultKey);
	      return ViewHelper.getJsonView(rMap);
	   }
}

