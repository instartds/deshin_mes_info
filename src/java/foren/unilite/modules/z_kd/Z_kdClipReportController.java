package foren.unilite.modules.z_kd;

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

import foren.unilite.com.code.CodeInfo;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.prodt.pmp.Pmp100ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;
import foren.unilite.modules.matrl.mms.Mms110ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_kdClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Matrl/";

	final static String			CRF_PATH2		= "Clipreport4/Z_kd/";
	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "s_mpo150rkrv_kdService" )
	private S_mpo150rkrv_kdServiceImpl s_mpo150rkrv_kdService;

	@Resource( name = "s_pmp120rkrv_kdService" )
	private S_pmp120rkrv_kdServiceImpl s_pmp120rkrv_kdService;

	@Resource( name = "s_str900skrv_kdService" )
	private S_str900skrv_kdServiceImpl s_str900skrv_kdService;

	@Resource( name = "s_zcc610skrv_kdService" )
	private S_zcc610skrv_kdServiceImpl s_zcc610skrv_kdService;

	@Resource( name = "s_bpr210rkrv_kdService" )
	private S_bpr210rkrv_kdServiceImpl s_bpr210rkrv_kdService;

	@Resource( name = "s_pmr928rkrv_kdService" )
	private S_pmr928rkrv_kdServiceImpl s_pmr928rkrv_kdService;
	/**
	 * 라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kd/s_mpo150clrkrv_kd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mpo150clrkrv_kd( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
        String sDivCode = (String) param.get("DIV_CODE");
    	CodeDetailVO cdo = null;

    	 if(param.get("FORM").equals("K")) {
    		  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
    	 }else{
    		  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
    	 }

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  s_mpo150rkrv_kdService.selectList(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_kd/s_pmp120clrkrv_kd.do", method = {RequestMethod.GET,RequestMethod.POST})
		public ModelAndView s_pmp120clrkrv_kdPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		  ClipReportDoc doc = new ClipReportDoc();
		
		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  
		  
		  String crfFile = null;
		  List<Map<String, Object>> report_data = null;
		  	
		  crfFile = CRF_PATH2 + "s_pmp120clrkrv_kd.crf";
		  report_data = s_pmp120rkrv_kdService.printList(param);
		 
		  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		  Map<String, Object> rMap = new HashMap<String, Object>();
		  rMap.put("success", "true");
		  rMap.put("resultKey", resultKey);
		  return ViewHelper.getJsonView(rMap);
	   }

	/**
	 * 출고현황 테스트
	 */
	@RequestMapping(value = "/z_kd/s_str900skrv_kd_clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str900skrv_kd_clrkrvPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + "s_str900skrv2_kd.crf";

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		List<Map<String, Object>> report_data =  s_str900skrv_kdService.selectPrint(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "testData", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	/**
	 * 금형미수금 레포트(개발금형, 시작샘플)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kd/s_zcc610clskrv_kd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_zcc610clskrv_kdPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
        String sDivCode = (String) param.get("DIV_CODE");
    	CodeDetailVO cdo = null;

    	if(param.get("WORK_TYPE").equals("1")){
    		crfFile = CRF_PATH2 + "s_zcc610clskrv_kd1.crf";		//개발금형
    	}else{
    		crfFile = CRF_PATH2 + "s_zcc610clskrv_kd2.crf";		//시작샘플
    	}
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  s_zcc610skrv_kdService.selectDetail(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 품목라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kd/s_bpr210clrkrv_kd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_bpr210clrkrv_kdPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  
	  
	  String crfFile = null;
	  List<Map<String, Object>> report_data = null;
	  	
	  if(param.get("GUBUN").equals("A")){//원부자재

		  crfFile = "Clipreport4/Matrl/" + "mms110clukrv_kdg.crf";
	  }else{		//제품

		  crfFile = CRF_PATH2 + "s_pmp120clrkrv_kd.crf";
	  }
	  
	  
	  report_data = s_bpr210rkrv_kdService.printList(param);
	 
	  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
	
	  Map<String, Object> rMap = new HashMap<String, Object>();
	  rMap.put("success", "true");
	  rMap.put("resultKey", resultKey);
	  return ViewHelper.getJsonView(rMap);
   }
	
	@RequestMapping(value = "/z_kd/s_pmr928clrkrv_kd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmr928clrkrv_kdPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
	
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = null;
		List<Map<String, Object>> report_data = null;
	  	
		String[] words  =   ((String) param.get("LINE_SEQ")).split(",");
		List<Map<String, Object>> detailList =  (List<Map<String, Object>>) dao.list("s_pmr928rkrv_kdServiceImpl.selectList2", param);
		String reqNum = (String) dao.select("s_pmr928rkrv_kdServiceImpl.selectAutoReqNum", param);
 	 
		int ii = 0;
		for(Map paramData: detailList) {

			paramData.put("REQ_NUM", reqNum);
			paramData.put("S_USER_ID", user.getUserID());
 		 
			for(int i=0; i <= words.length-1; i++){

				String[] words2 = words[i].split("[|]");
				if(words2[0].equals( (String) paramData.get("BASIS_NUM") + (String) paramData.get("INSPEC_NUM") + String.valueOf(paramData.get("INSPEC_SEQ")))){
					ii =  ii +1;
					paramData.put("REQ_SEQ", ii );
					if(words2.length > 1 ){
						paramData.put("REMARK",words2[1]);
					}
					dao.insert("s_pmr928rkrv_kdServiceImpl.insertL_PMR928T_KD", paramData);
				}
			}
		}

		param.put("S_REQ_NUM", reqNum);
		
		crfFile = CRF_PATH2 + "s_pmr928clrkrv_kd.crf";
		report_data = s_pmr928rkrv_kdService.printList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
	
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	
}

