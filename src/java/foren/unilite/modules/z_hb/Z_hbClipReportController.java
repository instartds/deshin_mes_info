package foren.unilite.modules.z_hb;

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
public class Z_hbClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/mpo/";
  final static String            CRF_PATH2           = "Clipreport4/z_hb/";
  public final static String FILE_TYPE_OF_PHOTO = "base";

  @Resource( name = "s_mpo502ukrv_hbService" )
  private S_mpo502ukrv_hbServiceImpl s_mpo502ukrv_hbService;

  @Resource( name = "s_sof130rkrv_hbService" )
  private S_sof130rkrv_hbServiceImpl s_sof130rkrv_hbService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  @RequestMapping(value = "/z_hb/s_mpo502clrkrv_hb.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView s_mpo502ukrv_hbPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
	  String path = request.getSession().getServletContext().getRealPath("/");//omegaPlus설치 경로를 가져옴
	  String[] directory = path.split(":");
	  String drive = "";
	  String imageFullPath="";
	  if(directory != null && directory.length >= 2)	{
		  drive = directory[0]+":";
	  }
	 // String photoPath = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO, true);

	  param.put("IMAGE_SAVE_DRIVE", drive);
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = s_mpo502ukrv_hbService.labelPrint1(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }

  @RequestMapping(value = "/z_hb/s_sof130clrkrv_hb.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_sof130clrkrv_hbPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
	  logger.debug("[[param]]" + param);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
	  List<Map<String, Object>> report_data = null ;
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //생산, 외주구분
	  if( param.get("OPT").equals("P")){
		  //Report use data
		 report_data = s_sof130rkrv_hbService.clipselect1(param);
	  }else{
		  //Report use data
		 report_data = s_sof130rkrv_hbService.clipselect2(param);
	  }


	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }



}
