package foren.unilite.modules.stock.qms;

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
import foren.unilite.modules.matrl.mms.Mms110ukrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class QmsClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Quality/";

	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "qms702skrvService" )
	private Qms702skrvServiceImpl qms702skrvService;


	/**
	 * 코팅검사성적서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/qms/qms702clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView qms702clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		String  opt = "";
		opt = (String) param.get("OPT") ;
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));

		if(opt.equals("0")) { //코팅 성적서 출력시
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		}else if(opt.equals("1")){ //왼제품 검사 성적서
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID2"));
		}else{//공정 검사 성적서
			crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID3"));
		}


		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);
		String[] wkordNumArry = null;
		String wkordNums = ObjUtils.getSafeString(param.get("WKORD_NUMS"));
		 if(ObjUtils.isNotEmpty(wkordNums)){
			 wkordNumArry = wkordNums.split(",");
		 }
		 List<Map> wkordNumList = new ArrayList<Map>();
		 for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();

				Object SELECT_WKORD_NUMS =  wkordNumArry[i] ;

				map.put("WKORD_NUM", SELECT_WKORD_NUMS);

				wkordNumList.add(map);
			}
		    param.put("WKORD_NUMS", wkordNumList);
		    List<Map<String, Object>> report_data = null;
		    if(opt.equals("2")) { //공적 성적서 출력시
		    	report_data =  qms702skrvService.printListProgWork(param);
		    }else{
		    	report_data =  qms702skrvService.printList(param);
		    }

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		Map<String, Object> subReportMap2= new HashMap<String ,Object>();
		if(opt.equals("1")) { //완제품 성적서 출력시
			subReportMap.put("qms702clskrv_sub", "SQLDS2");
			subReportMap2.put("qms702clskrv_sub2", "SQLDS2");
			List<Map<String, Object>> subReport_data = qms702skrvService.printList(param);;
			subReportMap.put("SUB_DATA", subReport_data);
			subReportMap2.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);
			subReports.add(subReportMap2);
		}
		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}

