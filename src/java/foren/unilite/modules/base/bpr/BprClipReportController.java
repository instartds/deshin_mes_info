package foren.unilite.modules.base.bpr;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.str.Str800ukrvServiceImpl;
import foren.unilite.modules.base.bpr.Bpr300rkrvServiceImpl;


@Controller
public class BprClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  //final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "Clipreport4/Base/";
  final static String            CRF_PATH3           = "Clipreport4/Matrl/";

  @Resource( name = "str800ukrvService" )
  private Str800ukrvServiceImpl str800ukrvService;

  @Resource( name = "bpr300rkrvService" )
  private Bpr300rkrvServiceImpl bpr300rkrvService;

  @Resource( name = "bpr305rkrvService" )
  private Bpr305rkrvServiceImpl bpr305rkrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @Resource( name = "bpr815rkrvService" )
  private Bpr815rkrvServiceImpl bpr815rkrvService;

  @RequestMapping(value = "/base/bpr300clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView bpr300clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  List itemCodeList = new ArrayList();
	  List lotNoList = new ArrayList();
	  List whCodeList = new ArrayList();

	  String[] itemCodes = param.get("ITEM_CODE").toString().split(",");
	  String[] lotNos = param.get("LOT_NO").toString().split(",");
	  String[] whCodes = param.get("WH_CODE").toString().split(",");

	  for(String itemcode : itemCodes) {
		  itemCodeList.add(itemcode);
	  }
	  for(String lotno : lotNos) {
		  lotNoList.add(lotno);
	  }
	  for(String whcode : whCodes) {
		  whCodeList.add(whcode);
	  }
	  param.put("ITEM_CODE", itemCodeList);
	  param.put("LOT_NO", lotNoList);
	  param.put("WH_CODE", whCodeList);
	  logger.debug("[param]" + param);

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	 // List<Map<String, Object>> report_data = str800ukrvService.selectPrintList(param);
	  List<Map<String, Object>> report_data = bpr300rkrvService.selectClipPrintList(param);
	  //List<Map<String, Object>> report_data = null;
	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }

  @RequestMapping(value = "/base/bpr305clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView bpr305clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String sDivCode = (String) param.get("DIV_CODE");
	  String crfFile = null;

		crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));


		String[] groupKeyArry	= param.get("GROUP_KEYS").toString().split(",");
		String[] packQtyArry	= param.get("PACK_QTY").toString().split(",");
		String[] labelQtyArry	= param.get("LABEL_QTY").toString().split(",");
		String[] editYn1Arry		= param.get("EDIT_YN1").toString().split(",");
		String[] editYn2Arry		= param.get("EDIT_YN2").toString().split(",");

		List<Map> groupKeyList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_GROUP_KEY =  groupKeyArry[i];
			Object SELECT_PACK_QTY  =  packQtyArry[i];
			Object SELECT_LABEL_QTY =  labelQtyArry[i];
			Object SELECT_EDIT_YN1   =  editYn1Arry[i];
			Object SELECT_EDIT_YN2   =  editYn2Arry[i];
			map.put("GROUP_KEY", SELECT_GROUP_KEY);
			map.put("PACK_QTY", SELECT_PACK_QTY);
			map.put("LABEL_QTY", SELECT_LABEL_QTY);
			map.put("EDIT_YN1", SELECT_EDIT_YN1);
			map.put("EDIT_YN2", SELECT_EDIT_YN2);
			groupKeyList.add(map);
		}
	    param.put("GROUP_KEYS", groupKeyList);


	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = bpr305rkrvService.selectClipPrintList(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  /**
   * 원자재라벨출력
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @param model
   * @return
   * @throws Exception
   */
	@RequestMapping(value = "/base/bpr815clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView bpr815clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);


	  String crfFile = null;
	  List<Map<String, Object>> report_data = null;

	  crfFile = CRF_PATH3 + ObjUtils.getSafeString(param.get("RPT_ID1"));
	  report_data = bpr815rkrvService.printList(param);

	  String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

	  Map<String, Object> rMap = new HashMap<String, Object>();
	  rMap.put("success", "true");
	  rMap.put("resultKey", resultKey);
	  return ViewHelper.getJsonView(rMap);
   }


}
