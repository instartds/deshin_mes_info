package foren.unilite.modules.z_novis;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.z_in.S_mms510ukrv_inServiceImpl;
import foren.unilite.modules.z_in.S_pmp100skrv_inServiceImpl;
import foren.unilite.modules.z_in.S_sof130rkrv_inServiceImpl;


@Controller
public class Z_novisClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/mpo/";
  final static String            CRF_PATH2           = "Clipreport4/z_novis/";
  public final static String FILE_TYPE_OF_PHOTO = "base";


  @Resource( name = "s_sof130rkrv_novisService" )
  private S_sof130rkrv_novisServiceImpl s_sof130rkrv_novisService;
  
  @Resource( name = "s_pmp270skrv_novisService" )
  private S_pmp270skrv_novisServiceImpl s_pmp270skrv_novisService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;



  @RequestMapping(value = "/z_novis/s_sof130clrkrv_novis.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_sof130clrkrv_novisPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);

	  String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
	  String[] directory = path.split(":");
	  String drive = "";
	  String imageFullPath="";
	  if(directory != null && directory.length >= 2)	{
		  drive = directory[0]+":";
	  }
	  param.put("IMAGE_SAVE_DRIVE", drive);

	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID2"));
	  List<Map<String, Object>> report_data = null ;
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  String[] orderNumArry = null;
	  String orderNum = ObjUtils.getSafeString(param.get("PRINT_KEY"));
	    if(ObjUtils.isNotEmpty(orderNum)){
	    	orderNumArry = orderNum.split(",");
	    }


	    String[] outQArry = null;
		  String outQ = ObjUtils.getSafeString(param.get("OUT_Q"));
		    if(ObjUtils.isNotEmpty(outQ)){
		    	outQArry = outQ.split(",");
		    }



	    List<Map> orderNumList = new ArrayList<Map>();
	    for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();

			Object SELECT_ORDER_NUMS =  orderNumArry[i];
			Object SELECT_OUT_QS =  outQArry[i];

			map.put("ORDER_NUM", SELECT_ORDER_NUMS);
			map.put("OUT_Q", SELECT_OUT_QS);

			orderNumList.add(map);
		}
	    param.put("ORDER_NUMS", orderNumList);


//		    List<Map> outQList = new ArrayList<Map>();
//		    for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
//				Map map = new HashMap();
//
//				Object SELECT_OUT_QS =  outQArry[i];
//
//				map.put("OUT_Q", SELECT_OUT_QS);
//
//				outQList.add(map);
//			}
//		    param.put("OUT_QS", outQList);

	  //생산, 외주구분
	  if( param.get("OPT").equals("P")){
		  //Report use data
		 report_data = s_sof130rkrv_novisService.clipselect3_mainReport(param);
	  }else{
		  //Report use data
		 report_data = s_sof130rkrv_novisService.clipselect2(param);
	  }

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
	  Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
	  List<Map<String, Object>> subReport_data1 = s_sof130rkrv_novisService.clipselect3_subReport(param);
	  List<Map<String, Object>> subReport_data2 = s_sof130rkrv_novisService.clipselect3_subReport(param);
	  subReportMap.put("REPORT_FILE", "s_sof130clrkrv_novis_sub1");
	  subReportMap.put("DATA_SET", "SQLDS2");
	  subReportMap.put("SUB_DATA", subReport_data1);
	  subReports.add(subReportMap);
	  subReportMap2.put("REPORT_FILE", "s_sof130clrkrv_novis_sub2");
	  subReportMap2.put("DATA_SET", "SQLDS2");
	  subReportMap2.put("SUB_DATA", subReport_data2);
	  subReports.add(subReportMap2);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/z_novis/s_sof130clrkrv_novis_label.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_sof130clrkrv_novisLabelPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);

	  String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
	  String[] directory = path.split(":");
	  String drive = "";
	  String imageFullPath="";
	  if(directory != null && directory.length >= 2)	{
		  drive = directory[0]+":";
	  }
	  param.put("IMAGE_SAVE_DRIVE", drive);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
	  logger.debug("[[crfFile]]" + crfFile);
	  List<Map<String, Object>> report_data = null ;
	//Image 경로 
	  String imagePath = doc.getImagePath();


	  report_data = s_sof130rkrv_novisService.clipselect1(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }
  
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/z_novis/s_pmp270clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp270clrkrv_novisLabelPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
  		
  		ClipReportDoc doc = new ClipReportDoc();
  		
  		Map param = _req.getParameterMap();
  		
  		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao); // 레포트명 가져오기
		
		//로고, 스탬프 패스 추가
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
  		
  		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));

  		//Image 경로 
  		String imagePath = doc.getImagePath();

		String[] progWorkNameArry = param.get("PROG_WORK_NAME") == null ? null : param.get("PROG_WORK_NAME").toString().split(",");  // 공정명
		String[] wkordNumArry	  = param.get("WKORD_NUM")      == null ? null : param.get("WKORD_NUM").toString().split(",");       // 제조번호
		String[] boxQtyArry  	  = param.get("BOX_QTY")        == null ? null : param.get("BOX_QTY").toString().split(",");         // 용기수량
		String[] wholeWeightArry  = param.get("WHOLE_WEIGHT")   == null ? null : param.get("WHOLE_WEIGHT").toString().split(",");    // 전체무게
		String[] boxWeightArry	  = param.get("BOX_WEIGHT")     == null ? null : param.get("BOX_WEIGHT").toString().split(",");      // 용기무게
		String[] realWeightArry	  = param.get("REAL_WEIGHT")    == null ? null : param.get("REAL_WEIGHT").toString().split(",");     // 실제무게
		String[] workDateArry	  = param.get("WORK_DATE")      == null ? null : param.get("WORK_DATE").toString().split(",");       // 작업일
		String[] remarkArry	      = param.get("REMARK")         == null ? null : param.get("REMARK").toString().split(",");          // 비고
	  
		List<Map> wkordDataList = new ArrayList<Map>();

		// grid에서 받은 값 세팅
		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			
			Map map = new HashMap();
			
			map.put("PROG_WORK_NAME", (progWorkNameArry == null || progWorkNameArry.length < 1) ? null : progWorkNameArry[i]);
			map.put("WKORD_NUM"     , (wkordNumArry     == null || wkordNumArry.length < 1)     ? null : wkordNumArry[i]);
			map.put("BOX_QTY"       , (boxQtyArry       == null || boxQtyArry.length < 1)       ? null : boxQtyArry[i]);
			map.put("WHOLE_WEIGHT"  , (wholeWeightArry  == null || wholeWeightArry.length < 1)  ? null : wholeWeightArry[i]);
			map.put("BOX_WEIGHT"    , (boxWeightArry    == null || boxWeightArry.length < 1)    ? null : boxWeightArry[i]);
			map.put("REAL_WEIGHT"   , (realWeightArry   == null || realWeightArry.length < 1)   ? null : realWeightArry[i]);
			map.put("WORK_DATE"     , (workDateArry     == null || workDateArry.length < 1)     ? null : workDateArry[i]);
			map.put("REMARK"        , (remarkArry       == null || remarkArry.length < 1)       ? null : remarkArry[i]);

			wkordDataList.add(map);
		}
		param.put("WKORD_DATA", wkordDataList);

		//Main Report
		List<Map<String, Object>> report_data = s_pmp270skrv_novisService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}
