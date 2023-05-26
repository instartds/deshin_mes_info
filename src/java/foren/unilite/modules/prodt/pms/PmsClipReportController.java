package foren.unilite.modules.prodt.pms;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.prodt.pmp.Pmp100ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class PmsClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Prodt/";

	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Prodt";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "pms410skrvService" )
	private  Pms410skrvServiceImpl pms410skrvService;

	@Resource( name = "pms300skrvService" )
	private  Pms300skrvServiceImpl pms300skrvService;


	/**
	 * 검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms410clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pms410clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		String divCode = (String) param.get("DIV_CODE");
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

	/*	if(divCode.equals("02")){//화성인 경우
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID5"));
		}else{*/
			if(param.get("INSPEC_ITEM").equals("1")){//반제품 공정검사
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
			}else{													//제품 출하검사
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
			}
		//}


		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

	    String[] inspecNumArry = null;
	    String[] inspecSeqArry = null;

	    String inspecNum = ObjUtils.getSafeString(param.get("INSPEC_NUMS2"));
	    if(ObjUtils.isNotEmpty(inspecNum)){
	        inspecNumArry = inspecNum.split(",");
	    }
		List<Map> inspecNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_INSPEC_NUMS =  inspecNumArry[i];

			map.put("INSPEC_NUMS", SELECT_INSPEC_NUMS);

			inspecNumSeqList.add(map);
		}
	    param.put("INSPEC_NUM_SEQ", inspecNumSeqList);

		List<Map<String, Object>> report_data =  pms410skrvService.mainReport(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		if(divCode.equals("02")){//화성인 경우
			if(param.get("INSPEC_ITEM").equals("1")){//반제품 공정검사
				subReportMap.put("pms410clrkrv_5_sub", "SQLDS2");
			}else{
				subReportMap.put("pms410clrkrv_5_sub2", "SQLDS2");
			}
		}else{
			if(param.get("INSPEC_ITEM").equals("1")){//반제품 공정검사
				subReportMap.put("pms410clrkrv_2_sub", "SQLDS2");
			}else{
				subReportMap.put("pms410clrkrv_sub", "SQLDS2");
			}

		}


		List<Map<String, Object>> subReport_data = pms410skrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 검사성적서_라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms410clrkrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pms410clrkrv_label( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		/*if( sDivCode.equals("01")){//사업장이 김천일 경우
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
		}else if(sDivCode.equals("02")){//사업장이 화성일 경우
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));
		}else{// 그외
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
		}*/
        /*검사성적서의 라벨은 김천, 화성 같은 규격을 사용*/
        crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

	    String[] inspecNumArry = null;
	    String[] inspecSeqArry = null;

	    String inspecNum = ObjUtils.getSafeString(param.get("INSPEC_NUMS"));
	    if(ObjUtils.isNotEmpty(inspecNum)){
	        inspecNumArry = inspecNum.split(",");
	    }
		List<Map> inspecNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_INSPEC_NUMS =  inspecNumArry[i];

			map.put("INSPEC_NUMS", SELECT_INSPEC_NUMS);

			inspecNumSeqList.add(map);
		}
	    param.put("INSPEC_NUM_SEQ", inspecNumSeqList);

		List<Map<String, Object>> report_data =  pms410skrvService.mainReport_label(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서) 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms300clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pms300clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		String divCode = (String) param.get("DIV_CODE");
		String selTab = (String) param.get("SEL_TAB");
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		if(divCode.equals("02")){//화성인 경우
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
		}else{
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		}

		logger.debug("[crfFile]" + crfFile);
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

	    String[] prodtNumArry = null;
	    String[] itemCodeArry = null;

	    String prodtNum = ObjUtils.getSafeString(param.get("PRODT_NUMS"));
	    if(ObjUtils.isNotEmpty(prodtNum)){
	        prodtNumArry = prodtNum.split(",");
	    }
		List<Map> prodtNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_PRODT_NUMS =  prodtNumArry[i];

			map.put("PRODT_NUM", SELECT_PRODT_NUMS);

			prodtNumSeqList.add(map);
		}
	    param.put("PRODT_NUMS", prodtNumSeqList);

	    String itemCodes = ObjUtils.getSafeString(param.get("ITEM_CODES"));
	    if(ObjUtils.isNotEmpty(itemCodes)){
	    	itemCodeArry = itemCodes.split(",");
	    }
		List<Map>  itemCodeList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_ITEM_CODES =  itemCodeArry[i];

			map.put("ITEM_CODES", SELECT_ITEM_CODES);

			itemCodeList.add(map);
		}
	    param.put("SEL_ITEM_CODE", itemCodeList);


		List<Map<String, Object>> report_data = null;

		if(selTab.equals("01")){
			report_data = pms300skrvService.mainReport(param);
		}else if(selTab.equals("02")){
			report_data = pms300skrvService.mainReport_2(param);
		}else{
			report_data =pms300skrvService.mainReport_3(param);
		}


		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		if(divCode.equals("02")){//화성인 경우

				subReportMap.put("pms300clrkrv_2_sub", "SQLDS2");
				subReportMap.put("pms300clrkrv_2_sub2", "SQLDS2");

		}else{

				subReportMap.put("pms300clrkrv_sub", "SQLDS2");
				subReportMap.put("pms300clrkrv_sub2", "SQLDS2");

		}


		List<Map<String, Object>> subReport_data = pms300skrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 접수및검사현황조회(검사의뢰서)_라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms300clrkrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pms300clrkrv_label( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
        String selTab = (String) param.get("SEL_TAB");

		/*if( sDivCode.equals("01")){//사업장이 김천일 경우
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
		}else if(sDivCode.equals("02")){//사업장이 화성일 경우
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));
		}else{// 그외
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
		}*/
        /*검사성적서의 라벨은 김천, 화성 같은 규격을 사용*/
        crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		 String[] prodtNumArry = null;


	    String prodtNum = ObjUtils.getSafeString(param.get("PRODT_NUMS"));
	    if(ObjUtils.isNotEmpty(prodtNum)){
	        prodtNumArry = prodtNum.split(",");
	    }
		List<Map> prodtNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_PRODT_NUMS =  prodtNumArry[i];

			map.put("PRODT_NUM", SELECT_PRODT_NUMS);

			prodtNumSeqList.add(map);
		}
	    param.put("PRODT_NUMS", prodtNumSeqList);

	    List<Map<String, Object>> report_data = null;
		if(selTab.equals("01")){
			report_data = pms300skrvService.mainReport_label(param);
		}else if(selTab.equals("02")){
			report_data =  pms300skrvService.mainReport_label_2(param);
		}else{
			report_data = pms300skrvService.mainReport_label_3(param);
		}



		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}

