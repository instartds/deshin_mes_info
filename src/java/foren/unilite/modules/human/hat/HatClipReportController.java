package foren.unilite.modules.human.hat;

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
public class HatClipReportController  extends UniliteCommonController {
	final static String CRF_PATH	= "/clipreport4/crf/human/";
	final static String CRF_PATH2	= "Clipreport4/Human/";

	@Resource( name = "hat530rkrService" )
	private Hat530rkrServiceImpl hat530rkrServiceImpl;

	@Resource( name = "hat540rkrService" )
	private Hat540rkrServiceImpl hat540rkrServiceImpl;

	//20200812 추가: 월근무현황출력 (hat820rkr)
	@Resource( name = "hat820rkrService" )
	private Hat820rkrServiceImpl hat820rkrServiceImpl;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	/**
	 * 일근태현황출력 (hat530rkr)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hat530clrkrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hat530clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";		
		String dutyInputRuleStr = "N";
		
		List<Map<String, Object>> dutyInputRuleList = hat530rkrServiceImpl.selectHBS400T(param);
		if (dutyInputRuleList != null && dutyInputRuleList.size() > 0) {
			Map<String, Object> map = dutyInputRuleList.get(0);
			if (map.get("DUTY_INPUT_RULE") != null) {
				dutyInputRuleStr = map.get("DUTY_INPUT_RULE").toString();
			}
		}

		int fieldNum = 0;
		
		if (dutyInputRuleStr.equals("Y")) {
			fieldNum = 14;
			if ("1".equals(param.get("DOC_KIND"))) {
				crfFile = CRF_PATH2 + "hat530rkr1.crf";
			} else {
				crfFile = CRF_PATH2 + "hat530rkr2.crf";
			}
		} else {
			if ("1".equals(param.get("DOC_KIND"))) {
				fieldNum = 19;
				crfFile = CRF_PATH2 + "hat530rkr3.crf";
			} else {
				fieldNum = 17;
				crfFile = CRF_PATH2 + "hat530rkr4.crf";
			}
		}	   
				
		param.put("USE_YN", "Y");
		List<Map<String, Object>> DUTY_CODE = hat530rkrServiceImpl.selectDutyCode(param);
		List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
		if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
			int num = DUTY_CODE.size();
			for (int i = 0; i <= fieldNum; i++) {
				if (i >= num) {
					param.put("Field" + ( i + 1 ), "");
					DUTY_CODE_SUPPLY.add(i + 1);
				} else {
					Map<String, Object> map = DUTY_CODE.get(i);
					param.put("Field" + ( i + 1 ), map.get("CODE_NAME"));
				}
			}
			param.put("DUTY_CODE_SIZE", num);
			param.put("DUTY_CODE", DUTY_CODE);
			param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
			param.put("FIELD_NUM", fieldNum);
			List<Integer> fieldNumList = new ArrayList<Integer>();
			for (int i = 0; i <= fieldNum; i++) {
				fieldNumList.add(i);
			}
			param.put("FIELD_NUM_LIST", fieldNumList);
		}
				
		param.put("DUTY_INPUT_RULE", dutyInputRuleStr);
		param.put("COMP_NAME", user.getCompName());
		
		//Main Report
		List<Map<String, Object>> report_data = hat530rkrServiceImpl.selectToPrint(param);

		//Sub Report use data
		/*List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("HRT510RKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = hat530rkrServiceImpl.selectPrintDData(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);*/

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 일일인원현황  (hat540rkr)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hat540clrkrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hat540clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String dutyInputRuleStr = "N";
		
		List<Map<String, Object>> dutyInputRuleList = hat540rkrServiceImpl.selectHBS400T(param);
		if (dutyInputRuleList != null && dutyInputRuleList.size() > 0) {
			Map<String, Object> map = dutyInputRuleList.get(0);
			if (map.get("DUTY_INPUT_RULE") != null) {
				dutyInputRuleStr = map.get("DUTY_INPUT_RULE").toString();
			}
		}
		
		int fieldNum = 0;
		
		fieldNum = 19;

		if ("1".equals(param.get("DOC_KIND"))) {
			crfFile = CRF_PATH2 + "hat540rkr1.crf";
		} else {
			crfFile = CRF_PATH2 + "hat540rkr2.crf";
		}

		param.put("USE_YN", "Y");
		
		List<Map<String, Object>> DUTY_CODE = hat540rkrServiceImpl.selectDutyCode(param);
		List<Integer> DUTY_CODE_SUPPLY = new ArrayList<Integer>();
		if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
			int num = DUTY_CODE.size();
			for (int i = 0; i <= fieldNum; i++) {
				if (i >= num) {
					param.put("Field" + ( i + 1 ), "");
					DUTY_CODE_SUPPLY.add(i + 1);
				} else {
					Map<String, Object> map = DUTY_CODE.get(i);
					param.put("Field" + ( i + 1 ), map.get("CODE_NAME"));
				}
			}
			param.put("DUTY_CODE_SIZE", num);
			param.put("DUTY_CODE", DUTY_CODE);
			param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
			param.put("FIELD_NUM", fieldNum);
			
			//List<Integer> fieldNumList = new ArrayList<Integer>();
			
			//for (int i = 0; i <= fieldNum; i++) {
			//	fieldNumList.add(i);
			//}
			
			//param.put("FIELD_NUM_LIST", fieldNumList);
		}
		
		param.put("USE_YN", "N");

		
		List<Map<String, Object>> dutyCodeN = hat540rkrServiceImpl.selectDutyCode(param);
		
		param.put("DUTY_CODE_N", dutyCodeN);
		
		param.put("DUTY_INPUT_RULE", dutyInputRuleStr);
		param.put("COMP_NAME", user.getCompName());
		
		//Main Report
		List<Map<String, Object>> report_data = hat540rkrServiceImpl.selectToPrint(param);

		//Sub Report use data
		/*List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("HRT510RKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = hat530rkrServiceImpl.selectPrintDData(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);*/

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 월근무현황출력 (hat820rkr)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hat820clrkrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hat820clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		String crfFile		= CRF_PATH2 + "hat820clrkr.crf";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String dutyInputRuleStr = "N";

		//근태코드 가져오는 로직
		List<Map<String, Object>> DUTY_CODE	= hat820rkrServiceImpl.fnHat820nQ(param);
		List<Integer> DUTY_CODE_SUPPLY		= new ArrayList<Integer>();
		if (DUTY_CODE != null && DUTY_CODE.size() > 0) {
			int num = DUTY_CODE.size();
			for (int i = 0; i <= 9; i++) {
				if (i >= num) {
					param.put("FIELD" + ( i + 1 ), "");
					DUTY_CODE_SUPPLY.add(i + 1);
				} else {
					Map<String, Object> map = DUTY_CODE.get(i);
					param.put("FIELD" + ( i + 1 ), map.get("CODE_NAME"));
				}
			}
			param.put("DUTY_CODE_SIZE", num);
			param.put("DUTY_CODE", DUTY_CODE);
			param.put("DUTY_CODE_SUPPLY", DUTY_CODE_SUPPLY);
		}
		//Main Report
		List<Map<String, Object>> report_data = hat820rkrServiceImpl.selectToPrint(param);

		//Sub Report use data
		/*List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("HRT510RKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = hat530rkrServiceImpl.selectPrintDData(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);*/

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}