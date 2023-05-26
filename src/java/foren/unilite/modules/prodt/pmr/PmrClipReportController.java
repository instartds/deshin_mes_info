package foren.unilite.modules.prodt.pmr;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({"unchecked","rawtypes"})
public class PmrClipReportController	extends UniliteCommonController {

	final static String			CRF_PATH = "Clipreport4/Prodt/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "pmr200ukrvService" )
	private Pmr200ukrvServiceImpl pmr200ukrvService;

	@Resource( name = "pmr360skrvService" )
	private Pmr360skrvServiceImpl pmr360skrvService;

	@Resource( name = "pmr100ukrvService" )
	private Pmr100ukrvServiceImpl pmr100ukrvService;

	/**
	 * 생산자재출고(pmr200ukrv) 라벨 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmr200clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		List itemCodeList	= new ArrayList();
		List lotNoList		= new ArrayList();
		List whCodeList		= new ArrayList();

		String[] itemCodes	= param.get("ITEM_CODE").toString().split(",");
		String[] lotNos		= param.get("LOT_NO").toString().split(",");
		String[] whCodes	= param.get("WH_CODE").toString().split(",");

		for(String itemcode : itemCodes) {
			itemCodeList.add(itemcode);
		}
		for(String lotno : lotNos) {
			lotNoList.add(lotno);
		}
		for(String whcode : whCodes) {
			whCodeList.add(whcode);
		}
		param.put("ITEM_CODE"	, itemCodeList);
		param.put("LOT_NO"		, lotNoList);
		param.put("WH_CODE"		, whCodeList);

		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = pmr200ukrvService.selectClipPrintList(param);
		//List<Map<String, Object>> report_data = null;
		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 공정검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr360clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmr360clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
//WKORD_NUM_PROGS
		  String[] groupKeysArry = null;


		    String groupKeys = ObjUtils.getSafeString(param.get("GROUP_KEYS"));
		    if(ObjUtils.isNotEmpty(groupKeys)){
		    	groupKeysArry = groupKeys.split(",");
		    }
			List<Map> groupKeysList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){

				Map map = new HashMap();

				Object SELECT_GROUP_KEY =  groupKeysArry[i];

				map.put("GROUP_KEY", SELECT_GROUP_KEY);

				groupKeysList.add(map);
			}
		    param.put("GROUP_KEYS", groupKeysList);

		List<Map<String, Object>> report_data =  pmr360skrvService.mainReport(param);
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		 subReportMap.put("pmr360clrkrv_sub", "SQLDS2");

		List<Map<String, Object>> subReport_data = pmr360skrvService.subReport(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

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
	@RequestMapping(value = "/prodt/pmr100clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmr100clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		if(divCode.equals("02")){//화성일 경우
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));
		}else{

			if(param.get("STD_ITEM_ACCOUNT").equals("20")){//반제품 공정검사
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
			}else{													//제품 출하검사
				crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
			}
		}


		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);



		List<Map<String, Object>> report_data =  pmr100ukrvService.mainReport(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data = null;
		if(divCode.equals("02")){//화성일 경우
			subReportMap.put("pmr100clrkrv_4_sub", "SQLDS2");
			subReportMap.put("pmr100clrkrv_4_sub2", "SQLDS2");
			subReport_data = pmr100ukrvService.subReport2(param);
		}else{
			if(param.get("STD_ITEM_ACCOUNT").equals("20")){//반제품 공정검사
				subReportMap.put("pmr100clrkrv_2_sub", "SQLDS2");
			}else{
				subReportMap.put("pmr100clrkrv_sub", "SQLDS2");
			}
			subReport_data = pmr100ukrvService.subReport(param);
		}



		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

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
	@RequestMapping(value = "/prodt/pmr100clrkrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView pmr100clrkrv_label( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
        String gubun = (String) param.get("GUBUN");

        /*검사성적서의 라벨은 김천, 화성 같은 규격을 사용*/
        crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);
		param.put("PAGE_START", 1);
		List<Map<String, Object>> report_data = null;
		if(gubun.equals("SHIN")){//신환용 라벨 후공정 가져오는 로직 적용
			Map paramAfterProg = new HashMap<String, Object>();
			String labelType = (String) param.get("LABEL_TYPE");
			if(labelType.equals("1")){ //사출
				 crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
			}else if(labelType.equals("2")){//라벨1
				 crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID4"));
			}else if(labelType.equals("3")){//라벨2
				 crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID5"));
			}else {//제품표준 양식
				 crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID6"));
			}
			String fromCnt =  String.valueOf(param.get("LABEL_QTY"));
			String toCnt =  String.valueOf(param.get("LABEL_QTY2"));
			int printQty = Integer.parseInt(toCnt) - Integer.parseInt(fromCnt) + 1;
			param.put("PRINT_CNT", printQty);
			param.put("PAGE_START", fromCnt);
			 report_data =  pmr100ukrvService.mainReport_label(param);
			if(param.get("LABEL_LOC").equals("PMP")){//작업지시 라벨인 경우
				report_data	=  pmr100ukrvService.mainReport_Pmplabel(param);
			}
			paramAfterProg.put("COMP_CODE", param.get("S_COMP_CODE"));
			paramAfterProg.put("DIV_CODE", sDivCode);
			paramAfterProg.put("SOF_ITEM_CODE", report_data.get(0).get("SOF_ITEM_CODE"));
			paramAfterProg.put("ITEM_CODE", report_data.get(0).get("ITEM_CODE"));
			paramAfterProg.put("ORDER_NUM", report_data.get(0).get("ORDER_NUM"));
			paramAfterProg.put("ORDER_SEQ", report_data.get(0).get("ORDER_SEQ"));
			List<Map<String, Object>> report_dataAfterProg2 =  pmr100ukrvService.mainReport_label_afterProg(paramAfterProg);
			if(report_dataAfterProg2.size() > 0){
				param.put("AFTER_PROG_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_NAME"));
				param.put("AFTER_PROG_CUSTOM_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_CUSTOM_NAME"));
			}
		}else{
			report_data =  pmr100ukrvService.mainReport_label(param);
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

