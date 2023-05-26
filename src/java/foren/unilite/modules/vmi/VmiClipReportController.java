package foren.unilite.modules.vmi;

import java.io.File;
import java.io.FileOutputStream;
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

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.str.Str400rkrvServiceImpl;
import foren.unilite.modules.sales.str.Str410skrvServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class VmiClipReportController	extends UniliteCommonController {

	final static String		CRF_PATH		= "Clipreport4/Vmi/";
	@InjectLogger
	 public static Logger logger  ;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "vmi210ukrvService" )
	private Vmi210ukrvServiceImpl vmi210ukrvService;

	/**
	 * 거래명세서 (납품관리 vmi용)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/vmi210clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView vmi210clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH+"vmi210clukrv.crf";
		List<Map<String, Object>> report_data = vmi210ukrvService.mainReport(param);


		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("vmi210clukrv_sub_01", "SQLDS2");
		subReportMap.put("vmi210clukrv_sub_02", "SQLDS2");

		List<Map<String, Object>> subReport_data = vmi210ukrvService.subReport(param);

		if(param.get("GUBUN").equals("SHIN")){
			crfFile = CRF_PATH+"vmi210clukrv_shin.crf";
			subReport_data = null;
			List<Map<String, Object>> bomParentData  = vmi210ukrvService.subReportShin_BomParentData(param);
			for(Map bomParam: bomParentData) {
				vmi210ukrvService.BomDataCreate(bomParam);
			}
			logger.debug("[[bomParentData]]" + bomParentData);
			subReport_data = vmi210ukrvService.subReportShin(param);

		}
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
	@RequestMapping(value = "/vmi/vmi210clukrv_label.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms510clukrv_label( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
    	String siteCode = (String) param.get("GUBUN");

    	if(param.get("PRINT_GUBUN").equals("B")){		//A4 용지
    		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
    	}else{
            crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
    	}
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);


		if(siteCode.equals("SHIN")){//신환용 후공정 가져오는 로직 적용
			Map paramAfterProg = new HashMap<String, Object>();
			List<Map<String, Object>> report_dataAfterProg =  vmi210ukrvService.mainReport_label(param);
			paramAfterProg.put("COMP_CODE", param.get("S_COMP_CODE"));
			paramAfterProg.put("DIV_CODE", sDivCode);
			paramAfterProg.put("SOF_ITEM_CODE", report_dataAfterProg.get(0).get("SOF_ITEM_CODE"));
			paramAfterProg.put("ITEM_CODE", report_dataAfterProg.get(0).get("ITEM_CODE"));
			paramAfterProg.put("ORDER_NUM", report_dataAfterProg.get(0).get("ORDER_NUM"));
			paramAfterProg.put("ORDER_SEQ", report_dataAfterProg.get(0).get("ORDER_SEQ"));
			List<Map<String, Object>> report_dataAfterProg2 =  vmi210ukrvService.mainReport_label_afterProg(paramAfterProg);
			if(report_dataAfterProg2.size() > 0){
				param.put("AFTER_PROG_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_NAME"));
				param.put("AFTER_PROG_CUSTOM_NAME", report_dataAfterProg2.get(0).get("AFTER_PROG_CUSTOM_NAME"));
			}
		}
		List<Map<String, Object>> report_data =  vmi210ukrvService.mainReport_label(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
