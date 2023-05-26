package foren.unilite.modules.base.bcm;

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
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.prodt.pmp.Pmp100ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;
import foren.unilite.modules.matrl.mms.Mms110ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class BcmClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Base/";

	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "bcm120ukrvService" )
	private Bcm120ukrvServiceImpl bcm120ukrvService;


	/**
	 * 창고라벨출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bcm/bcm120clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView bcm120clukrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
    	crfFile = CRF_PATH + "bcm120clukrv_kdg.crf";
    	/*if(param.get("FORM").equals("K")) {
    		  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
    	 }else{
    		  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
    	 }
*/
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;

		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List whCellCodeList		= new ArrayList();

		String[] whCellCodes	= param.get("WH_CELL_CODES").toString().split(",");

		for(String whCellCode : whCellCodes) {
			whCellCodeList.add(whCellCode);
		}
		param.put("WH_CELL_CODE_LIST"	, whCellCodeList);
		
		List<Map<String, Object>> report_data =  bcm120ukrvService.selectWhLabel(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	/**
	 * 창고CELL 라벨출력 - 20200507 추가: 이노베이션 용
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bcm/bcm120clukrv_inno.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView bcm120clukrv_inno( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
		crfFile = CRF_PATH + "bcm120clukrv_inno.crf";
		/*if(param.get("FORM").equals("K")) {
			  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		 }else{
			  crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
		 }
	*/
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
	
		param.put("IMAGE_PATH_FIRST",imagePathFirst);
	
		List whCellCodeList		= new ArrayList();
	
		String[] whCellCodes	= param.get("WH_CELL_CODES").toString().split(",");
	
		for(String whCellCode : whCellCodes) {
			whCellCodeList.add(whCellCode);
		}
		param.put("WH_CELL_CODE_LIST"	, whCellCodeList);
		
		List<Map<String, Object>> report_data =  bcm120ukrvService.selectWhCellLabel_inno(param);
	
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
	
		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
	
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}