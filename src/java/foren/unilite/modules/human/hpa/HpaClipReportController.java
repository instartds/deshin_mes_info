package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class HpaClipReportController extends UniliteCommonController {
	final static String	CRF_PATH	= "Clipreport4/human/";

	@Resource(name = "hpa700rkrService")
	private Hpa700rkrServiceImpl hpa700rkrService;

	@Resource(name = "hpa900rkrService")
	private Hpa900rkrServiceImpl hpa900rkrService;

	@Resource(name = "hpa930rkrService")
	private Hpa930rkrServiceImpl hpa930rkrService;

	@Resource(name = "hpa970rkrService")
	private Hpa970rkrServiceImpl hpa970rkrService;

	//20200814 추가: 홈텍스-원천징수이행상황전자신고 (hpa990ukr)
	@Resource(name = "hpa990ukrService")
	private Hpa990ukrServiceImpl hpa990ukrService;

	@Resource(name = "hpa994ukrService")
	private Hpa994ukrServiceImpl hpa994ukrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	@RequestMapping(value = "/human/hpa700clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa700clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		String imagePath = doc.getImagePath();
		List<Map<String, Object>> report_data = null;

		  //부서별 지급대장
   	   if(param.get("DOC_KIND").equals("1")){
   		//Main Report
          report_data = hpa700rkrService.selectList1(param);
   		  crfFile = CRF_PATH + "hpa700p1clrkr.crf";
   		  resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

   	   //부서별 집계표
   	   }else if(param.get("DOC_KIND").equals("2")){
   		//Main Report
	   	  report_data = hpa700rkrService.selectList2(param);
		  crfFile = CRF_PATH + "hpa700p2clrkr.crf";

		  resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

 	   //명세서
   	   }else if(param.get("DOC_KIND").equals("3")){

   		  report_data = hpa700rkrService.selectList3(param);
		  crfFile = CRF_PATH + "hpa700p3clrkr.crf";
		//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa700rkrService.selectList3_sub(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);
		  resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

   	   }

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hpa900clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa900clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		String imagePath = doc.getImagePath();

		if(param.get("DOC_KIND").equals("5")) {

			if(param.get("GUNTAE").equals("Y")) {
				//crfFile = CRF_PATH + "hpa910kr.crf";
				crfFile = CRF_PATH + "hpa915kr.crf";
			} else {
				//crfFile = CRF_PATH + "hpa913kr.crf";
				crfFile = CRF_PATH + "hpa916kr.crf";
			};

			//Main Report
			List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint56(param);

			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint56(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

/*
			//Main Report
			List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint1356(param);

			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint12356(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
*/

		} else if(param.get("DOC_KIND").equals("6")) {
			if(param.get("GUNTAE").equals("Y")) {
				//crfFile = CRF_PATH + "hpa912kr.crf";
				crfFile = CRF_PATH + "hpa917kr.crf";
			} else {
				//crfFile = CRF_PATH + "hpa914kr.crf";
				crfFile = CRF_PATH + "hpa918kr.crf";
			};

			//Main Report
			List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint56(param);

			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint56(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

/*
			//Main Report
			List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint1356(param);
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint12356(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
*/

		}
		else if(param.get("DOC_KIND").equals("4")) {
			crfFile = CRF_PATH + "hpa900clrkrv4.crf";

			//Main Report
			List<Map<String, Object>> report_data = hpa900rkrService.selectListPrint4(param);

			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint4(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		else {
			crfFile = CRF_PATH + "hpa900clrkrv1.crf";

			if(param.get("DOC_KIND").equals("2")) {
				crfFile = CRF_PATH + "hpa900clrkrv2.crf";
			}
			else if(param.get("DOC_KIND").equals("3")) {
				//crfFile = CRF_PATH + "hpa900clrkrv3.crf";
				if(param.get("GUNTAE").equals("Y")) {
					crfFile = CRF_PATH + "hpa900clrkrv3.crf";
				} else {
					crfFile = CRF_PATH + "hpa900clrkrv3_2.crf";
				};
			}

			//Main Report
			List<Map<String, Object>> report_data = null;
			if(param.get("DOC_KIND").equals("2")) {
				report_data = hpa900rkrService.selectListPrint2(param);
			}
			else {
				report_data = hpa900rkrService.selectListPrint1356(param);
			}

			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = hpa900rkrService.selectSubListPrint12356(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hpa930clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa930clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String rptType = ObjUtils.getSafeString(param.get("PRINT"));
		String crfFile = CRF_PATH + "hpa930clrkrv.crf";

		List<Map<String, Object>> report_data = hpa930rkrService.selectList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hpa970clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa970clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		//Image 경로 
				String imagePath = doc.getImagePath();

				//로고, 스탬프 패스 추가
				ReportUtils.clipReportLogoPath(param, dao, request);
				ReportUtils.clipReportSteampPath(param, dao, request);
		
		String crfFile = CRF_PATH + "hpa970clrkrv.crf";

		List<Map<String, Object>> report_data = hpa970rkrService.selectList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 홈텍스-원천징수이행상황전자신고 (hpa990ukr) - 20200814 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hpa990clukrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hpa990clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		String crfFile		= CRF_PATH + "hpa990clukr.crf";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hpa990ukrService.printMainData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		//원천징수 명세 및 납부세액 조회
		List<Map<String, Object>> subReport_data1 = hpa990ukrService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);
		//환급세액 데이터 조회
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = hpa990ukrService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);
		//주민세 합계 계산
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = hpa990ukrService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);
		//주민세 납부 신고
		Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data4 = hpa990ukrService.printResidentNapTax(param);
		subReportMap4.put("DATA_SET", "SQLDS5");
		subReportMap4.put("SUB_DATA", subReport_data4);
		subReports.add(subReportMap4);
		//주민세 종업원분
		Map<String, Object> subReportMap5 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data5 = hpa990ukrService.printResidentEmployee(param);
		subReportMap5.put("DATA_SET", "SQLDS6");
		subReportMap5.put("SUB_DATA", subReport_data5);
		subReports.add(subReportMap5);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hpa994clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa994clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String rptType = ObjUtils.getSafeString(param.get("PRINT"));
		String crfFile = "";

		if("1".equals(rptType)){
			crfFile = CRF_PATH + "hpa994rkr1.crf";
		} else {
			crfFile = CRF_PATH + "hpa994rkr2.crf";
		};
		List<Map<String, Object>> report_data = null;

		if("1".equals(rptType)){
			//Main Report
			report_data = hpa994ukrService.selectList1(param);
		} else {
			//Main Report
			report_data = hpa994ukrService.selectList2(param);
		};

		//Main Report
		//report_data = hpa994ukrService.selectList1(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}