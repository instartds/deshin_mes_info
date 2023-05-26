package foren.unilite.modules.human.hpa;

import java.io.File;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.bcel.generic.ARRAYLENGTH;
import org.apache.commons.ssl.org.bouncycastle.asn1.x509.qualified.TypeOfBiometricData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.stringtemplate.v4.compiler.CodeGenerator.listElement_return;
import org.stringtemplate.v4.compiler.STParser.mapExpr_return;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class HpaReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;// = LoggerFactory.getLogger(this.getClass());
	private final Logger logger1 = LoggerFactory.getLogger(this.getClass());
	@Resource(name="hpa990ukrService")
	private Hpa990ukrServiceImpl hpa990ukrService ;
	/**
	 * add by Chen.rd
	 * 거래처별원장출력
	 * 
	 * @param _req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hpa/hpa900rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView hpa900rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = { "top_Payment","hpa900az_sub","hpa900az3_sub","hpa900az4_sub" };

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("S_COMP_CODE", user.getCompCode());
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		int strtype = Integer.valueOf(param.get("STRTYPE").toString());
		JasperFactory jf = null;   // "폴더명" , "파일명" , "파라미터
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>(); 
		switch (strtype) {
		case 1: jf = jasperService.createJasperFactory("hpa900rkr","hpa900rkr", param);
				list = jasperService.selectList("hpa900rkrServiceImpl.selectListForPrint", param);
				break;
		case 3: jf = jasperService.createJasperFactory("hpa900rkr","hpa900rkr3", param); 
				list = jasperService.selectList("hpa900rkrServiceImpl.selectListForPrint", param);
				break;
		case 4: jf = jasperService.createJasperFactory("hpa900rkr","hpa900rkr4", param); 
				list = jasperService.selectList("hpa900rkrServiceImpl.selectListForPrint4", param);
				break;
		default:
			jf = jasperService.createJasperFactory("hpa900rkr", param); 
			break;
		}
		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌


		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);

		// 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
		// jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		jf.addParam("DEFUAL_TITLE", param.get("STRTYPE"));
		jf.addParam("REMARK", param.get("REMARK"));
		// Primary data source

		Map dataParam = new HashMap();
		List<Map<String, Object>> sublist = jasperService.selectList("hpa900rkrServiceImpl.selectSubListForPrint", param);
//		if(strtype == 4 ||strtype == 5){
//			for(Map.Entry<String, Object> entry : sublist.get(0).entrySet())
//				jf.addParam(entry.getKey(), entry.getValue());
//		}
//		else{
			jf.addSubDS("DS_SUB02", sublist);
//		}
		jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
		jf.setList(list);
		return ViewHelper.getJasperView(jf);
	}
	
	/**
	 * add by Chen.rd
	 * 거래처별원장출력
	 * 
	 * @param _req
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hpa/hpa901rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView hpa901rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = { "top_payment","hpa901az_sub","hpa901az3_sub" };

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("S_COMP_CODE", user.getCompCode());
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		int strtype = Integer.valueOf(param.get("STRTYPE").toString());
		JasperFactory jf = null;   // "폴더명" , "파일명" , "파라미터
		switch (strtype) {
		case 1: jf = jasperService.createJasperFactory("hpa901rkr","hpa901rkr", param); break;
		case 2: jf = jasperService.createJasperFactory("hpa901rkr","hpa901rkr2", param); break;
		case 3: jf = jasperService.createJasperFactory("hpa901rkr","hpa901rkr3", param); break;
		case 4: jf = jasperService.createJasperFactory("hpa901rkr","hpa901rkr4", param); break;
		case 5: jf = jasperService.createJasperFactory("hpa901rkr","hpa901rkr5", param); break;
		default:
			jf = jasperService.createJasperFactory("hpa901rkr", param); 
			break;
		}
		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌


		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);

		// 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
		// jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		jf.addParam("DEFUAL_TITLE", param.get("STRTYPE"));
		jf.addParam("REMARK", param.get("REMARK"));
		// Primary data source

		Map dataParam = new HashMap();
		List<Map<String, Object>> list = jasperService.selectList("hpa901rkrServiceImpl.selectList1", param);
		List<Map<String, Object>> sublist = jasperService.selectList("hpa901rkrServiceImpl.getSubList", param);
		if(strtype == 4 ||strtype == 5){
			for(Map.Entry<String, Object> entry : sublist.get(0).entrySet())
				jf.addParam(entry.getKey(), entry.getValue());
		}
		else{
			jf.addSubDS("DS_SUB02", sublist);
		}
		jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));
		jf.setList(list);
		return ViewHelper.getJasperView(jf);
	}
	
	
	@RequestMapping(value = "/hpa/hpa930rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView hpa930rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = {};

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("S_COMP_CODE", user.getCompCode());
		if(param.get("DEPT_CODES")!=null){
			String[] depts = param.get("DEPT_CODES").toString().split(",");
			param.put("DEPT_CODE", depts);
		}
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		int cost_pool = Integer.valueOf(param.get("COST_POOL").toString());
		JasperFactory jf = null;   // "폴더명" , "파일명" , "파라미터
		switch (cost_pool) {
		case 1: jf = jasperService.createJasperFactory("hpa930rkr","hpa930rkr", param); break;
		case 2: jf = jasperService.createJasperFactory("hpa930rkr","hpa931rkr", param); break;
		case 3: jf = jasperService.createJasperFactory("hpa930rkr","hpa932rkr", param); break;
		default:
			jf = jasperService.createJasperFactory("hpa930rkr", param); 
			break;
		}
		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌


		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);
		jf.addParam("PAY_YYYYMM", param.get("PAY_YYYYMM"));
		// 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
		// jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		// Primary data source
		List<Map<String, Object>> list = jasperService.selectList("Hpa930rkrServiceImpl.selectList", param);
		jf.setList(list);
		return ViewHelper.getJasperView(jf);
	}
	
	
	/**
	 * add by Chen.Rd
	 * @param _req
	 * @param user
	 * @param request
	 * @param reportType
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hpa/hpa940ukrPrint.do", method = RequestMethod.GET)
	public ModelAndView hpa940rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = {};

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		Map data = new HashMap<String, Object>();
		int dataLenth = Integer.parseInt(param.get("DATA_LENGTH").toString());
		List<Map<String, Object>> list = new ArrayList<>();
		for(int i=0;i<dataLenth;i++){
			Map<String,Object> map = new Gson().fromJson(param.get(i+"").toString(), Map.class);
			if(map.get("SELECTED")==null)
				map.put("SELECTED", false);
			list.add(map);
		}
		Map arg = new HashMap<String, Object>();
		arg.put("S_COMP_CODE", user.getCompCode());
		for(Map item:list){
			arg.put("DIV_CODE", item.get("DIV_CODE"));
			item.put("DIV_NAME", jasperService.selectList("Hpa940ukrServiceImpl.selectByDivCode", arg).get(0).get("DIV_NAME"));
			arg.put("POST_CODE", item.get("POST_CODE"));
			item.put("POST_NAME", jasperService.selectList("Hpa940ukrServiceImpl.selectByPostCode", arg).get(0).get("CODE_NAME"));
		}
		
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		JasperFactory jf = jasperService.createJasperFactory("hpa940ukr", param); 

		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
		jf.addParam("TITLE", param.get("TITLE").toString());

		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		// 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
		// jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		// Primary data source
		jf.setList(list);
		return ViewHelper.getJasperView(jf);
	}
	
	
	@RequestMapping(value = "/hpa/hpa970rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView hpa970rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = {};

		// Report와 SQL용 파라미터 구성
		Map param = _req.getParameterMap();
		param.put("S_COMP_CODE", user.getCompCode());
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		JasperFactory jf = jasperService.createJasperFactory("hpa970rkr", param);
		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌


		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);
		jf.addParam("YEAR_TO", param.get("DATE_TO").toString().substring(0, 4));
		jf.addParam("PRINT_NUM",param.get("PRINT_NUM"));
		jf.addParam("OBJECTS",param.get("OBJECTS"));
		jf.addParam("JECHUL",param.get("JECHUL"));
		jf.addParam("SOJONUM",param.get("SOJONUM"));
		jf.addParam("ISSUE_DATE",param.get("ISSUE_DATE"));
		// 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)
		// jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
		// Primary data source
		List<Map<String, Object>> list = jasperService.selectList("hpa970rkrServiceImpl.selectList", param);
		jf.setList(list);
		return ViewHelper.getJasperView(jf);
	}
	/**
	 * add by zhshl
	 * @param _req
	 * @param user
	 * @param request
	 * @param reportType
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value = "/hpa/hpa990ukrPrint.do", method = RequestMethod.GET)
//	public ModelAndView hpa990ukrPrint(
//			ExtHtttprequestParam _req,
//			LoginVO user,
//			HttpServletRequest request,
//			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
//			throws Exception {
//		String[] subReportFileNames = {};
//
//		// Report와 SQL용 파라미터 구성
//		Map param = _req.getParameterMap();
//		param.put("S_COMP_CODE", user.getCompCode());
//		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
//		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
//		JasperFactory jf = jasperService.createJasperFactory("hpa990ukr", param);
//		// 거래합계 출력 여부에 따라서 레포트 다른 화면을 보여줌
//
//		jf.setReportType(reportType);
//		// SubReport 파일명 목록을 전달
//		// 레포트 수행시 compile을 상황에 따라 수행함.
//		jf.setSubReportFiles(subReportFileNames);
//		// Primary data source
//		List<Map<String, Object>> list = hpa990ukrService.selectList(param);
//		jf.setList(list);
//		return ViewHelper.getJasperView(jf);
//	}
}
